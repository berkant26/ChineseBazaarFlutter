import 'package:chinese_bazaar/Core/Services/auth_service.dart';
import 'package:chinese_bazaar/data/sources/login_api.dart';
import 'package:chinese_bazaar/presentation/pages/UserAddress.dart';
import 'package:chinese_bazaar/presentation/pages/admin/AdminPanelPage.dart';
import 'package:chinese_bazaar/presentation/pages/auth/login_page.dart';
import 'package:chinese_bazaar/presentation/pages/displayUserAddress.dart';
import 'package:chinese_bazaar/presentation/pages/main_page.dart';
import 'package:chinese_bazaar/presentation/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({super.key});
  

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  Future<void> _signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token'); // Remove the token to log out
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const MainPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && !snapshot.data!) {
          // If the user is not logged in, show a "Giriş Yap" button
          return Scaffold(
            appBar: AppBar(
              title: const Text("Hesabım"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Hesap bilgilerinizi görüntülemek için lütfen giriş yapın.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Giriş Yap"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Kayıt Ol"),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // If the user is logged in, show the account page with buttons
        return FutureBuilder<bool>(
          future:  AuthApi().canAddProduct(),
          builder: (context, adminSnapshot) {
            if (adminSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Log the result of the permission check
            if (adminSnapshot.hasData) {
             final logger = Logger();

              logger.d("User has admin panel access: ${adminSnapshot.data}");
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text("Hesabım"),
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Hoş geldiniz!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () => _signOut(context),
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text("Çıkış Yap"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Add your order action here
                        },
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text("Siparişlerim"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) =>  AddressDisplayPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_location_alt),
                        label: const Text("Adres Bilgilerim"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Show the "Admin Panel" button if the user is an admin
                      if (adminSnapshot.hasData && adminSnapshot.data!)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(pageBuilder: (context,animation,secondaryAnimation) => const AdminPanelPage()),
                            );
                          },
                          child: const Text("Admin Panel"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
