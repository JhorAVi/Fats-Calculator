import 'package:flutter/material.dart';
import 'my_widgets.dart';
import 'constants.dart';

class BFTapeResultPage extends StatelessWidget {
  final double bodyFats;
  final bool isFemale;
  String genderPath;
  String shortSummary;
  String longSummary;
  BFTapeResultPage(
      {@required this.bodyFats,
      @required this.isFemale,
      this.genderPath,
      this.shortSummary,
      this.longSummary});

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
