import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; 

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DatabaseReference _paketRef =
      FirebaseDatabase.instance.ref().child('conveyor/paket');
  final DatabaseReference _paketSortRef =
      FirebaseDatabase.instance.ref().child('conveyor/paket_sort');

  int totalJalur = 0;
  int tersortirCount = 0;
  int prosesCount = 0;
  int gagalCount = 0;
  int jumlahPaket = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  void _fetchDashboardData() {
    // Mendengarkan perubahan pada node paket utk Total Jalur
    _paketRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      Set<String> jalurSet = {};
      if (data != null) {
        data.forEach((key, value) {
          final jalur = (value as Map<dynamic, dynamic>)['jalur'] as String?;
          if (jalur != null) {
            jalurSet.add(jalur);
          }
        });
      }
      setState(() {
        totalJalur = jalurSet.length;
      });
    });

    // Mendengarkan perubahan pada node paket_sort
    _paketSortRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      int sorted = 0;
      int proses = 0;
      int gagal = 0;
      int jumlah = 0;
      if (data != null) {
        data.forEach((key, value) {
          final status = (value as Map<dynamic, dynamic>)['status'] as String?;
          if (status != null) {
            if (status.toLowerCase() == 'tersortir') {
              sorted++;
            } else if (status.toLowerCase() == 'proses') {
              proses++;
            } else if (status.toLowerCase() == 'gagal') {
              gagal++;
            }
          }
        });
        jumlah = sorted + proses + gagal;
      }
      setState(() {
        tersortirCount = sorted;
        prosesCount = proses;
        gagalCount = gagal;
        jumlahPaket = jumlah;
      });
    });
  }

  String getCurrentDateTime() {
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(now);
    final formattedTime = DateFormat('HH:mm').format(now);
    return '$formattedDate, $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title di Tengah
              Center(
                child: Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        color: Colors.indigo,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      getCurrentDateTime(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.indigo[600],
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'PT PaketPro Auto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo[700],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Monitoring Section
              Text(
                'Monitoring',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[800],
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Data terakhir pada ${getCurrentDateTime()}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo[600],
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 20),
              // card monitoring
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildSummaryCard(
                    title: 'Total Jalur',
                    count: totalJalur,
                    icon: Icons.track_changes,
                    color: Colors.orange,
                  ),
                  _buildSummaryCard(
                    title: 'Tersortir',
                    count: tersortirCount,
                    icon: Icons.sort,
                    color: Colors.green,
                  ),
                  _buildSummaryCard(
                    title: 'Paket Proses',
                    count: prosesCount,
                    icon: Icons.settings,
                    color: Colors.blue,
                  ),
                  _buildSummaryCard(
                    title: 'Paket Gagal',
                    count: gagalCount,
                    icon: Icons.error,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildFullWidthCard(
                title: 'Jumlah Paket',
                count: jumlahPaket,
                icon: Icons.inventory,
                color: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk card
  Widget _buildSummaryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: color.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                color: color,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget khusus untuk card Jumlah Paket
  Widget _buildFullWidthCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: color.withOpacity(0.2),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 28,
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
