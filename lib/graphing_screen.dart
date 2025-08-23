import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'services/calculator_engine.dart';
import 'app/theme.dart';
import 'widgets/viewport_display.dart';

class GraphingScreen extends StatefulWidget {
  final CalculatorTheme theme;

  const GraphingScreen({super.key, required this.theme});

  @override
  State<GraphingScreen> createState() => _GraphingScreenState();
}

class _GraphingScreenState extends State<GraphingScreen> {
  final TextEditingController _functionController = TextEditingController();
  List<FlSpot> _plotData = [];
  double _minX = -10.0;
  double _maxX = 10.0;
  double _minY = -10.0;
  double _maxY = 10.0;
  final double _step = 0.1;
  String _currentFunction = '';
  bool _isLoading = false;

  // Add pan & zoom state
  Offset _panOffset = Offset.zero;
  double _scaleFactor = 1.0;

  // For gesture handling
  Offset _lastFocalPoint = Offset.zero;
  double _initialScale = 1.0;

  @override
  void initState() {
    super.initState();
    _functionController.text = 'x^2';
    _plotFunction();
  }

  @override
  void dispose() {
    _functionController.dispose();
    super.dispose();
  }

  List<FlSpot> generatePlotData(
    String expression,
    double minX,
    double maxX,
    double step,
  ) {
    List<FlSpot> spots = [];

    for (double x = minX; x <= maxX; x += step) {
      try {
        // Replace 'x' with the current x value
        String modifiedExpression = expression.replaceAll('x', '($x)');

        // Evaluate using our calculator engine
        String result = CalculatorEngine.evaluate(modifiedExpression);
        double y = double.tryParse(result) ?? double.nan;

        // Only add valid points
        if (!y.isNaN && !y.isInfinite) {
          spots.add(FlSpot(x, y));
        }
      } catch (e) {
        // Skip invalid points
        continue;
      }
    }

    return spots;
  }

