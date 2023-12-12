import 'package:flutter/material.dart';
import 'package:lunchly1/providers/theme_provider.dart';
import 'package:lunchly1/utils/routes.dart';
import 'package:provider/provider.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return ChangeNotifierProvider.value(
      value: themeProvider,
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeProvider.isDarkMode
                        ? Color.fromARGB(255, 33, 33, 33)
                        : Color.fromARGB(255, 255, 255, 255),
                    themeProvider.isDarkMode
                        ? Color.fromARGB(255, 16, 16, 16)
                        : Color.fromARGB(255, 243, 223, 223),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 0.1 * constraints.maxHeight),
                          Image.asset(
                            "assets/images/LoginImg.png", // Update the image path
                            fit: BoxFit.contain,
                            height: 0.27 * constraints.maxHeight,
                            width: double.infinity,
                            alignment: Alignment.center,
                          ),
                          SizedBox(height: 0.1 * constraints.maxHeight),
                          Text(
                            "Welcome to Lunchly",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 0.03 * constraints.maxHeight),
                          Text(
                            "Delicious lunches, just a tap away!",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 0.05 * constraints.maxHeight),
                          Container(
                            width: 0.79 * constraints.maxWidth,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              gradient: LinearGradient(
                                colors: [
                                  themeProvider.isDarkMode
                                      ? Colors.deepOrange
                                      : Colors.orange,
                                  themeProvider.isDarkMode
                                      ? Colors.red
                                      : Colors.red,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, MyRoutes.loginRoute);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(
                                    0.01 * constraints.maxHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                elevation: 0,
                                backgroundColor: Colors.transparent,
                              ),
                              child: Text(
                                "Get Started",
                                style: TextStyle(
                                  fontSize: 0.025 * constraints.maxHeight,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
