import 'dart:io';

import 'package:authentication_biometric/service/firestore_service.dart';
import 'package:authentication_biometric/widget/custom_textfeild.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import '../service/local_auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LocalAuth auth = LocalAuth();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String deviceId =" " ;
  late String? savedDeviceId = "UE1A.230829.036.A";

  Future<void> _signInWithEmailAndPassword() async {
    try {
      bool isDeveloperMode = await FlutterJailbreakDetection.developerMode;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Developer Mode '),
          ),
        );
    
      
      if (savedDeviceId != null && savedDeviceId =="UE1A.230829.036.A" && !isDeveloperMode) {

          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );
        print('User signed in successfully!');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication successful!'),
          ),
        );
      } else {
        
        print('Error: Device ID does not match!');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Device ID does not match. Login failed.'),
          ),
        );
        
      }
    } catch (e) {
      
      print('Error signing in: $e');
    }
  }

  Future<String?> _getDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor; // Unique on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.id; // Unique ID on Android
  }
 
  return null; 
}

  Future<void> getDeviceIdByEmail() async {
    savedDeviceId = await firestoreService.getDeviceIdByEmail(_emailController.text);
    print("dev id =================== $deviceId");
  }

  @override
  void initState() {
    
    super.initState();
      _getDeviceId().then((id) {
      setState(() {
        deviceId = id ?? 'Unknown';
      });
    });
     //getDeviceIdByEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biometric Authentication'),
      ),
      body: Center(
        child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("device ID = $deviceId"),
              
              CustomTextField(hintText: "Email", controller: _emailController),
              const SizedBox(height: 16.0),
              CustomTextField(hintText: "Password", controller: _passwordController,obscureText: true,),
              const SizedBox(height: 24.0),
                 ElevatedButton(

              onPressed: () async {
                FocusScope.of(context).unfocus();
                bool isAuthenticated = await LocalAuth.authenticate();
               // getDeviceIdByEmail();

            
                if (isAuthenticated ) {
                  
                  _signInWithEmailAndPassword();
                  
                 // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Authentication successful!'),
                    ),
                  );
                } else {
             
                  
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Authentication failed.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, 
                padding: const EdgeInsets.all(16.0), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), 
                ),
              ),
              child: const Text('Login'),
            ),
            ],
          ),
        ),
      ),
        
      ),
    );
  }
}