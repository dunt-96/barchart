import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartCustom extends StatefulWidget {
  const LineChartCustom(
      {Key? key,
      this.moneys,
      this.greatestValue,
      // this.yearMonth,
      this.maxMonth})
      : super(key: key);
  final List<int>? moneys;
  final double? greatestValue;
  // final YearMonth? yearMonth;
  final int? maxMonth;
  @override
  _LineChartCustomState createState() => _LineChartCustomState();
}

class _LineChartCustomState extends State<LineChartCustom> {
  List<FlSpot> spots = <FlSpot>[];

  @override
  void initState() {
    super.initState();
    spots = List.generate(
        widget.moneys!.length - (12 - (widget.maxMonth ?? 12)),
        (index) =>
            FlSpot((index + 1).toDouble(), widget.moneys![index].toDouble()));
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(mainData());
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        // show: true,
        // leftTitles: SideTitles(
        //   showTitles: false,
        // ),
        // bottomTitles: SideTitles(
        //   showTitles: true,
        //   getTitles: (value) {
        //     return '';
        //   },
        // ),
      ),
      borderData: FlBorderData(show: false),
      minX: 1,
      maxX: 13,
      minY: -widget.greatestValue!,
      maxY: widget.greatestValue,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          color: Colors.green,
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
              radius: 2
              // index == widget.yearMonth!.month - 1
              //     ? Constants.dimens_04
              //     : Constants.dimens_03,
              // color: AppColors.green6BD97C,
              // strokeColor: index == widget.yearMonth!.month - 1
              //     ? AppColors.green6BD97C.withOpacity(Constants.dimens_0_2)
              //     : AppColors.whiteFFFFFF,
              // strokeWidth: index == widget.yearMonth!.month - 1
              //     ? Constants.dimens_05
              //     : Constants.dimens_02,
            ),
            checkToShowDot: (spot, barData) {
              return true;
            },
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }
}
