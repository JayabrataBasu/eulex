import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'graphing_state.dart';

class GraphingScreen extends StatefulWidget {
  const GraphingScreen({super.key});

  @override
  State<GraphingScreen> createState() => _GraphingScreenState();
}

class _GraphingScreenState extends State<GraphingScreen> {
  final _controller = TextEditingController();
  Offset? _lastPan;

  @override
  Widget build(BuildContext context) {
    final graphState = context.watch<GraphingState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graphing Calculator'),
        actions: [
          IconButton(
            tooltip: 'Zoom In',
            icon: const Icon(Icons.zoom_in),
            onPressed: () => graphState.zoom(0.8),
          ),
          IconButton(
            tooltip: 'Zoom Out',
            icon: const Icon(Icons.zoom_out),
            onPressed: () => graphState.zoom(1.25),
          ),
          IconButton(
            tooltip: 'Clear All Functions',
            icon: const Icon(Icons.clear_all),
            onPressed: () => graphState.clear(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Graph area
          Expanded(
            child: Listener(
              onPointerDown: (e) => _lastPan = e.position,
              onPointerMove: (e) {
                if (_lastPan != null) {
                  final delta = e.position - _lastPan!;
                  _lastPan = e.position;
                  final scaleX =
                      (graphState.xmax - graphState.xmin) / context.size!.width;
                  final scaleY =
                      (graphState.ymax - graphState.ymin) /
                      context.size!.height;
                  graphState.pan(-delta.dx * scaleX, delta.dy * scaleY);
                }
              },
              onPointerUp: (_) => _lastPan = null,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return LineChart(
                      LineChartData(
                        minX: graphState.xmin,
                        maxX: graphState.xmax,
                        minY: graphState.ymin,
                        maxY: graphState.ymax,
                        gridData: const FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                            ),
                          ),
                          bottomTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32,
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        lineBarsData: [
                          for (final f in graphState.functions)
                            LineChartBarData(
                              spots: [
                                for (final pt in graphState.sample(f))
                                  FlSpot(pt.dx, pt.dy),
                              ],
                              isCurved: false,
                              color: f.color,
                              barWidth: 2,
                              dotData: const FlDotData(show: false),
                            ),
                        ],
                        lineTouchData: const LineTouchData(enabled: false),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Function list
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final f in graphState.functions)
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: f.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: f.color),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 12, height: 12, color: f.color),
                        const SizedBox(width: 8),
                        Text('y = ${f.expression}'),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => graphState.removeFunction(f),
                          child: const Icon(Icons.close, size: 16),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Input field
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter function in x, e.g. sin(x) or x^2',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (v) {
                      graphState.addFunction(v);
                      _controller.clear();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    graphState.addFunction(_controller.text);
                    _controller.clear();
                  },
                  child: const Text('Plot'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
