import 'package:flutter/material.dart';
import 'package:bmicalculator/bf_tape_page.dart';
import 'package:bmicalculator/input_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'my_widgets.dart';
import 'constants.dart';
//import 'result_page.dart';
import 'function_utils.dart';

enum Gender { male, female }
Gender selectedGender;

// investigate if it's best stateful or stateless because of SingleChildScrollView
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[Text('BMI CALCULATOR   '), Text('by jhoravi', style: kAuthorTextStyle)],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ReusableCard(
              onPressedMy: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return InputPage();
                }));
              },
              colour: kInActiveButtonColor,
              widgetContents: GenderCardContent(
                label: 'BMI',
                iconGender: FontAwesomeIcons.mars,
              ),
            ),
            ReusableCard(
              onPressedMy: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FatsTape();
                }));
              },
              colour: kInActiveButtonColor,
              widgetContents: GenderCardContent(
                label: 'BodyFats Tape measure',
                iconGender: FontAwesomeIcons.venus,
              ),
            ),
            ReusableCard(
              onPressedMy: () {
                setState(() {
                  selectedGender = Gender.male;
                });
              },
              colour: kInActiveButtonColor,
              widgetContents: GenderCardContent(
                label: 'BodyFats Caliper',
                iconGender: FontAwesomeIcons.mars,
              ),
            ),
            ReusableCard(
              onPressedMy: () {
                setState(() {
                  selectedGender = Gender.female;
                });
              },
              colour: kInActiveButtonColor,
              widgetContents: GenderCardContent(
                label: 'Ideal weight',
                iconGender: FontAwesomeIcons.venus,
              ),
            ),
            ReusableCard(
              onPressedMy: () {
                setState(() {
                  selectedGender = Gender.male;
                });
              },
              colour: kInActiveButtonColor,
              widgetContents: GenderCardContent(
                label: 'Ideal Calories',
                iconGender: FontAwesomeIcons.mars,
              ),
            ),
            ReusableCard(
              onPressedMy: () {
                setState(() {
                  selectedGender = Gender.female;
                });
              },
              colour: kInActiveButtonColor,
              widgetContents: GenderCardContent(
                label: 'Graph',
                iconGender: FontAwesomeIcons.venus,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
