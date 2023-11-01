import 'package:application/screen/Detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

class SeatReservationScreen extends StatefulWidget {
  final String number;
  final String fromStation;
  final String toStation;
  final String time;
  final String road;
  final String token;
  final String image;

  SeatReservationScreen({
    required this.number,
    required this.fromStation,
    required this.toStation,
    required this.time,
    required this.road,
    required this.image,
    required this.token,
  });

  @override
  _SeatReservationScreenState createState() => _SeatReservationScreenState();
}

class _SeatReservationScreenState extends State<SeatReservationScreen> {
  List<List<bool>> seats =
      List.generate(4, (_) => List.generate(3, (_) => false));
  List<List<bool>> reservedSeats =
      List.generate(4, (_) => List.generate(3, (_) => false));

  void _toggleSeat(int row, int col) {
    setState(() {
      if (!reservedSeats[row][col]) {
        if (!seats[row][col]) {
          // If the seat is not already selected, check if any other seat is selected
          bool anySeatSelected = false;
          for (int i = 0; i < seats.length && !anySeatSelected; i++) {
            for (int j = 0; j < seats[i].length && !anySeatSelected; j++) {
              if (seats[i][j]) {
                anySeatSelected = true;
              }
            }
          }
          if (anySeatSelected) {
            // If any seat is already selected, show an alert and return
            showDialog(
              context: context,
              builder: (context) {
                // return AlertDialog(
                //   title: Text(
                //     'เลือกได้ 1 ที่เท่านั้น!',
                //     style: GoogleFonts.notoSansThai(),
                //   ),
                //   content: Text(
                //     'คุณไม่สามารถเลือกที่นั่งเพิ่มได้',
                //     style: GoogleFonts.notoSansThai(),
                //   ),
                //   actions: [
                //     TextButton(
                //       onPressed: () {
                //         Navigator.pop(context);
                //       },
                //       child: Text('OK'),
                //     ),
                //   ],
                // );
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0), // ตั้งค่า radius ที่คุณต้องการ
                  ),
                  // title: const Text(''),
                  content: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      'คุณสามารถเลือกได้ 1 ที่เท่านั้น ',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.redAccent),
                    ),
                  ),
                  // actions: [
                  //   TextButton(
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     },
                  //     child: Text(
                  //       'OK',
                  //       style: GoogleFonts.notoSans(
                  //           color: Colors.red),
                  //     ),
                  //   ),
                  // ],
                );
              },
            );
            return;
          }
        }
        seats[row][col] = !seats[row][col];
        selectedRow = row;
        selectedCol = col;
      }
    });
  }

  String formatSelectedSeats() {
    List<String> formattedSeats = [];
    for (int row = 0; row < seats.length; row++) {
      for (int col = 0; col < seats[row].length; col++) {
        if (seats[row][col]) {
          formattedSeats.add(getSeatLabel(row, col));
        }
      }
    }
    return formattedSeats.join(', '); // Join seats with a comma and space
  }

  String getCurrentDate() {
    initializeDateFormatting('th_TH', null);
    final now = DateTime.now()
        .toUtc()
        .add(const Duration(hours: 7)); // เพิ่ม 7 ชั่วโมงเพื่อให้เป็น GMT+7
    final formatter = DateFormat('yyyy/MM/dd', 'th_TH');
    return formatter.format(now);
  }

  int calculateTotalCost() {
    // Calculate the total cost based on the number of selected seats
    int numberOfSelectedSeats = 0;
    for (int row = 0; row < seats.length; row++) {
      for (int col = 0; col < seats[row].length; col++) {
        if (seats[row][col]) {
          numberOfSelectedSeats++;
        }
      }
    }
    return numberOfSelectedSeats * 30; // 30 baht per seat
  }

  int selectedRow = -1;
  int selectedCol = -1;

  Future<void> fetchReservedSeats() async {
    final url = Uri.parse('http://localhost:8081/booking/api/getSeats');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          for (final reservation in data) {
            final row = reservation['row'];
            final col = reservation['col'];
            final fromstation = reservation['fromstation'];
            final tostation = reservation['tostation'];
            final time = reservation['time'];
            final date = reservation['date'];

            // เพิ่มเงื่อนไขเช็คข้อมูลตรงกับค่าที่รับมาจากคอนสตรักเตอร์
            if (fromstation == widget.fromStation &&
                tostation == widget.toStation &&
                time == widget.time &&
                date == getCurrentDate()) {
              reservedSeats[row][col] = true;
            }
          }
        });
      } else {
        // แสดงข้อความหรือแจ้งเตือนในกรณีที่ไม่สามารถดึงข้อมูลการจองได้
        print('ไม่สามารถดึงข้อมูลการจอง: ${response.statusCode}');
      }
    } catch (error) {
      // แสดงข้อความหรือแจ้งเตือนในกรณีที่มีข้อผิดพลาดในการเชื่อมต่อ
      print('เกิดข้อผิดพลาดในการเชื่อมต่อ: $error');
    }
  }

  String getSeatLabel(int row, int col) {
    List<String> rowLabels = ['A', 'B', 'C', 'D'];

    row = row.clamp(0, rowLabels.length - 1);

    row++;

    col++;

    return '${rowLabels[row - 1]}$col';
  }

  @override
  void initState() {
    super.initState();
    fetchReservedSeats();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(children: [
      Container(
        width: size.width,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Color(0xFFF2F4F8)),
      ),
      Container(
        width: size.width,
        height: 300,
        decoration: const ShapeDecoration(
          color: Color(0xFF5C24D4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      Column(children: [
        const SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
        Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "โปรดเลือกที่นั่ง",
                style: GoogleFonts.notoSansThai(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        Container(
          width: 350,
          height: 80,
          decoration: ShapeDecoration(
            color: const Color(0xFF262626),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // จัดให้ Text สาย 999 อยู่ซ้ายสุด
                  children: [
                    Text(
                      '${widget.fromStation} - ${widget.toStation}',
                      style: GoogleFonts.notoSansThai(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'สาย : ${widget.number}',
                      style: GoogleFonts.notoSansThai(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'วันที่ ${getCurrentDate()}',
                      style: GoogleFonts.notoSansThai(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'เวลา : ${widget.time.substring(0, 5)}',
                      style: GoogleFonts.notoSansThai(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 45),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/sold.png', // Replace 'your_image.png' with your actual image path
                      fit: BoxFit.cover, // You can adjust the fit as needed
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ที่นั่งเต็ม',
                    style: GoogleFonts.notoSansThai(),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/selected.png', // Replace 'your_image.png' with your actual image path
                      fit: BoxFit.cover, // You can adjust the fit as needed
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('กำลังเลือก', style: GoogleFonts.notoSansThai())
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/unselected.png', // Replace 'your_image.png' with your actual image path
                      fit: BoxFit.cover, // You can adjust the fit as needed
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ที่นั่งว่าง',
                    style: GoogleFonts.notoSansThai(),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Container(
                width: 300,
                padding: const EdgeInsets.all(10),
                // decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: List.generate(
                    seats.length,
                    (row) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          seats[row].length,
                          (col) {
                            return GestureDetector(
                              onTap: () {
                                _toggleSeat(row, col);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: seats[row][col]
                                          ? const AssetImage(
                                              'assets/selected.png')
                                          : reservedSeats[row][col]
                                              ? const AssetImage(
                                                  'assets/sold.png')
                                              : AssetImage(
                                                  'assets/unselected.png'),
                                      fit: BoxFit
                                          .cover, // You can adjust the fit as needed
                                    ),
                                    // Add any other styling you need, such as borders or borderRadius.
                                  ),
                                  child: Center(
                                    child: Text(
                                      getSeatLabel(row, col),
                                      style: GoogleFonts.notoSansThai(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 55),
              Stack(
                children: [
                  Container(
                    width: 390,
                    height: 116,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF5C24D4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 170,
                          height: 70,
                          decoration: ShapeDecoration(
                            color: const Color(0xFF262626),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'เลือกที่นั่ง: ${formatSelectedSeats()}',
                                  style: GoogleFonts.notoSansThai(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'รวมเงิน: ${calculateTotalCost()} บาท',
                                  style: GoogleFonts.notoSansThai(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 140,
                          height: 40,
                          child: TextButton(
                            onPressed: () {
                              bool isAnySeatSelected = false;
                              for (int row = 0; row < seats.length; row++) {
                                for (int col = 0;
                                    col < seats[row].length;
                                    col++) {
                                  if (seats[row][col]) {
                                    isAnySeatSelected = true;
                                    break;
                                  }
                                }
                                if (isAnySeatSelected) {
                                  break;
                                }
                              }

                              if (!isAnySeatSelected) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0), // ตั้งค่า radius ที่คุณต้องการ
                                      ),
                                      // title: const Text(''),
                                      content: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: Text(
                                          'โปรดเลือกที่นั่งของคุณ',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.notoSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.indigoAccent),
                                        ),
                                      ),
                                      // actions: [
                                      //   TextButton(
                                      //     onPressed: () {
                                      //       Navigator.pop(context);
                                      //     },
                                      //     child: Text(
                                      //       'OK',
                                      //       style: GoogleFonts.notoSans(
                                      //           color: Colors.red),
                                      //     ),
                                      //   ),
                                      // ],
                                    );
                                  },
                                );
                              } else {
                                final totalCost = calculateTotalCost();
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: StepBooking(
                                      number: widget.number,
                                      fromStation: widget.fromStation,
                                      toStation: widget.toStation,
                                      time: widget.time,
                                      date: getCurrentDate(),
                                      road: widget.road,
                                      selectedSeats: formatSelectedSeats(),
                                      token: widget.token,
                                      selectedRow: selectedRow,
                                      selectedCol: selectedCol,
                                      image: widget.image,
                                      totalCost:
                                          totalCost, // Pass total cost here
                                    ),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'ถัดไป',
                              style: GoogleFonts.notoSansThai(
                                color: Colors
                                    .black, // You can customize the text color here
                                fontSize:
                                    16, // You can adjust the font size here
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ])
    ]));
  }
}
