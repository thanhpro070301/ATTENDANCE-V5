import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample2 extends StatefulWidget {

  const BarChartSample2({super.key, required this.absentData, required this.presentData});
  final List<Map<String,double>> absentData;
  final List<Map<String,double>> presentData;

  final Color absentBarColor = Colors.red;
  final Color presentBarColor = Colors.green;
  final Color avgColor = Colors.orange;
  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;




  @override
  Widget build(BuildContext context) {
    BarChartGroupData barGroup1;
    BarChartGroupData barGroup2;
    BarChartGroupData barGroup3;
    BarChartGroupData barGroup4;
    BarChartGroupData barGroup5;
    BarChartGroupData barGroup6;
    BarChartGroupData barGroup7;
    if(widget.absentData.isEmpty || widget.presentData.isEmpty){
      barGroup1  = makeGroupData(0, 0,0);
      barGroup2  = makeGroupData(1, 0,0);
      barGroup3  = makeGroupData(2, 0,0);
      barGroup4  = makeGroupData(3, 0,0);
      barGroup5  = makeGroupData(4, 0,0);
      barGroup6  = makeGroupData(5, 0,0);
      barGroup7  = makeGroupData(6, 0,0);
    }else{
       barGroup1 = makeGroupData(0, widget.presentData[0].values.first,
          widget.absentData[0].values.first);
       barGroup2 = makeGroupData(1, widget.presentData[1].values.first,
          widget.absentData[1].values.first);
       barGroup3 = makeGroupData(2, widget.presentData[2].values.first,
          widget.absentData[2].values.first);
       barGroup4 = makeGroupData(3, widget.presentData[3].values.first,
          widget.absentData[3].values.first);
       barGroup5 = makeGroupData(4, widget.presentData[4].values.first,
          widget.absentData[4].values.first);
       barGroup6 = makeGroupData(5, widget.presentData[5].values.first,
          widget.absentData[5].values.first);
       barGroup7 = makeGroupData(6, widget.presentData[6].values.first,
          widget.absentData[6].values.first);
    }

    final items = [
      barGroup1,
      barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.only( left: 10,
          right: 18,
          top: 18,
          bottom: 4,),
        margin:const  EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(2, 4), // changes position of shadow
              ),
            ]
        ),
        child:  BarChart(
                BarChartData(
                  maxY: 100,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.grey,
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                          in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                                barRods: showingBarGroups[touchedGroupIndex]
                                    .barRods
                                    .map((rod) {
                                  return rod.copyWith(
                                      toY: avg, color: widget.avgColor);
                                }).toList(),
                              );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles:  AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles:  AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 10,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData:  FlGridData(show: false),
                ),
              ),


      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${value}%',
        style: style,
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double yPresent, double yAbsent) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: yPresent,
          color: widget.presentBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: yAbsent,
          color: widget.absentBarColor,
          width: width,
        ),
      ],
    );
  }

  Widget makeTransactionsIcon() {
    const width = 4.5;
    const space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
