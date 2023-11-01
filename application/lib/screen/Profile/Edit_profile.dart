import 'dart:convert';

import 'package:application/Auth/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:application/Auth/users.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfiles extends StatefulWidget {
  final String name;
  final int id;
  final String image;
  final String imageUrl;

  const EditProfiles({
    required this.name,
    required this.id,
    required this.image,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfiles> createState() => _EditProfilesState();
}

class _EditProfilesState extends State<EditProfiles> {
  late TextEditingController _nameController;
  late int userId;
  bool canUpdate = true;

  @override
  void initState() {
    super.initState();
    userId = widget.id;
    _nameController = TextEditingController(text: widget.name);
  }

  File? _selectedImage;

  Future<void> _updateProfile() async {
    final apiUrl =
        Uri.parse('http://localhost:8081/auth/update/username/$userId');

    try {
      final request = http.MultipartRequest('PUT', apiUrl);

      request.fields['name'] = _nameController.text;

      if (_selectedImage != null) {
        final imageFile = http.MultipartFile.fromBytes(
          'image',
          File(_selectedImage!.path).readAsBytesSync(),
          filename: 'user_image.jpg',
        );
        request.files.add(imageFile);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                'คำเตือน',
                style:
                    GoogleFonts.notoSansThai(color: Colors.red, fontSize: 18),
              ),
              content: Text(
                'การเปลี่ยนแปลงข้อมูล ต้องออกจากระบบ',
                style: GoogleFonts.notoSansThai(
                    fontWeight: FontWeight.w400, fontSize: 16),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'ยกเลิก',
                    style: GoogleFonts.notoSansThai(
                        color: Colors.red, fontSize: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด Alert
                  },
                ),
                TextButton(
                  child: Text(
                    'ออกจากระบบ',
                    style: GoogleFonts.notoSansThai(
                        color: Colors.blue, fontSize: 14),
                  ),
                  onPressed: () {
                    logOut();
                    Navigator.of(context).pop(); // ปิด Alert
                  },
                ),
              ],
            );
          },
        );
      } else if (response.statusCode == 409) {
        final jsonResponse = json.decode(responseBody);
        if (jsonResponse.containsKey('message')) {
          setState(() {
            canUpdate = false;
          });
        } else {
          print("Update Failed with Status Code: ${response.statusCode}");
          print("Response Body: $responseBody");
        }
      }
    } catch (e) {
      print("Error updating profile: $e");
    }
  }

  Future<void> _updateImage() async {
    final apiUrl =
        Uri.parse('http://localhost:8081/auth/update/userimage/$userId');

    try {
      final request = http.MultipartRequest('PUT', apiUrl);

      if (_selectedImage != null) {
        final imageFile = http.MultipartFile.fromBytes(
          'image',
          File(_selectedImage!.path).readAsBytesSync(),
          filename: 'user_image.jpg',
        );
        request.files.add(imageFile);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text(
                'คำเตือน',
                style:
                    GoogleFonts.notoSansThai(color: Colors.red, fontSize: 18),
              ),
              content: Text(
                'การเปลี่ยนแปลงข้อมูล ต้องออกจากระบบ',
                style: GoogleFonts.notoSansThai(
                    fontWeight: FontWeight.w400, fontSize: 16),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'ยกเลิก',
                    style: GoogleFonts.notoSansThai(
                        color: Colors.red, fontSize: 14),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // ปิด Alert
                  },
                ),
                TextButton(
                  child: Text(
                    'ออกจากระบบ',
                    style: GoogleFonts.notoSansThai(
                        color: Colors.blue, fontSize: 14),
                  ),
                  onPressed: () {
                    logOut();
                    Navigator.of(context).pop(); // ปิด Alert
                  },
                ),
              ],
            );
          },
        );
      } else {
        print("Update Image Failed with Status Code: ${response.statusCode}");
        print("Response Body: $responseBody");
      }
    } catch (e) {
      print("Error updating image: $e");
    }
  }

  // void _showAlertDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text("Update Failed"),
  //         content: Text(message),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop(); // ปิดกล่องข้อความแจ้งเตือน
  //             },
  //             child: Text("OK"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _selectedImage = File(image.path);
      }
    });
  }

  Future<void> logOut() async {
    await Users.removeToken();
    await Users.setsignin(false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'ปิด',
                      style: GoogleFonts.notoSansThai(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.notoSansThai(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_selectedImage != null) {
                        _updateImage();
                        _updateProfile();
                      } else {
                        _updateProfile();
                      }
                    },
                    child: Text(
                      'ยืนยัน',
                      style: GoogleFonts.notoSansThai(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD9D9D9),
                        shape: BoxShape.circle,
                      ),
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ClipOval(
                              child: Image.network(
                                widget.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Container(
                          width: 200,
                          child: TextFormField(
                            controller: _nameController,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (!canUpdate)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'ชื่อมีการใช้งานไปแล้ว',
                            style: GoogleFonts.notoSansThai(
                                color: Colors.red, fontSize: 12),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
