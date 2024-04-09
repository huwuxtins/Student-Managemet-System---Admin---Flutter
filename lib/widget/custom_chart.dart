import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

class CustomChart extends StatefulWidget {
  const CustomChart({key, required this.chartData}) : super(key: key);

  final ChartData chartData;

  @override
  State<CustomChart> createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  late ChartData _chartData;
  LabelLayoutStrategy? xContainerLabelLayoutStrategy;

  @override
  void initState() {
    super.initState();
    _chartData = widget.chartData;
  }

  @override
  Widget build(BuildContext context) {
    return VerticalBarChart(
      painter: VerticalBarChartPainter(
        verticalBarChartContainer: VerticalBarChartTopContainer(
          chartData: _chartData,
          xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
        ),
      ),
    );
  }
}
