import 'package:flutter/material.dart';

List<String> userRoleList = [
  'Setter',
  'Closer',
  'Manager',
];
List<String> userTeamList = [
  'HR',
  'IT',
  'Accounts',
];
List<String> loginAccessList = [
  'Active',
  'Restricted',
];
Widget poppinsText(
        {required String? txt,
        required double? fontSize,
        FontWeight weight = FontWeight.w600,
        double? letterSpacing,
        int maxLines = 1,
        TextAlign? textAlign}) =>
    Text(
      txt!,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
