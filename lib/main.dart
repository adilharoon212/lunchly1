import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lunchly1/screens/donate.dart';
import 'package:lunchly1/screens/home_screen.dart';
import 'package:lunchly1/screens/login_screen.dart';
import 'package:lunchly1/screens/placeorder_screen.dart';
import 'package:lunchly1/screens/select_screen.dart';
import 'package:lunchly1/screens/vote_screen.dart';
import 'package:lunchly1/utils/routes.dart';
import 'package:lunchly1/screens/register_screen.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAVCo5H7FIA962BTKRKRdur5Oqg4VMGUoc",
      appId: "1:442043651336:android:1667c82ef2f21f761008bd",
      messagingSenderId: "442043651336",
      projectId: "lunchly1-abd2f",
      storageBucket: "lunchly1-abd2f.appspot.com",
    ),
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.light,
      ),
      routes: {
        "/": (context) => SelectScreen(),
        MyRoutes.selectRoute: (context) => SelectScreen(),
        MyRoutes.loginRoute: (context) => LoginScreen(),
        MyRoutes.registerRoute: (context) => RegisterScreen(),
        MyRoutes.homeRoute: (context) => HomeScreen(),
        MyRoutes.voteRoute: (context) {
          DateTime votingEndTime = DateTime.now().add(Duration(hours: 25));
          return VoteScreen(votingEndTime: votingEndTime);
        },
        MyRoutes.donateRoute: (context) => DonateScreen(),
        MyRoutes.placeorderRoute: (context) {
          //DateTime votingEndTime = DateTime.now().add(Duration(hours: 25));
          return PlaceOrderScreen(
            topVotedItems: [],
          ); // Remove the unnecessary parameter
        },
      },
    );
  }
}
