import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'my_widgets.dart';
import 'constants.dart';
import 'function_utils.dart';
import 'scale_class.dart';
import 'bf_tape_results_page.dart';
import 'dart:io';

enum Gender { male, female }
enum ButtonScale { age, weight, height, waist, hip, wrist, forearm, thigh, calf, neck }
Gender selectedGender;
ButtonScale selectedButtonScale;

String genderPath;
SliderValues sliderValues = SliderValues();

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
          children: <Widget>[
            Text('BMI CALCULATOR   '),
            Text('by jhorViente', style: kAuthorTextStyle),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // TABS start here!!!!!
          TabBar(
            // tabs
            controller: _tabController,
            tabs: _kTabs,
          ),
          /*  Container(  // TAB VIEW
            // margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            // color: kInActiveButtonColor,
            height: 200,
            child: TabBarView(
              controller: _tabController,
              children: _kTabPages,
            ),
          ),*/
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

          // This separates the value displays to the left and slider to the right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                // The column of all measurement widgets
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // GENDER GENDER
                    Visibility(
                      // visible: isMYMCA | isUSNAVY | isCOVERTBAILEY,
                      visible: true,
                      child: Row(
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
                    ),
                    // SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS
                    Visibility(
                      visible: isCOVERTBAILEY | isHERITAGE,
                      child: ReusableCard(
                        // AGE AGE AGE
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.age;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.age) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                            // AGE AGE AGE currently merging this with statsCardContent
                            text: cAge.text,
                            unit: cAge.unit,
                            value: cAge.age,
                            min: cAge.min,
                            max: cAge.max,
                            selected: (selectedButtonScale == ButtonScale.age)),
                      ),
                    ),
                    Visibility(
                      visible: isUSNAVY | isHERITAGE,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.height;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.height) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                            // HEIGHT HEIGHT HEIGHT
                            text: cHeight.text,
                            unit: cHeight.unit,
                            value: cHeight.length,
                            min: cHeight.min,
                            max: cHeight.max,
                            toggleText: cHeight.toggleText,
                            selected: (selectedButtonScale == ButtonScale.height)),
                      ),
                    ),

                    Visibility(
                      visible: isMYMCA | isHERITAGE,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.weight;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.weight) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          // WEIGHT WEIGHT WEIGHT
                          text: cWeight.text,
                          unit: cWeight.unit,
                          value: cWeight.weight,
                          min: cWeight.min,
                          max: cWeight.max,
                          toggleText: cWeight.toggleText, selected: (selectedButtonScale == ButtonScale.weight),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: isMYMCA | isUSNAVY | (isCOVERTBAILEY & !isFemale),
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.waist;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.waist) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cWaist.text,
                          unit: cWaist.unit,
                          value: cWaist.length,
                          min: cWaist.min,
                          max: cWaist.max,
                          toggleText: cWaist.toggleText,
                          selected: (selectedButtonScale == ButtonScale.waist),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (isMYMCA & isFemale) | (isUSNAVY & isFemale) | isCOVERTBAILEY,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.hip;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.hip) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cHips.text,
                          unit: cHips.unit,
                          value: cHips.length,
                          min: cHips.min,
                          max: cHips.max,
                          toggleText: cHips.toggleText,
                          selected: (selectedButtonScale == ButtonScale.hip),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (isMYMCA & isFemale) | (isCOVERTBAILEY & !isFemale),
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.forearm;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.forearm) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cForearm.text,
                          unit: cForearm.unit,
                          value: cForearm.length,
                          min: cForearm.min,
                          max: cForearm.max,
                          toggleText: cForearm.toggleText,
                          selected: (selectedButtonScale == ButtonScale.forearm),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: (isMYMCA & isFemale) | isCOVERTBAILEY,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.wrist;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.wrist) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cWrist.text,
                          unit: cWrist.unit,
                          value: cWrist.length,
                          min: cWrist.min,
                          max: cWrist.max,
                          toggleText: cWrist.toggleText,
                          selected: (selectedButtonScale == ButtonScale.wrist),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: (isCOVERTBAILEY & isFemale),
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.thigh;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.thigh) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cThigh.text,
                          unit: cThigh.unit,
                          value: cThigh.length,
                          min: cThigh.min,
                          max: cThigh.max,
                          toggleText: cThigh.toggleText,
                          selected: (selectedButtonScale == ButtonScale.thigh),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: (isCOVERTBAILEY & isFemale),
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.calf;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.calf) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cCalf.text,
                          unit: cCalf.unit,
                          value: cCalf.length,
                          min: cCalf.min,
                          max: cCalf.max,
                          toggleText: cCalf.toggleText,
                          selected: (selectedButtonScale == ButtonScale.calf),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isUSNAVY,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedButtonScale = ButtonScale.neck;
                          });
                        },
                        colour: (selectedButtonScale == ButtonScale.neck) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cNeck.text,
                          unit: cNeck.unit,
                          value: cNeck.length,
                          min: cNeck.min,
                          max: cNeck.max,
                          toggleText: cNeck.toggleText,
                          selected: (selectedButtonScale == ButtonScale.neck),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // slider here
              Container(
                height: 300,
                child: ReusableCard(
                  colour: kInActiveButtonColor,
                  widgetContents: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          // INCREMENT INCREMENT INCREMENT INCREMENT
                          // INCREMENT INCREMENT INCREMENT INCREMENT
                          // Doesn't care if it's kgs or lbs
                          flex: 1,
                          child: SliderSideButton(
                            icon: FontAwesomeIcons.plus,
                            onPress: () {
                              setState(() {
                                incrementNow(sliderValues.text); // perform increment
                              });
                            },
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          // DECIMAL DECIMAL DECIMAL
                          // DECIMAL DECIMAL DECIMAL
                          flex: 1,
                          child: SliderSideButton(
                            icon: FontAwesomeIcons.dotCircle,
                            onPress: () {
                              setState(() {
                                incrementNow(sliderValues.text); // perform increment
                              });
                            },
                          )),
                      Expanded(
                        flex: 7,
                        // SLIDER SLIDER SLIDER SLIDER SLIDER
                        // SLIDER SLIDER SLIDER SLIDER SLIDER
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Slider(
                              value: sliderValues.value,
                              min: sliderValues.min.toDouble(),
                              max: sliderValues.max.toDouble(),
                              activeColor: Color(0xFFEB1555),
                              inactiveColor: Color(0xFF8D8E98),
                              onChanged: (newValue) {
                                setState(() {
                                  newValueTxt(sliderValues.text, newValue); // New value in text
                                  sliderValues.value = newValue;
/*                                  print('value = ' + sliderValues.value.toString());
                                  print('newValue = ' + newValue.toString());
                                  print('min = ' + sliderValues.min.toString());
                                  print('max = ' + sliderValues.max.toString());*/
                                });
                              }),
                        ),
                      ),
                      Expanded(
                        // DECREMENT DECREMENT DECREMENT DECREMENT DECREMENT
                        // DECREMENT DECREMENT DECREMENT DECREMENT DECREMENT
                        // Does not care if it is kgs or lbs
                        flex: 1,
                        child: SliderSideButton(
                          icon: FontAwesomeIcons.minus,
                          onPress: () {
                            setState(() {
                              decrementNow(sliderValues.text); // Decrement now!
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
    );
  }

  // Widget inside the slider card FUNCTION
  // Widget inside the slider card FUNCTION
  // TODO add the ft with proper size
  Row statsCardContent(
      {final String text,
      final String unit,
      final double value, // To display the initial value depending on the metrics
      final int min,
      final int max,
      final String toggleText,
      final bool selected}) {
    if (selected) sliderForAll(text: text, unit: unit, value: value, min: min, max: max); // Links current button to slider
    return Row(
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
        // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
        // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
        UnitToggleButton(
          // Negate the UNIT Button  // Make sure that the conversion has decimal accuracy
          //text: toggleText,
          unitName: unit,
          enabled: disableToggleOnAge(text),
          onPress: () {
            setState(() {
              toggleNow(text, unit); // Change the value after toggle
            });
          },
        ),
      ],
    );
  }

  // assign the slider to the pressed button
  void sliderForAll({String text, double value, int min, int max, String unit}) {
    sliderValues.text = text;
    sliderValues.value = value;
    sliderValues.min = min;
    sliderValues.max = max;
    sliderValues.unit = unit;
  }

  // The actual value depending on the text
  String currentValueTxt(String text) {
    if (text == 'AGE') return cAge.ageDisplay;
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

  // Process the visibility of the feet text
  String currentFeetText(String text, String unit) {
    //return (text == 'HEIGHT') ? cHeight.feetText : '';
    return (text == 'HEIGHT' && unit == 'in.') ? 'ft. ' : '';
  }

  // Process the inches display part
  String currentInchesText(String text, unit) {
    return (text == 'HEIGHT' && unit == 'in.') ? cHeight.inchesDisplay : '';
  }

  // no toggle arrow down on AGE
  bool disableToggleOnAge(String text) {
    return (text == 'AGE') ? false : true;
  }

  // The new value in text returned by the slider
  void newValueTxt(String text, double newValue) {
    // I've just changed this from STring to void
    if (text == "AGE") cAge.movingValue(newValue);
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
    if (text == 'AGE') cAge.incrementPointOne();
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
    if (text == "AGE") cAge.decrementOne();
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
    if (text == 'AGE') cAge.incrementOne();
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
  // this is the only function with AGE is excuded
  void toggleNow(String text, unit) {
    if (text == 'HEIGHT' && unit == 'cm.') {
      cHeight.toggleToInches();
    } else if (text == 'HEIGHT' && unit == 'in.')
      cHeight.toggleToCentimeters();
    else if (text == 'WEIGHT' && unit == 'kgs')
      cWeight.toggleToLbs();
    else if (text == 'WEIGHT' && unit == 'lbs')
      cWeight.toggleToKilograms();
    else if (text == 'WAIST' && unit == 'cm.')
      cWaist.toggleToInches();
    else if (text == 'WAIST' && unit == 'in.')
      cWaist.toggleToCentimeters();
    else if (text == 'HIP' && unit == 'cm.')
      cHips.toggleToInches();
    else if (text == 'HIP' && unit == 'in.')
      cHips.toggleToCentimeters();
    else if (text == 'FOREARM' && unit == 'cm.')
      cForearm.toggleToInches();
    else if (text == 'FOREARM' && unit == 'in.')
      cForearm.toggleToCentimeters();
    else if (text == 'WRIST' && unit == 'cm.')
      cWrist.toggleToInches();
    else if (text == 'WRIST' && unit == 'in.')
      cWrist.toggleToCentimeters();
    else if (text == 'THIGH' && unit == 'cm.')
      cThigh.toggleToInches();
    else if (text == 'THIGH' && unit == 'in.')
      cThigh.toggleToCentimeters();
    else if (text == 'CALF' && unit == 'cm.')
      cCalf.toggleToInches();
    else if (text == 'CALF' && unit == 'in.')
      cCalf.toggleToCentimeters();
    else if (text == 'NECK' && unit == 'cm.')
      cNeck.toggleToInches();
    else if (text == 'NECK' && unit == 'in.') cNeck.toggleToCentimeters();
  }
}
