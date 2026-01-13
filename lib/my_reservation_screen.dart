import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'services/reservation_service.dart';
import 'models/reservation_model.dart';

class MyReservationScreen extends StatefulWidget {
  final int initialIndex;

  const MyReservationScreen({super.key, this.initialIndex = 0});

  @override
  State<MyReservationScreen> createState() => _MyReservationScreenState();
}

class _MyReservationScreenState extends State<MyReservationScreen> {
  final ReservationService _reservationService = ReservationService();
  List<ReservationModel> _allReservations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  Future<void> _fetchReservations() async {
    final reservations = await _reservationService.getUserReservations();
    if (mounted) {
      setState(() {
        _allReservations = reservations;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter logic
    final activeReservations = _allReservations.where((r) => 
      r.status.toLowerCase() != 'completed' && r.status.toLowerCase() != 'cancelled'
    ).toList();
    
    final historyReservations = _allReservations.where((r) => 
      r.status.toLowerCase() == 'completed' || r.status.toLowerCase() == 'cancelled'
    ).toList();

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            'Reservasi Saya', 
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          automaticallyImplyLeading: false, 
          backgroundColor: AppColors.primary,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Berlangsung'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),
        body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
          children: [
            _ReservationList(reservations: activeReservations, isHistory: false),
            _ReservationList(reservations: historyReservations, isHistory: true),
          ],
        ),
      ),
    );
  }
}

class _ReservationList extends StatelessWidget {
  final List<ReservationModel> reservations;
  final bool isHistory;

  const _ReservationList({
    required this.reservations,
    required this.isHistory,
  });

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return Center(
        child: Text(
          isHistory ? 'Belum ada riwayat reservasi.' : 'Tidak ada reservasi aktif.',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final reservation = reservations[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Meja No. ${reservation.id}', // Using ID as table number placeholder
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isHistory ? Colors.grey[200] : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        reservation.status.toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: isHistory ? Colors.grey : AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 8),
                _buildRowInfo(Icons.calendar_today, reservation.date),
                const SizedBox(height: 4),
                _buildRowInfo(Icons.access_time, reservation.time),
                const SizedBox(height: 4),
                _buildRowInfo(Icons.people, '${reservation.partySize} Orang'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRowInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.poppins(color: Colors.grey[800])),
      ],
    );
  }
}