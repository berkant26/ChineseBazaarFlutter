import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    var createAnAccount = ' Hesap Oluşturun';
    const String labelEmail = 'Email';
    const String labelPassword = 'Password';
    const String labelRegister ='Hesap oluştur';
    const String confirmPassword = 'Şifreyi Doğrula';
    return Scaffold(
      appBar: AppBar(
        title: const Text(labelRegister),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),

              // Title
              Text(
                createAnAccount,
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // Email Field
              const TextField(
                decoration: InputDecoration(
                  labelText: labelEmail,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Password Field
              const TextField(
                decoration: InputDecoration(
                  labelText: labelPassword,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.02),

              // Confirm Password Field
              const TextField(
                decoration: InputDecoration(
                  labelText: confirmPassword,
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: screenHeight * 0.04),

              // Register Button
              ElevatedButton(
                onPressed: () {
                  // Handle registration logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  labelRegister,
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
