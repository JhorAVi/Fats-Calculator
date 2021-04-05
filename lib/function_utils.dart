import 'dart:math';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:bmicalculator/constants.dart';

class CalcBodyFats {
  double age, weight, height, waist, hips, forearm, wrist, thigh, calf, neck;
  bool weightIsLbs, heightIsCm, waistIsCm, hipsIsCm, forearmIsCm, wristIsCm, thighIsCm, calfIsCm, neckIsCm;
  FatFormula selectedFatFormula;
  bool isFemale;
  double _fatsYMCA = 0.0;
  double _fatsHERITAGE = 0.0;
  double _fatsUSNAVY = 0.0;
  double _fatsCOVERTBAILEY = 0.0;
  double _fats = 0.0;
  String _shortSummary = ' ';
  String _longSummary = ' ';
  int selFlex1, selFlex2, selFlex3;

  CalcBodyFats(
      {this.age,
      this.isFemale,
      this.weight,
      this.height,
      this.waist,
      this.hips,
      this.forearm,
      this.wrist,
      this.thigh,
      this.calf,
      this.neck,
      this.weightIsLbs,
      this.heightIsCm,
      this.waistIsCm,
      this.hipsIsCm,
      this.forearmIsCm,
      this.wristIsCm,
      this.thighIsCm,
      this.calfIsCm,
      this.neckIsCm,
      this.selectedFatFormula}) {
    // Convert all values to pounds and inches
    if (!weightIsLbs) weight = kilogramsToLbs(weight);
    if (heightIsCm) height = centimetersToInches(height);
    if (neckIsCm) neck = centimetersToInches(neck);
    if (waistIsCm) waist = centimetersToInches(waist);
    if (hipsIsCm) hips = centimetersToInches(hips);
    if (thighIsCm) thigh = centimetersToInches(thigh);
    if (calfIsCm) calf = centimetersToInches(calf);
    if (forearmIsCm) forearm = centimetersToInches(forearm);
    if (wristIsCm) wrist = centimetersToInches(wrist);
    // Determine which formula
    if (selectedFatFormula == FatFormula.MYMCA)
      calcYMCA();
    else if (selectedFatFormula == FatFormula.HERIGATE)
      calcHERITAGE();
    else if (selectedFatFormula == FatFormula.COVERTBAILEY)
      calcCOVERTBAILEY();
    else if (selectedFatFormula == FatFormula.USNAVY) calcUSNAVY();

    computeSummary();
    // debug
    //print('selected formula ' + selectedFatFormula.toString());
    //print('calcYMCA result = ' + calcYMCA().toString());
  }
  void calcYMCA() {
    // MODIFIED YMCA
    if (isFemale)
      _fatsYMCA = ((0.268 * weight - 0.318 * wrist + 0.157 * waist + 0.245 * hips - 0.434 * forearm - 8.987) / weight) * 100;
    else
      // _fatsYMCA = ((4.15 * waist - 0.082 * weight - 94.42) / weight) * 100; // Not modified
      _fatsYMCA = ((-0.082 * weight + 4.15 * waist - 94.42) / weight) * 100; // modified

    _fats = _fatsYMCA;
  }

  void calcHERITAGE() {
    double heightCm = inchesToCentimeters(height); // convert height to cm
    double weightKg = lbsToKilograms(weight); // convert weight to kg
    double bmi = weightKg / (pow(heightCm / 100, 2));
    if (isFemale)
      _fatsHERITAGE = (1.39 * bmi) + (0.16 * age) - 9;
    else
      _fatsHERITAGE = (1.39 * bmi) + (0.16 * age) - 19.34;

    _fats = _fatsHERITAGE;
  }

  void calcCOVERTBAILEY() {
    if (isFemale) {
      // FEMALE
      if (age <= 30)
        _fatsCOVERTBAILEY = hips + (0.8 * thigh) - (2 * calf) - wrist;
      else
        _fatsCOVERTBAILEY = hips + thigh - (2 * calf) - wrist;
    } else {
      // MALE
      if (age <= 30)
        _fatsCOVERTBAILEY = waist + (0.5 * hips) - (3 * forearm) - wrist;
      else
        _fatsCOVERTBAILEY = waist + (0.5 * hips) - (2.7 * forearm) - wrist;
    }
    _fats = _fatsCOVERTBAILEY;
  }

