import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'my_widgets.dart';
import 'constants.dart';
import 'function_utils.dart';
import 'scale_class.dart';
import 'bf_tape_results_page.dart';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';

class FatsTape extends StatefulWidget {
  @override
  _FatsTapeState createState() => _FatsTapeState();
}

class _FatsTapeState extends State<FatsTape> with TickerProviderStateMixin {
  AnimationController animateSlider;

  // Trying all declarations here
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

  // tabs definition
  final _kTabs = <Tab>[
    Tab(text: 'mod YMCA'),
    Tab(text: 'US Navy'),
    Tab(text: 'Covert Bailey'),
    Tab(text: 'Heritage'),
  ];

  final _kTabPages = <Widget>[
    // probably useless
    TabWidget(
      title: 'Modified YMCA',
      description: kYMCADescription,
      formula: kYMCAFormula,
      //animate: animateButton,
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

    animateSlider = AnimationController(vsync: this, duration: Duration(seconds: 1), lowerBound: 1, upperBound: 407);

/*    animateSlider.forward();
    animateSlider.addListener(() {
      print('This is from  animation ${animateSlider.value}');
      setState(() {});
    });
    animateSlider.reset();*/
  }

  @override
  void dispose() {
    _tabController.dispose();
    animateSlider.dispose();
    super.dispose();
  }

  double sliderV = 50; // testing testing
  bool valChanged = false; // check

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
                  animate: (val) {
                    val.forward();
                    val.addListener(() {
                      print(val.animate.value);
                      setState(() {});
                    });
                  },
                  onPressed: () {
                    // When the close intro button is pressed
                    setState(() {
                      introVisible = false;
                      scalesVisible = true;
                      sliderValues.selectedButton = ButtonScale.age;
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
                Row(
                  children: <Widget>[
                    Expanded(
                      // flex: (!isFemale) ? 6 : 4,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedGender = Gender.male;
                            isFemale = false;
                          });
                        },
                        colour: (selectedGender == Gender.male) ? kLightButtonColor : kInActiveButtonColor,
                        //colour: kInActiveButtonColor,
                        widgetContents: GenderCardContent(
                          label: 'MALE',
                          iconGender: FontAwesomeIcons.male,
                          iconStatus: (!isFemale) ? FontAwesomeIcons.check : FontAwesomeIcons.times,
                        ),
                      ),
                    ),
                    Expanded(
                      //  flex: (isFemale) ? 6 : 4,
                      child: ReusableCard(
                        onPressedMy: () {
                          setState(() {
                            selectedGender = Gender.female;
                            isFemale = true;
                          });
                        },
                        colour: (selectedGender == Gender.female) ? kLightButtonColor : kInActiveButtonColor,
                        //colour: kInActiveButtonColor,
                        widgetContents: GenderCardContent(
                          label: 'FEMALE',
                          iconGender: FontAwesomeIcons.female,
                          iconStatus: (isFemale) ? FontAwesomeIcons.check : FontAwesomeIcons.times,
                        ),
                      ),
                    ),
                  ],
                ),

                // THE SCALE BUTTONS!
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // SCALES SCALES SCALES SCALES
                    // AGE HERE
                    Visibility(
                      visible: true,
                      child: ReusableCard(
                        // AGE AGE AGE
                        colour: (cAge.changed) ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          // AGE AGE AGE currently merging this with statsCardContent
                          text: cAge.text,
                          unit: cAge.unit,
                          value: cAge.age,
                          min: cAge.min,
                          max: cAge.max,
                          selected: (sliderValues.selectedButton == ButtonScale.age),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.age;
                          });

