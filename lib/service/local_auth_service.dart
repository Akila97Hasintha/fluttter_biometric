import 'package:local_auth/local_auth.dart';

class LocalAuth {
  static LocalAuthentication auth = LocalAuthentication();

  static Future<bool> canAuthenticate() async =>
      await auth.canCheckBiometrics || await auth.isDeviceSupported();

  static Future<bool> authenticate() async {
    try {
      if (!await canAuthenticate()) return false;

      return await auth.authenticate(
        localizedReason: 'Use face ID to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print("Error during authentication: $e");
      return false;
    }
  }
}