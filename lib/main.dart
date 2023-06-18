import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wid_learn/ExtraLogin/auth.dart';
import 'package:wid_learn/Pages/LoginIn.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wid_learn/Pages/components/LoginAuth.dart';
import 'package:wid_learn/Pages/components/SignUpAuth.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const lesgo());
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
          )

    );
  }
}




