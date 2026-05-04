import 'package:flutter/material.dart';
import 'navigation/router.dart';
import 'navigation/routes.dart';
import 'theme/theme_data.dart';

void main() {
  runApp(const PureScanApp());
}

class PureScanApp extends StatelessWidget {
  const PureScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pure Scan',
      theme: AppTheme.lightTheme,
      initialRoute: Routes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
