import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parking_cars/screens/parking_selection.dart';

class TimerScreen extends StatefulWidget {
  final int hours;
  final int slot;

  const TimerScreen({
    super.key,
    required this.hours,
    required this.slot,
  });

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int time;
  Timer? timer;

  bool isFinished = false; // 🔥 أهم متغير

  @override
  void initState() {
    super.initState();
    time = widget.hours;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (time > 0) {
        setState(() {
          time--;
        });
      } else {
        // 🔥 يمنع التكرار
        if (isFinished) return;

        isFinished = true;
        t.cancel();

        // ⏱️ تأخير بسيط عشان ميحصلش Crash
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => const ParkingSelectionScreen(),
            ),
                (route) => false,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050816),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // رقم الركنة
            Text(
              'P${widget.slot + 1}',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // 🔥 التايمر
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Colors.blue, Colors.black],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.7),
                    blurRadius: 40,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  '$time',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 90,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Parking Time",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}