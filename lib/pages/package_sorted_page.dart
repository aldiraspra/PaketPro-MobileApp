import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/package.dart';
import 'package:intl/intl.dart';

class PackageSortedPage extends StatefulWidget {
  const PackageSortedPage({Key? key}) : super(key: key);

  @override
  _PackageSortedPageState createState() => _PackageSortedPageState();
}

class _PackageSortedPageState extends State<PackageSortedPage> {
  final DatabaseReference _paketSortRef =
      FirebaseDatabase.instance.ref().child('conveyor/paket_sort');

  String _searchQuery = '';
  String _selectedStatus = 'Semua';
  final List<String> _statusOptions = ['Semua', 'Proses', 'Tersortir', 'Gagal'];

  final Map<String, Color> _statusColors = {
    'Proses': Colors.blue,
    'Tersortir': Colors.green,
    'Gagal': Colors.red,
  };

  final TextEditingController _searchController = TextEditingController();

  int _currentPage = 1;
  final int _itemsPerPage = 10;

  String _formatToWIB(String utcTime) {
    final utcDateTime = DateTime.parse(utcTime).toUtc();
    final wibDateTime = utcDateTime.add(const Duration(hours: 7));
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(wibDateTime);
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Cari Paket',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _searchController,
                  style: const TextStyle(fontFamily: 'Poppins'),
                  decoration: InputDecoration(
                    hintText: 'Masukkan ID atau Jalur',
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = _searchController.text.toLowerCase();
                        });
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cari',
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog() {
    String tempSelectedStatus =
        _selectedStatus; // Variabel lokal untuk menyimpan status sementara

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Gunakan StatefulBuilder untuk memperbarui dialog
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Filter Status',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._statusOptions.map((status) {
                      return RadioListTile<String>(
                        title: Text(
                          status,
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                        value: status,
                        groupValue: tempSelectedStatus,
                        onChanged: (value) {
                          setDialogState(() {
                            tempSelectedStatus =
                                value!; // Perbarui status di dalam dialog
                          });
                        },
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Tutup dialog tanpa menyimpan
                          },
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedStatus =
                                  tempSelectedStatus; // Simpan status setelah dialog ditutup
                            });
                            Navigator.of(context).pop(); // Tutup dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Terapkan',
                            style: TextStyle(
                                fontFamily: 'Poppins', color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Paket',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.indigo),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
            tooltip: 'Cari Paket',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Status',
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: _paketSortRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Package> paketSortList = [];
                    final data =
                        snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                    if (data != null) {
                      data.forEach((key, value) {
                        final paket = Package.fromMap(key, value);
                        paketSortList.add(paket);
                      });
                    }

                    final filteredList = paketSortList.where((paket) {
                      final matchesSearch =
                          paket.key.toLowerCase().contains(_searchQuery) ||
                              paket.jalur.toLowerCase().contains(_searchQuery);
                      final matchesStatus = _selectedStatus == 'Semua' ||
                          paket.status.toLowerCase() ==
                              _selectedStatus.toLowerCase();
                      return matchesSearch && matchesStatus;
                    }).toList();

                    final totalPages =
                        (filteredList.length / _itemsPerPage).ceil();
                    final paginatedList = filteredList
                        .skip((_currentPage - 1) * _itemsPerPage)
                        .take(_itemsPerPage)
                        .toList();

                    if (filteredList.isEmpty) {
                      return const Center(
                        child: Text(
                          'Tidak ada paket yang sesuai.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: paginatedList.length,
                            itemBuilder: (context, index) {
                              final paket = paginatedList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side:
                                        BorderSide(color: Colors.grey.shade300),
                                  ),
                                  elevation: 3,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'ID: ${paket.key}',
                                              style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              ' ${paket.jalur}',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                '${paket.id}',
                                                style: const TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              ' ${_formatToWIB(paket.updatedAt!)}',
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:
                                                _statusColors[paket.status] ??
                                                    Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            paket.status,
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: _currentPage > 1
                                    ? () {
                                        setState(() {
                                          _currentPage--;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                                color: _currentPage > 1
                                    ? Colors.indigo
                                    : Colors.grey,
                              ),
                              Text(
                                '$_currentPage dari $totalPages',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              IconButton(
                                onPressed: _currentPage < totalPages
                                    ? () {
                                        setState(() {
                                          _currentPage++;
                                        });
                                      }
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                                color: _currentPage < totalPages
                                    ? Colors.indigo
                                    : Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
