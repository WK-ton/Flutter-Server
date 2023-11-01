import 'package:application/components/Bottom_tap.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart' as path;

import 'package:awesome_dialog/awesome_dialog.dart';

class QRCodePaymentScreen extends StatefulWidget {
  final String qrCodeData;
  final String selectedSeats;
  final String number;
  final String fromStation;
  final String toStation;
  final String time;
  final String date;
  final String road;
  final String name;
  final String email;
  final String phone;
  final String token;
  final int selectedRow;
  final int selectedCol;
  final int totalCost;

  const QRCodePaymentScreen(
      {required this.qrCodeData,
      required this.selectedSeats,
      required this.number,
      required this.fromStation,
      required this.toStation,
      required this.time,
      required this.date,
      required this.road,
      required this.token,
      required this.name,
      required this.email,
      required this.phone,
      required this.selectedRow,
      required this.selectedCol,
      required this.totalCost,
      Key? key})
      : super(key: key);

  @override
  State<QRCodePaymentScreen> createState() => _QRCodePaymentScreenState();
}

class _QRCodePaymentScreenState extends State<QRCodePaymentScreen> {
  late ImagePicker _imagePicker;
  XFile? _selectedImage;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _showAlertDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'โปรดใส่ข้อมูล',
            style: GoogleFonts.notoSansThai(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: GoogleFonts.notoSansThai(fontSize: 16),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'ตกลง',
                style: GoogleFonts.notoSansThai(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onConfirmBooking() async {
    if (_selectedImage == null ||
        _selectedDate == null ||
        _selectedTime == null) {
      _showAlertDialog(context, 'กรุณาใส่ข้อมูลให้ครบถ้วน');
      return; // Stop execution if data is missing
    }

    bool isDuplicate = await _checkDuplicateData();

    if (isDuplicate) {
      _showAlertDialog(context, 'ข้อมูลนี้ถูกบันทึกแล้ว');
      return; // Stop execution if data is duplicate
    }

    List<int> imageBytes = File(_selectedImage!.path).readAsBytesSync();
    String imageBase64 = base64Encode(imageBytes);

    String timeString = _selectedTime!.format(context);
    var stream = _selectedImage!.openRead();
    var length = await _selectedImage!.length();

    var uri = Uri.parse('http://localhost:8081/booking/create/cars');
    final int payment = widget.totalCost;
    final request = http.MultipartRequest('POST', uri)
      ..headers['Content-Type'] = 'multipart/form-data'
      ..fields['fromstation'] = widget.fromStation
      ..fields['tostation'] = widget.toStation
      ..fields['number'] = widget.number
      // ..fields['seat'] = widget.selectedSeats
      ..fields['name'] = widget.name
      ..fields['email'] = widget.email
      ..fields['phone'] = widget.phone
      ..fields['date'] = widget.date
      ..fields['time'] = widget.time
      ..fields['road'] = widget.road
      ..fields['amount'] = jsonEncode(payment)
      ..fields['time_image'] = timeString
      ..fields['date_image'] = _selectedDate!.toLocal().toString().split(' ')[0]
      ..fields['row'] = widget.selectedRow.toString()
      ..fields['col'] = widget.selectedCol.toString()
      ..fields['seat'] = widget.selectedSeats
      ..files.add(http.MultipartFile(
        'image',
        stream,
        length,
        filename: path.basename(_selectedImage!.path),
      ));

    final response = await request.send();

    if (response.statusCode == 200) {
      String imageFilename = await response.stream.bytesToString();
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: false,
        title: 'Success',
        desc: 'กรุณารอตั๋ว 2 - 5 นาที',
        btnOkOnPress: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomTab(
                        token: widget.token,
                      )));
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        },
      ).show();
    } else {
      print('Booking failed: ${response.reasonPhrase}');
    }
  }

  Future<bool> _checkDuplicateData() async {
    // For now, let's assume it's not duplicate for testing purposes
    return false;
  }

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: size.width,
            height: size.height,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Color(0xFFF2F4F8),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 50,
                  right: 335,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_outlined,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  left: 90,
                  top: 100,
                  child: Container(
                    width: 210,
                    height: 210,
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Positioned(
                  left: 122,
                  top: 148,
                  child: Container(
                    width: 146,
                    height: 146,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(
                              base64Decode(widget.qrCodeData
                                  .split(',')[1]), // Decode base64 image data
                            ),
                            fit: BoxFit.cover)),
                  ),
                ),
                Positioned(
                  left: 127,
                  top: 125,
                  child: Text(
                    'โปรดแสกนคิวอาร์โค้ด',
                    style: GoogleFonts.notoSansThai(
                        color: const Color(0xFF4C2CA4),
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Positioned(
                  top: 330,
                  left: 90,
                  child: Stack(
                    children: [
                      Container(
                        width: 210,
                        height: 250,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 16, 0, 0),
                        child: Text(
                          "แนปสลิปชำระเงิน",
                          style: GoogleFonts.notoSansThai(
                              color: const Color(0xFF4C2CA4),
                              fontSize: 13,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      if (_selectedImage != null)
                        Positioned(
                          top: 45,
                          left: 25,
                          right: 25,
                          bottom: 15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (_selectedImage ==
                          null) // Display default image or placeholder
                        Positioned(
                          top: 45,
                          left: 25,
                          right: 25,
                          bottom: 15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Colors.grey, // Placeholder color
                              child: const Center(
                                child: Icon(
                                  Icons
                                      .image_search_outlined, // You can replace this with any other icon or widget
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 575,
                  left: 166,
                  child: TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      'เลือกรูปภาพ',
                      style: GoogleFonts.notoSansThai(
                          color: const Color(0xFF0093FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Positioned(
                  top: 630,
                  left: 29,
                  child: Text(
                    'เลือกวันที่ตรงกับสลีป',
                    style: GoogleFonts.notoSansThai(
                        color: const Color(0xFF4C2CA4),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Stack(
                  children: [
                    Positioned(
                      top: 650,
                      left: 29,
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    if (_selectedDate != null)
                      Positioned(
                        top: 660,
                        left: 50,
                        child: Text(
                          '${_selectedDate!.toLocal().toString().split(' ')[0]}',
                          style: GoogleFonts.notoSansThai(fontSize: 14),
                        ),
                      )
                  ],
                ),
                Positioned(
                  top: 680,
                  left: 50,
                  child: TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'เลือกวันที่',
                      style: GoogleFonts.notoSansThai(
                          color: const Color(0xFF0093FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Positioned(
                  top: 630,
                  left: 240,
                  child: Text(
                    'เลือกเวลาตรงกับสลีป',
                    style: GoogleFonts.notoSansThai(
                        color: const Color(0xFF4C2CA4),
                        fontSize: 12,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Stack(
                  children: [
                    Positioned(
                      top: 650,
                      left: 240,
                      child: Container(
                        width: 120,
                        height: 40,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    if (_selectedTime != null)
                      Positioned(
                        top: 660,
                        left: 255,
                        child: Text(
                          'เวลา: ${_selectedTime!.format(context)}',
                          style: GoogleFonts.notoSansThai(fontSize: 14),
                        ),
                      )
                  ],
                ),
                Positioned(
                  top: 680,
                  left: 265,
                  child: TextButton(
                    onPressed: () => _selectTime(context),
                    child: Text(
                      'เลือกเวลา',
                      style: GoogleFonts.notoSansThai(
                          color: const Color(0xFF0093FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                Positioned(
                  top: 730,
                  left: 20,
                  child: TextButton(
                    onPressed: _onConfirmBooking,
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
                          'ยืนยันการจอง',
                          style: GoogleFonts.notoSansThai(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
