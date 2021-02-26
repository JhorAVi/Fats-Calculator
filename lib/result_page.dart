import 'package:bmicalculator/my_widgets.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class ReportPage extends StatelessWidget {
  ReportPage(
      {@required this.bmiResult,
      @required this.shortSummary,
      @required this.longSummary,
      @required this.genderPath,
      @required this.selFlex1,
      @required this.selFlex2,
      @required this.selFlex3});

  final String bmiResult, shortSummary, longSummary;
  final int selFlex1, selFlex2, selFlex3;
  final String genderPath; // Male or female photo

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Result'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 4 / 2.25,
            child: Container(
              // constraints: BoxConstraints.expand(),
              width: double.infinity,
              //height: 230,
              decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                    image: AssetImage(genderPath),
                    fit: BoxFit.fill,
                    alignment: Alignment.topCenter),
              ),
              child: HumanPointerLayout(selFlex1, selFlex2, selFlex3),
            ),
          ),
          Expanded(
            //flex: 5,
            child: ReusableCard(
              colour: kActiveButtonColor,
              widgetContents: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    shortSummary,
                    style: kResultTextStyle,
                  ),
                  Text(
                    bmiResult,
                    style: kBMITextStyle,
                  ),
                  Text(
                    longSummary,
                    style: kBodyTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          BottomButton(
            text: 'RETURN',
            onPress: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

class HumanPointerLayout extends StatelessWidget {
  HumanPointerLayout(this.selFlex1, this.selFlex2, this.selFlex3);

  final int selFlex1, selFlex2, selFlex3;

  @override
  Widget build(BuildContext context) {
    return Column(
      // the indicator of the body image is defined here
      children: <Widget>[
        Expanded(flex: 60, child: Container(width: double.infinity)),
        Expanded(
          flex: 29,
          child: Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(flex: selFlex1, child: Container()),
              Expanded(flex: selFlex2, child: HumanPointer()),
              Expanded(flex: selFlex3, child: Container()),
            ],
          ),
        ),
        Expanded(flex: 16, child: Container(width: double.infinity))
      ],
    );
  }
}

class HumanPointer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 10, color: Colors.red),
              right: BorderSide(width: 10, color: Colors.red),
              left: BorderSide(width: 10, color: Colors.red))),
    );
  }
}