  void _plotFunction() {
    setState(() {
      _isLoading = true;
    });

    String expression = _functionController.text.trim();
    if (expression.isEmpty) {
      setState(() {
        _plotData = [];
        _isLoading = false;
      });
      return;
    }

    // Remove 'y =' prefix if present
    if (expression.toLowerCase().startsWith('y=') ||
        expression.toLowerCase().startsWith('y =')) {
      expression = expression.substring(expression.indexOf('=') + 1).trim();
    }

    _currentFunction = expression;
    _plotData = generatePlotData(expression, _minX, _maxX, _step);

    // Auto-scale Y axis based on data
    if (_plotData.isNotEmpty) {
      double minY = _plotData
          .map((spot) => spot.y)
          .reduce((a, b) => a < b ? a : b);
      double maxY = _plotData
          .map((spot) => spot.y)
          .reduce((a, b) => a > b ? a : b);

      // Add some padding
      double padding = (maxY - minY) * 0.1;
      _minY = minY - padding;
      _maxY = maxY + padding;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _zoomIn() {
    setState(() {
      double centerX = (_minX + _maxX) / 2;
      double centerY = (_minY + _maxY) / 2;
      double rangeX = (_maxX - _minX) * 0.8;
      double rangeY = (_maxY - _minY) * 0.8;

      _minX = centerX - rangeX / 2;
      _maxX = centerX + rangeX / 2;
      _minY = centerY - rangeY / 2;
      _maxY = centerY + rangeY / 2;

      _plotFunction();
    });
  }

  void _zoomOut() {
    setState(() {
      double centerX = (_minX + _maxX) / 2;
      double centerY = (_minY + _maxY) / 2;
      double rangeX = (_maxX - _minX) * 1.25;
      double rangeY = (_maxY - _minY) * 1.25;

      _minX = centerX - rangeX / 2;
      _maxX = centerX + rangeX / 2;
      _minY = centerY - rangeY / 2;
      _maxY = centerY + rangeY / 2;

      _plotFunction();
    });
  }

  void _resetView() {
    setState(() {
      _minX = -10.0;
      _maxX = 10.0;
      _minY = -10.0;
      _maxY = 10.0;
      _plotFunction();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate effective viewport with pan & zoom
    final double baseRangeX = _maxX - _minX;
    final double baseRangeY = _maxY - _minY;
    final double scale = _scaleFactor;
    final double panX = _panOffset.dx / 200 * baseRangeX; // 200 px = 1x range
    final double panY = _panOffset.dy / 200 * baseRangeY;

    final double effectiveRangeX = baseRangeX / scale;
    final double effectiveRangeY = baseRangeY / scale;

    final double centerX = (_minX + _maxX) / 2 - panX;
    final double centerY = (_minY + _maxY) / 2 + panY;

    final double minX = centerX - effectiveRangeX / 2;
    final double maxX = centerX + effectiveRangeX / 2;
    final double minY = centerY - effectiveRangeY / 2;
    final double maxY = centerY + effectiveRangeY / 2;

    return Scaffold(
      backgroundColor: widget.theme.themeData.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Function Graphing'),
        backgroundColor: widget.theme.themeData.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Function input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.theme.displayBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _functionController,
                    style: TextStyle(
                      fontSize: 18,
                      color: widget.theme.numberTextColor,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Enter function (e.g., x^2, sin(x), log(x))',
                      labelStyle: TextStyle(
                        color: widget.theme.numberTextColor,
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.theme.operatorColor,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.theme.functionColor,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _plotFunction(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _plotFunction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.theme.functionColor,
                            foregroundColor: widget.theme.functionTextColor,
                          ),
                          child: const Text('Plot'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _zoomIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.theme.utilityColor,
                          foregroundColor: widget.theme.utilityTextColor,
                        ),
                        child: const Icon(Icons.zoom_in),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _zoomOut,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.theme.utilityColor,
                          foregroundColor: widget.theme.utilityTextColor,
                        ),
                        child: const Icon(Icons.zoom_out),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _resetView,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.theme.utilityColor,
                          foregroundColor: widget.theme.utilityTextColor,
                        ),
                        child: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Graph area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.theme.displayBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Chart area (with gestures)
                    Positioned.fill(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _plotData.isEmpty
                          ? Center(
                              child: Text(
                                'No data to display\nTry a different function',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: widget.theme.numberTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onScaleStart: (details) {
                                _lastFocalPoint = details.focalPoint;
                                _initialScale = _scaleFactor;
                              },
                              onScaleUpdate: (details) {
                                setState(() {
                                  if (details.scale == 1.0) {
                                    _panOffset +=
                                        details.focalPoint - _lastFocalPoint;
                                    _lastFocalPoint = details.focalPoint;
                                  }
                                  if (details.scale != 1.0) {
                                    _scaleFactor =
                                        (_initialScale * details.scale).clamp(
                                          0.5,
                                          10.0,
                                        );
                                  }
                                });
                              },
                              onScaleEnd: (details) {
                                setState(() {
                                  final double panX =
                                      _panOffset.dx / 200 * baseRangeX;
                                  final double panY =
                                      _panOffset.dy / 200 * baseRangeY;
                                  _minX -= panX;
                                  _maxX -= panX;
                                  _minY += panY;
                                  _maxY += panY;
                                  final double centerX = (_minX + _maxX) / 2;
                                  final double centerY = (_minY + _maxY) / 2;
                                  final double newRangeX =
                                      (_maxX - _minX) / _scaleFactor;
                                  final double newRangeY =
                                      (_maxY - _minY) / _scaleFactor;
                                  _minX = centerX - newRangeX / 2;
                                  _maxX = centerX + newRangeX / 2;
                                  _minY = centerY - newRangeY / 2;
                                  _maxY = centerY + newRangeY / 2;
                                  _panOffset = Offset.zero;
                                  _scaleFactor = 1.0;
                                });
                              },
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: true,
                                    drawHorizontalLine: true,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: widget.theme.numberTextColor
                                          .withAlpha(50),
                                      strokeWidth: 1,
                                    ),
                                    getDrawingVerticalLine: (value) => FlLine(
                                      color: widget.theme.numberTextColor
                                          .withAlpha(50),
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) => Text(
                                          value.toStringAsFixed(1),
                                          style: TextStyle(
                                            color: widget.theme.numberTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) => Text(
                                          value.toStringAsFixed(1),
                                          style: TextStyle(
                                            color: widget.theme.numberTextColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: true,
                                    border: Border.all(
                                      color: widget.theme.numberTextColor,
                                      width: 1,
                                    ),
                                  ),
                                  minX: minX,
                                  maxX: maxX,
                                  minY: minY,
                                  maxY: maxY,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: _plotData,
                                      color: widget.theme.functionColor,
                                      barWidth: 2,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(show: false),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    // Overlay viewport display in top left
                    Positioned(
                      left: 0,
                      top: 0,
                      child: ViewportDisplay(
                        minX: minX,
                        maxX: maxX,
                        minY: minY,
                        maxY: maxY,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Current function display
            if (_currentFunction.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.theme.historyBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'y = $_currentFunction',
                  style: TextStyle(
                    color: widget.theme.numberTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
