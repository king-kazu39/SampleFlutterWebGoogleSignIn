import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample_flutter_web_google_signin/firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SingInDemo(),
    );
  }
}

class SingInDemo extends StatefulWidget {
  const SingInDemo({super.key});

  @override
  State<SingInDemo> createState() => _SingInDemoState();
}

class _SingInDemoState extends State<SingInDemo> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'email',
  ]);
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleGoogleSignOut() async => await _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Google Signin Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentUser != null)
              ListTile(
                leading: GoogleUserCircleAvatar(identity: _currentUser!),
                title: Text(_currentUser?.displayName ?? ''),
                subtitle: Text(_currentUser?.email ?? ''),
              ),
            ElevatedButton(
              onPressed: _handleGoogleSignIn,
              child: const Text('Google SignIn'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleGoogleSignOut,
              child: const Text('Google SignOut'),
            ),
          ],
        ),
      ),
    );
  }
}
