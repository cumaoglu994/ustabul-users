import 'package:flutter/material.dart';
import 'package:ustabuul/Controller/auth_controller.dart';
import 'package:ustabuul/auth/register_screen.dart';
import 'package:ustabuul/screens/main_srceen.dart';
import 'package:ustabuul/utils/show_snackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  late String email;

  late String password;
  bool _isLoading = false;
  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formkey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);
      if (res == 'success') {
        // ignore: use_build_context_synchronously
        return Navigator.pushReplacement(context,
            // ignore: non_ant_identifier_names
            MaterialPageRoute(builder: (BuildContext Context) {
          return MainScreen();
        }));
      } else {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        return showSnakBar(context, res);
      }
    } else {
      return showSnakBar(context, 'Lütfen alan boş olmasın');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/a3.png'), // Arka plan resmi buraya
            fit: BoxFit.cover, // Resmin nasıl yerleştirileceğini belirler
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Image.asset(
                      'assets/logos/light_logo_app.png',
                      width: 64, // Genişlik
                      height: 64, // Yükseklik
                      //height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    // Araya boşluk eklemek için kullanabiliriz
                    Text(
                      " Hesabına Giriş Yapın ",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen e-posta alanı boş olmamalıdır';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(labelText: 'E-postayı Girin'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Lütfen şifre alanı boş bırakılmamalıdır';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(labelText: "şifreyi girin"),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    _loginUsers();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Giriş yap',
                              style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        'Bir hesaba ihtiyacınız var mı? ',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            // ignore: non_ant_identifier_names
                            MaterialPageRoute(builder: (BuildContext Context) {
                              return RegisterScreen();
                            }),
                          );
                        },
                        child: Text(
                          "Kayıt Ol",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
