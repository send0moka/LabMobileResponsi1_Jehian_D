import 'package:flutter/material.dart';
import 'package:keu_pemasukan/bloc/pemasukan_bloc.dart';
import 'package:keu_pemasukan/models/pemasukan.dart';
import 'package:keu_pemasukan/ui/pemasukan_page.dart';
import 'package:keu_pemasukan/widget/success_dialog.dart';
import 'package:keu_pemasukan/widget/warning_dialog.dart';

class PemasukanForm extends StatefulWidget {
  final Pemasukan? pemasukan;
  const PemasukanForm({Key? key, this.pemasukan}) : super(key: key);

  @override
  _PemasukanFormState createState() => _PemasukanFormState();
}

class _PemasukanFormState extends State<PemasukanForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _judul = "TAMBAH PEMASUKAN";
  String _tombolSubmit = "SIMPAN";

  final _sourceTextboxController = TextEditingController();
  final _amountTextboxController = TextEditingController();
  final _frequencyTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isUpdate();
  }

  _isUpdate() {
    if (widget.pemasukan != null) {
      setState(() {
        _judul = "UBAH PEMASUKAN";
        _tombolSubmit = "UBAH";
        _sourceTextboxController.text = widget.pemasukan!.source!;
        _amountTextboxController.text = widget.pemasukan!.amount.toString();
        _frequencyTextboxController.text = widget.pemasukan!.frequency.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_judul, style: const TextStyle(fontFamily: 'Verdana', color: Colors.white)),
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
                  _buildTextField(_sourceTextboxController, "Source"),
                  _buildTextField(_amountTextboxController, "Amount", TextInputType.number),
                  _buildTextField(_frequencyTextboxController, "Frequency", TextInputType.number),
                  const SizedBox(height: 20),
                  _buttonSubmit()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, [TextInputType? keyboardType]) {
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
        keyboardType: keyboardType ?? TextInputType.text,
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "$label harus diisi";
          }
          return null;
        },
      ),
    );
  }

  Widget _buttonSubmit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      ),
      child: Text(
        _tombolSubmit,
        style: const TextStyle(fontSize: 18, fontFamily: 'Verdana', color: Colors.white),
      ),
      onPressed: () {
        var validate = _formKey.currentState!.validate();
        if (validate) {
          if (!_isLoading) {
            if (widget.pemasukan != null) {
              _ubah();
            } else {
              _simpan();
            }
          }
        }
      },
    );
  }

  _simpan() async {
    if (!validateInput()) return;  
    setState(() {
      _isLoading = true;
    });
    Pemasukan createPemasukan = Pemasukan(
      source: _sourceTextboxController.text,
      amount: int.parse(_amountTextboxController.text),
      frequency: int.parse(_frequencyTextboxController.text),
    );
    try {
      var result = await PemasukanBloc.addPemasukan(pemasukan: createPemasukan);
      if (result['success']) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SuccessDialog(
            description: "Pemasukan berhasil ditambahkan",
            okClick: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) => const PemasukanPage(),
                ),
                (route) => false,
              );
            },
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => WarningDialog(
            description: result['message'],
          ),
        );
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Simpan gagal, silahkan coba lagi",
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _ubah() async {
    if (!validateInput()) return;  
    setState(() {
      _isLoading = true;
    });
    Pemasukan updatePemasukan = Pemasukan(
      id: widget.pemasukan!.id,
      source: _sourceTextboxController.text,
      amount: int.parse(_amountTextboxController.text),
      frequency: int.parse(_frequencyTextboxController.text),
    );
    PemasukanBloc.updatePemasukan(pemasukan: updatePemasukan).then((value) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(
          description: "Pemasukan berhasil diubah",
          okClick: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => const PemasukanPage(),
              ),
              (route) => false,
            );
          },
        ),
      );
    }, onError: (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "Permintaan ubah data gagal, silahkan coba lagi",
        ),
      );
    });
    setState(() {
      _isLoading = false;
    });
  }

  bool validateInput() {  
    int amount = int.tryParse(_amountTextboxController.text) ?? -1;
    int? frequency = int.tryParse(_frequencyTextboxController.text);

    if (amount < 0) {  
      _showWarning("Amount harus bernilai positif");  
      return false;  
    } else if (frequency == null) {  
      _showWarning("Frequency harus berupa angka bulat");  
      return false;  
    }  
    return true;
  }  

  void _showWarning(String message) {  
    showDialog(  
      context: context,  
      builder: (context) => WarningDialog(  
        description: message,  
      ),  
    );  
  }  
}