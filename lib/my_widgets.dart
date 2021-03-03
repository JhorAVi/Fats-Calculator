import 'package:bmicalculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonCard extends StatelessWidget {
  ButtonCard({this.onPressedMy, this.colour, this.widgetContents});

  final Function onPressedMy;
  final Color colour;
  final Widget widgetContents;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        fillColor: colour,
        //color: Colors.black,
        onPressed: onPressedMy,
        child: widgetContents,
      ),
    );
  }
}

// Main card widget
class ReusableCard extends StatelessWidget {
  ReusableCard({this.colour, this.widgetContents});

  final Color colour;
  final Widget widgetContents;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colour,
      ),
      child: widgetContents,
    );
  }
}

// the widget containing genders inside main widget
class GenderCardContent extends StatelessWidget {
  GenderCardContent({this.label, this.iconGender});

  final String label;
  final IconData iconGender;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          label,
          style: kTextStyle,
          textAlign: TextAlign.center,
        ),
        Icon(
          iconGender,
          size: 50.0,
        ),
      ],
    );
  }
}

// the unit toggle button inside the slider card
class UnitToggleButton extends StatelessWidget {
  UnitToggleButton({this.onPress, this.text});
  final Function onPress;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      padding: EdgeInsets.symmetric(horizontal: 10),
      elevation: 6.0,
      onPressed: onPress,
      constraints: BoxConstraints.tightFor(
        //width: 100.0,
        height: 40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      fillColor: Color(0xFF4C4F5E),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: kUnitTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(width: 5),
          Icon(FontAwesomeIcons.caretDown, size: 20),
        ],
      ),
    );
  }
}

// the red button at the bottom
class BottomButton extends StatelessWidget {
  BottomButton({this.text, this.onPress});
  final String text;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 20),
        child: Text(text, style: kLargeButtonTextStyle),
        color: kBottomContainerColor,
        height: kBottomContainerHeight,
        // margin: EdgeInsets.only(top: 10),
        width: double.infinity,
      ),
    );
  }
}

// Increment Decrement Buttons encompassing the slider
class SliderSideButton extends StatelessWidget {
  SliderSideButton({this.icon, this.onPress});

  final IconData icon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(icon),
      onPressed: onPress,
      constraints: BoxConstraints.tightFor(
        width: 40,
        height: 40,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 6.0,
      fillColor: Color(0xFF4C4F5E),
    );
  }
}

// Tabs Tabs Tabs
class TabWidget extends StatelessWidget {
  final String title, description, formula;
  TabWidget({this.title, this.description, this.formula});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5, top: 5, right: 5),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              title,
              textAlign: TextAlign.center,
            ),
            Text(
              description,
              textAlign: TextAlign.left,
            ),
            // Image.asset('images/CodeYMCA.png', height: 100, fit: BoxFit.fill)
            Text(
              'Formula:',
              textAlign: TextAlign.center,
            ),
            Text(
              formula,
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
