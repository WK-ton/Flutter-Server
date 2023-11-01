import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class TimeSelect extends StatefulWidget {
  const TimeSelect({super.key});

  @override
  State<TimeSelect> createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  List<dynamic> cars = [];
  Set<String> uniqueTimes = {};

  @override
  void initState() {
    super.initState();
    fetchCarBangKhen();
    fetchCarMonument();
    fetchCarSatTai();
  }

  void checkAndReserveTime(String selectedTime) {
    final currentTime = DateTime.now();
    final selectedDateTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      int.parse(selectedTime.split(':')[0]),
      int.parse(selectedTime.split(':')[1]),
      int.parse(selectedTime.split(':')[2]),
    );

    final isTimePassed = selectedDateTime.isBefore(currentTime);

    if (isTimePassed) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('เวลาไม่ถูกต้อง'),
            content: const Text('ไม่สามารถจองเวลาที่เกินเวลาจริงได้'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'),
              ),
            ],
          );
        },
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ปิด',
                        style: GoogleFonts.notoSansThai(
                            fontWeight: FontWeight.w500, color: Colors.grey)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                    child: Text(
                      'เลือกเวลา',
                      style: GoogleFonts.notoSansThai(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              const Divider(height: 10),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    final time = car['time'];
                    final formattedTime = time.substring(0, 5);
                    final currentTime = DateTime.now();
                    final selectedDateTime = DateTime(
                      currentTime.year,
                      currentTime.month,
                      currentTime.day,
                      int.parse(time.split(':')[0]),
                      int.parse(time.split(':')[1]),
                      int.parse(time.split(':')[2]),
                    );

                    final isTimePassed = selectedDateTime.isBefore(currentTime);
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  checkAndReserveTime(time);
                                  Navigator.pop(context, time);
                                },
                                child: Text(
                                  'เวลา: $formattedTime น.',
                                  style: GoogleFonts.notoSansThai(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: isTimePassed
                                          ? Colors.grey
                                          : Colors.indigo),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void fetchCarBangKhen() async {
    const url = 'http://localhost:8081/carBangkhen/getCars/cars_bangkhen';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    final monumentCars = json['Result'];
    for (final car in monumentCars) {
      final time = car['time'];
      if (!cars.any((car) => car['time'] == time)) {
        cars.add(car);
      }
    }
    setState(() {
      cars = cars;
    });
  }

  void fetchCarMonument() async {
    const url = 'http://localhost:8081/carMonument/getCars/cars_monument';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    // กรองข้อมูลที่ซ้ำกันก่อนเพิ่มเข้ากับ cars
    final monumentCars = json['Result'];
    for (final car in monumentCars) {
      final time = car['time'];
      if (!cars.any((car) => car['time'] == time)) {
        cars.add(car);
      }
    }
    setState(() {
      cars = cars;
    });
  }

  void fetchCarSatTai() async {
    const url = 'http://localhost:8081/carSaiTai/getCars/cars_SatTai';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    // กรองข้อมูลที่ซ้ำกันก่อนเพิ่มเข้ากับ cars
    final monumentCars = json['Result'];
    for (final car in monumentCars) {
      final time = car['time'];
      if (!cars.any((car) => car['time'] == time)) {
        cars.add(car);
      }
    }
    setState(() {
      cars = cars;
    });
  }
}
