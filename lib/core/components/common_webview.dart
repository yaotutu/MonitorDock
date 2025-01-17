import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../theme/app_theme.dart';

class CommonWebView extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxDecoration? decoration;
  final bool showLoadingIndicator;
  final void Function(WebViewController)? onWebViewCreated;
  final void Function(String)? onPageFinished;
  final void Function(WebResourceError)? onError;

  const CommonWebView({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.decoration,
    this.showLoadingIndicator = true,
    this.onWebViewCreated,
    this.onPageFinished,
    this.onError,
  });

  @override
  State<CommonWebView> createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(CupertinoColors.systemBackground)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (progress == 100) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            widget.onPageFinished?.call(url);
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            widget.onError?.call(error);
          },
        ),
      );

    widget.onWebViewCreated?.call(_controller);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(Uri.parse(widget.url));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: widget.width ?? constraints.maxWidth,
          height: widget.height ?? constraints.maxHeight,
          decoration: widget.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(AppMetrics.containerRadius),
                border: Border.all(
                  color: AppColors.getBorderColor(isDark),
                  width: AppMetrics.borderWidth,
                ),
              ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              SizedBox.expand(
                child: WebViewWidget(controller: _controller),
              ),
              if (_isLoading && widget.showLoadingIndicator)
                const Center(
                  child: CupertinoActivityIndicator(),
                ),
            ],
          ),
        );
      },
    );
  }
}
