import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:kickmyflutter/screens/auth_screen/AuthStatePage.dart';
import 'package:kickmyflutter/screens/home_screen/HomePage.dart';
import 'package:provider/provider.dart';
import 'models/User.dart';

Future<String> isAuth() async {
  dynamic cookie = await SessionManager().get('auth-cookie');
  return  cookie != null && cookie.toString().isNotEmpty
      ? await SessionManager().get('username')
      : '';
}

main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Wrapper(),
    );
  }
}

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    //return either home or authenticate widget
    return FutureBuilder(
        future: isAuth(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasError) {
            return const Text("Whoops!");
          } else if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          return ChangeNotifierProvider<UserModel>.value(
              value: snapshot.data.toString().isNotEmpty
                  ? UserModel(User(snapshot.data!))
                  : UserModel(null),
              child: Consumer<UserModel>(
                builder: (context, userModel, child) {
                  if (userModel.user == null) {
                    return const AuthPage();
                  } else {
                    return const HomePage();
                  }
                },
              ));
        });
  }
}
