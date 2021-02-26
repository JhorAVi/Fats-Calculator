import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'my_widgets.dart';
import 'constants.dart';
import 'function_utils.dart';
import 'scale_class.dart';
import 'bf_tape_results_page.dart';
import 'dart:io';

enum Gender { male, female }
Gender selectedGender;
String genderPath;

// the default formulas
FatFormula selectedFatFormula = FatFormula.MYMCA;
// for use in bit selections
bool isFemale = false; // enable or disable additional slides for female
bool isMYMCA = true;
bool isUSNAVY = false;
bool isCOVERTBAILEY = false;
bool isHERITAGE = false;
double _fatsYMCA = 0.0;
double _fatsHERITAGE = 0.0;
double _fatsUSNAVY = 0.0;
double _fatsCOVERTBAILEY = 0.0;

AgeScale cAge = AgeScale(min: 5, max: 100);
WeightScale cWeight = WeightScale(lbsMin: 50, lbsMax: 300);
LengthScale cHeight = LengthScale(cmMin: 91, cmMax: 228, text: 'HEIGHT');
LengthScale cWaist = LengthScale(cmMin: 20, cmMax: 200, text: 'WAIST');
LengthScale cHips = LengthScale(cmMin: 20, cmMax: 200, text: 'HIP');
LengthScale cWrist = LengthScale(cmMin: 5, cmMax: 30, text: 'WRIST');
LengthScale cForearm = LengthScale(cmMin: 5, cmMax: 50, text: 'FOREARM');
LengthScale cThigh = LengthScale(cmMin: 5, cmMax: 50, text: 'THIGH');
LengthScale cCalf = LengthScale(cmMin: 5, cmMax: 50, text: 'CALF');
LengthScale cNeck = LengthScale(cmMin: 5, cmMax: 50, text: 'NECK');

class FatsTape extends StatefulWidget {
  @override
  _FatsTapeState createState() => _FatsTapeState();
}

class _FatsTapeState extends State<FatsTape> with SingleTickerProviderStateMixin {
  // tabs definition
  final _kTabs = <Tab>[
    Tab(text: 'mod YMCA'),
    Tab(text: 'US Navy'),
    Tab(text: 'Covert Bailey'),
    Tab(text: 'Heritage'),
  ];

  final _kTabPages = <Widget>[
    TabWidget(
      title: 'Modified YMCA',
      description: kYMCADescription,
      formula: kYMCAFormula,
    ),
    TabWidget(
      title: 'Department of Defense a.k.a. US Navy',
      description: kUSNAVYDescription,
      formula: kUSNAVYFormula,
    ),
    TabWidget(
      title: 'Covert Bailey',
      description: kCovertBaileyDescription,
      formula: kCoverBaileyFormula,
    ),
    TabWidget(
      title: 'Heritage',
      description: kHeritageDescription,
      formula: kHeritageFormula,
    ),
  ];

