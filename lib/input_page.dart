import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'my_widgets.dart';
import 'constants.dart';
import 'result_page.dart';
import 'function_utils.dart';

enum Gender { male, female }
Gender selectedGender;
String genderPath;
//enum SelectedUnit { lb, kg, cm, inch }
//enum WeightUnit { lb, kg }
//enum HeightUnit { cm, inch }
//enum Metric { height, weight }

//WeightUnit weightUnit = WeightUnit.lb;
//HeightUnit heightUnit = HeightUnit.cm;
//SelectedUnit selectedUnit;
//Metric selectedMetric;

String weightUnitStr = 'lbs';
String heightUnitStr = 'centimeters';

bool lbsIsDefault = true;
bool cmIsDefault = true; // lbs and centimeters are default metric

// Weight slider properties
// These are the 8 variables needed for each slider
// Good thing is only the first two need values
const int lbsMin = 50; // min slider range
const int lbsMax = 300; // max slider range
final int kgMin = lbsToKilograms(lbsMin.toDouble()).round(); // 23;
final int kgMax = lbsToKilograms(lbsMax.toDouble()).round(); //136;
int weightMin = lbsMin; // current metric used. lbs(default) or kgs
int weightMax = lbsMax; // current metric used. lbs(default) or kgs
double weight = (lbsMin + lbsMax) / 2; // initial weight at the center
String heightDisplay = height.round().toString();

