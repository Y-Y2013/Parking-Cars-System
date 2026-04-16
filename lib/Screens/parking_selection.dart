import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parking_cars/Services/storage_service.dart';
import 'package:parking_cars/Screens/payment_screen.dart';

class ParkingSelectionScreen extends StatefulWidget {
  const ParkingSelectionScreen({super.key});

  @override
  State<ParkingSelectionScreen> createState() => _ParkingSelectionScreenState();
}

class _ParkingSelectionScreenState extends State<ParkingSelectionScreen> {
  bool _loading = true;
  List<bool> _slots = List<bool>.filled(8, false);

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _load();
  }

  // يولد توزيع عشوائي:
  // true  = محجوز
  // false = متاح
  // مع ضمان إن مش كل الأماكن تبقى محجوزة
  List<bool> _generateRandomSlots(int count) {
    final slots = List<bool>.filled(count, false);

    // نختار عدد أماكن محجوزة عشوائي من 1 إلى count - 1
    // يعني دايمًا هيبقى فيه مكان فاضي على الأقل
    final occupiedCount = 1 + _random.nextInt(count - 1);

    // نجهز كل الأرقام من 0 إلى count - 1
    final indices = List<int>.generate(count, (i) => i)..shuffle(_random);

    // نحجز أول occupiedCount أماكن من اللي اتخلطوا
    for (int i = 0; i < occupiedCount; i++) {
      slots[indices[i]] = true;
    }

    return slots;
  }

  Future<void> _load() async {
    // نولد حالة عشوائية جديدة كل مرة
    final data = _generateRandomSlots(8);

    // نحفظها في التخزين عشان تفضل ثابتة أثناء التنقلات الحالية
    await StorageService.saveSlots(data);

    if (!mounted) return;

    setState(() {
      _slots = data;
      _loading = false;
    });
  }

  void _openSlot(int index) {
    if (_slots[index]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This slot is already occupied')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(selectedIndex: index),
      ),
    ).then((_) => _load());
  }

  Widget _slotCard(int index) {
    final full = _slots[index];

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _openSlot(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: full
              ? const LinearGradient(
            colors: [Color(0xFF5A1724), Color(0xFF7A1F2F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : const LinearGradient(
            colors: [Color(0xFF143A2B), Color(0xFF1E5A42)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: full ? const Color(0xFFFF788A) : const Color(0xFF59D49F),
            width: 1.3,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 16,
              offset: Offset(0, 10),
              color: Colors.black38,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 14,
              left: 14,
              child: Text(
                'P${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Icon(
                full ? Icons.directions_car_filled : Icons.local_parking,
                color: Colors.white,
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    full ? Icons.close : Icons.check_circle,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    full ? 'Occupied' : 'Available',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 14,
              left: 14,
              right: 14,
              child: Text(
                full ? 'Tap blocked' : 'Tap to continue',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF07111F), Color(0xFF0D1A30), Color(0xFF07111F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xFF101B33),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF24304A)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/P.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.local_parking,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose a parking slot',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Occupied slots are shown in red.',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: GridView.builder(
                    itemCount: 8,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.15,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemBuilder: (context, index) => _slotCard(index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}