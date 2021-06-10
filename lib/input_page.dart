import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'my_widgets.dart';
import 'constants.dart';
import 'result_page.dart';
import 'function_utils.dart';
import 'scale_class.dart';

enum Gender { male, female }
Gender selectedGender;
String genderPath;
bool isFemale = false; // enable or disable additional slides for female
/*bool lbsIsDefault = true;
bool cmIsDefault = true; // lbs and centimeters are default metric*/

WeightScale cWeight = WeightScale(lbsMin: 50, lbsMax: 300);
LengthScale cHeight = LengthScale(cmMin: 91, cmMax: 228, text: 'HEIGHT');

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[Text('BMI CALCULATOR   '), Text('by jhorViente', style: kAuthorTextStyle)],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // GENDER GENDER
            Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: ReusableCard(
                      onPressedMy: () {
                        setState(() {
                          selectedGender = Gender.male;
                          isFemale = false;
                        });
                      },
                      colour: (selectedGender == Gender.male) ? Color(0xFF4C4F5E) : kInActiveButtonColor,
                      widgetContents: GenderCardContent(
                        label: 'MALE',
                        iconGender: FontAwesomeIcons.male,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: ReusableCard(
                      onPressedMy: () {
                        setState(() {
                          selectedGender = Gender.female;
                          isFemale = true;
                        });
                      },
                      colour: (selectedGender == Gender.female) ? Color(0xFF4C4F5E) : kInActiveButtonColor,
                      widgetContents: GenderCardContent(
                        label: 'FEMALE',
                        iconGender: FontAwesomeIcons.female,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS
            ReusableCard(
              colour: kInActiveButtonColor,
              widgetContents: statsCardContent(
                  // HEIGHT HEIGHT HEIGHT
                  text: cHeight.text,
                  unit: cHeight.unit,
                  value: cHeight.length,
                  min: cHeight.min,
                  max: cHeight.max,
                  toggleText: cHeight.toggleText),
            ),
            ReusableCard(
              colour: kInActiveButtonColor,
              widgetContents: statsCardContent(
                  // WEIGHT WEIGHT WEIGHT
                  text: cWeight.text,
                  unit: cWeight.unit,
                  value: cWeight.weight,
                  min: cWeight.min,
                  max: cWeight.max,
                  toggleText: cWeight.toggleText),
            ),
            buildBottomButton(context) // CALCULATE BUTTON
          ],
        ),
      ),
    );
  }

  BottomButton buildBottomButton(BuildContext context) {
    return BottomButton(
      // CALCULATE CALCULATE CALCULATE CALCULATE
      // CALCULATE CALCULATE CALCULATE CALCULATE
      text: 'CALCULATE',
      onPress: () {
        CalculatorBrain calc =
            CalculatorBrain(height: cHeight.length, weight: cWeight.weight, lbsIsDefault: cWeight.lbsIsDefault, cmIsDefault: cHeight.cmIsDefault);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ReportPage(
                bmiResult: calc.calculateBMI(),
                shortSummary: calc.shortSummary(),
                longSummary: calc.longSummary(),
                selFlex1: calc.getFlex1(),
                selFlex2: calc.getFlex2(),
                selFlex3: calc.getFlex3(),
                genderPath: (selectedGender == Gender.female) ? 'images/bmi females.jpg' : 'images/bmi males.jpg',
              );
            },
          ),
        );
      },
    );
  }

  // Widget inside the slider card FUNCTION
  // Widget inside the slider card FUNCTION
  // TODO add the ft with proper size
  Column statsCardContent(
      {final String text,
      final String unit,
      final double value, // To display the initial value depending on the metrics
      final int min,
      final int max,
      final String toggleText}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              // WEIGHT or HEIGHT TEXT
              text,
              style: kTextStyle,
            ),
            SizedBox(width: 10),
            // tap to Add .1 decimal accuracy to the value
            GestureDetector(
              child: Row(
                children: [
                  Text(
                    // SLIDER CURRENT VALUE NUMBER
                    currentValueTxt(text),
                    style: kAgeTextStyle,
                  ),
                  Text(
                    currentFeetText(text, unit),
                    style: kUnitTextStyle, // show feet or not
                  ),
                  Text(
                    currentInchesText(text, unit),
                    style: kAgeTextStyle, // show inch fraction or not
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  incrementFractionNow(text); // FRACTIONAL INCREMENT
                });
              },
            ),
            /*           SizedBox(
              width: 2,
            ),*/
