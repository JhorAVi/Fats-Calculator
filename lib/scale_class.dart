import 'package:flutter/material.dart';
import 'function_utils.dart';

// AGE CLASS AGE CLASS AGE CLASS
// AGE CLASS AGE CLASS AGE CLASS
class AgeScale {
  double age;
  int min, max;
  String ageDisplay;
  String text = 'AGE';
  String unit = 'years';

  AgeScale({this.min, this.max}) {
    // age = (min + max) / 2;
    age = min.toDouble() + 1; // starts at the lowest age
    ageDisplay = age.round().toString();
  }
// TODO add increment decrement moving
  void decrementOne() {
    if (min + 1 < age - 1 && max - 1 > age - 1) {
      age--;
      ageDisplay = age.toStringAsFixed(0); // temp
    }
  }

  void incrementOne() {
    if (min + 1 < age + 1 && max - 1 > age + 1) {
      age++;
      ageDisplay = age.toStringAsFixed(0);
    }
  }

  void movingValue(double newValue) {
    if (min + 1 < newValue && max - 1 > newValue) {
      // deduct 1 in range for safety
      age = newValue.roundToDouble(); // remove fractions for now
      ageDisplay = age.toStringAsFixed(0);
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

  WeightScale({@required this.lbsMin, @required this.lbsMax}) {
    kgMin = lbsToKilograms(lbsMin.toDouble()).round(); // 23;
    kgMax = lbsToKilograms(lbsMax.toDouble()).round(); //136;
    min = lbsMin; // can either be lbs or kgs
    max = lbsMax;
    //weight = (lbsMin + lbsMax) / 2;
    weight = lbsMin.toDouble() + 1; // Set to lowest value to make it obvious that it has not been set yet
    //toggleText = (lbsIsDefault) ? '<< switch kgs' : '<< switch lbs';
    weightDisplay = weight.round().toString();
  }

  void toggleToKilograms() {
    unit = 'kilograms';
    weight = lbsToKilograms(weight); //  Do conversion here
    min = kgMin;
    max = kgMax;
    lbsIsDefault = false;
    // SETSTATE THIS!
    //toggleText = '<< switch lbs';
    weightDisplay = weight.toStringAsFixed(1); // remove trailing zeros
  }

  void toggleToLbs() {
    unit = 'lbs';
    weight = kilogramsToLbs(weight); // round off
    min = lbsMin;
    max = lbsMax;
    lbsIsDefault = true;
    // SETSTATE THIS!
    //toggleText = '<< switch kgs';
    weightDisplay = weight.toStringAsFixed(1); // remove trailing zeros
  }

  void decrementOne() {
    if (min + 1 < weight - 1 && max - 1 > weight - 1) {
      weight = weight.roundToDouble() - 1;
      // SETSTATE THIS!
      weightDisplay = weight.toStringAsFixed(0); // temp
    }
  }

  void incrementOne() {
    if (min + 1 < weight + 1 && max - 1 > weight + 1) {
      weight = weight.roundToDouble() + 1;
      // SETSTATE THIS!
      weightDisplay = weight.toStringAsFixed(0);
    }
  }

  // Tap to increment .1 decimal accuracy
  void incrementPointOne() {
    if (max - 1 > weight + 1) {
      weight = weight + 0.1;
      // SETSTATE this
      weightDisplay = weight.toStringAsFixed(1);
    }
  }

  void movingValue(double newValue) {
    if (min + 1 < newValue && max - 1 > newValue) {
      // deduct 1 in range for safety
      weight = newValue.roundToDouble(); // remove fractions for now
      // SETSTATE THIS!
      weightDisplay = weight.toStringAsFixed(0);
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
  String feetText;
  String inchesDisplay; // the inches part of feet display computed differently from the rest
  String text;
  String unit = 'centimeters';
  String toggleText; // maybe unused
  bool cmIsDefault = true;

  LengthScale({@required this.cmMin, @required this.cmMax, @required this.text}) {
    inchMin = centimetersToInches(cmMin.toDouble()).round();
    inchMax = centimetersToInches(cmMax.toDouble()).round();
    min = cmMin;
    max = cmMax;
    // length = (cmMin + cmMax) / 2;
    length = cmMin.toDouble() + 1; // Start at the lowest value so that user will know that the value is not yet set.
//    if (cmIsDefault) {
//      toggleText = (text == 'HEIGHT') ? '<< switch feet' : '<< switch inches';
//    } else {
//      toggleText = '<< switch cm';
//    }
    lengthDisplay = length.round().toString();
    inchesDisplay = '';
    feetText = '';
  }
  void toggleToInches() {
    unit = 'inches';
    length = centimetersToInches(length); // temp
    min = inchMin;
    max = inchMax;
    cmIsDefault = false;
    // SETSTATE this!!
    // toggleText = '<< switch cm';
    if (text == 'HEIGHT') {
      inchesDisplay = (length % 12).toStringAsFixed(1);
      feetText = 'ft';
      lengthDisplay = (length ~/ 12).toInt().toString();
    } else {
      inchesDisplay = '';
      feetText = '';
      //lengthDisplay = length.toStringAsFixed(1);
      lengthDisplay = removeDecimalZero(length);
    }
  }

  void toggleToCentimeters() {
    unit = 'centimeters';
    length = inchesToCentimeters(length); // Do conversion here
    min = cmMin;
    max = cmMax;
    cmIsDefault = true;
    // SETSTATE this
    // toggleText = (text == 'HEIGHT') ? '<< switch feet' : '<< switch inches';
    //lengthDisplay = length.toStringAsFixed(1); // remove zero decimal
    lengthDisplay = removeDecimalZero(length);

    feetText = '';
    inchesDisplay = '';
  }

  void decrementOne() {
    if (min + 1 < length - 1 && max - 1 > length - 1) {
      length = length.roundToDouble() - 1;
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'inches') {
        inchesDisplay = (length % 12).toStringAsFixed(0);
        feetText = 'ft';
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        lengthDisplay = length.toStringAsFixed(0);
        feetText = '';
        inchesDisplay = '';
      }
    }
  }

  void incrementOne() {
    if (min + 1 < length + 1 && max - 1 > length + 1) {
      length = length.roundToDouble() + 1;
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'inches') {
        inchesDisplay = (length % 12).toStringAsFixed(0);
        feetText = 'ft';
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        lengthDisplay = length.toStringAsFixed(0);
        feetText = '';
        inchesDisplay = '';
      }
    }
  }

  void incrementPointOne() {
    if (max - 1 > length + 1) {
      length = length + 0.1;
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'inches') {
        inchesDisplay = (length % 12).toStringAsFixed(1);
        feetText = 'ft';
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        //lengthDisplay = length.toStringAsFixed(1);
        lengthDisplay = removeDecimalZero(length);

        feetText = '';
        inchesDisplay = '';
      }
    }
  }

  void movingValue(double newValue) {
    if (min + 1 < newValue && max - 1 > newValue) {
      // deduct 1 in range for safety
      length = newValue.roundToDouble();
      // SETSTATE this
      if (text == 'HEIGHT' && unit == 'inches') {
        inchesDisplay = (length % 12).toStringAsFixed(0);
        feetText = 'ft';
        lengthDisplay = (length ~/ 12).toInt().toString();
      } else {
        lengthDisplay = length.toStringAsFixed(0);
        feetText = '';
        inchesDisplay = '';
      }
    }
  }
}
