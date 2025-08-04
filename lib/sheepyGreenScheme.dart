import 'package:flutter/material.dart';
final ThemeData sheepyGreenSheme = ThemeData(
  cardTheme: CardThemeData(elevation: 5,),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor:  Color(0xFFB7D3BA),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF7BA86F),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFCDE3C5),
    onPrimaryContainer: Color(0xFF1F331B),
    secondary: Color(0xFFA2CDB0),
    onSecondary: Color(0xFF1D3023),
    surface: Color(0xFFE6F0E2),
    onSurface: Color(0xFF2C3D2B),
    surfaceContainerHighest: Color(0xFFB7D3BA),
    onSurfaceVariant: Color(0xFF1F331B),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),),
  useMaterial3: true,
);
