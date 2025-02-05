import 'package:chinese_bazaar/data/sources/login_api.dart';
import 'package:chinese_bazaar/presentation/pages/admin/AdminPanelPage.dart';
import 'package:chinese_bazaar/presentation/pages/auth/login_page.dart';
import 'package:chinese_bazaar/presentation/pages/displayUserAddress.dart';
import 'package:chinese_bazaar/presentation/pages/auth/register_page.dart';
import 'package:flutter/material.dart';
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
   Navigator.pushAndRemoveUntil(
    context,
    PageRouteBuilder(
      settings: RouteSettings(name: "/myAccountPage"), // Sayfa ismini ayarla
      pageBuilder: (context, animation, secondaryAnimation) => const MyAccountPage(),
    ),
    (route) => false,
  );
  }

  @override
  @override
Widget build(BuildContext context) {
  return FutureBuilder<bool>(
    future: _checkLoginStatus(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator()); // Scaffold kaldırıldı
      }

      if (snapshot.hasData && !snapshot.data!) {
        // If the user is not logged in, show login options
        return Center( // Scaffold yerine sadece body
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hesap bilgilerinizi görüntülemek için lütfen giriş yapın.",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => LoginPage()),
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
                       PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => RegisterPage()),
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
        );
      }

      // If the user is logged in, show account details
      return FutureBuilder<bool>(
        future: AuthApi().canAddProduct(),
        builder: (context, adminSnapshot) {
          if (adminSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Scaffold kaldırıldı
          }

          return Center( // Scaffold yerine sadece body
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "Hoş geldin ${AuthApi().getUserName()}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    onPressed: () {},
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
                          pageBuilder: (context, animation, secondaryAnimation) => AddressDisplayPage(),
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
                  if (adminSnapshot.hasData && adminSnapshot.data!)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const AdminPanelPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.admin_panel_settings),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      label: const Text("Yönetici Paneli",style: TextStyle(color: Colors.red),),
                    ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
}