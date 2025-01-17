import 'package:flutter/cupertino.dart';
import '../../core/block/base_block.dart';
import '../../core/components/common_webview.dart';
import '../../core/theme/app_theme.dart';

class DemoBlock extends StatefulWidget {
  const DemoBlock({super.key});

  @override
  State<DemoBlock> createState() => _DemoBlockState();
}

class _DemoBlockState extends State<DemoBlock> {
  @override
  Widget build(BuildContext context) {
    const String url = 'http://192.168.55.212:9999/ui/';

    return BaseBlock(
      width: AppMetrics.defaultBlockWidth * 1.2,
      height: 500,
      child: const SizedBox(
        width: AppMetrics.defaultBlockWidth * 1.2,
        height: 500,
        child: CommonWebView(
          url: url,
        ),
      ),
      expandedContent: const CommonWebView(
        url: url,
      ),
    );
  }
}
