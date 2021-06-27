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

  AgeScale cAge = AgeScale(
      min: 5,
      max: 100,
      image: 'images/scales/age.jpg',
      image2: 'images/scales/age2.jpg');
  WeightScale cWeight = WeightScale(
      lbsMin: 50,
      lbsMax: 500,
      image: 'images/scales/weight.jpg',
      image2: 'images/scales/weight2.jpg');
  LengthScale cHeight = LengthScale(
      cmMin: 91,
      cmMax: 228,
      text: 'HEIGHT',
      image: 'images/scales/height.jpg',
      image2: 'images/scales/height2.jpg');
  LengthScale cWaist = LengthScale(
      cmMin: 20,
      cmMax: 200,
      text: 'WAIST',
      image: 'images/scales/waist.jpg',
      image2: 'images/scales/waist2.jpg');
  LengthScale cHips = LengthScale(
      cmMin: 20,
      cmMax: 200,
      text: 'HIPS',
      image: 'images/scales/hips.jpg',
      image2: 'images/scales/hips2.jpg');
  LengthScale cWrist = LengthScale(
      cmMin: 5,
      cmMax: 30,
      text: 'WRIST',
      image: 'images/scales/wrist.jpg',
      image2: 'images/scales/wrist2.jpg');
  LengthScale cForearm = LengthScale(
      cmMin: 5,
      cmMax: 50,
      text: 'FOREARM',
      image: 'images/scales/forearm.jpg',
      image2: 'images/scales/forearm2.jpg');
  LengthScale cThigh = LengthScale(
      cmMin: 5,
      cmMax: 100,
      text: 'THIGH',
      image: 'images/scales/thigh.jpg',
      image2: 'images/scales/thigh2.jpg');
  LengthScale cCalf = LengthScale(
      cmMin: 5,
      cmMax: 50,
      text: 'CALF',
      image: 'images/scales/calf.jpg',
      image2: 'images/scales/calf2.jpg');
  LengthScale cNeck = LengthScale(
      cmMin: 5,
      cmMax: 50,
      text: 'NECK',
      image: 'images/scales/neck.jpg',
      image2: 'images/scales/neck2.jpg');

  // tabs definition
  final _kTabs = <Tab>[
    Tab(text: 'mod YMCA'),
    Tab(text: 'US Navy'),
    Tab(text: 'Covert Bailey'),
    Tab(text: 'Heritage'),
  ];

  // Tab controller
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    selectedGender = Gender.male; // set male as default
    // sliderValues.selectedButton = ButtonScale.age; // set age as default. useless
    _tabController = new TabController(vsync: this, length: _kTabs.length);

    animateSlider = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        lowerBound: 1,
        upperBound: 407);

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
                child: Text(_fatsYMCA.toStringAsFixed(1),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text(_fatsUSNAVY.toStringAsFixed(1),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text(_fatsCOVERTBAILEY.toStringAsFixed(1),
                    textAlign: TextAlign.center),
              ),
              Expanded(
                child: Text(_fatsHERITAGE.toStringAsFixed(1),
                    textAlign: TextAlign.center),
              )
            ],
          ),
          // Tab INTRO before showing the scale buttons
          Visibility(
            visible: introVisible,
            child: Expanded(
              // this is the reason why SingleShildScrollView works
              child: SingleChildScrollView(
                child: Container(
                  // TAB Contents VIEW
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent)),
                  // color: kInActiveButtonColor,
                  child: TabWidget(
                      title: introData.title[introIndex],
                      description: introData.description[introIndex],
                      formula: introData.formula[introIndex],
                      introIndex: introIndex,
                      tips: introData.tips,
/*                  animate: (val) {
                        val.forward();
                        val.addListener(() {
                          print(val.animate.value);
                          setState(() {});
                        });
                      },*/
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
                        colour: (selectedGender == Gender.male)
                            ? kLightButtonColor
                            : kInActiveButtonColor,
                        //colour: kInActiveButtonColor,
                        widgetContents: GenderCardContent(
                          label: 'MALE',
                          iconGender: FontAwesomeIcons.male,
                          iconStatus: (!isFemale)
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.times,
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
                        colour: (selectedGender == Gender.female)
                            ? kLightButtonColor
                            : kInActiveButtonColor,
                        //colour: kInActiveButtonColor,
                        widgetContents: GenderCardContent(
                          label: 'FEMALE',
                          iconGender: FontAwesomeIcons.female,
                          iconStatus: (isFemale)
                              ? FontAwesomeIcons.check
                              : FontAwesomeIcons.times,
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
                        colour: (cAge.changed)
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          // AGE AGE AGE currently merging this with statsCardContent
                          text: cAge.text,
                          unit: cAge.unit,
                          image: (selectedGender == Gender.female)
                              ? cAge.image
                              : cAge.image2,
                          changed: cAge.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.age; // useless
                          // BuildContext dialogContext;
                          await popupDialog(
                            context,
                            text: cAge.text,
                            value: cAge.age,
                            min: cAge.min,
                            max: cAge.max,
                            image: (selectedGender == Gender.female)
                                ? cAge.image
                                : cAge.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: isUSNAVY | isHERITAGE,
                      child: ReusableCard(
                        // HEIGHT HEIGHT HEIGHT
                        colour: cHeight.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cHeight.text,
                          unit: cHeight.unit,
                          image: (selectedGender == Gender.female)
                              ? cHeight.image
                              : cHeight.image2,
                          changed: cHeight.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton = ButtonScale.height;
                          await popupDialog(
                            context,
                            text: cHeight.text,
                            value: cHeight.length,
                            min: cHeight.min,
                            max: cHeight.max,
                            image: (selectedGender == Gender.female)
                                ? cHeight.image
                                : cHeight.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: isMYMCA | isHERITAGE,
                      child: ReusableCard(
                        // WEIGHT WEIGHT WEIGHT
                        colour: cWeight.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cWeight.text,
                          unit: cWeight.unit,
                          image: (selectedGender == Gender.female)
                              ? cWeight.image
                              : cWeight.image2,
                          changed: cWeight.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.weight; // useless
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cWeight.text,
                            value: cWeight.weight,
                            min: cWeight.min,
                            max: cWeight.max,
                            image: (selectedGender == Gender.female)
                                ? cWeight.image
                                : cWeight.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible:
                          isMYMCA | isUSNAVY | (isCOVERTBAILEY & !isFemale),
                      child: ReusableCard(
                        // WAIST WAIST
                        colour: cWaist.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cWaist.text,
                          unit: cWaist.unit,
                          image: (selectedGender == Gender.female)
                              ? cWaist.image
                              : cWaist.image2,
                          changed: cWaist.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.waist; // useless
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cWaist.text,
                            value: cWaist.length,
                            min: cWaist.min,
                            max: cWaist.max,
                            image: (selectedGender == Gender.female)
                                ? cWaist.image
                                : cWaist.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible: (isMYMCA & isFemale) |
                          (isUSNAVY & isFemale) |
                          isCOVERTBAILEY,
                      child: ReusableCard(
                        // HIPS HIPS
                        colour: cHips.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cHips.text,
                          unit: cHips.unit,
                          image: (selectedGender == Gender.female)
                              ? cHips.image
                              : cHips.image2,
                          changed: cHips.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.hip; // useless
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cHips.text,
                            value: cHips.length,
                            min: cHips.min,
                            max: cHips.max,
                            image: (selectedGender == Gender.female)
                                ? cHips.image
                                : cHips.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible:
                          (isMYMCA & isFemale) | (isCOVERTBAILEY & !isFemale),
                      child: ReusableCard(
                        // FOREARM FOREARM
                        colour: cForearm.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cForearm.text,
                          unit: cForearm.unit,
                          image: (selectedGender == Gender.female)
                              ? cForearm.image
                              : cForearm.image2,
                          changed: cForearm.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.forearm; // useless
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cForearm.text,
                            value: cForearm.length,
                            min: cForearm.min,
                            max: cForearm.max,
                            image: (selectedGender == Gender.female)
                                ? cForearm.image
                                : cForearm.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible: (isMYMCA & isFemale) | isCOVERTBAILEY,
                      child: ReusableCard(
                        // WRIST WRIST
                        colour: cWrist.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cWrist.text,
                          unit: cWrist.unit,
                          image: (selectedGender == Gender.female)
                              ? cWrist.image
                              : cWrist.image2,
                          changed: cWrist.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.wrist; // useless
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cWrist.text,
                            value: cWrist.length,
                            min: cWrist.min,
                            max: cWrist.max,
                            image: (selectedGender == Gender.female)
                                ? cWrist.image
                                : cWrist.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: (isCOVERTBAILEY & isFemale),
                      child: ReusableCard(
                        // THIGH THIGH
                        colour: cThigh.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cThigh.text,
                          unit: cThigh.unit,
                          image: (selectedGender == Gender.female)
                              ? cThigh.image
                              : cThigh.image2,
                          changed: cThigh.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.thigh; // useless
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cThigh.text,
                            value: cThigh.length,
                            min: cThigh.min,
                            max: cThigh.max,
                            image: (selectedGender == Gender.female)
                                ? cThigh.image
                                : cThigh.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),

                    Visibility(
                      visible: (isCOVERTBAILEY & isFemale),
                      child: ReusableCard(
                        // CALF CALF
                        colour: cCalf.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cCalf.text,
                          unit: cCalf.unit,
                          image: (selectedGender == Gender.female)
                              ? cCalf.image
                              : cCalf.image2,
                          changed: cCalf.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.calf; // useless
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cCalf.text,
                            value: cCalf.length,
                            min: cCalf.min,
                            max: cCalf.max,
                            image: (selectedGender == Gender.female)
                                ? cCalf.image
                                : cCalf.image2,
                          );
                          setState(() {});
                        },
                      ),
                    ),
                    Visibility(
                      visible: isUSNAVY,
                      child: ReusableCard(
                        // NECK NECK
                        colour: cNeck.changed
                            ? kActiveButtonColor
                            : kInActiveButtonColor,
                        widgetContents: statsCardContent(
                          text: cNeck.text,
                          unit: cNeck.unit,
                          image: (selectedGender == Gender.female)
                              ? cNeck.image
                              : cNeck.image2,
                          changed: cNeck.changed,
                        ),
                        onPressedMy: () async {
                          sliderValues.selectedButton =
                              ButtonScale.neck; // useless
                          // startAnimateSlider();
                          await popupDialog(
                            context,
                            text: cNeck.text,
                            value: cNeck.length,
                            min: cNeck.min,
                            max: cNeck.max,
                            image: (selectedGender == Gender.female)
                                ? cNeck.image
                                : cNeck.image2,
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
                      weightIsLbs: cWeight.lbsIsDefault, // default checker
                      heightIsCm: cHeight.cmIsDefault,
                      waistIsCm: cWaist.cmIsDefault,
                      hipsIsCm: cHips.cmIsDefault,
                      forearmIsCm: cForearm.cmIsDefault,
                      wristIsCm: cWrist.cmIsDefault,
                      thighIsCm: cThigh.cmIsDefault,
                      calfIsCm: cCalf.cmIsDefault,
                      neckIsCm: cNeck.cmIsDefault,
                      selectedFatFormula: selectedFatFormula,
                      ageChanged: cAge.changed, // changed checker
                      weightChanged: cWeight.changed,
                      heightChanged: cHeight.changed,
                      waistChanged: cWaist.changed,
                      hipsChanged: cHips.changed,
                      thighChanged: cThigh.changed,
                      forearmChanged: cForearm.changed,
                      wristChanged: cWrist.changed,
                      neckChanged: cNeck.changed,
                      calfChanged: cCalf.changed,
                    );
                    // Now check if some scales are missed and cancel computation
                    if (calcBF.getChangedAll() == false) {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.blueGrey,
                        content: Row(
                          children: [
                            Icon(Icons.announcement_outlined),
                            SizedBox(width: 10.0),
                            Expanded(
                                child: Text(
                                    'Complete all measurements before proceeding',
                                    style: TextStyle(color: Colors.white))),
                          ],
                        ),
                        action: SnackBarAction(
                          label: 'OK',
                          onPressed: () {},
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }
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
                            genderPath: isFemale
                                ? 'images/bodyFatsWomen.jpg'
                                : 'images/bodyFatsMen.jpg',
                            shortSummary: calcBF.shortSummary(),
                            longSummary: calcBF.longSummary(),
                            formulaSummary: calcBF.formulaSummary(),
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
      final String image,
      final bool changed}) {
    // if (selected) sliderForAll(value: value, min: min, max: max); // Links current button to slider.
    // The above function executes all the time so it updates the slider values anytime you
    // press the increment or decrement or any operation
    String leftSpace =
        '  ' * (10 - (text.length)); // the left tab depending on text length
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          // contains the value group
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //          SizedBox(width: (50 - (text.length)).toDouble()),
            Text(leftSpace),
            Text(
              // WEIGHT or HEIGHT TEXT
              text,
              style: kTextStyle,
            ),
            SizedBox(width: 10),
            Container(
              // contains the image
              height: 45,
              width: 70,
              child: ReusableImage(
                image: image,
                // width: 30,
                // height: 20,
              ),
            ),
            SizedBox(width: 10),
            // tap to Add .1 decimal accuracy to the value
            Text(
              // SLIDER CURRENT VALUE NUMBER
              currentValueTxt(text),
              style: kAgeTextStyle,
            ),
            Text(
              // Display Feet of unit is in inches
              ' ${(text == 'HEIGHT' && cHeight.unit == 'in.') ? 'ft.' : unit}',
              // The value above executes all the time so it updates whenever the unit is toggled
              style: kUnitTextStyle,
              // textAlign: TextAlign.center,
            ),
            Text(
              // Inches or Month value
              ' ${inchOrMonthValue(text)}',
              style: kAgeTextStyle,
            ),
            Text(
              // Inches or Month unit
              ' ${inchOrMonthUnit(text)}',
              style: kUnitTextStyle,
            ),
          ],
        ),
        Visibility(
          visible: changed ? true : false,
          child: Row(
            children: [
              Text('done '),
              Icon(
                FontAwesomeIcons.check,
                size: 15.0,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> popupDialog(
    // All the contents here are just for initial value.
    BuildContext context, {
    final String text,
    final double value, // To display the initial value depending on the metrics
    final int min, // initial min value
    final int max, // initial max value
    final String image,
  }) {
    // sliderUpdate(text); // Initial value for the dialog slider
    sliderValues.value = value;
    sliderValues.min = min;
    sliderValues.max = max;
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          // backgroundColor: kInActiveButtonColor,
          titlePadding: EdgeInsets.fromLTRB(8, 10, 10, 0),
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          // The TEXT above the slider
          title: Container(
            height:
                77, // this height should depend on the fonsize of the content
            child: Row(
              // Separation between Value group and image
              // mainAxisAlignment: MainAxisAlignment.end, // to set image to top right corner
              // crossAxisAlignment: CrossAxisAlignment.start, // to set image to top right corner

              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    // Unit on top and value under
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        // WEIGHT or HEIGHT TEXT
                        text,
                        style: kDialogTitleStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //SizedBox(width: 10),
                          Text(
                            // SLIDER CURRENT VALUE NUMBER
                            currentValueTxt(text),
                            style: kAgeTextStyle,
                          ),
                          Text(
                            // INCHES OR CM with adjustment for feet and age
                            ' ${unitDisplay(text)}',
                            style: kUnitTextStyle,
                          ),

                          // The following is for extra info for inches and months
                          Text(
                            // FRACTIONS by INCHES or MONTHS
                            ' ${inchOrMonthValue(text)}',
                            style: kAgeTextStyle,
                          ),
                          Text(
                            // FEET OR NOT
                            ' ${inchOrMonthUnit(text)}',
                            style: kUnitTextStyle,
                          ),

                          // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
                          // TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE TOGGLE
                          Visibility(
                            visible: (text == 'AGE') ? false : true,
                            child: UnitToggleButton(
                              // Negate the UNIT Button  // Make sure that the conversion has decimal accuracy
                              //text: toggleText,
                              onPress: () {
                                setState(() {
                                  toggleNow(
                                      text); // Change the value after toggle
                                  sliderUpdate(
                                      text); // The slider min max values update after toggle.
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  flex: 3,
                  child: ReusableImage(
                    image: image,
                    //width: 90,
                    //height: 70,
                  ),
                ),
              ],
            ),
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
                    flex: 2,
                    child: SliderSideButton(
                      icon: FontAwesomeIcons.chevronCircleLeft,
                      onPress: () {
                        setState(() {
                          decrementNow(text); // Decrement now!
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Slider(
                        value: sliderValues.value,
                        min: sliderValues.min.toDouble(),
                        max: sliderValues.max.toDouble(),
                        activeColor: Color(0xFFEB1555),
                        inactiveColor: Color(0xFF8D8E98),
                        onChanged: (newValue) {
                          setState(() {
                            newValueTxt(newValue, text); // New value in text
                            sliderValues.value = newValue;
/*                            print('value from popup = ' + sliderValues.value.toString());
                            print('newValue = ' + newValue.toString());
                            print('min = ' + sliderValues.min.toString());
                            print('max = ' + sliderValues.max.toString());*/
                          });
                        }),
                  ),
                  Expanded(
                    flex: 2,
                    child: SliderSideButton(
                      icon: FontAwesomeIcons.chevronCircleRight,
                      onPress: () {
                        setState(() {
                          incrementNow(text); // perform increment
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
            Column(
              // All the action button with tips under it
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      color: kSmallButtonColor,
                      onPressed: () {
                        setState(() {
                          decrementFractionNow(text); // perform increment
                        });
                      },
                      child: Text((text == 'AGE') ? '- mo.' : '- 0.1'),
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
                          incrementFractionNow(text); // perform increment
                        });
                      },
                      child: Text(
                        (text == 'AGE') ? '+ mo.' : '+ 0.1',
                      ),
                    ),
                  ],
                ),
                //SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (text == 'AGE')
                        ? '* Tip: You can increase the age precision by specifying the number of months'
                        : '* Tip: The button right of the value auto converts that value to the alternative unit.',
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // assign the slider to the pressed button
  void sliderUpdate(String text) {
    if (text == "AGE") {
      sliderValues.selectedButton = ButtonScale.age; // USELESS
      sliderValues.value = cAge.age; // useless
      sliderValues.min = cAge.min;
      sliderValues.max = cAge.max;
    } else if (text == "HEIGHT") {
      sliderValues.selectedButton = ButtonScale.height;
      sliderValues.value = cHeight.length;
      sliderValues.min = cHeight.min;
      sliderValues.max = cHeight.max;
    } else if (text == "WEIGHT") {
      sliderValues.selectedButton = ButtonScale.weight;
      sliderValues.value = cWeight.weight;
      sliderValues.min = cWeight.min;
      sliderValues.max = cWeight.max;
    } else if (text == "WAIST") {
      sliderValues.selectedButton = ButtonScale.waist;
      sliderValues.value = cWaist.length;
      sliderValues.min = cWaist.min;
      sliderValues.max = cWaist.max;
    } else if (text == "HIPS") {
      sliderValues.selectedButton = ButtonScale.hip;
      sliderValues.value = cHips.length;
      sliderValues.min = cHips.min;
      sliderValues.max = cHips.max;
    } else if (text == "FOREARM") {
      sliderValues.selectedButton = ButtonScale.forearm;
      sliderValues.value = cForearm.length;
      sliderValues.min = cForearm.min;
      sliderValues.max = cForearm.max;
    } else if (text == "WRIST") {
      sliderValues.selectedButton = ButtonScale.wrist;
      sliderValues.value = cWrist.length;
      sliderValues.min = cWrist.min;
      sliderValues.max = cWrist.max;
    } else if (text == "THIGH") {
      sliderValues.selectedButton = ButtonScale.thigh;
      sliderValues.value = cThigh.length;
      sliderValues.min = cThigh.min;
      sliderValues.max = cThigh.max;
    } else if (text == "CALF") {
      sliderValues.selectedButton = ButtonScale.calf;
      sliderValues.value = cCalf.length;
      sliderValues.min = cCalf.min;
      sliderValues.max = cCalf.max;
    } else if (text == "NECK") {
      sliderValues.selectedButton = ButtonScale.neck;
      sliderValues.value = cNeck.length;
      sliderValues.min = cNeck.min;
      sliderValues.max = cNeck.max;
    }
  }

  // The actual value depending on the text
  // text is passed instead of sliderValue because there are many individual buttons
  String currentValueTxt(String text) {
    if (text == 'AGE')
      return cAge.ageDisplay;
    else if (text == 'WEIGHT')
      return cWeight.weightDisplay;
    else if (text == 'HEIGHT')
      return cHeight.lengthDisplay;
    else if (text == 'WAIST')
      return cWaist.lengthDisplay;
    else if (text == 'HIPS')
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

  // Process the inches display part
  String inchOrMonthValue(String text) {
    String returnText;
    if (text == 'HEIGHT' &&
        cHeight.unit == 'in.' &&
        cHeight.inchesDisplay != '0')
      returnText = cHeight.inchesDisplay;
    else if (text == 'AGE' && cAge.monthDisplay != '0')
      returnText = cAge.monthDisplay;
    //print('This is month display ' + cAge.monthDisplay);
    else
      returnText = '';
    return returnText;
  }

  // Process the visibility of the feet text
  String inchOrMonthUnit(String text) {
    String returnText;
    if (text == 'HEIGHT' &&
        cHeight.unit == 'in.' &&
        cHeight.inchesDisplay != '0')
      returnText = cHeight.unit;
    else if (text == 'AGE' && cAge.monthDisplay != '0')
      returnText = 'mos.';
    else
      returnText = '';
    return returnText;
  }

  // no toggle arrow down on AGE
  bool disableToggleOnAge(String text) {
    return (text == 'AGE') ? false : true;
  }

  // Displays inches or cm
  String unitDisplay(String text) {
    // I've just changed this from STring to void
    String unit = '';
    if (text == "AGE")
      unit = cAge.unit;
    else if (text == "HEIGHT")
      unit = (cHeight.unit == 'in.') ? 'ft.' : cHeight.unit;
    else if (text == "WEIGHT")
      unit = cWeight.unit;
    else if (text == "WAIST")
      unit = cWaist.unit;
    else if (text == "HIPS")
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
  void newValueTxt(double newValue, String text) {
    switch (text) {
      // Maybe Change sliderValues.selectedButton to scale.text
      case 'AGE':
        cAge.editValue(newValue);
        break;
      case 'WEIGHT':
        cWeight.editValue(newValue);
        break;
      case 'HEIGHT':
        cHeight.editValue(newValue);
        break;
      case 'WAIST':
        cWaist.editValue(newValue);
        break;
      case 'HIPS':
        cHips.editValue(newValue);
        break;
      case 'FOREARM':
        cForearm.editValue(newValue);
        break;
      case 'WRIST':
        cWrist.editValue(newValue);
        break;
      case 'THIGH':
        cThigh.editValue(newValue);
        break;
      case 'CALF':
        cCalf.editValue(newValue);
        break;
      case 'NECK':
        cNeck.editValue(newValue);
        break;
      default:
        break;
    }
  }

  // increment by fraction
  void incrementFractionNow(String text) {
    switch (text) {
      case 'AGE':
        {
          cAge.incrementPointOne();
          sliderValues.value = cAge.age;
        }
        break;
      case 'WEIGHT':
        {
          cWeight.incrementPointOne();
          sliderValues.value = cWeight.weight;
        }
        break;
      case 'HEIGHT':
        {
          cHeight.incrementPointOne();
          sliderValues.value = cHeight.length;
        }
        break;
      case 'WAIST':
        {
          cWaist.incrementPointOne();
          sliderValues.value = cWaist.length;
        }
        break;
      case 'HIPS':
        {
          cHips.incrementPointOne();
          sliderValues.value = cHips.length;
        }
        break;
      case 'FOREARM':
        {
          cForearm.incrementPointOne();
          sliderValues.value = cForearm.length;
        }
        break;
      case 'WRIST':
        {
          cWrist.incrementPointOne();
          sliderValues.value = cWrist.length;
        }
        break;
      case 'THIGH':
        {
          cThigh.incrementPointOne();
          sliderValues.value = cThigh.length;
        }
        break;
      case 'CALF':
        {
          cCalf.incrementPointOne();
          sliderValues.value = cCalf.length;
        }
        break;
      case 'NECK':
        {
          cNeck.incrementPointOne();
          sliderValues.value = cNeck.length;
        }
        break;
      default:
        break;
    }
  }

  void decrementFractionNow(String text) {
    switch (text) {
      case 'AGE':
        {
          cAge.decrementPointOne();
          sliderValues.value = cAge.age;
        }
        break;
      case 'WEIGHT':
        {
          cWeight.decrementPointOne();
          sliderValues.value = cWeight.weight;
        }
        break;
      case 'HEIGHT':
        {
          cHeight.decrementPointOne();
          sliderValues.value = cHeight.length;
        }
        break;
      case 'WAIST':
        {
          cWaist.decrementPointOne();
          sliderValues.value = cWaist.length;
        }
        break;
      case 'HIPS':
        {
          cHips.decrementPointOne();
          sliderValues.value = cHips.length;
        }
        break;
      case 'FOREARM':
        {
          cForearm.decrementPointOne();
          sliderValues.value = cForearm.length;
        }
        break;
      case 'WRIST':
        {
          cWrist.decrementPointOne();
          sliderValues.value = cWrist.length;
        }
        break;
      case 'THIGH':
        {
          cThigh.decrementPointOne();
          sliderValues.value = cThigh.length;
        }
        break;
      case 'CALF':
        {
          cCalf.decrementPointOne();
          sliderValues.value = cCalf.length;
        }
        break;
      case 'NECK':
        {
          cNeck.decrementPointOne();
          sliderValues.value = cNeck.length;
        }
        break;
      default:
        break;
    }
  }

  void decrementNow(String text) {
    switch (text) {
      case 'AGE':
        {
          cAge.decrementOne();
          sliderValues.value = cAge.age;
        }
        break;
      case 'WEIGHT':
        {
          cWeight.decrementOne();
          sliderValues.value = cWeight.weight;
        }
        break;
      case 'HEIGHT':
        {
          cHeight.decrementOne();
          sliderValues.value = cHeight.length;
        }
        ;
        break;
      case 'WAIST':
        {
          cWaist.decrementOne();
          sliderValues.value = cWaist.length;
        }
        break;
      case 'HIPS':
        {
          cHips.decrementOne();
          sliderValues.value = cHips.length;
        }
        break;
      case 'FOREARM':
        {
          cForearm.decrementOne();
          sliderValues.value = cForearm.length;
        }
        break;
      case 'WRIST':
        {
          cWrist.decrementOne();
          sliderValues.value = cWrist.length;
        }
        break;
      case 'THIGH':
        {
          cThigh.decrementOne();
          sliderValues.value = cThigh.length;
        }
        break;
      case 'CALF':
        {
          cCalf.decrementOne();
          sliderValues.value = cCalf.length;
        }
        break;
      case 'NECK':
        {
          cNeck.decrementOne();
          sliderValues.value = cNeck.length;
        }
        break;
      default:
        break;
    }
  }

  void incrementNow(String text) {
    switch (text) {
      case 'AGE':
        {
          cAge.incrementOne();
          sliderValues.value = cAge.age;
        }
        break;
      case 'WEIGHT':
        {
          cWeight.incrementOne();
          sliderValues.value = cWeight.weight;
        }
        break;
      case 'HEIGHT':
        {
          cHeight.incrementOne();
          sliderValues.value = cHeight.length;
        }
        break;
      case 'WAIST':
        {
          cWaist.incrementOne();
          sliderValues.value = cWaist.length;
        }
        break;
      case 'HIPS':
        {
          cHips.incrementOne();
          sliderValues.value = cHips.length;
        }
        break;
      case 'FOREARM':
        {
          cForearm.incrementOne();
          sliderValues.value = cForearm.length;
        }
        break;
      case 'WRIST':
        {
          cWrist.incrementOne();
          sliderValues.value = cWrist.length;
        }
        break;
      case 'THIGH':
        {
          cThigh.incrementOne();
          sliderValues.value = cThigh.length;
        }
        break;
      case 'CALF':
        {
          cCalf.incrementOne();
          sliderValues.value = cCalf.length;
        }
        break;
      case 'NECK':
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
  void toggleNow(String text) {
    if (text == 'HEIGHT' && cHeight.unit == 'cm.') {
      cHeight.toggleToInches();
      //sliderValues.selectedButton = ButtonScale.height;
    } else if (text == 'HEIGHT' && cHeight.unit == 'in.') {
      cHeight.toggleToCentimeters();
      //sliderValues.selectedButton = ButtonScale.height;
    } else if (text == 'WEIGHT' && cWeight.unit == 'kgs') {
      cWeight.toggleToLbs();
      //sliderValues.selectedButton = ButtonScale.weight;
    } else if (text == 'WEIGHT' && cWeight.unit == 'lbs') {
      cWeight.toggleToKilograms();
      //sliderValues.selectedButton = ButtonScale.weight;
    } else if (text == 'WAIST' && cWaist.unit == 'cm.') {
      cWaist.toggleToInches();
      // sliderValues.selectedButton = ButtonScale.waist;
    } else if (text == 'WAIST' && cWaist.unit == 'in.') {
      cWaist.toggleToCentimeters();
      //sliderValues.selectedButton = ButtonScale.waist;
    } else if (text == 'HIPS' && cHips.unit == 'cm.') {
      cHips.toggleToInches();
      //sliderValues.selectedButton = ButtonScale.hip;
    } else if (text == 'HIPS' && cHips.unit == 'in.') {
      cHips.toggleToCentimeters();
      //sliderValues.selectedButton = ButtonScale.hip;
    } else if (text == 'FOREARM' && cForearm.unit == 'cm.') {
      cForearm.toggleToInches();
      //sliderValues.selectedButton = ButtonScale.forearm;
    } else if (text == 'FOREARM' && cForearm.unit == 'in.') {
      cForearm.toggleToCentimeters();
      //sliderValues.selectedButton = ButtonScale.forearm;
    } else if (text == 'WRIST' && cWrist.unit == 'cm.') {
      cWrist.toggleToInches();
      //sliderValues.selectedButton = ButtonScale.wrist;
    } else if (text == 'WRIST' && cWrist.unit == 'in.') {
      cWrist.toggleToCentimeters();
      //sliderValues.selectedButton = ButtonScale.wrist;
    } else if (text == 'THIGH' && cThigh.unit == 'cm.') {
      cThigh.toggleToInches();
      //sliderValues.selectedButton = ButtonScale.thigh;
    } else if (text == 'THIGH' && cThigh.unit == 'in.') {
      cThigh.toggleToCentimeters();
      //sliderValues.selectedButton = ButtonScale.thigh;
    } else if (text == 'CALF' && cCalf.unit == 'cm.') {
      cCalf.toggleToInches();
      //sliderValues.selectedButton = ButtonScale.calf;
    } else if (text == 'CALF' && cCalf.unit == 'in.') {
      cCalf.toggleToCentimeters();
      //sliderValues.selectedButton = ButtonScale.calf;
    } else if (text == 'NECK' && cNeck.unit == 'cm.') {
      cNeck.toggleToInches();
      //sliderValues.selectedButton = ButtonScale.neck;
    } else if (text == 'NECK' && cNeck.unit == 'in.') {
      cNeck.toggleToCentimeters();
      //sliderValues.selectedButton = ButtonScale.neck;
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
