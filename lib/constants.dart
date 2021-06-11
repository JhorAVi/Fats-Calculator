import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Gender { male, female }
enum ButtonScale { age, weight, height, waist, hip, wrist, forearm, thigh, calf, neck, none }

// const kActiveButtonColor = Color(0xFF334033);
// const kActiveButtonColor = Colors.deepPurple;
const kLightButtonColor = Color(0xFF4C4F5E);
const kActiveButtonColor = Color(0xFF1D1E33);

const kInActiveButtonColor = Color(0xFF111328);

const kSmallButtonColor = Color(0xFF4C4F5E);

const kAuthorTextStyle = TextStyle(
  fontSize: 15.0,
  fontStyle: FontStyle.italic,
);

const kTextStyle = TextStyle(
  fontSize: 18.0,
  color: Color(0xFF8D8E98),
);

const kAgeTextStyle = TextStyle(
  fontSize: 30.0,
  fontWeight: FontWeight.w900,
);

const kUnitTextStyle = TextStyle(
  fontSize: 20.0,
);

// The red button at the bottom
const kBottomContainerColor = Color(0xFFEB1555);
const kBottomContainerHeight = 80.0;
const kLargeButtonTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

// result page
const kTitleTextStyle = TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
const kResultTextStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.bold,
  color: Color(0xFF24D876),
);
const kBMITextStyle = TextStyle(fontSize: 70, fontWeight: FontWeight.bold);
const kBodyTextStyle = TextStyle(
  fontSize: 22.0,
);

enum FatFormula {
  MYMCA, // reviced YMCA
  USNAVY,
  COVERTBAILEY,
  HERIGATE,
}
const kYMCADescription =
    '\nThis is the most reliable method and was developed by the YMCA as a simple way to estimate your body fat percentage. Weight is part of the formula.\n';
const kYMCAFormula = 'if (isFemale)\n'
    '     _fatsYMCA = ((0.268 * weight - 0.318 * wrist + 0.157 * waist\n'
    '     + 0.245 * hips - 0.434 * forearm - 8.987) / weight) * 100;\n'
    'else\n'
    '     _fatsYMCA = ((-0.082 * weight + 4.15 * waist - 94.42) / weight)\n'
    '     * 100;';

const kUSNAVYDescription =
    '\nDepartment of Defense a.k.a. US Navy: Very reliable. Height is part of the formula but no weight. The demographics though are young and healthy.\n';
const kUSNAVYFormula = 'if (isFemale)\n'
    '     _fatsUSNAVY = 163.205 * log10(waist + hips - neck)\n'
    '     - 97.684 * log10(height) - 78.387;\n'
    'else\n'
    '     _fatsUSNAVY = 86.01 * log10(waist - neck)\n'
    '     - 70.041 * log10(height) + 36.76;';

const kHeritageDescription = '\nThis method is very simplistic as the only variables needed are your age and your Body Mass Index.\n';
const kHeritageFormula = 'double bmi = weightKg / (pow(heightCm / 100, 2));\n'
    'if (isFemale)\n'
    '     _fatsHERITAGE = (1.39 * bmi) + (0.16 * age) - 9;\n'
    'else\n'
    '     _fatsHERITAGE = (1.39 * bmi) + (0.16 * age) - 19.34;';

const kCovertBaileyDescription =
    '\nThis is probably the newest method among the list created by a well known diet guru. Maybe better for active people. It does\'nt use height nor weight.\n';
const kCoverBaileyFormula = 'if (isFemale) {\n'
    '     if (age <= 30)\n'
    '          _fatsCOVERTBAILEY = hips + (0.8 * thigh) - (2 * calf) - wrist;\n'
    '     else\n'
    '          _fatsCOVERTBAILEY = hips + thigh - (2 * calf) - wrist;\n'
    '     } else {\n'
    '     if (age <= 30)\n'
    '          _fatsCOVERTBAILEY = waist + (0.5 * hips) - (3 * forearm) - wrist;\n'
    '     else\n'
    '          _fatsCOVERTBAILEY = waist + (0.5 * hips) - (2.7 * forearm) - wrist;\n'
    '}';
const kTips = '\n-------------------------------------------\n\n'
    '* Tips *\n\n'
    'Results from different formulas will vary slightly depending on the individual\'s body shape. To insure a consistent '
    'result, use the same formula for tracking your progress.\n';
