import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skadoodlem/ExtraLogin/auth.dart';
import 'package:skadoodlem/Pages/LoginIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skadoodlem/Pages/components/LoginAuth.dart';
import 'package:skadoodlem/Pages/components/SignUpAuth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(lesgo());
}
class lesgo extends StatelessWidget {
  const lesgo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context)=>SignupAuthProvider()
        ),
        ChangeNotifierProvider(
            create: (context) => LoginAuthProvider()
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner:false,
        home:AuthPage(),
      ),
    );
  }
}




