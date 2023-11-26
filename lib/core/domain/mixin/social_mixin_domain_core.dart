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

// If user is running the project on desktop then run this function to get request details.
  Future<SiteModel?> _getDesktop({
    Duration? timeout,
    required String url,
    String? executablePath,
  }) async {
    final Browser browser = await puppeteer.launch(
      timeout: timeout,
      executablePath: executablePath,
    );
    final Page page = await browser.newPage();
    await page.goto('https://en.savefrom.net', wait: Until.networkIdle);
    await page.type('#sf_url', url);
    await page.click('#sf_submit');
    await page.waitForSelector('.info-box');
    final String? content = await page.content;
    await browser.close();
    return _parseContent(content);
  }

  // If user is running the project on mobile then run this function to get request details.
  Future<SiteModel?> _getMobile({required String url}) async {
    final Completer<SiteModel> model = Completer<SiteModel>();
    // Make Headless Request Using InAppWebView Package.
    HeadlessInAppWebView(
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          useOnLoadResource: true,
          mediaPlaybackRequiresUserGesture: false,
          javaScriptCanOpenWindowsAutomatically: true,
        ),
      ),
      initialUrlRequest: URLRequest(url: Uri.parse('https://en.savefrom.net')),
      onLoadStop: (InAppWebViewController controller, Uri? uri) async {
        await controller.evaluateJavascript(source: '''
          document.querySelector('#sf_url').value = '$url'
          document.querySelector('#sf_submit').click()
        ''');
        // Get SiteModel from Running Script
        final SiteModel data = await Future<SiteModel>.delayed(
          const Duration(seconds: 10),
          () async {
            final String? content = await controller.getHtml();
            return _parseContent(content);
          },
        );
        return model.complete(data);
      },
    )
      ..run()
      ..dispose();
    // return result back to client.
    return model.future;
  }

  /// Parse HTML Content into Site Model
  SiteModel _parseContent(String? content) {
    // Parse HTML Content
    final Document body = parse(content.nullSafe);
    // Get Video Thumbnail
    final String? thumbnail =
        body.querySelector(".media-result .clip img")?.attributes['src'];
    // Get content into from body
    final Element? info = body.querySelector(".info-box");
    // Get Video Title
    final String? title = info?.querySelector(".title")?.text;
    // Get Video Duration
    final String? duration = info?.querySelector(".duration")?.text;
    // Get Videos Link with Different Qualities.
    final List<Element> linkGroup =
        info?.querySelectorAll('.link-group a') ?? <Element>[];
    // Hold Video Links Gere
    final List<LinkModel> links = <LinkModel>[];
    // Start a loop and try to get video links from here
    if (linkGroup.isNotEmpty) {
      for (Element e in linkGroup) {
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

    /// Add all the information info SiteModel
    return SiteModel(
      title: title,
      links: links,
      duration: duration,
      thumbnail: thumbnail,
    );
  }

  /// Get LinkModel from Given Element
  LinkModel _parseLink(Element e) {
    final LinkedHashMap<Object, String> attr = e.attributes;
    // Get Video Quality
    final String quality = e.querySelector('span')?.text ?? e.text;
    return LinkModel(
      quality: quality,
      link: attr['href'],
      type: attr['data-type'],
    );
  }
}
