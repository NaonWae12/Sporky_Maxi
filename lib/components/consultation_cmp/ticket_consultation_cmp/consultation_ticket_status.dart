enum ConsultationTicketStatus { notYet, schedule, finish }

extension ConsultationTicketStatusLabel on ConsultationTicketStatus {
  String get title {
    switch (this) {
      case ConsultationTicketStatus.notYet:
        return 'Belum';
      case ConsultationTicketStatus.schedule:
        return 'Jadwal';
      case ConsultationTicketStatus.finish:
        return 'Selesai';
    }
  }

  String get emptyMessage {
    switch (this) {
      case ConsultationTicketStatus.notYet:
        return 'Belum ada pembelian konsultasi yang menunggu pembayaran.';
      case ConsultationTicketStatus.schedule:
        return 'Belum ada jadwal konsultasi aktif.';
      case ConsultationTicketStatus.finish:
        return 'Belum ada konsultasi yang selesai.';
    }
  }
}
