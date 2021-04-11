import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'my_widgets.dart';
import 'constants.dart';
import 'function_utils.dart';
import 'scale_class.dart';
import 'bf_tape_results_page.dart';
import 'dart:io';

// Trying a declaration here
IntroData introData = IntroData();
bool introVisible = true;
bool scalesVisible = false;

Gender selectedGender;
int introIndex = 0;

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
    selectedGender = Gender.male; // set male as default
    sliderValues.selectedButton = ButtonScale.age; // set age as default
    _tabController = new TabController(vsync: this, length: _kTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // selectedGender = Gender.male;
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
            onTap: (index) {
              setState(() {
                introVisible = true;
                scalesVisible = false;
                switch (index) {
                  // Modified YMCA selected // Modified YMCA selected
                  case 0:
                    introIndex = 0;
                    break;
                  // US Navy selected US Navy selected
                  case 1:
                    // Modified YMCA selected
                    introIndex = 1;
                    break;
                  // Convert Baily selected Covert Bailey selected
                  case 2:
                    // Modified YMCA selected
                    introIndex = 2;
                    break;
                  // Heritage BMI selected Heritage selected
                  case 3:
                    // Modified YMCA selected
                    introIndex = 3;
                    break;
                  default:
                    break;
                }
              });
            },
          ),
          // Tab results Tab results Tab results
          Row(
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
          // Tab INTRO before showing the scale buttons
          Visibility(
            visible: introVisible,
            child: Container(
              // TAB Contents VIEW
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
              // color: kInActiveButtonColor,
              child: TabWidget(
                  title: introData.title[introIndex],
                  description: introData.description[introIndex],
                  formula: introData.formula[introIndex],
                  introIndex: introIndex,
                  onPressed: () {
                    // When the close intro button is pressed
                    setState(() {
                      introVisible = false;
                      scalesVisible = true;
                      if (introIndex == 0) {
                        isMYMCA = true;
                        isUSNAVY = false;
                        isCOVERTBAILEY = false;
                        isHERITAGE = false;
                        selectedFatFormula = FatFormula.MYMCA;
                      } else if (introIndex == 1) {
                        isMYMCA = false;
                        isUSNAVY = true;
                        isCOVERTBAILEY = false;
                        isHERITAGE = false;
                        selectedFatFormula = FatFormula.USNAVY;
                      } else if (introIndex == 2) {
                        isMYMCA = false;
                        isUSNAVY = false;
                        isCOVERTBAILEY = true;
                        isHERITAGE = false;
                        selectedFatFormula = FatFormula.COVERTBAILEY;
                      } else if (introIndex == 3) {
                        isMYMCA = false;
                        isUSNAVY = false;
                        isCOVERTBAILEY = false;
                        isHERITAGE = true;
                        selectedFatFormula = FatFormula.HERIGATE;
                      }
                    });
                  }),
            ),
          ),
          // Make all the scale buttons Invisible while on tab intro
          Visibility(
            visible: scalesVisible,
            child: Column(
              children: [
                // GENDER GENDER in separate column
/*                ReusableCard(
                  onPressedMy: () {
                    setState(() {
                      if (selectedGender == Gender.male) {
                        selectedGender = Gender.female;
                        isFemale = true;
                      } else if (selectedGender == Gender.female) {
                        selectedGender = Gender.male;
                        isFemale = false;
                      }
                    });
                  },
                  colour: kInActiveButtonColor,
                  widgetContents: GenderCardContent(
                      label: (selectedGender == Gender.male) ? 'MALE' : 'FEMALE',
                      iconGender: (selectedGender == Gender.male) ? FontAwesomeIcons.mars : FontAwesomeIcons.venus),
                ),*/
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: (!isFemale) ? 6 : 4,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            if (selectedGender == Gender.male) {
                              selectedGender = Gender.female;
                              isFemale = true;
                            } else {
                              selectedGender = Gender.male;
                              isFemale = false;
                            }
                          });
                        },
                        colour: (selectedGender == Gender.male) ? kActiveButtonColor : kInActiveButtonColor,
                        //colour: kInActiveButtonColor,
                        widgetContents: GenderCardContent(
                          label: 'MALE',
                          iconGender: FontAwesomeIcons.male,
                          iconStatus: (!isFemale) ? FontAwesomeIcons.check : FontAwesomeIcons.notEqual,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: (isFemale) ? 6 : 4,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            if (selectedGender == Gender.male) {
                              selectedGender = Gender.female;
                              isFemale = true;
                            } else {
                              selectedGender = Gender.male;
                              isFemale = false;
                            }
                          });
                        },
                        colour: (selectedGender == Gender.female) ? kActiveButtonColor : kInActiveButtonColor,
                        //colour: kInActiveButtonColor,
                        widgetContents: GenderCardContent(
                          label: 'FEMALE',
                          iconGender: FontAwesomeIcons.female,
                          iconStatus: (isFemale) ? FontAwesomeIcons.check : FontAwesomeIcons.notEqual,
                        ),
                      ),
                    ),
                  ],
                ),

                // This separates the value displays to the left and slider to the right
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // flex: 8,
                      // The column of all measurement widgets
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS SLIDERS
                          // AGE HERE
                          Visibility(
                            visible: true,
                            child: ReusableCard(
                              // AGE AGE AGE
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.age;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.age) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                  // AGE AGE AGE currently merging this with statsCardContent
                                  text: cAge.text,
                                  unit: cAge.unit,
                                  value: cAge.age,
                                  min: cAge.min,
                                  max: cAge.max,
                                  selected: (sliderValues.selectedButton == ButtonScale.age)),
                            ),
                          ),

                          Visibility(
                            visible: isUSNAVY | isHERITAGE,
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.height;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.height) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                  // HEIGHT HEIGHT HEIGHT
                                  text: cHeight.text,
                                  unit: cHeight.unit,
                                  value: cHeight.length,
                                  min: cHeight.min,
                                  max: cHeight.max,
                                  toggleText: cHeight.toggleText,
                                  selected: (sliderValues.selectedButton == ButtonScale.height)),
                            ),
                          ),

                          Visibility(
                            visible: isMYMCA | isHERITAGE,
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.weight;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.weight) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                // WEIGHT WEIGHT WEIGHT
                                text: cWeight.text,
                                unit: cWeight.unit,
                                value: cWeight.weight,
                                min: cWeight.min,
                                max: cWeight.max,
                                toggleText: cWeight.toggleText, selected: (sliderValues.selectedButton == ButtonScale.weight),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: isMYMCA | isUSNAVY | (isCOVERTBAILEY & !isFemale),
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.waist;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.waist) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                text: cWaist.text,
                                unit: cWaist.unit,
                                value: cWaist.length,
                                min: cWaist.min,
                                max: cWaist.max,
                                toggleText: cWaist.toggleText,
                                selected: (sliderValues.selectedButton == ButtonScale.waist),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (isMYMCA & isFemale) | (isUSNAVY & isFemale) | isCOVERTBAILEY,
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.hip;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.hip) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                text: cHips.text,
                                unit: cHips.unit,
                                value: cHips.length,
                                min: cHips.min,
                                max: cHips.max,
                                toggleText: cHips.toggleText,
                                selected: (sliderValues.selectedButton == ButtonScale.hip),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (isMYMCA & isFemale) | (isCOVERTBAILEY & !isFemale),
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.forearm;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.forearm) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                text: cForearm.text,
                                unit: cForearm.unit,
                                value: cForearm.length,
                                min: cForearm.min,
                                max: cForearm.max,
                                toggleText: cForearm.toggleText,
                                selected: (sliderValues.selectedButton == ButtonScale.forearm),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (isMYMCA & isFemale) | isCOVERTBAILEY,
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.wrist;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.wrist) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                text: cWrist.text,
                                unit: cWrist.unit,
                                value: cWrist.length,
                                min: cWrist.min,
                                max: cWrist.max,
                                toggleText: cWrist.toggleText,
                                selected: (sliderValues.selectedButton == ButtonScale.wrist),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: (isCOVERTBAILEY & isFemale),
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.thigh;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.thigh) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                text: cThigh.text,
                                unit: cThigh.unit,
                                value: cThigh.length,
                                min: cThigh.min,
                                max: cThigh.max,
                                toggleText: cThigh.toggleText,
                                selected: (sliderValues.selectedButton == ButtonScale.thigh),
                              ),
                            ),
                          ),

                          Visibility(
                            visible: (isCOVERTBAILEY & isFemale),
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.calf;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.calf) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                text: cCalf.text,
                                unit: cCalf.unit,
                                value: cCalf.length,
                                min: cCalf.min,
                                max: cCalf.max,
                                toggleText: cCalf.toggleText,
                                selected: (sliderValues.selectedButton == ButtonScale.calf),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isUSNAVY,
                            child: ReusableCard(
                              onPressedMy: () {
                                setState(() {
                                  sliderValues.selectedButton = ButtonScale.neck;
                                });
                              },
                              colour: (sliderValues.selectedButton == ButtonScale.neck) ? kActiveButtonColor : kInActiveButtonColor,
                              widgetContents: statsCardContent(
                                text: cNeck.text,
                                unit: cNeck.unit,
                                value: cNeck.length,
                                min: cNeck.min,
                                max: cNeck.max,
                                toggleText: cNeck.toggleText,
                                selected: (sliderValues.selectedButton == ButtonScale.neck),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // slider here
                    Container(
                      width: 70,
                      height: 340,
                      child: ReusableCard(
                        colour: kActiveButtonColor,
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
                                      incrementNow(); // perform increment
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
                                      incrementFractionNow(); // perform increment
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
                                        newValueTxt(newValue); // New value in text
                                        sliderValues.value = newValue;
                                        print('value = ' + sliderValues.value.toString());
                                        print('newValue = ' + newValue.toString());
                                        print('min = ' + sliderValues.min.toString());
                                        print('max = ' + sliderValues.max.toString());
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
                                    decrementNow(); // Decrement now!
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
                            // The page to show
                            isFemale: isFemale,
                            bodyFats: bodyFats,
                            genderPath: isFemale ? 'images/bodyFatsWomen.jpg' : 'images/bodyFatsMen.jpg',
                            shortSummary: calcBF.shortSummary(),
                            longSummary: calcBF.longSummary(),
                            selFlex1: calcBF.getFlex1(),
                            selFlex2: calcBF.getFlex2(),
                            selFlex3: calcBF.getFlex3(),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
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
    if (selected) sliderForAll(value: value, min: min, max: max); // Links current button to slider
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
        Row(
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
  void sliderForAll({double value, int min, int max}) {
    //sliderValues.text = text;
    sliderValues.value = value;
    sliderValues.min = min;
    sliderValues.max = max;
    //sliderValues.unit = unit;
  }

  // The actual value depending on the text
  // text is passed insead of sliderValue because there are many individual buttons
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
  /* void newValueTxt(String text, double newValue) {
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
  }*/

  // The new value in text returned by the slider
  void newValueTxt(double newValue) {
    switch (sliderValues.selectedButton) {
      case ButtonScale.age:
        cAge.movingValue(newValue);
        break;
      case ButtonScale.weight:
        cWeight.movingValue(newValue);
        break;
      case ButtonScale.height:
        cHeight.movingValue(newValue);
        break;
      case ButtonScale.waist:
        cWaist.movingValue(newValue);
        break;
      case ButtonScale.hip:
        cHips.movingValue(newValue);
        break;
      case ButtonScale.forearm:
        cForearm.movingValue(newValue);
        break;
      case ButtonScale.wrist:
        cWrist.movingValue(newValue);
        break;
      case ButtonScale.thigh:
        cThigh.movingValue(newValue);
        break;
      case ButtonScale.calf:
        cCalf.movingValue(newValue);
        break;
      case ButtonScale.neck:
        cNeck.movingValue(newValue);
        break;
      default:
        break;
    }
  }

  // increment by fraction
  void incrementFractionNow() {
    switch (sliderValues.selectedButton) {
      case ButtonScale.age:
        cAge.incrementPointOne();
        break;
      case ButtonScale.weight:
        cWeight.incrementPointOne();
        break;
      case ButtonScale.height:
        cHeight.incrementPointOne();
        break;
      case ButtonScale.waist:
        cWaist.incrementPointOne();
        break;
      case ButtonScale.hip:
        cHips.incrementPointOne();
        break;
      case ButtonScale.forearm:
        cForearm.incrementPointOne();
        break;
      case ButtonScale.wrist:
        cWrist.incrementPointOne();
        break;
      case ButtonScale.thigh:
        cThigh.incrementPointOne();
        break;
      case ButtonScale.calf:
        cCalf.incrementPointOne();
        break;
      case ButtonScale.neck:
        cNeck.incrementPointOne();
        break;
      default:
        break;
    }
  }

  void decrementNow() {
    switch (sliderValues.selectedButton) {
      case ButtonScale.age:
        cAge.decrementOne();
        break;
      case ButtonScale.weight:
        cWeight.decrementOne();
        break;
      case ButtonScale.height:
        cHeight.decrementOne();
        break;
      case ButtonScale.waist:
        cWaist.decrementOne();
        break;
      case ButtonScale.hip:
        cHips.decrementOne();
        break;
      case ButtonScale.forearm:
        cForearm.decrementOne();
        break;
      case ButtonScale.wrist:
        cWrist.decrementOne();
        break;
      case ButtonScale.thigh:
        cThigh.decrementOne();
        break;
      case ButtonScale.calf:
        cCalf.decrementOne();
        break;
      case ButtonScale.neck:
        cNeck.decrementOne();
        break;
      default:
        break;
    }
  }

  void incrementNow() {
    switch (sliderValues.selectedButton) {
      case ButtonScale.age:
        cAge.incrementOne();
        break;
      case ButtonScale.weight:
        cWeight.incrementOne();
        break;
      case ButtonScale.height:
        cHeight.incrementOne();
        break;
      case ButtonScale.waist:
        cWaist.incrementOne();
        break;
      case ButtonScale.hip:
        cHips.incrementOne();
        break;
      case ButtonScale.forearm:
        cForearm.incrementOne();
        break;
      case ButtonScale.wrist:
        cWrist.incrementOne();
        break;
      case ButtonScale.thigh:
        cThigh.incrementOne();
        break;
      case ButtonScale.calf:
        cCalf.incrementOne();
        break;
      case ButtonScale.neck:
        cNeck.incrementOne();
        break;
      default:
        break;
    }
  }

  // toggle text
  // this is the only function with AGE is excuded
  void toggleNow(String text, String unit) {
    if (text == 'HEIGHT' && unit == 'cm.') {
      cHeight.toggleToInches();
      sliderValues.selectedButton = ButtonScale.height;
    } else if (text == 'HEIGHT' && unit == 'in.') {
      cHeight.toggleToCentimeters();
      sliderValues.selectedButton = ButtonScale.height;
    } else if (text == 'WEIGHT' && unit == 'kgs') {
      cWeight.toggleToLbs();
      sliderValues.selectedButton = ButtonScale.weight;
    } else if (text == 'WEIGHT' && unit == 'lbs') {
      cWeight.toggleToKilograms();
      sliderValues.selectedButton = ButtonScale.weight;
    } else if (text == 'WAIST' && unit == 'cm.') {
      cWaist.toggleToInches();
      sliderValues.selectedButton = ButtonScale.waist;
    } else if (text == 'WAIST' && unit == 'in.') {
      cWaist.toggleToCentimeters();
      sliderValues.selectedButton = ButtonScale.waist;
    } else if (text == 'HIP' && unit == 'cm.') {
      cHips.toggleToInches();
      sliderValues.selectedButton = ButtonScale.hip;
    } else if (text == 'HIP' && unit == 'in.') {
      cHips.toggleToCentimeters();
      sliderValues.selectedButton = ButtonScale.hip;
    } else if (text == 'FOREARM' && unit == 'cm.') {
      cForearm.toggleToInches();
      sliderValues.selectedButton = ButtonScale.forearm;
    } else if (text == 'FOREARM' && unit == 'in.') {
      cForearm.toggleToCentimeters();
      sliderValues.selectedButton = ButtonScale.forearm;
    } else if (text == 'WRIST' && unit == 'cm.') {
      cWrist.toggleToInches();
      sliderValues.selectedButton = ButtonScale.wrist;
    } else if (text == 'WRIST' && unit == 'in.') {
      cWrist.toggleToCentimeters();
      sliderValues.selectedButton = ButtonScale.wrist;
    } else if (text == 'THIGH' && unit == 'cm.') {
      cThigh.toggleToInches();
      sliderValues.selectedButton = ButtonScale.thigh;
    } else if (text == 'THIGH' && unit == 'in.') {
      cThigh.toggleToCentimeters();
      sliderValues.selectedButton = ButtonScale.thigh;
    } else if (text == 'CALF' && unit == 'cm.') {
      cCalf.toggleToInches();
      sliderValues.selectedButton = ButtonScale.calf;
    } else if (text == 'CALF' && unit == 'in.') {
      cCalf.toggleToCentimeters();
      sliderValues.selectedButton = ButtonScale.calf;
    } else if (text == 'NECK' && unit == 'cm.') {
      cNeck.toggleToInches();
      sliderValues.selectedButton = ButtonScale.neck;
    } else if (text == 'NECK' && unit == 'in.') {
      cNeck.toggleToCentimeters();
      sliderValues.selectedButton = ButtonScale.neck;
    }

    // sliderForAll(value: value, min: min, max: max); // updates slider to the current button
  }
}
