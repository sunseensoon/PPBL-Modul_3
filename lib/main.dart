import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Tally Counter',
      home: MyHomePage(title: 'Tally Counter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0; // Untuk melacak tombol yang dipilih

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Memuat data counter dan slot yang aktif dari SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = prefs.getInt('selectedSlot') ?? 0; // Default slot 0
      _counter = prefs.getInt('counter$_selectedIndex') ??
          0; // Memuat nilai counter untuk slot yang aktif
    });
  }

  // Menyimpan counter dan slot yang aktif ke SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter$_selectedIndex',
        _counter); // Menyimpan counter untuk slot yang aktif
    await prefs.setInt(
        'selectedSlot', _selectedIndex); // Menyimpan slot yang aktif
  }

  // Menambahkan counter pada slot aktif
  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    _saveData(); // Simpan data setiap kali counter diubah
  }

  // Mengatur ulang counter pada slot aktif
  Future<void> _resetCounter() async {
    setState(() {
      _counter = 0;
    });
    _saveData(); // Simpan data setiap kali counter direset
  }

  // Fungsi untuk mengubah slot yang aktif
  void _onSegmentChanged(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedIndex = index;
      _counter = prefs.getInt('counter$_selectedIndex') ??
          0; // Memuat nilai counter untuk slot yang baru
    });
    _saveData(); // Simpan slot yang aktif
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // Bagian SegmentedButton (ToggleButtons)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ToggleButtons(
              isSelected: List.generate(5, (index) => _selectedIndex == index),
              onPressed: _onSegmentChanged,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('1'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('2'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('3'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('4'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('5'),
                ),
              ],
            ),
          ),
          // Tampilan counter
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hitung:',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 30,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: 'reset',
              onPressed: _resetCounter,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.clear,
                size: 40,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 30,
            child: FloatingActionButton(
              heroTag: 'add',
              onPressed: _incrementCounter,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
