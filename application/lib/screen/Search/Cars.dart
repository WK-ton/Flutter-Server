import 'package:application/components/Dash.dart';
import 'package:application/screen/Seat.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cars extends StatefulWidget {
  const Cars(
      {required this.fromStation,
      required this.toStation,
      required this.time,
      required this.token,
      Key? key})
      : super(key: key);

  final String fromStation;
  final String toStation;
  final String time;
  final String token;

  @override
  State<Cars> createState() => _CarsState();
}

class _CarsState extends State<Cars> {
  List<dynamic> data = [];
  void _showPopup(BuildContext context, String road, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(
            'เส้นทางที่ผ่าน',
            style: GoogleFonts.notoSansThai(),
          ),
          content: Text('$road', style: GoogleFonts.notoSansThai()),
          actions: [
            TextButton(
              onPressed: () {
                showPopupImage(context, imageUrl);
                // Navigator.pop(context); // ปิด popup เมื่อกดปุ่ม
              },
              child: Text(
                'ดูรูปภาพเส้นทาง',
                style: GoogleFonts.notoSansThai(),
              ),
            ),
          ],
        );
      },
    );
  }

  void showPopupImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            'รูปภาพเส้นทาง',
            style: GoogleFonts.notoSansThai(fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(imageUrl), // แสดงรูปภาพจาก URL ที่รับมา
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // ปิด Modal เมื่อกดปุ่ม
                },
                child: Text(
                  'ปิด',
                  style: GoogleFonts.notoSansThai(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String getCurrentDate() {
    initializeDateFormatting('th_TH', null);
    final now = DateTime.now()
        .toUtc()
        .add(const Duration(hours: 7)); // เพิ่ม 7 ชั่วโมงเพื่อให้เป็น GMT+7
    final formatter = DateFormat('yyyy/MM/dd', 'th_TH');
    return formatter.format(now);
  }

  List<dynamic> cars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllCars();
  }

  Future<void> fetchAllCars() async {
    await Future.delayed(Duration(seconds: 1));

    final api1Url = 'http://localhost:8081/carBangkhen/getCars/cars_bangkhen';
    final api2Url = 'http://localhost:8081/carMonument/getCars/cars_monument';
    final api3Url = 'http://localhost:8081/carSaiTai/getCars/cars_SatTai';

    final api1Response = await http.get(Uri.parse(api1Url));
    final api2Response = await http.get(Uri.parse(api2Url));
    final api3Response = await http.get(Uri.parse(api3Url));

    final api1Body = api1Response.body;
    final api2Body = api2Response.body;
    final api3Body = api3Response.body;

    final api1Json = jsonDecode(api1Body);
    final api2Json = jsonDecode(api2Body);
    final api3Json = jsonDecode(api3Body);

    final api1Cars = api1Json['Result'];
    final api2Cars = api2Json['Result'];
    final api3Cars = api3Json['Result'];

    final allCars = [...api1Cars, ...api2Cars, ...api3Cars];

    cars = allCars.where((car) {
      return car['fromstation'] == widget.fromStation &&
          car['tostation'] == widget.toStation &&
          car['time'] == widget.time;
    }).toList();

    setState(() {
      isLoading = false;
      cars = cars;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 92, 36, 212),
      body: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            //margin: EdgeInsets.only(top: size.height * 0.10),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4F8),
            ),
          ),
          Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                height: 110,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 92, 36, 212),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 50,
                      right: 350,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_outlined,
                            color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Positioned(
                      top: 20, // Adjust the top position as needed
                      left: 0, // Adjust the left position as needed
                      child: Container(
                        width: size.width, // Use the full screen width
                        height: 110,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 92, 36, 212),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 32,
                              left: 20, // Adjust the left position for the icon
                              child: IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.fromStation} - ${widget.toStation}',
                                    style: GoogleFonts.notoSansThai(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    'วันที่ ${getCurrentDate()}',
                                    style: GoogleFonts.notoSansThai(
                                      color: Colors.white60,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Row(
                  children: [
                    Text(
                      'ผลลัพธ์ทั้งหมด',
                      style: GoogleFonts.notoSansThai(
                        color: const Color(0xFF2D3D50),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        //scrollDirection: Axis.horizontal,
                        itemCount: cars.length,
                        itemBuilder: (context, index) {
                          final car = cars[index];
                          final fromstation = car['fromstation'];
                          final tostation = car['tostation'];
                          final number = car['number'];
                          final road = car['road'];
                          final time = car['time'];
                          final image = car['image'];
                          final imageUrl =
                              'http://localhost:8081/images/$image';
                          final formattedTime = time.substring(0, 5);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: Container(
                              width: 330,
                              height: 191,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.indigo.withAlpha(50),
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        child: SeatReservationScreen(
                                            number: number,
                                            fromStation: fromstation,
                                            toStation: tostation,
                                            time: time,
                                            road: road,
                                            token: widget.token,
                                            image: imageUrl),
                                        type: PageTransitionType.rightToLeft),
                                  );
                                },
                                child: Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'สาย : $number',
                                          style: GoogleFonts.notoSansThai(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    left: 219,
                                    child: Container(
                                      width: 90,
                                      height: 20,
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFFC2A6FD),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Recommended',
                                          style: GoogleFonts.notoSansThai(
                                            color: const Color(0xFF4C2CA4),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 50,
                                    child: Text(
                                      'จาก',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF9B9999),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 66,
                                    child: Text(
                                      fromstation,
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF2D3D50),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 100,
                                    child: Text(
                                      'ถึง',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF9B9999),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 116,
                                    child: Text(
                                      tostation,
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF2D3D50),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 50,
                                    left: 250,
                                    child: Transform(
                                      transform: Matrix4.identity()
                                        ..translate(0.0, 0.0)
                                        ..rotateZ(1.56),
                                      child: Container(
                                        width: 90.01,
                                        decoration: const ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 0.50,
                                              strokeAlign:
                                                  BorderSide.strokeAlignCenter,
                                              color: Color(0xFFC9C8C8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 268,
                                    top: 50,
                                    child: Text(
                                      'รอบเวลา',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF9B9999),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 267,
                                    top: 66,
                                    child: Text(
                                      '$formattedTime',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF2D3D50),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 280,
                                    top: 100,
                                    child: Text(
                                      'มัดจำ',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF9B9999),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 260,
                                    top: 116,
                                    child: Text(
                                      '30 บาท',
                                      style: GoogleFonts.notoSansThai(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 272,
                                    top: 160,
                                    child: Text(
                                      'จอง',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF4C2CA4),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 160,
                                    left: 20,
                                    child: CustomPaint(
                                      size: Size(270,
                                          1), // Adjust the width and height of the dashed line
                                      painter:
                                          DashedLinePainter(), // Create a custom Painter for the dashed line
                                    ),
                                  ),
                                  Positioned(
                                    top: 170,
                                    left: 20,
                                    child: Text(
                                      'เส้นทางที่ผ่าน : ',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF2D3D50),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 153,
                                    left: 75,
                                    child: TextButton(
                                        onPressed: () =>
                                            _showPopup(context, road, imageUrl),
                                        child: Text(
                                          'กดเพื่อดูเพิ่มเติม',
                                          style: GoogleFonts.notoSansThai(
                                            color: const Color(0xFF5C24D4),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                  ),
                                  // Positioned(
                                  //   top: 167,
                                  //   left: 259,
                                  //   child: Text(
                                  //     'Buy Ticket',
                                  //     style: GoogleFonts.notoSansThai(
                                  //       color: Colors.indigo,
                                  //       fontSize: 12,
                                  //       fontWeight: FontWeight.w400,
                                  //     ),
                                  //   ),
                                  // ),
                                ]),
                              ),
                            ),
                          );
                        }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
