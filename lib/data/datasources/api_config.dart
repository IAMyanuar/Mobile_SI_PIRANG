class ApiConfig {
  // Ganti nilai 'YOUR_API_ENDPOINT' dengan endpoint API yang sesuai
  static const String apiEndpoint = 'http://192.168.1.16:8000/api';

  //register
  static String getRegisterUrl() {
    return '$apiEndpoint/registerUser';
  }

  //login
  static String getLoginUrl() {
    return '$apiEndpoint/login';
  }

  //get all data ruangan
  static String getAllRuanganUrl() {
    return '$apiEndpoint/ruangan';
  }

  //kalender
  static String getKalenderUrl() {
    return '$apiEndpoint/kalender';
  }

  //riwayat
  static String getRiwayatUrl(int id) {
    return '$apiEndpoint/peminjaman/riwayat/$id';
  }
  
  //detail peminjaman
  static String getPeminjamanBYIdUrl(int id) {
    return '$apiEndpoint/peminjaman/$id';
  }
}
