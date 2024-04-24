import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class toCar extends StatefulWidget {
  const toCar({super.key});

  @override
  State<toCar> createState() => _toState();
}

class _toState extends State<toCar> {
  List<dynamic> cars = [];

  @override
  void initState() {
    super.initState();
    fetchStation();
    fetchCarMonument();
    fetchCarSatTai();
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
                    child: Text(
                      'ปิด',
                      style: GoogleFonts.notoSansThai(
                          fontWeight: FontWeight.w500, color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
                    child: Text(
                      'สถานีปลายทาง',
                      style: GoogleFonts.notoSansThai(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 0.25,
                ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cars.toSet().toList().length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
                    final station = car['tostation'];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, station);
                                },
                                child: Text(
                                  '$station',
                                  style: GoogleFonts.notoSansThai(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Colors.indigo),
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

  void fetchStation() async {
    const url = 'http://localhost:8081/carBangkhen/getCars/cars_bangkhen';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    final monumentCars = json['Result'];
    for (final car in monumentCars) {
      final station = car['tostation'];
      if (!cars.any((car) => car['tostation'] == station)) {
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
      final station = car['tostation'];
      if (!cars.any((car) => car['tostation'] == station)) {
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
      final station = car['tostation'];
      if (!cars.any((car) => car['tostation'] == station)) {
        cars.add(car);
      }
    }
    setState(() {
      cars = cars;
    });
  }
}
