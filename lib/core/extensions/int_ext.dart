extension IntExt on int {
  /// Mengubah angka ke format currency lokal (Rp)
  String toCurrency() {
    return 'Rp ${toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    )}';
  }
}
