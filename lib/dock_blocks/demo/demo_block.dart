import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../core/block/base_block.dart';
import '../../core/theme/app_theme.dart';

class DemoBlock extends StatefulWidget {
  const DemoBlock({super.key});

  @override
  State<DemoBlock> createState() => _DemoBlockState();
}

class _DemoBlockState extends State<DemoBlock> {
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
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(Uri.parse('http://192.168.55.212:9999/ui/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return BaseBlock(
      width: AppMetrics.defaultBlockWidth * 1.2,
      height: 500,
      child: SizedBox(
        width: AppMetrics.defaultBlockWidth * 1.2,
        height: 500,
        child: Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppMetrics.containerRadius),
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
                    if (_isLoading)
                      const Center(
                        child: CupertinoActivityIndicator(),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
