import 'package:flutter/material.dart';
import 'my_widgets.dart';
import 'constants.dart';

class BFTapeResultPage extends StatelessWidget {
  final double bodyFats;
  final bool isFemale;
  String genderPath;
  String shortSummary;
  String longSummary;
  final int selFlex1, selFlex2, selFlex3;
  BFTapeResultPage({
    @required this.bodyFats,
    @required this.isFemale,
    this.genderPath,
    this.shortSummary,
    this.longSummary,
    @required this.selFlex1,
    @required this.selFlex2,
    @required this.selFlex3,
  });

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
                      bodyFats.toStringAsFixed(1),
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
        ));
  }
}

class HumanPointerLayout extends StatelessWidget {
  HumanPointerLayout(this.selFlex1, this.selFlex2, this.selFlex3);

  // the flexes from left, center, right
  final int selFlex1, selFlex2, selFlex3;

  @override
  Widget build(BuildContext context) {
    return Column(
      // the indicator of the body image is defined here
      children: <Widget>[
        // space above the pointer
        Expanded(
          flex: 60,
          child: Container(width: double.infinity),
        ),
        // the whole row where the pointer belongs
        Expanded(
          flex: 29,
          child: Row(
            children: <Widget>[
              Expanded(flex: selFlex1, child: Container()), // left of pointer
              Expanded(flex: selFlex2, child: HumanPointer()), // the three sided pointer
              Expanded(flex: selFlex3, child: Container()), // right of the pointer
            ],
          ),
        ),
        // space below the pointer
        Expanded(
          flex: 16,
          child: Container(width: double.infinity),
        )
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
