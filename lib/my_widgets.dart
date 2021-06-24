import 'package:bmicalculator/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// Main card widget
// Now almost thesame as ButtonCard
class ReusableCard extends StatelessWidget {
  ReusableCard({this.onPressedMy, this.colour, this.widgetContents});

  final Function onPressedMy;
  final Color colour;
  final Widget widgetContents;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colour,
      ),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        fillColor: colour,
        child: widgetContents,
        onPressed: onPressedMy,
      ),
    );
  }
}

// the widget containing genders inside main widget
class GenderCardContent extends StatelessWidget {
  GenderCardContent({this.label, this.iconGender, this.iconStatus});

  final String label;
  final IconData iconGender;
  final IconData iconStatus;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(iconStatus, size: 30.0),
        Text(
          label,
          style: kTextStyle,
          textAlign: TextAlign.center,
        ),
        Icon(
          iconGender,
          size: 30.0,
        ),
      ],
    );
  }
}

// the unit toggle button inside the slider card
class UnitToggleButton extends StatelessWidget {
  UnitToggleButton({
    this.onPress,
  });
  final Function onPress;
  //final bool enabled;

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
      fillColor: kSmallButtonColor,
      child: Icon(
        FontAwesomeIcons.caretDown,
        size: 20,
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
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: GestureDetector(
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
      fillColor: kSmallButtonColor,
    );
  }
}

// Tabs Tabs Tabs
class TabWidget extends StatefulWidget {
  final String title, description, formula, tips;
  final int introIndex;
  final Function onPressed;
  //final Function animate;

  TabWidget({
    this.title,
    this.description,
    this.formula,
    this.introIndex,
    this.tips,
    this.onPressed,
  });

  @override
  _TabWidgetState createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //widget.animate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // Contains the text information except the button
          padding: EdgeInsets.only(left: 5, top: 5, right: 5),
          child: Column(
            children: <Widget>[
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17),
              ),
              Text(
                widget.description,
                textAlign: TextAlign.left,
              ),
              // Image.asset('images/CodeYMCA.png', height: 100, fit: BoxFit.fill)
              Text(
                'Formula:',
                textAlign: TextAlign.center,
              ),
              Text(
                widget.formula,
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green, fontSize: 14),
              ),
              Text(
                widget.tips,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        MaterialButton(
          padding: EdgeInsets.all(15.0),
          color: kBottomContainerColor,
          onPressed: widget.onPressed,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Text(
            'MEASURE NOW',
            style: kLargeButtonTextStyle,
          ),
        )
      ],
    );
  }
}

class MenuButtonContent extends StatelessWidget {
  final String text;
  final String image;
  MenuButtonContent({this.text, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        children: [
          Image(
            image: AssetImage(image),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                text,
                style: kTextStyle,
                textAlign: TextAlign.center,
                // overflow: TextOverflow.ellipsis,
                // maxLines: 3,
              ),
            ),
          )
        ],
      ),
    );
  }
}
