import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PackageListPage extends StatefulWidget {
  const PackageListPage({Key? key}) : super(key: key);

  @override
  _PackageListPageState createState() => _PackageListPageState();
}

class _PackageListPageState extends State<PackageListPage> {
  final DatabaseReference _paketRef =
      FirebaseDatabase.instance.ref().child('conveyor/paket');

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _jalurController = TextEditingController();
  String _status = 'Ready';

  final List<String> _statusOptions = ['Ready', 'In Maintenance'];

  final Map<String, Color> _statusColors = {
    'Ready': Colors.green,
    'In Maintenance': Colors.red,
  };

  Future<void> _addOrUpdateJalur({String? key}) async {
    final id = _idController.text.trim();
    final jalur = _jalurController.text.trim();

    if (id.isEmpty || jalur.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    // Periksa apakah jalur sudah dipakai
    final snapshot = await _paketRef.once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      for (var entry in data.entries) {
        final existingData = entry.value as Map<dynamic, dynamic>;

        if (existingData['jalur'] == jalur &&
            (key == null || entry.key != key)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Jalur $jalur sudah dipakai. Pilih jalur lain.')),
          );
          return;
        }
      }
    }

    final dataToSave = {
      'id': id,
      'jalur': jalur,
      'status': _status,
    };

    if (key == null) {
      await _paketRef.push().set(dataToSave);
    } else {
      await _paketRef.child(key).update(dataToSave);
    }

    Navigator.of(context).pop();
    _idController.clear();
    _jalurController.clear();
    setState(() {});
  }

  Future<void> _deleteJalur(String key) async {
    await _paketRef.child(key).remove();
    setState(() {});
  }

  void _showJalurDialog(
      {String? key, String? id, String? jalur, String? status}) {
    _idController.text = id ?? '';
    _jalurController.text = jalur ?? '';
    _status = status ?? 'Ready';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  key == null ? 'Tambah Jalur' : 'Ubah Jalur',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'Kode Pos (Kecamatan)',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _jalurController,
                  decoration: InputDecoration(
                    labelText: 'Jalur',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _status,
                  items: _statusOptions
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Status',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _addOrUpdateJalur(key: key),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Jalur',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.indigo),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showJalurDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder<DatabaseEvent>(
          stream: _paketRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
              final paketList = data?.entries
                      .map((entry) => {'key': entry.key, ...entry.value as Map})
                      .toList() ??
                  [];

              return ListView.builder(
                itemCount: paketList.length,
                itemBuilder: (context, index) {
                  final paket = paketList[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(paket['id'],
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jalur: ${paket['jalur']}'),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  _statusColors[paket['status']] ?? Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              paket['status'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showJalurDialog(
                              key: paket['key'],
                              id: paket['id'],
                              jalur: paket['jalur'],
                              status: paket['status'],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteJalur(paket['key']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
