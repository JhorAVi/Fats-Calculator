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
              widgetContents: MenuButtonContent(
                text: 'BMI',
                image: 'images/bmiButton.jpg',
              ),
            ),
            ReusableCard(
              onPressedMy: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return FatsTape();
                }));
              },
              colour: kInActiveButtonColor,
              widgetContents: MenuButtonContent(
                text: 'Body fats using \nTape measure\n(simplier)',
                image: 'images/tapeMeasureWithBody.jpg',
              ),
            ),
            ReusableCard(
              onPressedMy: () {
                setState(() {
                  selectedGender = Gender.male;
                });
              },
              colour: kInActiveButtonColor,
              widgetContents: MenuButtonContent(
                image: 'images/caliperWithBody.jpg',
                text: 'Body fats using \nCaliper\n(more accurate)',
              ),
            ),
            ReusableCard(
                onPressedMy: () {
                  setState(() {
                    selectedGender = Gender.female;
                  });
                },
                colour: kInActiveButtonColor,
                widgetContents: MenuButtonContent(
                  text: 'Ideal weight',
                  image: 'images/weightscale.jpg',
                )),
            ReusableCard(
              onPressedMy: () {
                setState(() {
                  selectedGender = Gender.male;
                });
              },
              colour: kInActiveButtonColor,
              widgetContents: MenuButtonContent(
                text: 'Ideal calories',
                image: 'images/calories2.jpg',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
