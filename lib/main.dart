import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sporky_maxi/components/globals/colors/colors.dart';
import 'package:sporky_maxi/components/globals/dropdown/date_dropdown_field.dart';
import 'views/initial_display/login_page.dart';
import 'views/initial_display/reset_password_page.dart';
import 'views/initial_display/splash_screen.dart';
import 'views/initial_display/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: DateDropdownDismissController.handlePointerDown,
          child: Actions(
            actions: <Type, Action<Intent>>{
              EditableTextTapOutsideIntent:
                  CallbackAction<EditableTextTapOutsideIntent>(
                    onInvoke: (intent) {
                      intent.focusNode.unfocus();
                      return null;
                    },
                  ),
            },
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.base5,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.base5,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          shadowColor: Colors.transparent,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const LoginPage(),
        '/reset-password': (context) => const ResetPasswordPage(),
      },
    );
  }
}
