import 'package:flutter/cupertino.dart';
import '../../dock_blocks/clock/clock_block.dart';
import '../../dock_blocks/clash/clash_block.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 16.0,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    ClockBlock(),
                    SizedBox(width: 16),
                    ClashBlock(
                      baseUrl: 'ws://192.168.55.212:9999',
                      token: '',
                    ),
                    SizedBox(width: 16),
                    // DemoBlock(),
                    // SizedBox(width: 16),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