  void calcUSNAVY() {
    if (isFemale)
      _fatsUSNAVY = 163.205 * log10(waist + hips - neck) - 97.684 * log10(height) - 78.387;
    else
      _fatsUSNAVY = 86.01 * log10(waist - neck) - 70.041 * log10(height) + 36.76;

    _fats = _fatsUSNAVY;
  }

  void computeSummary() {
    // Todo add Skinny
    // for short summary per age group
    //_fats = _fatsYMCA;
    // FEMALE FEMALE FEMALE FEMALE FEMALE
    if (isFemale) {
      if (age <= 20) {
        if (_fats >= 11 && _fats <= 18)
          displayLean();
        else if (_fats >= 18 && _fats <= 23)
          displayIdeal();
        else if (_fats >= 23 && _fats <= 30)
          displayAverage();
        else if (_fats >= 30 && _fats <= 35)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 21 && age <= 25) {
        if (_fats >= 12 && _fats <= 19)
          displayLean();
        else if (_fats >= 19 && _fats <= 24)
          displayIdeal();
        else if (_fats >= 24 && _fats <= 30)
          displayAverage();
        else if (_fats >= 30 && _fats <= 35)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 26 && age <= 30) {
        if (_fats >= 13 && _fats <= 20)
          displayLean();
        else if (_fats >= 21 && _fats <= 25)
          displayIdeal();
        else if (_fats >= 25 && _fats <= 31)
          displayAverage();
        else if (_fats >= 31 && _fats <= 36)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 31 && age <= 35) {
        if (_fats >= 13 && _fats <= 21)
          displayLean();
        else if (_fats >= 21 && _fats <= 26)
          displayIdeal();
        else if (_fats >= 26 && _fats <= 33)
          displayAverage();
        else if (_fats >= 33 && _fats <= 36)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 36 && age <= 40) {
        if (_fats >= 14 && _fats <= 22)
          displayLean();
        else if (_fats >= 22 && _fats <= 27)
          displayIdeal();
        else if (_fats >= 27 && _fats <= 34)
          displayAverage();
        else if (_fats >= 34 && _fats <= 37)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 41 && age <= 45) {
        if (_fats >= 14 && _fats <= 23)
          displayLean();
        else if (_fats >= 23 && _fats <= 28)
          displayIdeal();
        else if (_fats >= 28 && _fats <= 35)
          displayAverage();
        else if (_fats >= 35 && _fats <= 38)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 46 && age <= 50) {
        if (_fats >= 15 && _fats <= 24)
          displayLean();
        else if (_fats >= 24 && _fats <= 30)
          displayIdeal();
        else if (_fats >= 30 && _fats <= 36)
          displayAverage();
        else if (_fats >= 36 && _fats <= 38)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 51 && age <= 55) {
        if (_fats >= 16 && _fats <= 26)
          displayLean();
        else if (_fats >= 26 && _fats <= 31)
          displayIdeal();
        else if (_fats >= 31 && _fats <= 36)
          displayAverage();
        else if (_fats >= 36 && _fats <= 39)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 56) {
        if (_fats >= 16 && _fats <= 27)
          displayLean();
        else if (_fats >= 27 && _fats <= 32)
          displayIdeal();
        else if (_fats >= 32 && _fats <= 37)
          displayAverage();
        else if (_fats >= 37 && _fats <= 40)
          displayOverFat();
        else
          displayExtremelyFat();
      }
    }
    // MALE MALE MALE MALE MALE MALE MALE
    else {
      if (age <= 20) {
        if (_fats >= 2 && _fats <= 8)
          displayLean();
        else if (_fats >= 8 && _fats <= 14)
          displayIdeal();
        else if (_fats >= 14 && _fats <= 21)
          displayAverage();
        else if (_fats >= 21 && _fats <= 25)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 21 && age <= 25) {
        if (_fats >= 3 && _fats <= 10)
          displayLean();
        else if (_fats >= 10 && _fats <= 15)
          displayIdeal();
        else if (_fats >= 15 && _fats <= 22)
          displayAverage();
        else if (_fats >= 23 && _fats <= 26)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 26 && age <= 30) {
        if (_fats >= 4 && _fats <= 11)
          displayLean();
        else if (_fats >= 11 && _fats <= 16)
          displayIdeal();
        else if (_fats >= 16 && _fats <= 21)
          displayAverage();
        else if (_fats >= 21 && _fats <= 27)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 31 && age <= 35) {
        if (_fats >= 5 && _fats <= 13)
          displayLean();
        else if (_fats >= 13 && _fats <= 17)
          displayIdeal();
        else if (_fats >= 17 && _fats <= 25)
          displayAverage();
        else if (_fats >= 25 && _fats <= 28)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 36 && age <= 40) {
        if (_fats >= 6 && _fats <= 15)
          displayLean();
        else if (_fats >= 15 && _fats <= 20)
          displayIdeal();
        else if (_fats >= 20 && _fats <= 26)
          displayAverage();
        else if (_fats >= 26 && _fats <= 29)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 41 && age <= 45) {
        if (_fats >= 7 && _fats <= 16)
          displayLean();
        else if (_fats >= 16 && _fats <= 22)
          displayIdeal();
        else if (_fats >= 22 && _fats <= 27)
          displayAverage();
        else if (_fats >= 27 && _fats <= 30)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 46 && age <= 50) {
        if (_fats >= 8 && _fats <= 17)
          displayLean();
        else if (_fats >= 17 && _fats <= 23)
          displayIdeal();
        else if (_fats >= 23 && _fats <= 29)
          displayAverage();
        else if (_fats >= 29 && _fats <= 31)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 51 && age <= 55) {
        if (_fats >= 9 && _fats <= 19)
          displayLean();
        else if (_fats >= 20 && _fats <= 25)
          displayIdeal();
        else if (_fats >= 25 && _fats <= 30)
          displayAverage();
        else if (_fats >= 31 && _fats <= 33)
          displayOverFat();
        else
          displayExtremelyFat();
      } else if (age >= 56) {
        if (_fats >= 10 && _fats <= 21)
          displayLean();
        else if (_fats >= 21 && _fats <= 26)
          displayIdeal();
        else if (_fats >= 26 && _fats <= 31)
          displayAverage();
        else if (_fats >= 31 && _fats <= 34)
          displayOverFat();
        else
          displayExtremelyFat();
      }
    }

    // long summary
    switch (selectedFatFormula) {
      case FatFormula.MYMCA:
        {
          _longSummary = 'Computed using the Modified YMCA formula';
        }
        break;
      case FatFormula.USNAVY:
        {
          _longSummary = 'Computed using the Department of Defense a.k.a US Navy formula';
        }
        break;
      case FatFormula.COVERTBAILEY:
        {
          _longSummary = 'Computed using the Covert Bailey formula';
        }
        break;
      case FatFormula.HERIGATE:
        {
          _longSummary = 'Computed using the Heritage BMI formula';
        }
        break;
      default:
        break;
    }
  }

