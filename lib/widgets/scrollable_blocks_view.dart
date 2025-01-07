import 'package:flutter/material.dart';

class ScrollableBlocksView extends StatelessWidget {
  const ScrollableBlocksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[200],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: IntrinsicWidth(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBlock(flex: 3, color: Colors.blue[200], text: '块1'),
              const SizedBox(width: 10),
              _buildBlock(flex: 4, color: Colors.green[200], text: '块2'),
              const SizedBox(width: 10),
              _buildBlock(flex: 3, color: Colors.orange[200], text: '块3'),
              const SizedBox(width: 10),
              _buildBlock(flex: 3, color: Colors.purple[200], text: '块4'),
              const SizedBox(width: 10),
              _buildBlock(flex: 4, color: Colors.red[200], text: '块5'),
              const SizedBox(width: 10),
              _buildBlock(flex: 3, color: Colors.teal[200], text: '块6'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlock({required int flex, Color? color, required String text}) {
    return Container(
      width: 200,
      color: color,
      child: Center(
        child: Text(text),
      ),
    );
  }
}
