import 'package:flutter/material.dart';

class ViewportDisplay extends StatelessWidget {
  final double minX, maxX, minY, maxY;

  const ViewportDisplay({
    super.key,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'X-Range: [${minX.toStringAsFixed(2)}, ${maxX.toStringAsFixed(2)}]',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          Text(
            'Y-Range: [${minY.toStringAsFixed(2)}, ${maxY.toStringAsFixed(2)}]',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