  double valueFats() {
    return _fats;
  }

  String shortSummary() {
    return _shortSummary;
  }

  String longSummary() {
    return _longSummary;
  }

  int getFlex1() {
    return selFlex1;
  }

  int getFlex2() {
    return selFlex2;
  }

  int getFlex3() {
    return selFlex3;
  }

  displayLean() {
    selFlex1 = 19;
    selFlex2 = 20;
    selFlex3 = 61;
    _shortSummary = 'Underweight';
    _longSummary = 'You have a lower than normal bodyweight. Try to eat some more';
  }

  displayIdeal() {
    selFlex1 = 37;
    selFlex2 = 20;
    selFlex3 = 43;
    _shortSummary = 'Ideal';
    _longSummary = 'You have a Normal body weight. Good job!';
  }

  displayAverage() {
    selFlex1 = 56;
    selFlex2 = 20;
    selFlex3 = 24;
    _shortSummary = 'Average';
    _longSummary = 'You have a higher than normal body weight. Try to exercise & eat balanced diet';
  }

  displayOverFat() {
    selFlex1 = 75;
    selFlex2 = 25;
    selFlex3 = 0;
    _shortSummary = 'Obese';
    _longSummary = 'Your body weight is too high. You should do exercise and diet control';
  }

  displayExtremelyFat() {
    selFlex1 = 75;
    selFlex2 = 25;
    selFlex3 = 0;
    _shortSummary = "Extremely Obese";
    _longSummary = 'Your too much weight puts you at risk. You better see a doctor';
  }
}

