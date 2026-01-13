class ReservationModel {
  final int id;
  final String date;
  final String time;
  final String status;
  final String partySize;
  final String? notes;

  ReservationModel({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.partySize,
    this.notes,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      date: json['reservation_date'] ?? '',
      time: json['reservation_time'] ?? '',
      status: json['status'] ?? 'pending',
      partySize: json['party_size']?.toString() ?? '1',
      notes: json['special_request'],
    );
  }
}
