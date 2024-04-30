import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:statusgetter/core/domain/model/site_model.dart';
import 'package:statusgetter/core/extensions/strings/string_extension_core.dart';

mixin SocialDomainMixin {
  Future<SiteModel?> get({
    required String url,
    required Duration? timeout,
    required String? executablePath,
  }) {
    if (Platform.isIOS || Platform.isAndroid) {
      return _getMobile(url: url);
    } else {
      return _getDesktop(
        url: url,
        timeout: timeout,
        executablePath: executablePath,
      );
    }
  }

  /// This function is used to retrieve download details when the project is running on a desktop platform.
  /// It utilizes the `puppeteer` library, which is a Node library that provides a high-level API over the Chrome DevTools Protocol.
  /// The function launches a headless browser, navigates to the 'https://en.savefrom.net' website, inputs the provided URL into the input field,
  /// clicks the submit button, waits for the selector '.info-box', retrieves the page content, and then closes the browser.
  /// Finally, it parses the obtained HTML content to extract the download details using the private function [_parseContent].

  /// Parameters:
  /// - [timeout]: Optional parameter to specify the maximum amount of time the function should wait for the browser or page actions.
  /// - [url]: The URL for which download details are to be retrieved.
  /// - [executablePath]: Optional parameter to specify the path to the browser executable.
  ///
  /// Returns:
  /// A [Future] containing a [SiteModel] that represents the download details, or `null` if the details couldn't be retrieved.
  Future<SiteModel?> _getDesktop({
    Duration? timeout,
    required String url,
    String? executablePath,
  }) async {
    // Launch a new headless browser using puppeteer
    final Browser browser = await puppeteer.launch(
      timeout: timeout,
      executablePath: executablePath,
    );

    // Create a new page within the browser
    final Page page = await browser.newPage();

    // Navigate to the savefrom.net website
    await page.goto('https://en.savefrom.net', wait: Until.networkIdle);

    // Input the URL into the designated field
    await page.type('#sf_url', url);

    // Click the submit button to request download details
    await page.click('#sf_submit');

    // Wait for the selector '.info-box' to ensure the page has loaded with download details
    await page.waitForSelector('.info-box');

    // Get the HTML content of the page
    final String? content = await page.content;

    // Close the browser
    await browser.close();

    // Parse the HTML content to extract download details
    return _parseContent(content);
  }

  /// This function is used to retrieve request details from a mobile device.
  /// It makes a headless request using the InAppWebView package, providing a URL to initiate the request.
  Future<SiteModel?> _getMobile({required String url}) async {
    // Completer to handle the asynchronous nature of the function
    final Completer<SiteModel> model = Completer<SiteModel>();

    // Using HeadlessInAppWebView for making headless requests
    HeadlessInAppWebView(
      // Setting for the web view
      initialSettings: InAppWebViewSettings(
        useOnLoadResource: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      // Providing the initial URL request
      initialUrlRequest: URLRequest(url: WebUri('https://en.savefrom.net')),
      // Callback triggered when the web view finishes loading
      onLoadStop: (InAppWebViewController controller, Uri? uri) async {
        // Injecting JavaScript code to populate the form with the provided URL and trigger a click
        await controller.evaluateJavascript(source: '''
        document.querySelector('#sf_url').value = '$url';
        document.querySelector('#sf_submit').click();
      ''');

        // Waiting for the web view to load and extracting HTML content
        final SiteModel data = await Future<SiteModel>.delayed(
          const Duration(seconds: 10),
          () async {
            final String? content = await controller.getHtml();
            return _parseContent(content);
          },
        );

        // Completing the future with the extracted data
        return model.complete(data);
      },
    )
      ..run() // Running the headless web view
      ..dispose(); // Disposing of the web view to free up resources

    // Returning the future result to the client
    return model.future;
  }

  /// This function parses HTML content to extract information about a video site,
  /// including its title, duration, thumbnail, and various video links.
  /// The structure of the HTML is navigated using the querySelector method.
  /// The function uses a loop to extract multiple video links and checks for a fallback link if the main links are empty.
  /// The extracted information is then used to create a SiteModel instance,
  /// providing a structured representation of the video site's data.
  SiteModel _parseContent(String? content) {
    // Parse HTML Content
    final Document body = parse(content.nullSafe);

    // Get Video Thumbnail
    final String? thumbnail =
        body.querySelector(".media-result .clip img")?.attributes['src'];

    // Get content info from body
    final Element? info = body.querySelector(".info-box");

    // Get Video Title
    final String? title = info?.querySelector(".title")?.text;

    // Get Video Duration
    final String? duration = info?.querySelector(".duration")?.text;

    // Get Videos Link with Different Qualities.
    final List<Element> linkGroup =
        info?.querySelectorAll('.link-group a') ?? <Element>[];

    // Hold Video Links Here
    final List<LinkModel> links = <LinkModel>[];

    // Start a loop and try to get video links from here
    if (linkGroup.isNotEmpty) {
      for (final Element e in linkGroup) {
        links.add(_parseLink(e));
      }
    }

    // Check if Links are empty then try to get links from button
    if (links.isEmpty) {
      final Element? single = body.querySelector('.def-btn-box a');
      if (single != null) {
        links.add(_parseLink(single));
      }
    }

    // Add all the information into SiteModel
    return SiteModel(
      title: title, // Set the extracted title
      links: links, // Set the extracted video links
      duration: duration, // Set the extracted duration
      thumbnail: thumbnail, // Set the extracted thumbnail URL
    );
  }

  /// Parses a link element to create a LinkModel.
  ///
  /// This function takes an HTML Element [e] and extracts relevant information
  /// to create a [LinkModel] object.
  ///
  /// Parameters:
  ///   - [e]: The HTML Element to parse.
  ///
  /// Returns:
  ///   - A [LinkModel] representing the parsed information.
  ///
  /// Details:
  ///   1. Extracts attributes from the HTML element [e].
  ///   2. Retrieves the video quality from a nested 'span' element or the text content of the element.
  ///   3. Constructs a [LinkModel] with quality, link, and type.
  ///
  /// Example:
  ///   Consider the following HTML element:
  ///   <a href="video-link" data-type="mp4">
  ///     <span>1080p</span>
  ///   </a>
  ///   The function would return a LinkModel with quality '1080p', link 'video-link', and type 'mp4'.
  ///
  /// Note:
  ///   - The 'span' element is considered for video quality, fallback to the element's text if 'span' is not found.
  ///
  LinkModel _parseLink(Element e) {
    // Extract attributes from the HTML element
    final LinkedHashMap<Object, String> attr = e.attributes;

    // Get Video Quality
    final String quality = e.querySelector('span')?.text ?? e.text;

    // Create a LinkModel with quality, link, and type
    return LinkModel(
      quality: quality,
      link: attr['href'],
      type: attr['data-type'],
    );
  }
}
