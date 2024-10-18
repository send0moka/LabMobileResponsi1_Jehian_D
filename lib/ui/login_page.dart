import 'package:flutter/material.dart';
import 'package:keu_pemasukan/bloc/login_bloc.dart';
import 'package:keu_pemasukan/helpers/user_info.dart';
import 'package:keu_pemasukan/ui/pemasukan_page.dart';
import 'package:keu_pemasukan/ui/registrasi_page.dart';
import 'package:keu_pemasukan/widget/success_dialog.dart';
import 'package:keu_pemasukan/widget/warning_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login',
            style: TextStyle(fontFamily: 'Verdana', color: Colors.white)),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red[300]!,
              Colors.orange[300]!,
              Colors.yellow[300]!,
              Colors.green[300]!,
              Colors.blue[300]!,
              Colors.purple[300]!,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _gifPlaceholder(),
                  const SizedBox(height: 20),
                  _emailTextField(),
                  _passwordTextField(),
                  const SizedBox(height: 20),
                  _buttonLogin(),
                  const SizedBox(height: 30),
                  _menuRegistrasi()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gifPlaceholder() {
    return Image.asset(
      'gif/cat.gif',
      width: 200,
      height: 200,
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email",
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(fontFamily: 'Verdana'),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        return null;
      },
    );
  }

  Widget _passwordTextField() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: "Password",
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(fontFamily: 'Verdana'),
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: _passwordTextboxController,
        validator: (value) {
          if (value!.isEmpty) {
            return "Password harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonLogin() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: const Text(
        "Login",
        style:
            TextStyle(fontSize: 18, fontFamily: 'Verdana', color: Colors.white),
      ),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) _submit();
        }
      },
    );
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
            email: _emailTextboxController.text,
            password: _passwordTextboxController.text)
        .then((value) async {
      if (value.code == 200) {
        await UserInfo().setToken(value.token ?? "");
        await UserInfo().setUserID(int.tryParse(value.userID.toString()) ?? 0);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Login berhasil",
            okClick: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PemasukanPage(),
                ),
              );
            },
          ),
        );
      } else {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => const WarningDialog(
                  description: "Login gagal, silahkan coba lagi",
                ));
      }
    }, onError: (error) {
      print(error);
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const WarningDialog(
                description: "Login gagal, silahkan coba lagi",
              ));
    });

    setState(() {
      _isLoading = false;
    });
  }

  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text(
          "Registrasi",
          style: TextStyle(color: Colors.blue),
        ),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const RegistrasiPage()));
        },
      ),
    );
  }
}
