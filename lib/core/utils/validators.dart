import 'package:intl/intl.dart';

class Validators {
  static String? checkEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter this field';
    }
    return null;
  }

  static String? checkZero(String? value) {
    if (value == '0') {
      return '0 is not valid';
    }
    //check if value is a number
    if (value != null && value.isNotEmpty) {
      if (double.tryParse(value) == null) {
        return 'Please enter a number';
      }
      if (value.length > 4) {
        return 'Please enter a number with a maximum of 4 digits';
      }
    }

    return null;
  }

  static String? check80Characters(String? value) {
    if (value != null && value.length > 80) {
      return 'Please enter a maximum of 80 characters';
    }
    return null;
  }

  static String? check1000Characters(String? value) {
    if (value != null && value.length > 1000) {
      return 'Please enter a maximum of 1000 characters';
    }
    return null;
  }

  static String? checkEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  static String? checkPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // check password contain at least one special character
  static String? checkPasswordSpecialChar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    final specialCharRegex = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    if (!specialCharRegex.hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? Function(String?) combineValidators(
      List<String? Function(String?)> validators) {
    return (value) {
      for (var validator in validators) {
        final error = validator(value);
        if (error != null) {
          return error;
        }
      }
      return null;
    };
  }

  static String? checkAgeOver14(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter date of birth';
    }
    try {
      final dateFormat = DateFormat('dd/MM/yyyy');
      final birthDate = dateFormat.parseStrict(value);
      final today = DateTime.now();

      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      if (age < 14) {
        return 'You must be at least 14 years old';
      }
    } catch (e) {
      return 'Please use dd/MM/yyyy format';
    }
    return null;
  }
}
