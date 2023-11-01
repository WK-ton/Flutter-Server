import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationPage extends StatefulWidget {
  final List<dynamic> data;
  NotificationPage({required this.data, super.key});

  @override
  State<NotificationPage> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> data = widget.data;
    data.sort((a, b) => b['id'].compareTo(a['id']));
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
                            fontWeight: FontWeight.w500, color: Colors.black)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                    child: Text(
                      'แจ้งเตือน',
                      style: GoogleFonts.notoSansThai(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final car = data[index];
                    // final time = car['time'];
                    final id = car['id'];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey, // Color of the bottom border
                            width: 0.5, // Width of the bottom border
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.ticket,
                              size: 40,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ตั๋วของคุณได้รับการยืนยันเรียบร้อยแล้ว',
                                  style: GoogleFonts.notoSansThai(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: const Color.fromARGB(
                                          255, 63, 181, 79)),
                                ),
                                Text(
                                  'ID: $id',
                                  style: GoogleFonts.notoSansThai(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
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
}