                          // BuildContext dialogContext;
                          await popupDialog(
                            context,
                            text: cAge.text,
                            unit: cAge.unit,
                            value: cAge.age,
                            min: cAge.min,
                            max: cAge.max,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: isUSNAVY | isHERITAGE,
                      child: ReusableCard(
                        // HEIGHT HEIGHT HEIGHT
                        colour: cHeight.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cHeight.text,
                          unit: cHeight.unit,
                          value: cHeight.length,
                          min: cHeight.min,
                          max: cHeight.max,
                          toggleText: cHeight.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.height),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.height;
                          });
                          await popupDialog(
                            context,
                            text: cHeight.text,
                            unit: cHeight.unit,
                            value: cHeight.length,
                            min: cHeight.min,
                            max: cHeight.max,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: isMYMCA | isHERITAGE,
                      child: ReusableCard(
                        // WEIGHT WEIGHT WEIGHT
                        colour: cWeight.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cWeight.text,
                          unit: cWeight.unit,
                          value: cWeight.weight,
                          min: cWeight.min,
                          max: cWeight.max,
                          toggleText: cWeight.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.weight),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.weight;
                          });
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cWeight.text,
                            unit: cWeight.unit,
                            value: cWeight.weight,
                            min: cWeight.min,
                            max: cWeight.max,
                            toggleText: cWeight.toggleText,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: isMYMCA | isUSNAVY | (isCOVERTBAILEY & !isFemale),
                      child: ReusableCard(
                        // WAIST WAIST
                        colour: cWaist.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cWaist.text,
                          unit: cWaist.unit,
                          value: cWaist.length,
                          min: cWaist.min,
                          max: cWaist.max,
                          toggleText: cWaist.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.waist),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.waist;
                          });
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cWaist.text,
                            unit: cWaist.unit,
                            value: cWaist.length,
                            min: cWaist.min,
                            max: cWaist.max,
                            toggleText: cWaist.toggleText,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible: (isMYMCA & isFemale) | (isUSNAVY & isFemale) | isCOVERTBAILEY,
                      child: ReusableCard(
                        // HIPS HIPS
                        colour: cHips.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cHips.text,
                          unit: cHips.unit,
                          value: cHips.length,
                          min: cHips.min,
                          max: cHips.max,
                          toggleText: cHips.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.hip),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.hip;
                          });
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cHips.text,
                            unit: cHips.unit,
                            value: cHips.length,
                            min: cHips.min,
                            max: cHips.max,
                            toggleText: cHips.toggleText,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible: (isMYMCA & isFemale) | (isCOVERTBAILEY & !isFemale),
                      child: ReusableCard(
                        // FOREARM FOREARM
                        colour: cForearm.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cForearm.text,
                          unit: cForearm.unit,
                          value: cForearm.length,
                          min: cForearm.min,
                          max: cForearm.max,
                          toggleText: cForearm.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.forearm),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.forearm;
                          });
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cForearm.text,
                            unit: cForearm.unit,
                            value: cForearm.length,
                            min: cForearm.min,
                            max: cForearm.max,
                            toggleText: cForearm.toggleText,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible: (isMYMCA & isFemale) | isCOVERTBAILEY,
                      child: ReusableCard(
                        // WRIST WRIST
                        colour: cWrist.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cWrist.text,
                          unit: cWrist.unit,
                          value: cWrist.length,
                          min: cWrist.min,
                          max: cWrist.max,
                          toggleText: cWrist.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.wrist),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.wrist;
                          });
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cWrist.text,
                            unit: cWrist.unit,
                            value: cWrist.length,
                            min: cWrist.min,
                            max: cWrist.max,
                            toggleText: cWrist.toggleText,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: (isCOVERTBAILEY & isFemale),
                      child: ReusableCard(
                        // THIGH THIGH
                        colour: cThigh.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cThigh.text,
                          unit: cThigh.unit,
                          value: cThigh.length,
                          min: cThigh.min,
                          max: cThigh.max,
                          toggleText: cThigh.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.thigh),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.thigh;
                          });
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cThigh.text,
                            unit: cThigh.unit,
                            value: cThigh.length,
                            min: cThigh.min,
                            max: cThigh.max,
                            toggleText: cThigh.toggleText,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: (isCOVERTBAILEY & isFemale),
                      child: ReusableCard(
                        // CALF CALF
                        colour: cCalf.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cCalf.text,
                          unit: cCalf.unit,
                          value: cCalf.length,
                          min: cCalf.min,
                          max: cCalf.max,
                          toggleText: cCalf.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.calf),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.calf;
                          });
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cCalf.text,
                            unit: cCalf.unit,
                            value: cCalf.length,
                            min: cCalf.min,
                            max: cCalf.max,
                            toggleText: cCalf.toggleText,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible: isUSNAVY,
                      child: ReusableCard(
                        // NECK NECK
                        colour: cNeck.changed ? kActiveButtonColor : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cNeck.text,
                          unit: cNeck.unit,
                          value: cNeck.length,
                          min: cNeck.min,
                          max: cNeck.max,
                          toggleText: cNeck.toggleText,
                          selected: (sliderValues.selectedButton == ButtonScale.neck),
                        ),
                        onPressedMy: () async {
                          setState(() {
                            sliderValues.selectedButton = ButtonScale.neck;
                          });
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cNeck.text,
                            unit: cNeck.unit,
                            value: cNeck.length,
                            min: cNeck.min,
                            max: cNeck.max,
                            toggleText: cNeck.toggleText,
                          );
                          setState(() {});
                        },
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

  Future<dynamic> popupDialog(
    BuildContext context, {
    final String text,
    final String unit,
    final double value, // To display the initial value depending on the metrics
    final int min,
    final int max,
    final String toggleText,
  }) {
    sliderForAll(value: value, min: min, max: max); // Initial value for the dialog slider
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          // backgroundColor: kInActiveButtonColor,
          contentPadding: EdgeInsets.zero,
          // The TEXT above the slider
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                // WEIGHT or HEIGHT TEXT
                text,
                style: kTextStyle,
              ),
              SizedBox(width: 10),
              // tap to Add .1 decimal accuracy to the value
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
              Text(
                ' ${unitDisplay(text)}',
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
                    toggleNow(text, unitDisplay(text)); // Change the value after toggle
                  });
                },
              ),
            ],
          ),
          // the SLIDER SLIDER
          content: Column(
            // This column is necessary to set the diaglog height to minimum
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: SliderSideButton(
                      icon: FontAwesomeIcons.chevronCircleLeft,
                      onPress: () {
                        setState(() {
                          decrementNow(); // Decrement now!
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 7,
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
/*                            print('value from popup = ' + sliderValues.value.toString());
                            print('newValue = ' + newValue.toString());
                            print('min = ' + sliderValues.min.toString());
                            print('max = ' + sliderValues.max.toString());*/
                          });
                        }),
                  ),
                  Expanded(
                    flex: 1,
                    child: SliderSideButton(
                      icon: FontAwesomeIcons.chevronCircleRight,
                      onPress: () {
                        setState(() {
                          incrementNow(); // perform increment
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  color: kSmallButtonColor,
                  onPressed: () {
                    setState(() {
                      decrementFractionNow(); // perform increment
                    });
                  },
                  child: Text('- 0.1'),
                ),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                  color: kBottomContainerColor,
                ),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  color: kSmallButtonColor,
                  onPressed: () {
                    setState(() {
                      incrementFractionNow(); // perform increment
                    });
                  },
                  child: Text('+ 0.1'),
                ),
              ],
            )
          ],
        ),
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
    if (selected) sliderForAll(value: value, min: min, max: max); // Links current button to slider.
    // The above function executes all the time so it updates the slider values anytime you
    // press the increment or decrement or any operation

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
        Text(
          ' $unit', // Displays Inches or cm etc.
          // The value above executes all the time so it updates whenever the unit is toggled
          style: kUnitTextStyle,
          // textAlign: TextAlign.center,
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
  // text is passed instead of sliderValue because there are many individual buttons
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

  // Displays inches or cm
  String unitDisplay(String text) {
    // I've just changed this from STring to void
    String unit = '';
    if (text == "AGE") unit = cAge.unit;
    if (text == "HEIGHT")
      unit = cHeight.unit;
    else if (text == "WEIGHT")
      unit = cWeight.unit;
    else if (text == "WAIST")
      unit = cWaist.unit;
    else if (text == "HIP")
      unit = cHips.unit;
    else if (text == "FOREARM")
      unit = cForearm.unit;
    else if (text == "WRIST")
      unit = cWrist.unit;
    else if (text == "THIGH")
      unit = cThigh.unit;
    else if (text == "CALF")
      unit = cCalf.unit;
    else if (text == "NECK") unit = cNeck.unit;
    return unit;
  }

  // The new value in text returned by the slider
  void newValueTxt(double newValue) {
    switch (sliderValues.selectedButton) {
      // Maybe Change sliderValues.selectedButton to scale.text
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
        {
          cAge.incrementPointOne();
          sliderValues.value = cAge.age;
        }
        break;
      case ButtonScale.weight:
        {
          cWeight.incrementPointOne();
          sliderValues.value = cWeight.weight;
        }
        break;
      case ButtonScale.height:
        {
          cHeight.incrementPointOne();
          sliderValues.value = cHeight.length;
        }
        break;
      case ButtonScale.waist:
        {
          cWaist.incrementPointOne();
          sliderValues.value = cWaist.length;
        }
        break;
      case ButtonScale.hip:
        {
          cHips.incrementPointOne();
          sliderValues.value = cHips.length;
        }
        break;
      case ButtonScale.forearm:
        {
          cForearm.incrementPointOne();
          sliderValues.value = cForearm.length;
        }
        break;
      case ButtonScale.wrist:
        {
          cWrist.incrementPointOne();
          sliderValues.value = cWrist.length;
        }
        break;
      case ButtonScale.thigh:
        {
          cThigh.incrementPointOne();
          sliderValues.value = cThigh.length;
        }
        break;
      case ButtonScale.calf:
        {
          cCalf.incrementPointOne();
          sliderValues.value = cCalf.length;
        }
        break;
      case ButtonScale.neck:
        {
          cNeck.incrementPointOne();
          sliderValues.value = cNeck.length;
        }
        break;
      default:
        break;
    }
  }

  void decrementFractionNow() {
    switch (sliderValues.selectedButton) {
      case ButtonScale.age:
        {
          cAge.decrementPointOne();
          sliderValues.value = cAge.age;
        }
        break;
      case ButtonScale.weight:
        {
          cWeight.decrementPointOne();
          sliderValues.value = cWeight.weight;
        }
        break;
      case ButtonScale.height:
        {
          cHeight.decrementPointOne();
          sliderValues.value = cHeight.length;
        }
        break;
      case ButtonScale.waist:
        {
          cWaist.decrementPointOne();
          sliderValues.value = cWaist.length;
        }
        break;
      case ButtonScale.hip:
        {
          cHips.decrementPointOne();
          sliderValues.value = cHips.length;
        }
        break;
      case ButtonScale.forearm:
        {
          cForearm.decrementPointOne();
          sliderValues.value = cForearm.length;
        }
        break;
      case ButtonScale.wrist:
        {
          cWrist.decrementPointOne();
          sliderValues.value = cWrist.length;
        }
        break;
      case ButtonScale.thigh:
        {
          cThigh.decrementPointOne();
          sliderValues.value = cThigh.length;
        }
        break;
      case ButtonScale.calf:
        {
          cCalf.decrementPointOne();
          sliderValues.value = cCalf.length;
        }
        break;
      case ButtonScale.neck:
        {
          cNeck.decrementPointOne();
          sliderValues.value = cNeck.length;
        }
        break;
      default:
        break;
    }
  }

  void decrementNow() {
    switch (sliderValues.selectedButton) {
      case ButtonScale.age:
        {
          cAge.decrementOne();
          sliderValues.value = cAge.age;
        }
        break;
      case ButtonScale.weight:
        {
          cWeight.decrementOne();
          sliderValues.value = cWeight.weight;
        }
        break;
      case ButtonScale.height:
        {
          cHeight.decrementOne();
          sliderValues.value = cHeight.length;
        }
        ;
        break;
      case ButtonScale.waist:
        {
          cWaist.decrementOne();
          sliderValues.value = cWaist.length;
        }
        break;
      case ButtonScale.hip:
        {
          cHips.decrementOne();
          sliderValues.value = cHips.length;
        }
        break;
      case ButtonScale.forearm:
        {
          cForearm.decrementOne();
          sliderValues.value = cForearm.length;
        }
        break;
      case ButtonScale.wrist:
        {
          cWrist.decrementOne();
          sliderValues.value = cWrist.length;
        }
        break;
      case ButtonScale.thigh:
        {
          cThigh.decrementOne();
          sliderValues.value = cThigh.length;
        }
        break;
      case ButtonScale.calf:
        {
          cCalf.decrementOne();
          sliderValues.value = cCalf.length;
        }
        break;
      case ButtonScale.neck:
        {
          cNeck.decrementOne();
          sliderValues.value = cNeck.length;
        }
        break;
      default:
        break;
    }
  }

  void incrementNow() {
    switch (sliderValues.selectedButton) {
      case ButtonScale.age:
        {
          cAge.incrementOne();
          sliderValues.value = cAge.age;
        }
        break;
      case ButtonScale.weight:
        {
          cWeight.incrementOne();
          sliderValues.value = cWeight.weight;
        }
        break;
      case ButtonScale.height:
        {
          cHeight.incrementOne();
          sliderValues.value = cHeight.length;
        }
        break;
      case ButtonScale.waist:
        {
          cWaist.incrementOne();
          sliderValues.value = cWaist.length;
        }
        break;
      case ButtonScale.hip:
        {
          cHips.incrementOne();
          sliderValues.value = cHips.length;
        }
        break;
      case ButtonScale.forearm:
        {
          cForearm.incrementOne();
          sliderValues.value = cForearm.length;
        }
        break;
      case ButtonScale.wrist:
        {
          cWrist.incrementOne();
          sliderValues.value = cWrist.length;
        }
        break;
      case ButtonScale.thigh:
        {
          cThigh.incrementOne();
          sliderValues.value = cThigh.length;
        }
        break;
      case ButtonScale.calf:
        {
          cCalf.incrementOne();
          sliderValues.value = cCalf.length;
        }
        break;
      case ButtonScale.neck:
        {
          cNeck.incrementOne();
          sliderValues.value = cNeck.length;
        }
        break;
      default:
        break;
    }
  }

  // toggle text
  // this is the only function with AGE is excluded
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

  // change color of the button of value is changed

  // Simply animates slider
/*  startAnimateSlider() {
    animateSlider.forward();
    animateSlider.addStatusListener((status) {
      if (status == AnimationStatus.dismissed)
        animateSlider.forward();
      else if (status == AnimationStatus.completed) {
        animateSlider.stop();
        animateSlider.reset();
      }
      print('This is the status: $status');
    });
    animateSlider.addListener(() {
      print('This is from  animation ${animateSlider.value}');
      setState(() {});
    });
  }*/
}
