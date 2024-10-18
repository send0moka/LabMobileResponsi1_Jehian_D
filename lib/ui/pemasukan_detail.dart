import 'package:flutter/material.dart';
import 'package:keu_pemasukan/bloc/pemasukan_bloc.dart';
import 'package:keu_pemasukan/models/pemasukan.dart';
import 'package:keu_pemasukan/ui/pemasukan_form.dart';
import 'package:keu_pemasukan/ui/pemasukan_page.dart';
import 'package:keu_pemasukan/widget/success_dialog.dart';
import 'package:keu_pemasukan/widget/warning_dialog.dart';

// ignore: must_be_immutable
class PemasukanDetail extends StatefulWidget {
  Pemasukan? pemasukan;
  PemasukanDetail({Key? key, required this.pemasukan}) : super(key: key);
  @override
  _PemasukanDetailState createState() => _PemasukanDetailState();
}

class _PemasukanDetailState extends State<PemasukanDetail> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemasukan',
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDetailCard(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Source: ${widget.pemasukan!.source}",
              style: const TextStyle(fontSize: 20.0, fontFamily: 'Verdana'),
            ),
            const SizedBox(height: 10),
            Text(
              "Amount: Rp. ${widget.pemasukan!.amount.toString()}",
              style: const TextStyle(fontSize: 18.0, fontFamily: 'Verdana'),
            ),
            const SizedBox(height: 10),
            Text(
              "Frequency: ${widget.pemasukan!.frequency.toString()}",
              style: const TextStyle(fontSize: 18.0, fontFamily: 'Verdana'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text("EDIT", style: TextStyle(fontFamily: 'Verdana', color: Colors.white)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PemasukanForm(pemasukan: widget.pemasukan!),
              ),
            );
          },
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
          child: const Text("DELETE", style: TextStyle(fontFamily: 'Verdana', color: Colors.white)),
          onPressed: () => _confirmDelete(context),
        ),
      ],
    );
  }


  void _confirmDelete(BuildContext context) {
    if (widget.pemasukan?.id == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
          description: "ID pemasukan tidak ditemukan, tidak bisa menghapus.",
        ),
      );
      return;
    }

    AlertDialog alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () async {
            bool success = await PemasukanBloc.deletePemasukan(
              id: widget.pemasukan!.id!,
            );
            if (success) {
              showDialog(
                context: context,
                builder: (BuildContext context) => SuccessDialog(
                  description: "Pemasukan berhasil dihapus",
                  okClick: () {
                    Navigator.of(context).pushReplacement(
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
                builder: (BuildContext context) => const WarningDialog(
                  description: "Gagal menghapus pemasukan",
                ),
              );
            }
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
    showDialog(builder: (context) => alertDialog, context: context);
  }
}
