import 'package:application/components/custom_icon.dart';
import 'package:application/screen/Search/Notification.dart';
import 'package:application/screen/Search/Cars.dart';
import 'package:application/screen/Search/FromCar.dart';
import 'package:application/screen/Search/Time.dart';
import 'package:application/screen/Search/ToCar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchVan extends StatefulWidget {
  SearchVan({@required this.token, Key? key}) : super(key: key);

  @override
  State<SearchVan> createState() => _SearchVan();

  final token;
}

class _SearchVan extends State<SearchVan> {
  List<dynamic> data = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String FromStation = '';
  String ToStation = '';
  String Time = '';
  String imageUrl = '';

  late String name;
  late String email;
  late String phone;
  late String image;

  bool emailSent = false;

  @override
  void initState() {
    super.initState();
    fetchNotification(context);
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    name = jwtDecodedToken['name'];
    email = jwtDecodedToken['email'];
    phone = jwtDecodedToken['phone'];
    image = jwtDecodedToken['image'];
    imageUrl = 'http://localhost:8081/images/$image';
  }

  Future<void> fetchNotification(BuildContext context) async {
    final api1Url = 'http://localhost:8081/booking/get/booking';

    final api1Response = await http.get(Uri.parse(api1Url));

    if (api1Response.statusCode == 200) {
      final api1Json = jsonDecode(api1Response.body);
      final api1Cars = api1Json['data'];

      final newData = api1Cars.where((notification) {
        return notification['email'] == email;
      }).toList();
      setState(() {
        data = newData;
        // showBrightnessIcon = true;
      });

      // checkTimeForNotification();
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool showContainer = false;

  bool isNotificationTime(String time, String date) {
    final currentTime = DateTime.now();
    final timeParts = time.split(':');

    final carTime = DateTime(currentTime.year, currentTime.month,
        currentTime.day, int.parse(timeParts[0]), int.parse(timeParts[1]));

    final notificationTime = carTime.subtract(Duration(minutes: 30));

    return currentTime.isBefore(carTime) &&
        currentTime.isAfter(notificationTime);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void sendEmail() async {
    String username = 'tonzaza181@gmail.com';
    String password = 'wbrgetarxpgdjrvv';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'VINVAN')
      ..recipients.add(email)
      ..subject = 'รถตู้จะออกในอีก 15 นาที'
      ..text = 'เตรียมตัวสำหรับการเดินทางของคุณ';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  bool showBrightnessIcon = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 92, 36, 212),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              margin: EdgeInsets.only(top: size.height * 0.25),
              color: Color(0xFFF2F4F8),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.black,
                            child: ClipOval(
                              child: Image.network(
                                imageUrl,
                                width: 50.0,
                                height: 50.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomIconButton(
                                    icon: Stack(
                                      children: [
                                        const Icon(Icons
                                            .notifications_active_outlined),
                                        if (showBrightnessIcon &&
                                            data.isNotEmpty)
                                          Positioned(
                                            left: 14.0,
                                            bottom: 15,
                                            child: Icon(
                                              Icons.brightness_1,
                                              color: Colors.red,
                                              size: 10.0,
                                            ),
                                          )
                                        // Positioned(
                                        //   right: 0,
                                        //   bottom: 8,
                                        //   child: Container(
                                        //     padding: const EdgeInsets.all(3),
                                        //     decoration: const BoxDecoration(
                                        //       shape: BoxShape.circle,
                                        //       color: Colors.red,
                                        //     ),
                                        //     child: Text(
                                        //       '${data.length}',
                                        //       style: const TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 10,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        showBrightnessIcon = false;
                                      });
                                      await Navigator.push(
                                        context,
                                        PageTransition(
                                            child: NotificationPage(data: data),
                                            type:
                                                PageTransitionType.bottomToTop),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          '🎊 $name',
                          style: GoogleFonts.notoSansThai(
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // _HeaderSection(),
                  // _SearchCard(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.lightBlue.withAlpha(50))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                FontAwesomeIcons.search,
                                size: 20,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            TextButton(
                              onPressed: () async {
                                final selectedStation = await Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const FromCar(),
                                      type: PageTransitionType.bottomToTop),
                                );
                                if (selectedStation != null) {
                                  //print('Selected station: $selectedStation');
                                  setState(() {
                                    FromStation = selectedStation;
                                  });
                                }
                              },
                              child: Text(
                                // readOnly: true,
                                // decoration: const InputDecoration(
                                //   border: InputBorder.none,
                                //   hintText: 'สถานีต้นทาง',
                                // ),
                                // style: GoogleFonts.notoSansThai(
                                //     color: Colors.indigo),

                                'สถานีต้นทาง: $FromStation',
                                style: GoogleFonts.notoSansThai(
                                    color: Colors.indigo),
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 0.1,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                FontAwesomeIcons.search,
                                size: 20,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            TextButton(
                              onPressed: () async {
                                final selectedStation = await Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const toCar(),
                                      type: PageTransitionType.bottomToTop),
                                );
                                if (selectedStation != null) {
                                  print('Selected station: $selectedStation');
                                  setState(() {
                                    ToStation = selectedStation;
                                  });
                                }
                              },
                              child: Text(
                                'สถานีปลายทาง: $ToStation',
                                style: GoogleFonts.notoSansThai(
                                    color: Colors.indigo),
                              ),
                              //controller: locationTextController,
                            ),
                          ],
                        ),
                        const Divider(
                          color: Colors.white,
                          thickness: 0.1,
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                FontAwesomeIcons.clock,
                                size: 20,
                                color: Colors.indigo,
                              ),
                            ),
                            const SizedBox(width: 20.0),
                            TextButton(
                              onPressed: () async {
                                final selectedStation = await Navigator.push(
                                  context,
                                  PageTransition(
                                      child: const TimeSelect(),
                                      type: PageTransitionType.bottomToTop),
                                );
                                if (selectedStation != null) {
                                  print('Selected station: $selectedStation');
                                  setState(() {
                                    Time = selectedStation;
                                  });
                                }
                              },
                              child: Text(
                                'เลือกเวลา: ${Time.isEmpty ? '' : Time.substring(0, 5)}',
                                style: GoogleFonts.notoSansThai(
                                    color: Colors.indigo),
                              ),
                              //controller: locationTextController,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: Cars(
                                    fromStation: FromStation,
                                    toStation: ToStation,
                                    time: Time,
                                    token: widget.token,
                                  ),
                                  type: PageTransitionType.bottomToTop),
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 92, 36, 212)),
                            elevation: MaterialStateProperty.all(0.0),
                            minimumSize:
                                MaterialStateProperty.all(const Size(300, 50)),
                          ),
                          child: Text(
                            'Search',
                            style: GoogleFonts.notoSans(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),

                  const Divider(color: Colors.grey, thickness: 0.4, height: 20),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(220, 0, 0, 0),
                    child: Text(
                      'รอบรถกำลังมาถึง',
                      style: GoogleFonts.notoSansThai(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500]),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final car = data[index];
                        final time = car['time'];
                        final date = car['date'];
                        final formattedTime = time.substring(0, 5);
                        final dateFormatter = DateFormat('yyyy/MM/dd');
                        final dateStr = date; // เปลี่ยนเป็นรูปแบบวันที่ของคุณ
                        final formatterdate = dateFormatter.parse(dateStr);

                        // ตรวจสอบเงื่อนไขเวลาและแสดงข้อมูลเฉพาะเวลาที่ตรง
                        if (isNotificationTime(time, date) &&
                            isSameDay(DateTime.now(), formatterdate)) {
                          final fromstation = car['fromstation'];
                          final tostation = car['tostation'];
                          final number = car['number'];
                          final seat = car['seat'];
                          final id = car['id'];
                          sendEmail();

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              width: 330,
                              height: 191,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.indigo.withAlpha(50),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    )
                                  ]),
                              child: InkWell(
                                onTap: () {},
                                child: Stack(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ID : $id',
                                          style: GoogleFonts.notoSansThai(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 20,
                                    left: 273,
                                    child: Text(
                                      'สาย: $number',
                                      style: GoogleFonts.notoSansThai(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
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
                                    left: 285,
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
                                    left: 283,
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
                                    left: 300,
                                    top: 100,
                                    child: Text(
                                      'วันที่',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF9B9999),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 260,
                                    top: 120,
                                    child: Text(
                                      '$date',
                                      style: GoogleFonts.notoSansThai(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 155,
                                    left: 20,
                                    child: Container(
                                      width: 289,
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
                                  Positioned(
                                    top: 165,
                                    left: 20,
                                    child: Text(
                                      'ที่นั่ง: $seat',
                                      style: GoogleFonts.notoSansThai(
                                        color: const Color(0xFF2D3D50),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 163,
                                    left: 240,
                                    child: Container(
                                      width: 90,
                                      height: 20,
                                      decoration: ShapeDecoration(
                                        color: const Color.fromARGB(
                                            255, 253, 166, 166),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Ticket Coming',
                                          style: GoogleFonts.notoSansThai(
                                            color: const Color.fromARGB(
                                                255, 92, 36, 212),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
