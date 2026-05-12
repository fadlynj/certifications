/// All user-facing strings centralised to avoid magic literals.
class AppStrings {
  AppStrings._();

  // ── App ───────────────────────────────────────────────────────────────────
  static const String appName = 'Todos';
  static const String appTagline = 'Tetap teratur, tetap produktif.';

  // ── Auth ──────────────────────────────────────────────────────────────────
  static const String login = 'Masuk';
  static const String logout = 'Keluar';
  static const String username = 'Nama Pengguna';
  static const String password = 'Kata Sandi';
  static const String newPassword = 'Kata Sandi Baru';
  static const String confirmPassword = 'Konfirmasi Kata Sandi';
  static const String resetPassword = 'Ubah Kata Sandi';
  static const String loginButton = 'Masuk';
  static const String logoutConfirmTitle = 'Keluar';
  static const String logoutConfirmMessage = 'Apakah Anda yakin ingin keluar?';

  // ── Auth errors ───────────────────────────────────────────────────────────
  static const String invalidCredentials =
      'Nama pengguna atau kata sandi salah.';
  static const String accountLocked =
      'Terlalu banyak percobaan gagal. Coba lagi dalam 15 menit.';
  static const String sessionExpired =
      'Sesi Anda telah berakhir. Silakan masuk kembali.';
  static const String usernameEmpty = 'Nama pengguna tidak boleh kosong.';
  static const String usernameTooShort = 'Nama pengguna minimal 3 karakter.';
  static const String usernameTooLong = 'Nama pengguna maksimal 50 karakter.';
  static const String passwordEmpty = 'Kata sandi tidak boleh kosong.';
  static const String passwordTooShort = 'Kata sandi minimal 6 karakter.';
  static const String passwordMismatch = 'Kata sandi tidak cocok.';
  static const String passwordResetSuccess = 'Kata sandi berhasil diperbarui.';

  // ── Todo ──────────────────────────────────────────────────────────────────
  static const String todos = 'Tugas';
  static const String addTodo = 'Tambah Tugas';
  static const String addImportantTodo = 'Tambah Tugas Penting';
  static const String todoList = 'Daftar Tugas';
  static const String titleHint = 'Apa yang perlu dilakukan?';
  static const String descriptionHint = 'Tambahkan deskripsi (opsional)';
  static const String deadline = 'Tenggat Waktu';
  static const String markImportant = 'Tandai Penting';
  static const String markDone = 'Tandai Selesai';
  static const String markPending = 'Tandai Belum Selesai';
  static const String deleteTodo = 'Hapus Tugas';
  static const String titleRequired = 'Judul wajib diisi.';
  static const String titleTooLong = 'Judul maksimal 100 karakter.';
  static const String descTooLong = 'Deskripsi maksimal 500 karakter.';
  static const String todoCreated = 'Tugas berhasil ditambahkan.';
  static const String todoUpdated = 'Tugas berhasil diperbarui.';
  static const String todoDeleted = 'Tugas dihapus.';
  static const String deleteConfirmTitle = 'Hapus Tugas';
  static const String deleteConfirmMessage =
      'Tugas ini akan dihapus secara permanen. Lanjutkan?';
  static const String emptyTodoList = 'Belum ada tugas di sini.';
  static const String emptyFilterResult =
      'Tidak ada tugas yang cocok dengan filter.';

  // ── Home ──────────────────────────────────────────────────────────────────
  static const String home = 'Beranda';
  static const String totalTodos = 'Total';
  static const String doneTodos = 'Selesai';
  static const String pendingTodos = 'Belum';
  static const String weeklyProgress = 'Progres Mingguan';

  // ── Settings ──────────────────────────────────────────────────────────────
  static const String settings = 'Pengaturan';
  static const String appVersion = 'Versi Aplikasi';
  static const String developerInfo = 'Pengembang';
  static const String developerName = 'Fadly Nugraha Jati';
  static const String developerEmail = 'fadlynugrahaj@gmail.com';
  static const String developerNik = '2241720149';
  static const String clearData = 'Hapus Semua Data';
  static const String clearDataConfirmTitle = 'Hapus Semua Data';
  static const String clearDataConfirmMessage =
      'Semua tugas dan akun Anda akan dihapus secara permanen. Tindakan ini tidak dapat dibatalkan.';
  static const String dataCleared = 'Semua data telah dihapus.';

  // ── Common ────────────────────────────────────────────────────────────────
  static const String confirm = 'Konfirmasi';
  static const String cancel = 'Batal';
  static const String save = 'Simpan';
  static const String delete = 'Hapus';
  static const String retry = 'Coba Lagi';
  static const String ok = 'OK';
  static const String unknownError = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String databaseError = 'Terjadi kesalahan database.';

  // ── Filters / Sort ────────────────────────────────────────────────────────
  static const String filterAll = 'Semua';
  static const String filterDone = 'Selesai';
  static const String filterPending = 'Belum';
  static const String filterImportant = 'Penting';
  static const String sortDeadline = 'Tenggat';
  static const String sortCreated = 'Dibuat';
  static const String sortImportance = 'Prioritas';
  static const String searchHint = 'Cari tugas…';
}
