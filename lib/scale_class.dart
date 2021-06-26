import 'package:flutter/material.dart';
import 'function_utils.dart';
import 'constants.dart';

class IntroData {
  var title = [
    'Modified YMCA',
    'Department of Defense a.k.a. US Navy',
    'Covert Bailey',
    'Heritage'
  ];
  var description = [
    kYMCADescription,
    kUSNAVYDescription,
    kCovertBaileyDescription,
    kHeritageDescription
  ];
  var formula = [
    kYMCAFormula,
    kUSNAVYFormula,
    kCoverBaileyFormula,
    kHeritageFormula
  ];
  var tips = kTips;
}

// values used for the slider
class SliderValues {
  int min = 1;
  int max = 100;
  String text = '';
  double value = 50;
  String unit = '';
  ButtonScale selectedButton = ButtonScale.none;
}

// AGE CLASS AGE CLASS AGE CLASS
// AGE CLASS AGE CLASS AGE CLASS
class AgeScale {
  double age;
  int min, max;
  String ageDisplay;
  String text = 'AGE';
  String unit = 'yr.';
  String monthDisplay; // new. displays months
  String image, image2;
  bool changed = false;

  AgeScale({this.min, this.max, this.image, this.image2}) {
    // age = (min + max) / 2;
    age = min.toDouble() + 1; // starts at the lowest age
    ageDisplay = age.floor().toString();
    monthDisplay = ((age - age.floor()) * 12).toStringAsFixed(0);
  }

  void incrementOne() {
    if (min + 1 < age + 1 && max - 1 > age + 1) {
      age = age.floorToDouble();
      age++;
      ageDisplay = age.floor().toString(); // temp
      monthDisplay = '0';
      changed = true;
    }
  }

  void decrementOne() {
    if (min + 1 < age - 1 && max - 1 > age - 1) {
      if (age.floor() == age) // no decimal
        age--;
      else
        age = age.floorToDouble();
      ageDisplay = age.floor().toString(); // temp
      monthDisplay = '0';
      changed = true;
    }
  }

  // New
  void incrementPointOne() {
    if (max - 1 > age + 1) {
      age = roundDecimal999(age + (1 / 12)); // round the age if decimal is .999
      ageDisplay = age.floor().toString(); // int part
      monthDisplay = ((age - age.floor()) * 12).toStringAsFixed(0);
      //print('age= $age month display++  ${(age - age.floor()) * 12} to $monthDisplay'); // testing
      changed = true;
    }
  }

  void decrementPointOne() {
    if (min + 1 < age - 1) {
      age = roundDecimal999(age - (1 / 12)); // round the age if decimal is .999
      ageDisplay = age.floor().toString(); // int part
      monthDisplay = ((age - age.floor()) * 12).toStringAsFixed(0);
      //print('age= $age month display--  ${(age - age.floor()) * 12} to $monthDisplay'); // testing
      changed = true;
    }
  }

  void editValue(double newValue) {
    if (min + 1 < newValue && max - 1 > newValue) {
      // deduct 1 in range for safety
      age = newValue.roundToDouble(); // remove fractions for clean display
      ageDisplay = age.floor().toString();
      monthDisplay = '0';
      changed = true;
      //print(weight); // debug
    }
  }
}

// WEIGHT CLASS WEIGHT CLASS
// WEIGHT CLASS WEIGHT CLASS
class WeightScale {
  double weight; // not constant
  int min, max; // not constant. can be either lbs or kgs
  int lbsMin, lbsMax;
  int kgMin, kgMax;
  String weightDisplay;
  String text = 'WEIGHT';
  String unit = 'lbs';
  String toggleText;
  bool lbsIsDefault = true;
  String image, image2;
  bool changed = false;

  WeightScale(
      {@required this.lbsMin, @required this.lbsMax, this.image, this.image2}) {
    kgMin = lbsToKilograms(lbsMin.toDouble()).round(); // 23;
    kgMax = lbsToKilograms(lbsMax.toDouble()).round(); //136;
    min = lbsMin; // can either be lbs or kgs
    max = lbsMax;
    //weight = (lbsMin + lbsMax) / 2;
    weight = lbsMin.toDouble() +
        1; // Set to lowest value to make it obvious that it has not been set yet
    //toggleText = (lbsIsDefault) ? '<< switch kgs' : '<< switch lbs';
    weightDisplay = weight.round().toString();
  }

  void toggleToKilograms() {
    unit = 'kgs';
    weight = lbsToKilograms(weight); //  Do conversion here
    min = kgMin;
    max = kgMax;
    lbsIsDefault = false;
    // SETSTATE THIS!
    //toggleText = '<< switch lbs';
    //weightDisplay = weight.toStringAsFixed(1); // remove trailing zeros
    weightDisplay = removeDecimalZero(weight);
  }

  void toggleToLbs() {
    unit = 'lbs';
    weight = kilogramsToLbs(weight); // round off
    min = lbsMin;
    max = lbsMax;
    lbsIsDefault = true;
    // SETSTATE THIS!
    //toggleText = '<< switch kgs';
    //weightDisplay = weight.toStringAsFixed(1); // remove trailing zeros
    weightDisplay = removeDecimalZero(weight);
  }

