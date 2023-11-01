import 'package:application/screen/QR_code.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:page_transition/page_transition.dart';

class StepBooking extends StatefulWidget {
  final String selectedSeats;
  final String number;
  final String fromStation;
  final String toStation;
  final String time;
  final String date;
  final String road;
  final String token;
  final int selectedRow;
  final int selectedCol;
  final int totalCost;
  final String image;

  StepBooking(
      {Key? key,
      required this.selectedSeats,
      required this.number,
      required this.fromStation,
      required this.toStation,
      required this.time,
      required this.date,
      required this.road,
      required this.token,
      required this.selectedRow,
      required this.selectedCol,
      required this.image,
      required this.totalCost})
      : super(key: key);

  @override
  State<StepBooking> createState() => _StepBookingState();
}

class _StepBookingState extends State<StepBooking> {
  late String name;
  late String email;
  late String phone;

  Future<String> generateQRCode() async {
    final url =
        'http://localhost:8081/booking/create/qrcode'; // Update with your actual URL
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'amount': widget.totalCost,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['Result'];
    } else {
      print('QR code generation failed: ${response.reasonPhrase}');
      return ''; // Return an empty string or some error message
    }
  }

  void showConfirmationDialog() {
    AlertDialog alertDialog = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        'เงื่อนไขของการจอง',
        style: GoogleFonts.notoSansThai(color: Colors.indigo, fontSize: 18),
      ),
      content: Text(
        'เมื่อคุณมาช้ากว่า 5 นาที ขอสงวนที่ให้กับคนอื่น',
        style: GoogleFonts.notoSansThai(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'ยกเลิก',
            style: GoogleFonts.notoSansThai(color: Colors.grey, fontSize: 14),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // ปิด AlertDialog
          },
        ),
        TextButton(
          child: Text(
            'ทำรายการต่อ',
            style: GoogleFonts.notoSansThai(color: Colors.indigo, fontSize: 14),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // ปิด AlertDialog
            confirmBooking(); // เรียกฟังก์ชัน confirmBooking เมื่อผู้ใช้เลือก "ออกจากระบบ"
          },
        ),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future<void> confirmBooking() async {
    final qrCodeData = await generateQRCode();
    if (qrCodeData.isNotEmpty) {
      Navigator.push(
        context,
        PageTransition(
          child: QRCodePaymentScreen(
            qrCodeData: qrCodeData,
            number: widget.number,
            fromStation: widget.fromStation,
            toStation: widget.toStation,
            time: widget.time,
            date: widget.date,
            road: widget.road,
            selectedSeats: widget.selectedSeats,
            token: widget.token,
            name: name,
            email: email,
            phone: phone,
            selectedRow: widget.selectedRow,
            selectedCol: widget.selectedCol,
            totalCost: widget.totalCost,
          ),
          type: PageTransitionType.bottomToTop,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    name = jwtDecodedToken['name'] ?? 'Unknown';
    email = jwtDecodedToken['email'] ?? 'Unknown';
    phone = jwtDecodedToken['phone'] ?? 'Unknown';
  }

  void _showPopup(BuildContext context, String road, String image) {
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
                showPopupImage(context, image);
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

  void showPopupImage(BuildContext context, String image) {
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
              Image.network(image), // แสดงรูปภาพจาก URL ที่รับมา
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Selected Seats'),
      // ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4F8),
            ),
          ),
          Column(
            children: [
              Container(
                width: size.width,
                height: 150,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 92, 36, 212),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 35, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const SizedBox(width: 10),
                          Center(
                            child: Text(
                              'รายละเอียดการจอง',
                              style: GoogleFonts.notoSansThai(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 42),
              Container(
                width: 350,
                height: 150,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FROM',
                            style: GoogleFonts.notoSansThai(
                              color: const Color.fromARGB(255, 92, 36, 212),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'INFO',
                            style: GoogleFonts.notoSansThai(
                              color: const Color.fromARGB(255, 92, 36, 212),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 50,
                        left: 10,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFFAFAFA),
                            shape: OvalBorder(
                              side: BorderSide(
                                  width: 0.15, color: Color(0xFFBDBABA)),
                            ),
                          ),
                        )),
                    Positioned(
                      top: 42,
                      left: 29,
                      child: Text(
                        '${widget.fromStation}',
                        style: GoogleFonts.notoSansThai(
                            color: const Color(0xFF1A1B1D),
                            // color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 243,
                      child: Text(
                        'วันที่ ${widget.date}',
                        style: GoogleFonts.notoSansThai(
                            color: const Color(0xFF1A1B1D),
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Positioned(
                      top: 64,
                      left: 15,
                      child: Transform(
                        transform: Matrix4.identity()
                          ..translate(0.0, 0.0)
                          ..rotateZ(1.57),
                        child: Container(
                          width: 42,
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 0.15,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFBBBBBB),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 110,
                      left: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const ShapeDecoration(
                          shape: OvalBorder(),
                          color: Color.fromARGB(255, 92, 36, 212),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 85,
                    //   left: 20,
                    //   child: Text(
                    //     'To',
                    //     style: GoogleFonts.notoSansThai(
                    //       color: const Color.fromARGB(255, 92, 36, 212),
                    //       fontSize: 10,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 102,
                      left: 30,
                      child: Text(
                        '${widget.toStation}',
                        style: GoogleFonts.notoSansThai(
                            color: const Color(0xFF1A1B1D),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Positioned(
                      top: 110,
                      left: 270,
                      child: Text(
                        'เวลา : ${widget.time.substring(0, 5)}',
                        style: GoogleFonts.notoSansThai(
                            color: const Color(0xFF1A1B1D),
                            fontSize: 13,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 80,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () =>
                            _showPopup(context, widget.road, widget.image),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'กดเพิ่มดูเส้นทางที่ผ่าน',
                              style: GoogleFonts.notoSansThai(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.blue),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 90,
                    height: 80,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ที่นั่ง',
                            style: GoogleFonts.notoSansThai(
                              color: const Color.fromARGB(255, 92, 36, 212),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${widget.selectedSeats}',
                            style: GoogleFonts.notoSansThai(
                              color: const Color(0xFF1A1B1D),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 90,
                    height: 80,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'มัดจำ',
                            style: GoogleFonts.notoSansThai(
                              color: const Color.fromARGB(255, 92, 36, 212),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '${widget.totalCost} บาท',
                            style: GoogleFonts.notoSansThai(
                              color: const Color(0xFF1A1B1D),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: 350,
                height: 187,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ข้อมูลส่วนตัว',
                            style: GoogleFonts.notoSansThai(
                              color: const Color.fromARGB(255, 92, 36, 212),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 54,
                      left: 20,
                      child: Text(
                        'อีเมล : $email',
                        style: GoogleFonts.notoSansThai(
                            color: const Color(0xFF1A1B1D),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Positioned(
                      top: 95,
                      left: 20,
                      child: Text(
                        'ชื่อ : $name',
                        style: GoogleFonts.notoSansThai(
                            color: const Color(0xFF1A1B1D),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Positioned(
                      top: 135,
                      left: 20,
                      child: Text(
                        'เบอร์โทร : $phone ',
                        style: GoogleFonts.notoSansThai(
                            color: const Color(0xFF1A1B1D),
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              TextButton(
                onPressed: () {
                  showConfirmationDialog();
                },
                child: Container(
                  width: 330,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: const Color.fromARGB(255, 92, 36, 212),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'ชำระเงิน',
                      style: GoogleFonts.notoSansThai(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
