import 'package:flutter/material.dart';
import 'package:keu_pemasukan/bloc/registrasi_bloc.dart';
import 'package:keu_pemasukan/widget/success_dialog.dart';
import 'package:keu_pemasukan/widget/warning_dialog.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);
  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  final String registeredEmail = "test@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi", style: TextStyle(fontFamily: 'Verdana', color: Colors.white)),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTextField(_namaTextboxController, "Nama", TextInputType.text),
                  _buildTextField(_emailTextboxController, "Email", TextInputType.emailAddress),
                  _buildTextField(_passwordTextboxController, "Password", TextInputType.text, true),
                  _buildTextField(null, "Konfirmasi Password", TextInputType.text, true),
                  const SizedBox(height: 20),
                  _buttonRegistrasi()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController? controller, String label, TextInputType keyboardType, [bool isPassword = false]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(fontFamily: 'Verdana'),
        keyboardType: keyboardType,
        obscureText: isPassword,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "$label harus diisi";
          }
          if (label == "Nama" && value.length < 3) {
            return "Nama harus diisi minimal 3 karakter";
          }
          if (label == "Email") {
            Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
            RegExp regex = RegExp(pattern.toString());
            if (!regex.hasMatch(value)) {
              return "Email tidak valid";
            }
          }
          if (label == "Password" && value.length < 6) {
            return "Password harus diisi minimal 6 karakter";
          }
          if (label == "Konfirmasi Password" && value != _passwordTextboxController.text) {
            return "Konfirmasi Password tidak sama";
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonRegistrasi() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: const Text(
        "Registrasi",
        style: TextStyle(fontSize: 18, fontFamily: 'Verdana', color: Colors.white),
      ),
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (!_isLoading) _checkEmailAndSubmit();  
        }
      },
    );
  }

  void _checkEmailAndSubmit() {
    if (_emailTextboxController.text == registeredEmail) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Email sudah terdaftar",
        ),
      );
    } else {
      _submit();
    }
  }

  void _submit() {
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    RegistrasiBloc.registrasi(
      nama: _namaTextboxController.text,
      email: _emailTextboxController.text,
      password: _passwordTextboxController.text,
    ).then((value) {
      if (value['status']) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Registrasi berhasil, silahkan login",
            okClick: () {
              Navigator.pop(context);
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => WarningDialog(
            description: value['message'],
          ),
        );
      }
    }).catchError((error) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const WarningDialog(
          description: "Registrasi gagal, silahkan coba lagi",
        ),
      );
    }).whenComplete(() {
      setState(() {
        _isLoading = false;
      });
    });
  }
}