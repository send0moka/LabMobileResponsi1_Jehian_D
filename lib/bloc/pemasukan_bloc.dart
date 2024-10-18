import 'dart:convert';
import 'package:keu_pemasukan/helpers/api.dart';
import 'package:keu_pemasukan/helpers/api_url.dart';
import 'package:keu_pemasukan/models/pemasukan.dart';

class PemasukanBloc {
  static Future<List<Pemasukan>> getPemasukans() async {
    String apiUrl = ApiUrl.listPemasukan;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPemasukan = (jsonObj as Map<String, dynamic>)['data'];
    List<Pemasukan> pemasukans = [];
    for (int i = 0; i < listPemasukan.length; i++) {
      pemasukans.add(Pemasukan.fromJson(listPemasukan[i]));
    }
    return pemasukans;
  }

  static Future<Map<String, dynamic>> addPemasukan({Pemasukan? pemasukan}) async {
    String apiUrl = ApiUrl.createPemasukan;
    var body = {
      "source": pemasukan!.source,
      "amount": pemasukan.amount.toString(),
      "frequency": pemasukan.frequency.toString()
    };
    try {
      var response = await Api().post(apiUrl, body);
      var jsonObj = json.decode(response.body);
      return {
        'success': jsonObj['status'],
        'message': jsonObj['message'] ?? 'Pemasukan sudah ada',
        'data': jsonObj['data']
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  static Future updatePemasukan({required Pemasukan pemasukan}) async {
    String apiUrl = ApiUrl.updatePemasukan(pemasukan.id!);
    print(apiUrl);
    var body = {
      "source": pemasukan.source,
      "amount": pemasukan.amount.toString(),
      "frequency": pemasukan.frequency.toString()
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deletePemasukan({int? id}) async {
    String apiUrl = ApiUrl.deletePemasukan(id!);
    var response = await Api().delete(apiUrl);
    if (response != null && response.body.isNotEmpty) {
      var jsonObj = json.decode(response.body);
      return jsonObj['status'] == true;
    } else {
      return false;
    }
  }
}