// Height slider variables
const int cmMin = 91; // needs a set for each slider
const int cmMax = 228; //
final int inchMin = centimetersToInches(cmMin.toDouble()).round(); // 36;
final int inchMax = centimetersToInches(cmMax.toDouble()).round(); // 90;
int heightMin = cmMin; // default used is cm value. Needs a set for each slider
int heightMax = cmMax; // default used is cm value
double height = (cmMin + cmMax) / 2; // height initially at the center of slider
String weightDisplay = weight.round().toString();

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[Text('BMI CALCULATOR   '), Text('by jhoravi', style: kAuthorTextStyle)],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2 / 1.3,
                    child: ButtonCard(
                      onPressedMy: () {
                        setState(() {
                          selectedGender = Gender.male;
                        });
                      },
                      colour: (selectedGender == Gender.male) ? kActiveButtonColor : kInActiveButtonColor,
                      widgetContents: GenderCardContent(
                        label: 'MALE',
                        iconGender: FontAwesomeIcons.mars,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2 / 1.3,
                    child: ButtonCard(
                      onPressedMy: () {
                        setState(() {
                          selectedGender = Gender.female;
                        });
                      },
                      colour: (selectedGender == Gender.female) ? kActiveButtonColor : kInActiveButtonColor,
                      widgetContents: GenderCardContent(
                        label: 'FEMALE',
                        iconGender: FontAwesomeIcons.venus,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS
          Expanded(
            // WEIGHT SLIDER CARD
            child: ReusableCard(
              colour: kInActiveButtonColor,
              widgetContents: statsCardContent(
                  text: 'WEIGHT', unit: weightUnitStr, value: weight, min: weightMin, max: weightMax, toggleText: 'toggle lbs or kilogram'),
            ),
          ),
          Expanded(
              // HEIGHT SLIDER CARD
              child: ReusableCard(
            colour: kInActiveButtonColor,
            widgetContents:
                statsCardContent(text: 'HEIGHT', unit: heightUnitStr, value: height, min: heightMin, max: heightMax, toggleText: 'toggle cm or feet'),
          )),
          BottomButton(
            // CALCULATE CALCULATE CALCULATE CALCULATE
            // CALCULATE CALCULATE CALCULATE CALCULATE
            text: 'CALCULATE',
            onPress: () {
              CalculatorBrain calc = CalculatorBrain(height: height, weight: weight, lbsIsDefault: lbsIsDefault, cmIsDefault: cmIsDefault);
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
          ),
        ],
      ),
    );
  }

  // Widget inside the slider card FUNCTION
  // Widget inside the slider card FUNCTION
  Column statsCardContent(
      {final String text,
      final String unit,
      final double value, // To display the initial value depending on the metrics
      final int min,
      final int max,
      final String toggleText}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
            // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
            UnitToggleButton(
              // Negate the UNIT Button  // Make sure that the conversion has decimal accuracy
              unitName: toggleText,
              onPress: () {
                if (text == 'HEIGHT' && unit == 'centimeters') {
                  heightUnitStr = 'inches';
                  height = centimetersToInches(height); // temp
                  heightMin = inchMin;
                  heightMax = inchMax;
                  cmIsDefault = false;
                  setState(() {
                    heightDisplay = (height ~/ 12).toInt().toString() + ' ft, ' + (height % 12).toStringAsFixed(0);
                  });
                } else if (text == 'HEIGHT' && unit == 'inches') {
                  heightUnitStr = 'centimeters';
                  height = inchesToCentimeters(height); // Do conversion here
                  heightMin = cmMin;
                  heightMax = cmMax;
                  cmIsDefault = true;
                  setState(() {
                    heightDisplay = height.toStringAsFixed(0); // remove zero decimal
                  });
                } else if (text == 'WEIGHT' && unit == 'kilograms') {
                  weightUnitStr = 'lbs';
                  weight = kilogramsToLbs(weight); // round off
                  weightMin = lbsMin;
                  weightMax = lbsMax;
                  lbsIsDefault = true;
                  setState(() {
                    weightDisplay = weight.toStringAsFixed(0); // remove trailing zeros
                  });
                } else if (text == 'WEIGHT' && unit == 'lbs') {
                  weightUnitStr = 'kilograms';
                  weight = lbsToKilograms(weight); //  Do conversion here
                  weightMin = kgMin;
                  weightMax = kgMax;
                  lbsIsDefault = false;
                  setState(() {
                    weightDisplay = weight.toStringAsFixed(0); // remove trailing zeros
                  });
                }
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              // SLIDER CURRENT VALUE NUMBER
              (text == 'WEIGHT') ? weightDisplay : heightDisplay,
              style: kAgeTextStyle,
            ),
            SizedBox(
              width: 5,
            ),
            Text(unit, style: kUnitTextStyle),
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
                  switch (text) {
                    case "WEIGHT":
                      {
                        if (min + 1 < weight - 1 && max - 1 > weight - 1) {
                          weight = weight.roundToDouble() - 1;
                          setState(() {
                            weightDisplay = weight.toStringAsFixed(0); // temp
                          });
                        }
                      }
                      break;
                    case "HEIGHT":
                      {
                        if (min + 1 < height - 1 && max - 1 > height - 1) {
                          height = height.roundToDouble() - 1;
                          setState(() {
                            if (unit == 'inches') {
                              heightDisplay = (height ~/ 12).toInt().toString() + ' ft, ' + (height % 12).toStringAsFixed(0);
                            } else {
                              heightDisplay = height.toStringAsFixed(0);
                            }
                          });
                        }
                      }
                      break;
                    default:
                      break;
                  }
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
                    switch (text) {
                      case "HEIGHT":
                        {
                          if (min + 1 < newValue && max - 1 > newValue) {
                            // deduct 1 in range for safety
                            height = newValue.roundToDouble(); // Move fractions for now
                            setState(() {
                              if (unit == 'inches') {
                                heightDisplay = (height ~/ 12).toInt().toString() + ' ft, ' + (height % 12).toStringAsFixed(0);
                              } else {
                                heightDisplay = height.toStringAsFixed(0);
                              }
                            });
                            //print(height); // debug
                          }
                        }
                        break;
                      case "WEIGHT":
                        {
                          if (min + 1 < newValue && max - 1 > newValue) {
                            // deduct 1 in range for safety
                            weight = newValue.roundToDouble(); // remove fractions for now
                            setState(() {
                              weightDisplay = weight.toStringAsFixed(0);
                            });
                            //print(weight); // debug
                          }
                        }
                        break;
                      default:
                        break;
                    }
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
                    switch (text) {
                      case "WEIGHT":
                        {
                          if (min + 1 < weight + 1 && max - 1 > weight + 1) {
                            weight = weight.roundToDouble() + 1;
                            setState(() {
                              weightDisplay = weight.toStringAsFixed(0);
                            });
                          }
                        }
                        break;
                      case "HEIGHT":
                        {
                          if (min + 1 < height + 1 && max - 1 > height + 1) {
                            height = height.roundToDouble() + 1;
                            setState(() {
                              if (unit == 'inches') {
                                heightDisplay = (height ~/ 12).toInt().toString() + ' ft, ' + (height % 12).toStringAsFixed(0);
                              } else {
                                heightDisplay = height.toStringAsFixed(0);
                              }
                            });
                          }
                        }
                        break;
                      default:
                        break;
                    }
                  },
                ))
          ],
        ),
      ],
    );
  }
}
