import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketModal extends StatelessWidget {
  final int id;
  final String number;
  final String fromstation;
  final String tostation;
  final String date;
  final String time;
  final String seat;
  final String road;
  final String name;
  final String phone;
  final String email;
  final String image;

  TicketModal(
      {required this.id,
      required this.number,
      required this.fromstation,
      required this.tostation,
      required this.date,
      required this.time,
      required this.seat,
      required this.road,
      required this.name,
      required this.phone,
      required this.image,
      required this.email});

  void showPopupImage(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            'สลิปการชำระเงินถูกต้อง',
            style: GoogleFonts.notoSansThai(
                color: Colors.green, fontSize: 18, fontWeight: FontWeight.w400),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(image), // แสดงรูปภาพจาก URL ที่รับมา
              SizedBox(height: 16),
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
    return AlertDialog(
      title: Center(
        child: Text(
          'ตั๋วของคุณ',
          style: GoogleFonts.notoSansThai(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      content: Stack(
        children: [
          Container(
            width: 330,
            height: 450,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
              left: 20,
              child: Text(
                'VINVAN',
                style: GoogleFonts.notoSansThai(
                  color: Color(0xFF5C24D4),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              )),
          Positioned(
              top: 20,
              left: 20,
              child: Text(
                'ID : $id',
                style: GoogleFonts.notoSansThai(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )),
          Positioned(
              left: 200,
              child: Text(
                'สาย : $number',
                style: GoogleFonts.notoSansThai(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )),
          Positioned(
              top: 80,
              child: Container(
                width: 10,
                height: 10,
                decoration: const ShapeDecoration(
                  color: Color(0xFFFAFAFA),
                  shape: OvalBorder(
                    side: BorderSide(width: 0.15, color: Color(0xFFBDBABA)),
                  ),
                ),
              )),
          Positioned(
            top: 72,
            left: 20,
            child: Text(
              '$fromstation',
              style: GoogleFonts.notoSansThai(
                color: Color(0xFF2D3D50),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 5,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(0.0, 0.0)
                ..rotateZ(1.57),
              child: Container(
                width: 40,
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
            top: 150,
            child: Container(
              width: 10,
              height: 10,
              decoration: const ShapeDecoration(
                color: Color(0xFF4C2CA4),
                shape: OvalBorder(),
              ),
            ),
          ),
          Positioned(
            top: 142,
            left: 20,
            child: Text(
              '$tostation',
              style: GoogleFonts.notoSansThai(
                color: const Color(0xFF2D3D50),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
              top: 145,
              left: 190,
              child: Text(
                'เวลา : $time',
                style: GoogleFonts.notoSansThai(
                  color: const Color(0xFF9B9999),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )),
          Positioned(
              top: 75,
              left: 190,
              child: Text(
                '$date',
                style: GoogleFonts.notoSansThai(
                  color: const Color(0xFF9B9999),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              )),
          Positioned(
            top: 200,
            child: Stack(
              children: [
                Container(
                  width: 90,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5F7FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'ที่นั่ง',
                    style: GoogleFonts.notoSansThai(
                      color: const Color(0xFFBDBABA),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                  child: Text(
                    '$seat',
                    style: GoogleFonts.notoSansThai(
                      color: const Color(0xFF2D3D50),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 200,
            left: 110,
            child: Stack(
              children: [
                Container(
                  width: 150,
                  height: 70,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5F7FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'สลิปชำระเงิน',
                    style: GoogleFonts.notoSansThai(
                      color: const Color(0xFFBDBABA),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(3, 20, 0, 0),
                  child: TextButton(
                      onPressed: () => showPopupImage(context, image),
                      child: Text(
                        'กดเพื่อดูเพิ่มเติม',
                        style: GoogleFonts.notoSansThai(
                          color: const Color(0xFF5C24D4),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                )
              ],
            ),
          ),
          Positioned(
            top: 300,
            child: Stack(
              children: [
                Container(
                  width: 260,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5F7FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'ชื่อผู้จอง',
                    style: GoogleFonts.notoSansThai(
                      color: const Color(0xFFBDBABA),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                  child: Text(
                    '$name',
                    style: GoogleFonts.notoSansThai(
                      color: const Color(0xFF2D3D50),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 380,
            child: Stack(
              children: [
                Container(
                  width: 260,
                  height: 60,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5F7FA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'เบอร์โทร',
                    style: GoogleFonts.notoSansThai(
                      color: const Color(0xFFBDBABA),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
                  child: Text(
                    '$phone',
                    style: GoogleFonts.notoSansThai(
                      color: const Color(0xFF2D3D50),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'ปิด',
            style: GoogleFonts.notoSansThai(color: Colors.blue, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
