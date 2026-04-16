import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parking_cars/Screens/timer_screen.dart';
import 'package:parking_cars/Services/storage_service.dart';

class ParkingMap extends StatefulWidget {
  final int selectedIndex;
  final int hours;

  const ParkingMap({
    super.key,
    required this.selectedIndex,
    required this.hours,
  });

  @override
  State<ParkingMap> createState() => _ParkingMapState();
}

class _ParkingMapState extends State<ParkingMap> {
  Map<String, dynamic>? car;

  bool isTopGateOpen = false;
  bool isBottomGateOpen = false;

  // مكان البوابة (بيتظبط حسب حجم الشاشة)
  double gateX = 0;

  final slots = const [
    Offset(10, 70),
    Offset(105, 70),
    Offset(200, 70),
    Offset(295, 70),
    Offset(10, 520),
    Offset(105, 520),
    Offset(200, 520),
    Offset(295, 520),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 400), start);
  }

  Future<void> start() async {
    final target = slots[widget.selectedIndex];
    final isTop = widget.selectedIndex < 4;
    final laneY = isTop ? 240.0 : 420.0;

    final width = MediaQuery.of(context).size.width;

    // تحديد مكان البوابة حسب الشاشة
    gateX = width * 0.8;

    final turnRight = isTop;

    // 1 - دخول من خارج الشاشة
    setState(() {
      car = {
        'x': width + 100,
        'y': laneY,
        'angle': -0.25,
        'img': 'assets/images/car1.png',
      };
    });

    await Future.delayed(const Duration(milliseconds: 300));

    // 2 - تتحرك لحد ما تقف قبل البوابة
    setState(() => car!['x'] = gateX + 60);

    await Future.delayed(const Duration(milliseconds: 600));

    // 3 - فتح البوابة
    setState(() {
      isTopGateOpen = isTop;
      isBottomGateOpen = !isTop;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    // 4 - تعدي البوابة (بدون رجوع)
    setState(() => car!['x'] = gateX - 120);

    await Future.delayed(const Duration(milliseconds: 500));

    // 5 - قفل البوابة
    setState(() {
      isTopGateOpen = false;
      isBottomGateOpen = false;
    });

    // 6 - تمشي للركنة
    setState(() => car!['x'] = target.dx);

    await Future.delayed(const Duration(milliseconds: 600));

    // 7 - تلف وتدخل الركنة
    setState(() {
      car!['angle'] = turnRight ? 0.0 : -0.5;
      car!['y'] = target.dy;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    await StorageService.saveSlot(widget.selectedIndex, true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TimerScreen(
          hours: widget.hours,
          slot: widget.selectedIndex,
        ),
      ),
    );
  }

  Widget buildCar() {
    if (car == null) return const SizedBox();

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      left: car!['x'],
      top: car!['y'],
      child: AnimatedRotation(
        turns: car!['angle'],
        duration: const Duration(milliseconds: 400),
        child: Image.asset(
          car!['img'],
          width: 85,
          height: 150,
        ),
      ),
    );
  }

  Widget gate(bool open) {
    return AnimatedRotation(
      turns: open ? 0.25 : 0,
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: 6,
        height: 90,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.white, Colors.red],
          ),
        ),
      ),
    );
  }

  Widget slotBox(int i) {
    return Positioned(
      left: slots[i].dx,
      top: slots[i].dy,
      child: Container(
        width: 85,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
        child: Center(
          child: Text(
            'P${i + 1}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 700,
          height: 900,
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.black)),

              ...List.generate(8, slotBox),

              Positioned(left: gateX, top: 235, child: gate(isTopGateOpen)),
              Positioned(left: gateX, top: 415, child: gate(isBottomGateOpen)),

              buildCar(),
            ],
          ),
        ),
      ),
    );
  }
}