//            Text(unit, style: kUnitTextStyle),
            Text(
              ' $unit',
              style: kUnitTextStyle,
              // textAlign: TextAlign.center,
            ),
            // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
            // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
            UnitToggleButton(
              // Negate the UNIT Button  // Make sure that the conversion has decimal accuracy
              //text: toggleText,
              enabled: disableToggleOnAge(text),
              onPress: () {
                setState(() {
                  toggleNow(text, unit); // Change the value after toggle
                });
              },
            ),
          ],
        ),
        Row(
          // SLIDER ROW SLIDER ROW SLIDER ROW
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              // DECREMENT DECREMENT DECREMENT DECREMENT DECREMENT
              // DECREMENT DECREMENT DECREMENT DECREMENT DECREMENT
              // Does not care if it is kgs or lbs
              flex: 1,
              child: SliderSideButton(
                icon: FontAwesomeIcons.minus,
                onPress: () {
                  setState(() {
                    decrementNow(text); // Decrement now!
                  });
                },
              ),
            ),
            Expanded(
              flex: 8,
              // SLIDER SLIDER SLIDER SLIDER SLIDER
              // SLIDER SLIDER SLIDER SLIDER SLIDER
              child: Slider(
                  value: value,
                  min: min.toDouble(),
                  max: max.toDouble(),
                  activeColor: Color(0xFFEB1555),
                  inactiveColor: Color(0xFF8D8E98),
                  onChanged: (newValue) {
                    setState(() {
                      newValueTxt(text, newValue); // New value in text
                    });
                  }),
            ),
            Expanded(
                // INCREMENT INCREMENT INCREMENT INCREMENT
                // INCREMENT INCREMENT INCREMENT INCREMENT
                // Doesn't care if it's kgs or lbs
                flex: 1,
                child: SliderSideButton(
                  icon: FontAwesomeIcons.plus,
                  onPress: () {
                    setState(() {
                      incrementNow(text); // perform increment
                    });
                  },
                ))
          ],
        ),
      ],
    );
  }

  // The actual value depending on the text
  String currentValueTxt(String text) {
    if (text == 'WEIGHT')
      return cWeight.weightDisplay;
    else if (text == 'HEIGHT')
      return cHeight.lengthDisplay;
    else
      return '';
  }

  // Process the visibility of the feet text
  String currentFeetText(String text, String unit) {
    //return (text == 'HEIGHT') ? cHeight.feetText : '';
    return (text == 'HEIGHT' && unit == 'in.') ? 'ft. ' : '';
  }

  // Process the inches display part
  String currentInchesText(String text, unit) {
    return (text == 'HEIGHT' && unit == 'in.') ? cHeight.inchesDisplay : '';
  }

  // The new value in text returned by the slider
  void newValueTxt(String text, double newValue) {
    // I've just changed this from STring to void
    if (text == "HEIGHT")
      cHeight.editValue(newValue);
    else if (text == "WEIGHT") cWeight.editValue(newValue);
  }

  // increment by fraction
  void incrementFractionNow(String text) {
    if (text == 'WEIGHT')
      cWeight.incrementPointOne();
    else if (text == 'HEIGHT') cHeight.incrementPointOne();
  }

  void decrementNow(String text) {
    if (text == "WEIGHT")
      cWeight.decrementOne();
    else if (text == "HEIGHT") cHeight.decrementOne();
  }

  void incrementNow(String text) {
    if (text == 'WEIGHT')
      cWeight.incrementOne();
    else if (text == 'HEIGHT') cHeight.incrementOne();
  }

  // toggle text
  // this is the only function with AGE is excuded
  void toggleNow(String text, unit) {
    if (text == 'HEIGHT' && unit == 'cm.')
      cHeight.toggleToInches();
    else if (text == 'HEIGHT' && unit == 'in.')
      cHeight.toggleToCentimeters();
    else if (text == 'WEIGHT' && unit == 'kgs')
      cWeight.toggleToLbs();
    else if (text == 'WEIGHT' && unit == 'lbs') cWeight.toggleToKilograms();
  }

  // no toggle arrow down on AGE
  bool disableToggleOnAge(String text) {
    return (text == 'AGE') ? false : true;
  }
}