// For BMI calculation
class CalculatorBrain {
  // Variable declarations here
  double height;
  double weight;
  final bool lbsIsDefault;
  final bool cmIsDefault;
  CalculatorBrain({this.height, this.weight, this.lbsIsDefault, this.cmIsDefault}) {
    if (lbsIsDefault) {
      // The BMI formula uses kilograms
      weight = lbsToKilograms(weight);
      // weight = kilogramsToLbs(weight);
    }
    if (!cmIsDefault) {
      height = inchesToCentimeters(height);
    }
    _bmi = weight / (pow(height / 100, 2));

    if (_bmi < 18.5) {
      // underweight
      selFlex1 = 0;
      selFlex2 = 20;
      selFlex3 = 80;
      _shortSummary = 'Underweight';
      _longSummary = 'You have a lower than normal bodyweight. Try to eat some more';
    } else if (_bmi < 25) {
      // normal
      selFlex1 = 19;
      selFlex2 = 20;
      selFlex3 = 61;
      _shortSummary = 'Normal';
      _longSummary = 'You have a Normal body weight. Good job!';
    } else if (_bmi < 29) {
      // overweight
      selFlex1 = 37;
      selFlex2 = 20;
      selFlex3 = 43;
      _shortSummary = 'Overweight';
      _longSummary = 'You have a higher than normal body weight. Try to exercise & eat balanced diet';
    } else if (_bmi < 35) {
      // obese
      selFlex1 = 56;
      selFlex2 = 20;
      selFlex3 = 24;
      _shortSummary = 'Obese';
      _longSummary = 'Your body weight is too high. You should do exercise and diet control';
    } else {
      // extremely obese
      selFlex1 = 75;
      selFlex2 = 25;
      selFlex3 = 0;
      _shortSummary = "Extremely Obese";
      _longSummary = 'Your too much weight puts you at risk. You better see a doctor';
    }
  }

  double _bmi;
  int selFlex1, selFlex2, selFlex3;

  String _shortSummary, _longSummary;

  String calculateBMI() {
    print("cmIsDefault = $cmIsDefault");
    print("lbsIsDefault = $lbsIsDefault");
    print("weight = $weight");
    print("height = $height");
    return _bmi.toStringAsFixed(1);
  }

  int getFlex1() {
    return selFlex1;
  }

  int getFlex2() {
    return selFlex2;
  }

  int getFlex3() {
    return selFlex3;
  }

  String shortSummary() {
    return _shortSummary;
  }

  String longSummary() {
    return _longSummary;
  }
}

double lbsToKilograms(double value) {
  return value / 2.2046;
}

double kilogramsToLbs(double value) {
  return value * 2.2046;
}

double centimetersToInches(double value) {
  return value / 2.54;
}

double inchesToCentimeters(double value) {
  return value * 2.54;
}

// removes the trailing zeros
String removeDecimalZero(double n) {
  n = double.parse(n.toStringAsFixed(1));
  return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
}

// my simpler version of the above
// Wong wrong this doesnt work here
String singlePrecisionNoZero(double n) {
  return double.parse(n.toStringAsFixed(1)).toString();
}
