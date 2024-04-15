import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({this.size, super.key});

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size ?? 17,
        width: size ?? 17,
        child: const CircularProgressIndicator(
          strokeWidth: 3.5,
          strokeCap: StrokeCap.round,
        ),
      ),
    );
  }
}

class FullDivider extends StatelessWidget {
  const FullDivider({this.height = 25, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, indent: 0, endIndent: 0);
  }
}

class EmptyList extends StatelessWidget {
  const EmptyList(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bubble_chart_outlined, size: 30),
            const SizedBox(height: 5),
            Text(
              text,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
