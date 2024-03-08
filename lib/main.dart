import 'package:assignment/src/data/blocs/users/user_bloc.dart';
import 'package:assignment/src/domain/helpers/shared_preference_helper.dart';
import 'package:assignment/src/domain/repos.dart';
import 'package:assignment/src/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesHelper.initSharedPrefs();

  await notificationRepo.getToken();
  notificationRepo.listenToNotification(
    onSelected: (String value) {},
  );

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) => UserBloc()..add(UserEventFetchAll()),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (_, child) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              title: 'Assignment',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.black,
                scaffoldBackgroundColor: Colors.white,
                // appBarTheme: AppBarTheme(
                //   backgroundColor: Colors.white,
                //   elevation: 0.0, // Remove shadow
                //   systemOverlayStyle: SystemUiOverlayStyle(
                //     statusBarColor: Colors.transparent,
                //     statusBarIconBrightness: Brightness.dark,
                //   ),
                // ),
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
                useMaterial3: true,
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    splashFactory: InkRipple.splashFactory,
                    overlayColor: MaterialStateProperty.all(Color(0x8bffffff)),
                  ),
                ),
              ),
              home: SignupScreen(),
            ),
          );
        });
  }
}
