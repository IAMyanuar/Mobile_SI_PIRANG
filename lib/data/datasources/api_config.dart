class ApiConfig {
  // Ganti nilai 'YOUR_API_ENDPOINT' dengan endpoint API yang sesuai
  static const String apiEndpoint = 'http://192.168.1.103:8000/api';

  //register
  static String postRegisterUrl() {
    return '$apiEndpoint/registerUser';
  }

  //login
  static String postLoginUrl() {
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

  //List pengajuan
  static String getListPengajuanUrl(int id) {
    return '$apiEndpoint/peminjamanbyuser/$id';
  }

  //riwayat
  static String getRiwayatUrl(int id) {
    return '$apiEndpoint/peminjaman/riwayat/$id';
  }

  //detail peminjaman
  static String getPeminjamanBYIdUrl(int id) {
    return '$apiEndpoint/peminjaman/$id';
  }

  //form Pengajuan
  static String postPeminjamanUrl() {
    return '$apiEndpoint/peminjaman';
  }

  //hapus peminjaman
  static String deletePeminjamanUrl(int id) {
    return '$apiEndpoint/peminjaman/$id';
  }

  //hapus peminjaman
  static String patchFeedbackUrl(int id) {
    return '$apiEndpoint/peminjaman/$id/feedback';
  }
}
