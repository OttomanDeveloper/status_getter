import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:statusgetter/core/extensions/buildcontext/buildcontext_extensions_core.dart';
import 'package:statusgetter/meta/themes/theme_meta.dart';

/// Custom Scaffold with Some Extra Features
class CustomScaffold extends StatefulWidget {
  final StackFit fit;
  final Clip clipBehavior;
  final List<Widget> children;
  final MainAxisSize mainAxisSize;
  final EdgeInsetsGeometry padding;
  final PreferredSizeWidget? appBar;
  final ScrollPhysics scrollPhysics;
  final bool? resizeToAvoidBottomInset;
  final SystemUiOverlayStyle? uiOverlay;
  final bool isScrollable, hideScrollGlow;
  final AlignmentDirectional stackAligment;
  final Future<bool> Function()? onWillPop;
  final ScrollController? scrollController;
  final MainAxisAlignment mainAxisAlignment;
  final GlobalKey<ScaffoldState>? globalKey;
  final BoxDecoration? backgroundDecoration;
  final void Function()? initState, dispose;
  final CrossAxisAlignment crossAxisAlignment;
  final Color? drawerScrimColor, backgroundColor;
  final void Function(bool)? onEndDrawerChanged, onDrawerChanged;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBody, extendBodyBehindAppBar, isStack, useSafeArea;
  final Widget? floatingActionButton, drawer, bottomNavigationBar, endDrawer;

  const CustomScaffold({
    super.key,
    this.appBar,
    this.drawer,
    this.dispose,
    this.initState,
    this.uiOverlay,
    this.onWillPop,
    this.globalKey,
    this.endDrawer,
    this.onDrawerChanged,
    this.backgroundColor,
    this.isStack = false,
    this.drawerScrimColor,
    this.scrollController,
    this.onEndDrawerChanged,
    this.extendBody = false,
    this.useSafeArea = true,
    this.children = const [],
    this.bottomNavigationBar,
    this.isScrollable = true,
    this.floatingActionButton,
    this.fit = StackFit.loose,
    this.backgroundDecoration,
    this.hideScrollGlow = true,
    this.resizeToAvoidBottomInset,
    this.padding = EdgeInsets.zero,
    this.clipBehavior = Clip.hardEdge,
    this.floatingActionButtonLocation,
    this.extendBodyBehindAppBar = false,
    this.mainAxisSize = MainAxisSize.max,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.stackAligment = AlignmentDirectional.topStart,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  @override
  void initState() {
    // Check if initState Function is not null then execute it
    if (widget.initState != null) {
      widget.initState!();
    }
    super.initState();
  }

  @override
  void dispose() {
    // Check if dispose Function is not null then execute it
    if (widget.dispose != null) {
      widget.dispose!();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Get Screen size from MediaQuery API
    final Size size = context.sizeApi;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: widget.uiOverlay ?? AppThemes().normalGB(context),
      child: WillPopScope(
        onWillPop: widget.onWillPop ?? () async => true,
        child: Scaffold(
          appBar: widget.appBar,
          drawer: widget.drawer,
          endDrawer: widget.endDrawer,
          extendBody: widget.extendBody,
          key: widget.globalKey ?? widget.key,
          onDrawerChanged: widget.onDrawerChanged,
          drawerScrimColor: widget.drawerScrimColor,
          onEndDrawerChanged: widget.onEndDrawerChanged,
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButton: widget.floatingActionButton,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          backgroundColor: widget.backgroundColor ?? context.bgColor,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          body: safeAreaProvider(
            value: widget.useSafeArea,
            child: Container(
              width: size.width,
              height: size.height,
              padding: widget.padding,
              decoration: widget.backgroundDecoration,
              child: widget.isStack
                  ? Stack(
                      fit: widget.fit,
                      alignment: widget.stackAligment,
                      clipBehavior: widget.clipBehavior,
                      children: widget.children,
                    )
                  : widget.isScrollable
                      ? _CustomScaffoldScrollableLayout(
                          padding: EdgeInsets.zero,
                          clipBehavior: widget.clipBehavior,
                          scrollPhysics: widget.scrollPhysics,
                          hideScrollGlow: widget.hideScrollGlow,
                          scrollController: widget.scrollController,
                          child: column,
                        )
                      : column,
            ),
          ),
        ),
      ),
    );
  }

  /// Get Column Widget with Given Properties
  Widget get column {
    return Column(
      mainAxisSize: widget.mainAxisSize,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: widget.children,
    );
  }

  /// Check if User requested to use safeArea then use it.
  /// Otherwise return normal widget
  Widget safeAreaProvider({required Widget child, required bool value}) {
    if (value) {
      return SafeArea(child: child);
    } else {
      return child;
    }
  }
}

/// Just for Custom Scaffold
class _CustomScaffoldScrollableLayout extends StatelessWidget {
  final Widget child;
  final Clip clipBehavior;
  final bool hideScrollGlow;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics scrollPhysics;
  final ScrollController? scrollController;

  const _CustomScaffoldScrollableLayout({
    required this.child,
    required this.padding,
    required this.clipBehavior,
    required this.scrollPhysics,
    required this.hideScrollGlow,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        if (hideScrollGlow) {
          overScroll.disallowIndicator();
        }
        return false;
      },
      child: SingleChildScrollView(
        padding: padding,
        physics: scrollPhysics,
        clipBehavior: clipBehavior,
        controller: scrollController,
        child: child,
      ),
    );
  }
}