  // Tab controller
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: _kTabs.length)
      ..addListener(() {
        setState(() {
          switch (_tabController.index) {
            // Modified YMCA selected // Modified YMCA selected
            case 0:
              {
                setState(() {
                  isMYMCA = true;
                  isUSNAVY = false;
                  isCOVERTBAILEY = false;
                  isHERITAGE = false;
                  selectedFatFormula = FatFormula.MYMCA;
                });
              }
              break;
            // US Navy selected US Navy selected
            case 1:
              {
                // Modified YMCA selected
                setState(() {
                  isMYMCA = false;
                  isUSNAVY = true;
                  isCOVERTBAILEY = false;
                  isHERITAGE = false;
                  selectedFatFormula = FatFormula.USNAVY;
                });
              }
              break;
            // Convert Baily selected Covert Bailey selected
            case 2:
              {
                // Modified YMCA selected
                setState(() {
                  isMYMCA = false;
                  isUSNAVY = false;
                  isCOVERTBAILEY = true;
                  isHERITAGE = false;
                  selectedFatFormula = FatFormula.COVERTBAILEY;
                });
              }
              break;
            // Heritage BMI selected Heritage selected
            case 3:
              {
                // Modified YMCA selected
                setState(() {
                  isMYMCA = false;
                  isUSNAVY = false;
                  isCOVERTBAILEY = false;
                  isHERITAGE = true;
                  selectedFatFormula = FatFormula.HERIGATE;
                });
              }
              break;
            default:
              break;
          }
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
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
            // TABS start here!!!!!
            TabBar(
              // tabs
              controller: _tabController,
              tabs: _kTabs,
            ),
            Container(
              height: 200,
              child: TabBarView(
                controller: _tabController,
                children: _kTabPages,
              ),
            ),
            // Tab results Tab results Tab results
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(_fatsYMCA.toStringAsFixed(1), textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text(_fatsUSNAVY.toStringAsFixed(1), textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text(_fatsCOVERTBAILEY.toStringAsFixed(1), textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text(_fatsHERITAGE.toStringAsFixed(1), textAlign: TextAlign.center),
                  )
                ],
              ),
            ),

            // GENDER GENDER
            Row(
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: ButtonCard(
                      onPressedMy: () {
                        setState(() {
                          selectedGender = Gender.male;
                          isFemale = false;
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
                    aspectRatio: 2 / 1,
                    child: ButtonCard(
                      onPressedMy: () {
                        setState(() {
                          selectedGender = Gender.female;
                          isFemale = true;
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
            // SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS
            ReusableCard(
              // AGE AGE AGE
              colour: kInActiveButtonColor,
              widgetContents: ageCardContent(text: cAge.text, unit: cAge.unit, value: cAge.age, min: cAge.min, max: cAge.max),
            ),
            Visibility(
              visible: isUSNAVY | isHERITAGE,
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cHeight.text,
                    unit: cHeight.unit,
                    value: cHeight.length,
                    min: cHeight.min,
                    max: cHeight.max,
                    toggleText: cHeight.toggleText),
              ),
            ),

            Visibility(
              visible: isMYMCA | isHERITAGE,
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cWeight.text,
                    unit: cWeight.unit,
                    value: cWeight.weight,
                    min: cWeight.min,
                    max: cWeight.max,
                    toggleText: cWeight.toggleText),
              ),
            ),

            Visibility(
              visible: isMYMCA | isUSNAVY | (isCOVERTBAILEY & !isFemale),
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cWaist.text, unit: cWaist.unit, value: cWaist.length, min: cWaist.min, max: cWaist.max, toggleText: cWaist.toggleText),
              ),
            ),
            Visibility(
              visible: (isMYMCA & isFemale) | (isUSNAVY & isFemale) | isCOVERTBAILEY,
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cHips.text, unit: cHips.unit, value: cHips.length, min: cHips.min, max: cHips.max, toggleText: cHips.toggleText),
              ),
            ),
            Visibility(
              visible: (isMYMCA & isFemale) | (isCOVERTBAILEY & !isFemale),
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cForearm.text,
                    unit: cForearm.unit,
                    value: cForearm.length,
                    min: cForearm.min,
                    max: cForearm.max,
                    toggleText: cForearm.toggleText),
              ),
            ),
            Visibility(
              visible: (isMYMCA & isFemale) | isCOVERTBAILEY,
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cWrist.text, unit: cWrist.unit, value: cWrist.length, min: cWrist.min, max: cWrist.max, toggleText: cWrist.toggleText),
              ),
            ),

            Visibility(
              visible: (isCOVERTBAILEY & isFemale),
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cThigh.text, unit: cThigh.unit, value: cThigh.length, min: cThigh.min, max: cThigh.max, toggleText: cThigh.toggleText),
              ),
            ),

            Visibility(
              visible: (isCOVERTBAILEY & isFemale),
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cCalf.text, unit: cCalf.unit, value: cCalf.length, min: cCalf.min, max: cCalf.max, toggleText: cCalf.toggleText),
              ),
            ),
            Visibility(
              visible: isUSNAVY,
              child: ReusableCard(
                colour: kInActiveButtonColor,
                widgetContents: statsCardContent(
                    text: cNeck.text, unit: cNeck.unit, value: cNeck.length, min: cNeck.min, max: cNeck.max, toggleText: cNeck.toggleText),
              ),
            ),

            BottomButton(
              // CALCULATE CALCULATE CALCULATE CALCULATE
              // CALCULATE CALCULATE CALCULATE CALCULATE
              text: 'CALCULATE',
              onPress: () {
                CalcBodyFats calcBF = CalcBodyFats(
                    age: cAge.age,
                    isFemale: isFemale,
                    weight: cWeight.weight,
                    height: cHeight.length,
                    waist: cWaist.length,
                    hips: cHips.length,
                    forearm: cForearm.length,
                    wrist: cWrist.length,
                    thigh: cThigh.length,
                    calf: cCalf.length,
                    neck: cNeck.length,
                    weightIsLbs: cWeight.lbsIsDefault,
                    heightIsCm: cHeight.cmIsDefault,
                    waistIsCm: cWaist.cmIsDefault,
                    hipsIsCm: cHips.cmIsDefault,
                    forearmIsCm: cForearm.cmIsDefault,
                    wristIsCm: cWrist.cmIsDefault,
                    thighIsCm: cThigh.cmIsDefault,
                    calfIsCm: cCalf.cmIsDefault,
                    neckIsCm: cNeck.cmIsDefault,
                    selectedFatFormula: selectedFatFormula);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      // Put the values below the tab
                      double bodyFats = calcBF.valueFats();
                      if (isMYMCA)
                        _fatsYMCA = bodyFats;
                      else if (isUSNAVY)
                        _fatsUSNAVY = bodyFats;
                      else if (isCOVERTBAILEY)
                        _fatsCOVERTBAILEY = bodyFats;
                      else if (isHERITAGE) _fatsHERITAGE = bodyFats;

                      return BFTapeResultPage(
                        isFemale: isFemale,
                        bodyFats: bodyFats,
                        genderPath: isFemale ? 'images/bodyFatsWomen.jpg' : 'images/bodyFatsMen.jpg',
                        shortSummary: calcBF.shortSummary(),
                        longSummary: calcBF.longSummary(),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //AGE AGE AGE AGE AGE
  // Widget inside the slider card FUNCTION
  // Widget inside the slider card FUNCTION
  Column ageCardContent(
      {final String text,
      final String unit,
      final double value, // To display the initial value depending on the metrics
      final int min,
      final int max}) {
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
            Text(
              // SLIDER CURRENT VALUE NUMBER
              cAge.ageDisplay,
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
                    setState(() {
                      cAge.decrementOne();
                    });
                  }),
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
                      cAge.movingValue(newValue);
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
                      cAge.incrementOne();
                    });
                  },
                ))
          ],
        ),
      ],
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
              child: Text(
                // SLIDER CURRENT VALUE NUMBER
                currentValueTxt(text),
                style: kAgeTextStyle,
              ),
              onTap: () {
                setState(() {
                  incrementFractionNow(text); // FRACTIONAL INCREMENT
                });
              },
            ),
            SizedBox(
              width: 5,
            ),
