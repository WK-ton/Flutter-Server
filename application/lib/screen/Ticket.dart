import 'package:application/components/Dash.dart';
import 'package:application/components/Ticket.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:async';

class Ticket extends StatefulWidget {
  const Ticket({@required this.token, Key? key});

  final token;

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  List<dynamic> data = [];
  bool hasNotified = false;

  late String name;
  late String email;
  late String phone;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    name = jwtDecodedToken['name'];
    email = jwtDecodedToken['email'];
    phone = jwtDecodedToken['phone'];
    fetchTicket();
  }

  Future<void> fetchTicket() async {
    final api1Url = 'http://localhost:8081/booking/get/booking';

    final api1Response = await http.get(Uri.parse(api1Url));

    if (api1Response.statusCode == 200) {
      final api1Json = jsonDecode(api1Response.body);
      final api1Cars = api1Json['data'];

      setState(() {
        data = api1Cars.where((notification) {
          return notification['phone'] == phone;
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    data.sort((a, b) {
      final idA = a['id'] as int;
      final idB = b['id'] as int;
      return idB.compareTo(idA);
    });
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.qr_code_2),
        backgroundColor: const Color.fromARGB(255, 92, 36, 212),
        titleTextStyle:
            GoogleFonts.notoSansThai(color: Colors.white, fontSize: 18),
        title: Text(
          'ตั๋วของคุณ',
          style: GoogleFonts.notoSansThai(),
        ),
        shadowColor: Colors.black,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(330, 20, 0, 0),
            child: Text(
              'ตั๋วล่าสุด',
              style: GoogleFonts.notoSansThai(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                if (data.isEmpty) {
                  return const CircularProgressIndicator();
                }
                final car = data[index];
                final fromstation = car['fromstation'];
                final tostation = car['tostation'];
                final number = car['number'];
                final time = car['time'];
                final formattedTime = time.substring(0, 5);
                final id = car['id'];
                final date = car['date'];
                final seat = car['seat'];
                final road = car['road'];
                final name = car['name'];
                final phone = car['phone'];
                final image = car['image'];
                final imageUrl = 'http://localhost:8081/images/$image';

                final apiDate = DateFormat('yyyy/MM/dd').parse(date);

                final currentDate = DateTime.now();

                final isDifferentDate = !DateFormat('yyyy/MM/dd')
                    .format(apiDate)
                    .startsWith(DateFormat('yyyy/MM/dd').format(currentDate));

                final isExpired = currentDate.difference(apiDate).inDays >= 2;

                return isExpired
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            if (!isDifferentDate) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TicketModal(
                                    id: id,
                                    number: number,
                                    fromstation: fromstation,
                                    tostation: tostation,
                                    date: date,
                                    time: formattedTime,
                                    seat: seat,
                                    road: road,
                                    name: name,
                                    phone: phone,
                                    email: email,
                                    image: imageUrl,
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            width: 350,
                            height: 185,
                            decoration: BoxDecoration(
                                color: isDifferentDate
                                    ? Colors.grey[300]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.indigo.withAlpha(50),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 2),
                                    blurRadius: 4,
                                  )
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 8,
                                    child: Text(
                                      'ID : $id',
                                      style: GoogleFonts.notoSansThai(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10, 50, 10, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$fromstation',
                                          style: GoogleFonts.notoSansThai(
                                              color: Colors.black),
                                        ),
                                        Text(
                                          '$tostation',
                                          style: GoogleFonts.notoSansThai(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 30,
                                    left: 148,
                                    child: Text(
                                      'เวลา $formattedTime',
                                      style: GoogleFonts.notoSansThai(
                                          fontSize: 10, color: Colors.black54),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 136,
                                    child: Text(
                                      'วันที่ $date',
                                      style: GoogleFonts.notoSansThai(
                                          fontSize: 10, color: Colors.black54),
                                    ),
                                  ),
                                  Positioned(
                                    top: 90,
                                    left: 40,
                                    child: CustomPaint(
                                      size: const Size(270,
                                          1), // Adjust the width and height of the dashed line
                                      painter:
                                          DashedLinePainter(), // Create a custom Painter for the dashed line
                                    ),
                                  ),
                                  Positioned(
                                    top: 85,
                                    left: 25,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const ShapeDecoration(
                                        color: Color(0xFFFAFAFA),
                                        shape: OvalBorder(
                                          side: BorderSide(
                                              width: 0.15,
                                              color: Color(0xFFBDBABA)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 85,
                                    left: 315,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const ShapeDecoration(
                                        color: Color(0xFF4C2CA4),
                                        shape: OvalBorder(
                                          side: BorderSide(
                                              width: 0.15,
                                              color: Color(0xFFBDBABA)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 120,
                                    child: Container(
                                      width: 350,
                                      decoration: const ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            width: 0.25,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            color: Color(0xFFBBBBBB),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 123,
                                    left: 19,
                                    child: Text(
                                      '$name',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF2D3D50),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 140,
                                    left: 19,
                                    child: Text(
                                      'ที่นั่ง : $seat',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF9B9999),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                      top: 65,
                                      left: 165,
                                      child: Icon(
                                        Icons.business_center_rounded,
                                        color: Colors.grey,
                                      )),
                                  const Positioned(
                                      top: 135,
                                      left: 309,
                                      child: Icon(
                                        Icons.arrow_circle_right_outlined,
                                        color: Colors.indigoAccent,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
