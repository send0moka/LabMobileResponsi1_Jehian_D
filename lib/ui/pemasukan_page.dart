import 'package:flutter/material.dart';
import 'package:keu_pemasukan/bloc/logout_bloc.dart';
import 'package:keu_pemasukan/bloc/pemasukan_bloc.dart';
import 'package:keu_pemasukan/models/pemasukan.dart';
import 'package:keu_pemasukan/ui/login_page.dart';
import 'package:keu_pemasukan/ui/pemasukan_detail.dart';
import 'package:keu_pemasukan/ui/pemasukan_form.dart';

class PemasukanPage extends StatefulWidget {
  const PemasukanPage({Key? key}) : super(key: key);
  @override
  _PemasukanPageState createState() => _PemasukanPageState();
}

class _PemasukanPageState extends State<PemasukanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Pemasukan', style: TextStyle(fontFamily: 'Verdana', color: Colors.white)),
        backgroundColor: Colors.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const PemasukanForm()));
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.purple[300]!,
                Colors.blue[300]!,
                Colors.green[300]!,
                Colors.yellow[300]!,
                Colors.orange[300]!,
                Colors.red[300]!,
              ],
            ),
          ),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.7),
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Verdana'),
                ),
              ),
              ListTile(
                title: const Text('Logout', style: TextStyle(color: Colors.white, fontFamily: 'Verdana')),
                trailing: const Icon(Icons.logout, color: Colors.white),
                onTap: () async {
                  await LogoutBloc.logout().then((value) => {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false
                    )
                  });
                },
              )
            ],
          ),
        ),
      ),
      body: Container(
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
        child: FutureBuilder<List<Pemasukan>>(
          future: PemasukanBloc.getPemasukans(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Tidak ada data pemasukan.'));
            } else {
              return ListPemasukan(list: snapshot.data);
            }
          },
        ),
      ),
    );
  }
}

class ListPemasukan extends StatelessWidget {
  final List<Pemasukan>? list;
  const ListPemasukan({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list?.length ?? 0,
      itemBuilder: (context, i) {
        return ItemPemasukan(pemasukan: list![i]);
      },
    );
  }
}

class ItemPemasukan extends StatelessWidget {
  final Pemasukan pemasukan;
  const ItemPemasukan({Key? key, required this.pemasukan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          leading: Container(
            padding: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(width: 1, color: Colors.purple)),
            ),
            child: const Icon(Icons.monetization_on, color: Colors.purple),
          ),
          title: Text(
            pemasukan.source ?? 'Unknown Source',
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Verdana'),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rp ${pemasukan.amount.toString()}', style: const TextStyle(fontFamily: 'Verdana')),
              Text('Frequency: ${pemasukan.frequency}', style: const TextStyle(fontFamily: 'Verdana')),
            ],
          ),
          trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.purple, size: 30.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PemasukanDetail(pemasukan: pemasukan),
              ),
            );
          },
        ),
      ),
    );
  }
}