import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:goedit/blocs/main.dart';
import 'package:goedit/ui/home_screen.dart';
import 'package:goedit/ui/login_screen.dart';
import 'package:goedit/utils/global_navigation.dart';
import 'package:minimal_onboarding/minimal_onboarding.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<OnboardingPageModel> _onboardingPages = [
    OnboardingPageModel('assets/images/onboarding1.png', 'Welcome to Go-Edit',
        'A portal of freelance opportunities! Become a part of graphics designing marketplace and explore both as a freelancer or employer.'),
    OnboardingPageModel(
        'assets/images/onboarding2.png',
        'Find a reliable freelancer now',
        'Get work done from professionals willing to work remotely in a house to variety of skilled persons and caters to business of all-sizes.'),
    OnboardingPageModel('assets/images/onboarding3.png', 'Become a freelancer',
        'Your search of great freelance opportunities is over. Go-Edit takes freelancers to the hub of opportunities in no time.'),
  ];

  @override
  void initState() {
    mainBloc.init(_key);
    mainBloc.getInitialScreen();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
    mainBloc.dispose();
  }

  Widget _initialScreen() {
    return StreamBuilder(
      stream: mainBloc.auth,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // now check which screen to initialize
          switch (snapshot.data) {
            case 'ONBOARDING':
              return MinimalOnboarding(
                onboardingPages: _onboardingPages,
                onFinishButtonPressed: () => mainBloc.changeAuthState('LOGIN'),
                onSkipButtonPressed: () => mainBloc.changeAuthState('LOGIN'),
                color: Theme.of(context).primaryColor,
                dotsDecoration: DotsDecorator(
                  activeColor: Theme.of(context).primaryColor,
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              );
              break;
            case 'LOGIN':
              return LoginScreen();
              break;
            case 'HOME':
              return HomeScreen();
              break;
            default:
              return Container(
                child: Text(snapshot.data),
              );
          }
        }
        return Container(
            child: Center(
                child: SpinKitFadingCube(
          color: Theme.of(context).primaryColor,
        )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Edit',
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalNavigation.key,
      theme: ThemeData(
        // primaryColor: Color(0xFF333738),
        primaryColor: Colors.purple,
      ),
      home: Scaffold(
        key: _key,
        body: _initialScreen(),
      ),
    );
  }
}
