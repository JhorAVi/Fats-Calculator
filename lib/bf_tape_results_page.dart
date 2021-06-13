import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_widgets.dart';
import 'constants.dart';

class BFTapeResultPage extends StatelessWidget {
  final double bodyFats;
  final bool isFemale;
  String genderPath;
  String shortSummary;
  String longSummary;
  String formulaSummary;
  Color pointerColor;
  final int selFlex1, selFlex2, selFlex3;
  BFTapeResultPage({
    @required this.bodyFats,
    @required this.isFemale,
    this.genderPath,
    this.shortSummary,
    this.longSummary,
    this.formulaSummary,
    @required this.selFlex1,
    @required this.selFlex2,
    @required this.selFlex3,
  }) {
    // adjust the color of the result pointer
    pointerColor = Colors.red; // set the default
    switch (shortSummary) {
      case 'Too low':
        pointerColor = Colors.blue;
        break;
      case 'Skinny':
        pointerColor = Colors.blue;
        break;
      case 'Lean':
        pointerColor = Colors.red;
        break;
      case 'Ideal':
        pointerColor = Colors.red;
        break;
      case 'Average':
        pointerColor = Colors.red;
        break;
      case 'Over fat':
        pointerColor = Colors.cyan;
        break;
      case 'Extremely Obese':
        pointerColor = Colors.cyan;
        break;
      case 'Too high':
        pointerColor = Colors.cyan;
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Body Fats result'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 4 / 2.25,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                      image: AssetImage(genderPath),
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                    ) // to see the overlap
                    ),
                child: HumanPointerLayout(selFlex1, selFlex2, selFlex3, pointerColor),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          bodyFats.toStringAsFixed(1),
                          style: kBMITextStyle,
                        ),
                        Text(
                          ' %',
                          style: TextStyle(fontSize: 30),
                        )
                      ],
                    ),
                    Text(
                      longSummary,
                      style: kBodyTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text('* $formulaSummary')
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
        ));
  }
}

class HumanPointerLayout extends StatelessWidget {
  Color pointerColor;
  HumanPointerLayout(this.selFlex1, this.selFlex2, this.selFlex3, this.pointerColor);

  // the flexes from left, center, right
  final int selFlex1, selFlex2, selFlex3;

  @override
  Widget build(BuildContext context) {
    return Column(
      // the indicator of the body image is defined here
      children: <Widget>[
        // space above the pointer
        Expanded(
          flex: 9,
          child: Container(width: double.infinity),
        ),
        // the whole row where the pointer belongs
        Expanded(
          flex: 1,
          child: Row(
            children: <Widget>[
              Expanded(flex: selFlex1, child: Container()), // left of pointer
              Expanded(flex: selFlex2, child: HumanPointer(pointerColor)), // the three sided pointer
              Expanded(flex: selFlex3, child: Container()), // right of the pointer
            ],
          ),
        ),
        // space below the pointer
/*        Expanded(
          // flex: 1,
          child: Container(width: double.infinity),
        )*/
      ],
    );
  }
}

class HumanPointer extends StatelessWidget {
  HumanPointer(this.pointerColor);
  Color pointerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25,
/*      decoration: const BoxDecoration(
          border: Border(
              //   bottom: BorderSide(width: 10, color: Colors.red),
              right: BorderSide(width: 10, color: Colors.red),
              left: BorderSide(width: 10, color: Colors.red))),*/
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Icon(Icons.arrow_back_ios, color: Colors.brown),
            //SizedBox(width: 30),
            //Icon(Icons.arrow_forward_ios, color: Colors.brown),
            Expanded(
              flex: 1,
              child: Container(
                color: pointerColor,
                //width: 5,
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                color: pointerColor,
                height: 5,
                // width: 76,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                color: pointerColor,
                //width: 5,
              ),
            )
          ],
        ));
  }
}
