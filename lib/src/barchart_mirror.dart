import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'custom_line_chart.dart';

class BarchartMirror extends StatefulWidget {
  const BarchartMirror({
    Key? key,
    required this.moneysForLineChart,
    required this.moneysIncome,
    required this.moneysOutcome,
    this.lineChartIsNull = false,
    this.maxMonthForLineChart,
    this.height = 240,
  }) : super(key: key);
  final List<double> moneysIncome;
  final List<double> moneysOutcome;
  final List<int> moneysForLineChart;
  final double? height;
  final bool lineChartIsNull;
  final int? maxMonthForLineChart;

  @override
  _BarchartMirrorState createState() => _BarchartMirrorState();
}

class _BarchartMirrorState extends State<BarchartMirror> {
  late double _maxValInOutcome;
  late int _indexFocus;
  late List<double> _maxValueList;

  static const double barWidth = 7;

  @override
  void initState() {
    super.initState();
    // _indexFocus = widget.yearMonth.month - 1;
    _getMaxY(widget.moneysIncome, widget.moneysOutcome);
    _maxValueList = List.generate(12, (index) => _maxValInOutcome);
  }

  // static const double barWidth = Constants.dimens_07;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: widget.height,
              child: _chart(
                moneys: widget.moneysIncome,
                maxY: 50000,
                justShowGrid: true,
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: widget.height,
              child: _chart(
                moneys: _maxValueList,
                maxY: _maxValInOutcome,
                isLast: true,
              ),
            ),
            SizedBox(
                width: double.infinity,
                height: widget.height,
                child: _chart(
                    moneys: _maxValueList,
                    maxY: _maxValInOutcome,
                    isLast: true,
                    isIncome: false)),
            SizedBox(
                width: double.infinity,
                height: widget.height,
                child: _chart(
                    moneys: widget.moneysOutcome,
                    maxY: _maxValInOutcome,
                    isIncome: false)),
            SizedBox(
                height: widget.height,
                width: double.infinity,
                child: _chart(
                  moneys: widget.moneysIncome,
                  maxY: _maxValInOutcome,
                )),
            !widget.lineChartIsNull
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: 28,
                      right: 28,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: widget.height,
                      child: LineChartCustom(
                        moneys: widget.moneysForLineChart,
                        greatestValue: _maxValInOutcome,
                        maxMonth: widget.maxMonthForLineChart,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            SizedBox(
                width: double.infinity,
                height: widget.height,
                child: _chart(
                  moneys: widget.moneysIncome,
                  maxY: _maxValInOutcome,
                  visible: true,
                  isLast: false,
                )),
            Container(
              width: double.infinity,
              height: widget.height ?? 270,
              color: Colors.transparent,
            ),
          ],
        ),
        const SizedBox(height: 9),
        _buildDescriptionForChart(),
        const SizedBox(height: 9)
      ],
    );
  }

  List<BarChartGroupData> _barGroupsIncome(
      List<double>? moneys, bool canTouch, bool isLast, bool showGridData) {
    return List.generate(
        moneys!.length,
        (index) => BarChartGroupData(
              x: index + 1,
              showingTooltipIndicators: isLast
                  ? []
                  : widget.lineChartIsNull
                      ? []
                      : widget.moneysForLineChart[_indexFocus] >= 0
                          ? [_indexFocus - index]
                          : [],
              barRods: [
                BarChartRodData(
                  color: isLast ? Colors.grey : Colors.black,
                  toY: index == 12 ? 0 : moneys[index].toDouble(),
                  width: widget.lineChartIsNull
                      ? 0
                      : !isLast
                          ? 10
                          : 34,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
            ))
      ..add(BarChartGroupData(
        x: 13,
        barRods: [
          BarChartRodData(
            color: Colors.red,
            toY: 0,
            width: barWidth,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
      ));
  }

  List<BarChartGroupData> _barGroupsOutcome(
      List<double>? moneys, bool canTouch, bool isLast, bool showGridData) {
    return List.generate(
        moneys!.length,
        (index) => BarChartGroupData(
              x: index + 1,
              showingTooltipIndicators: isLast
                  ? []
                  : widget.moneysForLineChart[_indexFocus] < 0
                      ? [_indexFocus - index]
                      : [],
              barRods: [
                BarChartRodData(
                  color: isLast
                      ? Colors.amber
                      : !canTouch
                          ? Colors.black
                          : Colors.black,
                  toY: index == 12 ? 0 : moneys[index].toDouble() * -1,
                  width: widget.lineChartIsNull
                      ? 0
                      : !isLast
                          ? barWidth
                          : 34,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(6),
                      bottomRight: Radius.circular(6)),
                ),
              ],
            ))
      ..add(BarChartGroupData(
        x: 13,
        barRods: [
          BarChartRodData(
            color: Colors.amberAccent,
            toY: 0,
            width: barWidth,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6)),
          ),
        ],
      ));
  }

  Widget _chart(
      {List<double>? moneys,
      bool isIncome = true,
      bool showGridData = false,
      double maxY = 0,
      bool isLast = false,
      bool visible = false,
      bool justShowGrid = false}) {
    return Padding(
      padding: EdgeInsets.only(
        left: !isLast ? 25 : 12,
        right: !isLast ? 25 : 40,
      ),
      child: BarChart(
        BarChartData(
          maxY: maxY,
          minY: -maxY,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            // SideTitles(
            //   getTextStyles: (val) {
            //     return TextStyles.defaultRoboto.copyWith(
            //         fontSize: val != 13
            //             ? TextStyles.fontSize_14
            //             : TextStyles.fontSize_11,
            //         fontWeight: FontWeight.w500,
            //         color: val == widget.yearMonth.month
            //             ? AppColors.blue6070DF
            //             : AppColors.greyC5C6CB);
            //   },
            //   showTitles: true,
            //   getTitles: (double val) {
            //     if (isLast) {
            //       return '';
            //     }
            //     if (val == 13) {
            //       return '(${L10n.of(context).msgap233})';
            //     }
            //     return val.toInt().toString();
            //   },
            // )
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipMargin: 9,
              tooltipPadding: EdgeInsets.zero,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return null;

                // final money = NumberFormatter.formatPrice(
                //     widget.moneysForLineChart[groupIndex].toInt(), context);
                // return BarTooltipItem(
                //   money,
                //   TextStyles.defaultRegular.copyWith(
                //       fontSize: TextStyles.fontSize_12,
                //       fontWeight: FontWeight.w500,
                //       color: AppColors.green6BD97C),
                // );
              },
            ),
            // touchCallback: (BarTouchResponse event) {}
          ),
          gridData: FlGridData(
            show: justShowGrid,
            drawHorizontalLine: true,
            checkToShowHorizontalLine: (value) => true,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(
                  color: Colors.blue,
                  strokeWidth: 1,
                );
              }
              if (value % 3 == 0) {
                return FlLine(
                  color: Colors.redAccent,
                  strokeWidth: 1,
                  dashArray: [5],
                );
              }
              return FlLine(
                color: Colors.transparent,
              );
            },
          ),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: !justShowGrid
              ? isIncome
                  ? _barGroupsIncome(moneys, visible, isLast, showGridData)
                  : _barGroupsOutcome(moneys, visible, isLast, showGridData)
              : [],
        ),
      ),
    );
  }

  Widget _buildDescriptionForChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildItemForDes(Colors.orange, 'des 1'),
        const SizedBox(
          width: 16,
        ),
        _buildItemForDes(Colors.orange, 'des 1'),
        const SizedBox(
          width: 16,
        ),
        _buildItemForDes(Colors.orange, 'des 1'),
      ],
    );
  }

  Widget _buildItemForDes(Color color, String content, {bool isCircle = true}) {
    return Row(
      children: [
        Container(
          width: isCircle ? 8 : 12,
          height: isCircle ? 8 : 3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                isCircle ? 4 : 10,
              ),
              color: color),
        ),
        const SizedBox(
          width: 3,
        ),
        Text(content, style: const TextStyle())
      ],
    );
  }

  void _getMaxY(List<double> moneysIncome, List<double> moneysOutcome) {
    _maxValInOutcome = moneysIncome.reduce(max) > moneysOutcome.reduce(max)
        ? moneysIncome.reduce(max)
        : moneysOutcome.reduce(max);
    if (_maxValInOutcome == 0) {
      _maxValInOutcome = 10;
    }
    _maxValInOutcome = _maxValInOutcome * 1.3;
  }
}
