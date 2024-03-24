import 'package:authentication_biometric/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   FirebaseOptions firebaseOptions = const FirebaseOptions(
          apiKey: 'AIzaSyCvkLaJgFAepJxGV81-TKLp-LP6DqT9nAw',
          
          projectId: 'gallery-6e2a9',
          
          messagingSenderId: '593829200713',
          appId: '1:593829200713:android:2dc2f04a8be97ef66fd098',
        );
            
        await Firebase.initializeApp(options:firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    checkDeveloperMode();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }

  Future<void> checkDeveloperMode() async {
  bool developerMode = await FlutterJailbreakDetection.developerMode;
  if (developerMode) {
    // Show a dialog or message to the user
    print('Developer mode is enabled. Please disable it for security reasons.');
  } else {
    // Continue with normal app flow
    print('Developer mode is not enabled.');
  }
}
}

