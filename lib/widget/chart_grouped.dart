import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class ChartGrouped extends StatefulWidget {
  const ChartGrouped({key, required this.ordinalList}) : super(key: key);

  final List<List<OrdinalData>> ordinalList;

  @override
  State<ChartGrouped> createState() => _ChartGroupedState();
}

class _ChartGroupedState extends State<ChartGrouped> {
  late List<List<OrdinalData>> _ordinalList;

  @override
  void initState() {
    super.initState();
    _ordinalList = widget.ordinalList;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DChartBarO(
        animate: true,
        animationDuration: const Duration(milliseconds: 500),
        barLabelValue: (group, ordinalData, index) {
          return group.seriesCategory!;
        },
        barLabelDecorator: BarLabelDecorator(
          barLabelPosition: BarLabelPosition.auto,
          labelAnchor: BarLabelAnchor.start,
          labelPadding: 10,
        ),
        fillColor: (group, ordinalData, index) {
          return switch (group.id) {
            "1" => Colors.red,
            "2" => Colors.blueAccent,
            "3" => Colors.green,
            _ => Colors.transparent,
          };
        },
        configRenderBar:
            ConfigRenderBar(barGroupingType: BarGroupingType.grouped),
        groupList: [
          OrdinalGroup(id: '1', data: _ordinalList[0], seriesCategory: "10"),
          OrdinalGroup(id: '2', data: _ordinalList[1], seriesCategory: "11"),
          OrdinalGroup(id: '3', data: _ordinalList[2], seriesCategory: "12"),
        ],
      ),
    );
  }
}
