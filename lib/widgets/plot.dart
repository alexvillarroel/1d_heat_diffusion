import 'package:fl_chart/fl_chart.dart';
import 'package:diffusion/difussion.dart';
import 'package:flutter/material.dart';

class PlotDifusion extends StatefulWidget {
  final List<FlSpot> difusion;
  const PlotDifusion(this.difusion, {super.key});

  @override
  State<PlotDifusion> createState() => _PlotDifusionState();
}

class _PlotDifusionState extends State<PlotDifusion> {
  List<Color> gradientColors = [
    Colors.cyanAccent,
    Colors.purpleAccent,
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      height: 350,
      child: LineChart(
        LineChartData(
          minX: -50,
          minY: 0,
          maxX: 50,
          maxY: 1200,
          lineBarsData: [
            LineChartBarData(
              spots: widget.difusion,
              isCurved: false,
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: gradientColors
                      .map((color) => color.withOpacity(0.3))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
