import 'package:flutter/material.dart';
import 'package:keu_pemasukan/helpers/user_info.dart';
import 'package:keu_pemasukan/ui/login_page.dart';
import 'package:keu_pemasukan/ui/pemasukan_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    var token = await UserInfo().getToken();
    if (token != null) {
      setState(() {
        page = const PemasukanPage();
      });
    } else {
      setState(() {
        page = const LoginPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keuangan Pemasukan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF9C27B0, {
          50: Colors.purple[50]!,
          100: Colors.purple[100]!,
          200: Colors.purple[200]!,
          300: Colors.purple[300]!,
          400: Colors.purple[400]!,
          500: Colors.purple[500]!,
          600: Colors.purple[600]!,
          700: Colors.purple[700]!,
          800: Colors.purple[800]!,
          900: Colors.purple[900]!,
        }),
        fontFamily: 'Verdana',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.purple,
          secondary: Colors.orange,
          surface: Colors.yellow[100],
        ),
      ),
      home: page,
    );
  }
}