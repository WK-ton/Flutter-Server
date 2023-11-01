import 'package:application/Auth/Login.dart';
import 'package:application/Auth/users.dart';
import 'package:application/screen/Profile/Edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  final token;

  const Profile({@required this.token, Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> logOut() async {
    await Users.removeToken();
    await Users.setsignin(false);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  late String name;
  late String email;
  late String phone;
  late int id;
  late String image;
  String token = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();

    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    id = jwtDecodedToken['userId'] ?? 0;
    name = jwtDecodedToken['name'];
    email = jwtDecodedToken['email'];
    phone = jwtDecodedToken['phone'];
    image = jwtDecodedToken['image'];
    imageUrl = 'http://localhost:8081/images/$image';
    // print('Decoded Token: $jwtDecodedToken');
  }

  Future<void> _navigateToEditProfile() async {
    final updatedName = await Navigator.push(
      context,
      PageTransition(
        child:
            EditProfiles(name: name, id: id, image: image, imageUrl: imageUrl),
        type: PageTransitionType.bottomToTop,
      ),
    );

    if (updatedName != null) {
      setState(() {
        name = updatedName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.supervised_user_circle),
        backgroundColor: const Color.fromARGB(255, 92, 36, 212),
        titleTextStyle:
            GoogleFonts.notoSansThai(color: Colors.white, fontSize: 18),
        title: Text('$name 👋'),
        shadowColor: Colors.black,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: Color(0xFFF2F4F8)),
        child: Stack(children: [
          Positioned(
            top: 160,
            left: 160,
            child: Container(
                width: 70,
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: TextButton(
                    onPressed: () {
                      _navigateToEditProfile();
                      // logOut();
                    },
                    child: Text(
                      'แก้ไข',
                      style:
                          GoogleFonts.notoSansThai(color: Colors.indigoAccent),
                    ))),
          ),
          Positioned(
            left: 150,
            top: 50,
            child: Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: image.isNotEmpty
                    ? Image.network(
                        imageUrl, // Use Image.memory to load image from memory
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.camera_alt,
                        size: 40, color: Colors.grey),
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 240,
            child: Container(
              width: 330,
              height: 50,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        '$name',
                        style: GoogleFonts.notoSansThai(color: Colors.black54),
                      )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.verified_user),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 330,
            child: Container(
              width: 330,
              height: 50,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      '$email',
                      style: GoogleFonts.notoSansThai(color: Colors.black54),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.email))
                ],
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 420,
            child: Container(
              width: 330,
              height: 50,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text(
                      '$phone',
                      style: GoogleFonts.notoSansThai(color: Colors.black54),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.phone))
                ],
              ),
            ),
          ),
          Positioned(
            left: 29,
            top: 216,
            child: Text(
              'ชื่อ',
              style: GoogleFonts.notoSansThai(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            left: 29,
            top: 306,
            child: Text(
              'อีเมล',
              style: GoogleFonts.notoSansThai(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
            left: 29,
            top: 396,
            child: Text(
              'เบอร์โทร',
              style: GoogleFonts.notoSansThai(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Positioned(
              top: 525,
              left: 250,
              child: Container(
                width: 110,
                height: 40,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: TextButton(
                  onPressed: () {
                    logOut();
                  },
                  child: Text(
                    'ออกจากระบบ',
                    style: GoogleFonts.notoSansThai(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ))
        ]),
      ),
    );
  }
}
