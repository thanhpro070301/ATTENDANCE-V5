import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample7 extends StatelessWidget {
  LineChartSample7({
    super.key,
    Color? line1Color,
    Color? line2Color,
    Color? betweenColor, required this.listLineBarData,
  })  : line1Color = line1Color ?? Colors.green,
        line2Color = line2Color ?? Colors.redAccent,
        betweenColor = betweenColor ?? Colors.cyan.withOpacity(0.5);

  final Color line1Color;
  final Color line2Color;
  final Color betweenColor;
  final List<LineChartBarData>listLineBarData;

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }


  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '$value%',
        style: style,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double sum = 0;
    double yPresent=0;
    double yAbsent=0;
    for(int i=0;i<12;i++){
       yPresent = listLineBarData.first.spots[i].y;
       yAbsent = listLineBarData.last.spots[i].y;
      sum=yAbsent+yPresent;
      if(sum!=0) {
        yPresent=(yPresent/sum)*100;
        yAbsent=(yAbsent/sum)*100;
      }
       listLineBarData.first.spots[i] = FlSpot(i.toDouble(), yPresent);
      listLineBarData.last.spots[i] = FlSpot(i.toDouble(), yAbsent);
    }
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.only(
          left: 10,
          right: 18,
          top: 18,
          bottom: 4,
        ),
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
        child: Stack(
          children: [
            const Align(alignment: Alignment.topCenter,child: Text('REPORT ATTENDANCE ',style: TextStyle(color: Colors.grey,fontStyle: FontStyle.italic,fontSize: 18, fontWeight: FontWeight.bold),),),
            Positioned(
                 child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: true),
                lineBarsData: listLineBarData,
                betweenBarsData: [
                  BetweenBarsData(
                    fromIndex: 0,
                    toIndex: 1,
                    color: Colors.pinkAccent.withOpacity(0.5),
                  ),
                ],
                minY: 0,
                maxY: 100,
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitleWidgets,
                      interval: 10,
                      reservedSize: 36,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  checkToShowHorizontalLine: (double value) {
                    return value == 1 || value == 6 || value == 4 || value == 5;
                  },
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