  void decrementOne() {
    if (min + 1 < weight - 1 && max - 1 > weight - 1) {
      weight = weight.roundToDouble() - 1;
      // SETSTATE THIS!
      weightDisplay = weight.toStringAsFixed(0); // temp
      changed = true;
    }
  }

  void incrementOne() {
    if (min + 1 < weight + 1 && max - 1 > weight + 1) {
      weight = weight.roundToDouble() + 1;
      // SETSTATE THIS!
      weightDisplay = weight.toStringAsFixed(0);
      changed = true;
    }
  }

  // Tap to increment .1 decimal accuracy
  void incrementPointOne() {
    if (max - 1 > weight + 1) {
      weight = weight + 0.1;
      // SETSTATE this
      weightDisplay = removeDecimalZero(weight);
      changed = true;
      // print(removeDecimalZero(weight));
    }
  }

  void decrementPointOne() {
    if (min + 1 < weight - 1) {
      weight = weight - 0.1;
      // SETSTATE this
      weightDisplay = removeDecimalZero(weight);
      changed = true;
      // print(removeDecimalZero(weight));
    }
  }

  void editValue(double newValue) {
    if (min + 1 < newValue && max - 1 > newValue) {
      // deduct 1 in range for safety
      weight = newValue.roundToDouble(); // remove fractions for now
      // SETSTATE THIS!
      weightDisplay = weight.toStringAsFixed(0);
      changed = true;
      //print(weight); // debug
    }
  }
}

// LENGTH CLASS LENGTH CLASS LENGTH CLASS
// LENGTH CLASS LENGTH CLASS LENGTH CLASS
class LengthScale {
  double length;
  int min, max;
  int cmMin, cmMax;
  int inchMin, inchMax;
  String lengthDisplay;
  //String feetText;
  String
      inchesDisplay; // the inches part of feet display computed differently from the rest
  String text;
  String unit = 'cm.';
  String toggleText; // maybe unused
  bool cmIsDefault = true;
  String image, image2;
  bool changed = false;

  LengthScale(
      {@required this.cmMin,
      @required this.cmMax,
      @required this.text,
      this.image,
      this.image2}) {
    inchMin = centimetersToInches(cmMin.toDouble()).round();
    inchMax = centimetersToInches(cmMax.toDouble()).round();
    min = cmMin;
    max = cmMax;
    // length = (cmMin + cmMax) / 2;
    length = cmMin.toDouble() +
        1; // Start at the lowest value so that user will know that the value is not yet set.
    lengthDisplay = length.round().toString();
  }

  // This toogles to height
  void toggleToInches() {
    unit = 'in.';
    length = centimetersToInches(length); // temp
    min = inchMin;
    max = inchMax;
    cmIsDefault = false;
    // SETSTATE this!!
    if (text == 'HEIGHT') {
      inchesDisplay = removeDecimalZero(length % 12);
      //inchesDisplay = ((length % 12)==0)?'':length.toStringAsFixed(1);
      lengthDisplay = (length ~/ 12).toInt().toString();
    } else {
      //lengthDisplay = length.toStringAsFixed(1);
      lengthDisplay = removeDecimalZero(length);
    }
  }

  void toggleToCentimeters() {
    unit = 'cm.';
    length = inchesToCentimeters(length); // Do conversion here
    min = cmMin;
    max = cmMax;
    cmIsDefault = true;
    // SETSTATE this
    lengthDisplay = removeDecimalZero(length);
  }

  void decrementOne() {
    if (min + 1 < length - 1 && max - 1 > length - 1) {
      var lengthF = length.floor().toDouble();
      if (lengthF == length)
        length--;
      else
        length = lengthF;
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'in.') {
        inchesDisplay = (length % 12).toStringAsFixed(0);
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        lengthDisplay = length.toStringAsFixed(0);
      }
      changed = true;
    }
  }

  void incrementOne() {
    if (min + 1 < length + 1 && max - 1 > length + 1) {
      length = length.floor().toDouble();
      length++;
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'in.') {
        inchesDisplay = (length % 12).toStringAsFixed(0);
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        lengthDisplay = length.toStringAsFixed(0);
      }
      changed = true;
    }
  }

  void incrementPointOne() {
    if (max - 1 > length + 1) {
      length = length + 0.1;
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'in.') {
        inchesDisplay = (length % 12).toStringAsFixed(1);
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        //lengthDisplay = length.toStringAsFixed(1);
        lengthDisplay = removeDecimalZero(length);
      }
      changed = true;
    }
  }

  void decrementPointOne() {
    if (min + 1 < length - 1) {
      length = length - 0.1;
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'in.') {
        inchesDisplay = (length % 12).toStringAsFixed(1);
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        //lengthDisplay = length.toStringAsFixed(1);
        lengthDisplay = removeDecimalZero(length);
      }
      changed = true;
    }
  }

  void editValue(double newValue) {
    if (min + 1 < newValue && max - 1 > newValue) {
      // deduct 1 in range for safety
      length = newValue.roundToDouble();
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'in.') {
        inchesDisplay = (length % 12).toStringAsFixed(0);
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        lengthDisplay = length.toStringAsFixed(0);
      }
      changed = true;
    }
  }
}
