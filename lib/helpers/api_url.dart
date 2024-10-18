class ApiUrl {
  static const String baseUrl = 'http://103.196.155.42/api';
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  static const String listPemasukan = baseUrl + '/keuangan/pemasukan';
  static const String createPemasukan = baseUrl + '/keuangan/pemasukan';
  
  static String updatePemasukan(int id) => baseUrl + '/keuangan/pemasukan/' + id.toString() + '/update';
  static String showPemasukan(int id) => baseUrl + '/keuangan/pemasukan/' + id.toString();
  static String deletePemasukan(int id) => baseUrl + '/keuangan/pemasukan/' + id.toString() + '/delete';
}