//            Text(unit, style: kUnitTextStyle),
            // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
            // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
            // TODO Change unit label to Toggle Button
            UnitToggleButton(
              // Negate the UNIT Button  // Make sure that the conversion has decimal accuracy
              //text: toggleText,
              text: unit,
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
    else if (text == 'WAIST')
      return cWaist.lengthDisplay;
    else if (text == 'HIP')
      return cHips.lengthDisplay;
    else if (text == 'FOREARM')
      return cForearm.lengthDisplay;
    else if (text == 'WRIST')
      return cWrist.lengthDisplay;
    else if (text == 'THIGH')
      return cThigh.lengthDisplay;
    else if (text == 'CALF')
      return cCalf.lengthDisplay;
    else if (text == 'NECK')
      return cNeck.lengthDisplay;
    else
      return '';
  }

  // The new value in text returned by the slider
  String newValueTxt(String text, double newValue) {
    if (text == "HEIGHT")
      cHeight.movingValue(newValue);
    else if (text == "WEIGHT")
      cWeight.movingValue(newValue);
    else if (text == "WAIST")
      cWaist.movingValue(newValue);
    else if (text == "HIP")
      cHips.movingValue(newValue);
    else if (text == "FOREARM")
      cForearm.movingValue(newValue);
    else if (text == "WRIST")
      cWrist.movingValue(newValue);
    else if (text == "THIGH")
      cThigh.movingValue(newValue);
    else if (text == "CALF")
      cCalf.movingValue(newValue);
    else if (text == "NECK") cNeck.movingValue(newValue);
  }

  // increment by fraction
  void incrementFractionNow(String text) {
    if (text == 'WEIGHT')
      cWeight.incrementPointOne();
    else if (text == 'HEIGHT')
      cHeight.incrementPointOne();
    else if (text == 'WAIST')
      cWaist.incrementPointOne();
    else if (text == 'HIP')
      cHips.incrementPointOne();
    else if (text == 'FOREARM')
      cForearm.incrementPointOne();
    else if (text == 'WRIST')
      cWrist.incrementPointOne();
    else if (text == 'THIGH') {
      cThigh.incrementPointOne();
    } else if (text == 'CALF')
      cCalf.incrementPointOne();
    else if (text == 'NECK') cNeck.incrementPointOne();
  }

  void decrementNow(String text) {
    if (text == "WEIGHT")
      cWeight.decrementOne();
    else if (text == "HEIGHT")
      cHeight.decrementOne();
    else if (text == "WAIST")
      cWaist.decrementOne();
    else if (text == "HIP")
      cHips.decrementOne();
    else if (text == "FOREARM")
      cForearm.decrementOne();
    else if (text == "WRIST")
      cWrist.decrementOne();
    else if (text == "THIGH")
      cThigh.decrementOne();
    else if (text == "CALF")
      cCalf.decrementOne();
    else if (text == "NECK") cNeck.decrementOne();
  }

  void incrementNow(String text) {
    if (text == 'WEIGHT')
      cWeight.incrementOne();
    else if (text == 'HEIGHT')
      cHeight.incrementOne();
    else if (text == 'WAIST')
      cWaist.incrementOne();
    else if (text == 'HIP')
      cHips.incrementOne();
    else if (text == 'FOREARM')
      cForearm.incrementOne();
    else if (text == 'WRIST')
      cWrist.incrementOne();
    else if (text == 'THIGH')
      cThigh.incrementOne();
    else if (text == 'CALF')
      cCalf.incrementOne();
    else if (text == 'NECK') cNeck.incrementOne();
  }

  // toggle text
  void toggleNow(String text, unit) {
    if (text == 'HEIGHT' && unit == 'centimeters')
      cHeight.toggleToInches();
    else if (text == 'HEIGHT' && unit == 'inches')
      cHeight.toggleToCentimeters();
    else if (text == 'WEIGHT' && unit == 'kilograms')
      cWeight.toggleToLbs();
    else if (text == 'WEIGHT' && unit == 'lbs')
      cWeight.toggleToKilograms();
    else if (text == 'WAIST' && unit == 'centimeters')
      cWaist.toggleToInches();
    else if (text == 'WAIST' && unit == 'inches')
      cWaist.toggleToCentimeters();
    else if (text == 'HIP' && unit == 'centimeters')
      cHips.toggleToInches();
    else if (text == 'HIP' && unit == 'inches')
      cHips.toggleToCentimeters();
    else if (text == 'FOREARM' && unit == 'centimeters')
      cForearm.toggleToInches();
    else if (text == 'FOREARM' && unit == 'inches')
      cForearm.toggleToCentimeters();
    else if (text == 'WRIST' && unit == 'centimeters')
      cWrist.toggleToInches();
    else if (text == 'WRIST' && unit == 'inches')
      cWrist.toggleToCentimeters();
    else if (text == 'THIGH' && unit == 'centimeters')
      cThigh.toggleToInches();
    else if (text == 'THIGH' && unit == 'inches')
      cThigh.toggleToCentimeters();
    else if (text == 'CALF' && unit == 'centimeters')
      cCalf.toggleToInches();
    else if (text == 'CALF' && unit == 'inches')
      cCalf.toggleToCentimeters();
    else if (text == 'NECK' && unit == 'centimeters')
      cNeck.toggleToInches();
    else if (text == 'NECK' && unit == 'inches') cNeck.toggleToCentimeters();
  }
}
