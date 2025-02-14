
import 'package:chinese_bazaar/Core/Helper/LegalDocuments.dart';
import 'package:chinese_bazaar/data/sources/login_api.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget{
  const RegisterPage({super.key});
  
  @override
  _RegisterPageState  createState() => _RegisterPageState();
}
class _RegisterPageState extends State<RegisterPage>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isKvkkChecked = false;
  bool _isMembershipChecked = false;
  
  void _showAgreementDialog(String title, String content) {
  showDialog(
    context: context,
    builder: (context) {
      const closeText = "Kapat";
      return AlertDialog(
        title: Text(title),
        content: SizedBox(
          height: 200, // Set a fixed height here
          child: SingleChildScrollView(child: Text(content)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(closeText),
          ),
        ],
      );
    },
  );
}
void _showDialog(String title, String content) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      );
    },
  );
}
String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Şifreyi tekrar giriniz";
    }
    if (value != _passwordController.text) {
      return "Şifreler eşleşmiyor";
    }
    return null;
  }
String? _emailValidatorFunc(String? value) {
  if (value == null || value.isEmpty) {
    return "E-posta adresi giriniz";
  }
  // E-posta formatı doğrulaması
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return "Geçerli bir e-posta adresi giriniz";
  }
  return null;  // Eğer geçerliyse null döner
}




 
  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    const registerTitle = "Hesap Oluştur";
    var createAccountText = "Hesap Oluşturun";
    const labelEmail = "Email";
    const labelPassword = "Şifre Giriniz";
    const passwordValidator = "Şifre en az 6 haneli olmalı";
    const labelPasswordAgain = "Şifreyi Tekrar Giriniz";
    
  const membershipInformation = "Üyelik Sözleşmesini okudum ve kabul ediyorum.";
    const kvkkInformation = "Kvkk metnini okudum ve Kabul ediyorum";
    const kvkkInformationTitle = "KİŞİSEL VERİLERİN KORUNMASI VE İŞLENMESİNE İLİŞKİN AYDINLATMA METNİ";
    const membershipInformationTitle = "ÜYELİK SÖZLEŞMESİ";
    const register = "Hesap oluştur";
    return Scaffold(
      appBar: AppBar(
        title: const Text(registerTitle),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color:Colors.black),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text(createAccountText,
              style: TextStyle(fontSize: screenWidth *0.05,
              fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.05),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: _labelFirstName,border: OutlineInputBorder()),
              //   validator: (value) => value!.isEmpty ? _firstNameValidator : null,
              // ),
              // SizedBox(height: screenHeight * 0.02),

              // TextFormField(
              //   decoration: const InputDecoration(labelText: _labelLastName,border: OutlineInputBorder()),
              //   validator: (value) => value!.isEmpty ? _lastNameValidator : null,
              // ),
              // SizedBox(height: screenHeight * 0.02),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: labelEmail,border: OutlineInputBorder()),
                validator: _emailValidatorFunc,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _passwordController,
                 decoration: const InputDecoration(labelText: labelPassword,
                 border: OutlineInputBorder()),
                 obscureText: true,
                 validator: (value) => value!.length < 6 ? passwordValidator : null,
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                controller: _confirmPasswordController,
                 decoration: const InputDecoration(labelText: labelPasswordAgain,
                 border: OutlineInputBorder()),
                 obscureText: true,
                 
                 validator: _confirmPasswordValidator,
              ),
              SizedBox(height: screenHeight * 0.02),
              CheckboxListTile(
                title: GestureDetector(
                  onTap: () => _showAgreementDialog(kvkkInformationTitle,LegalDocuments.kvkkMetni),
                  child: const Text(kvkkInformation, style: TextStyle(decoration: TextDecoration.underline,color:Colors.black),
                ),
                ),
                value: _isKvkkChecked,
                onChanged: (value) => setState(() => _isKvkkChecked = value!),
              ),
              CheckboxListTile(
                title: GestureDetector(
                  onTap: () => _showAgreementDialog(membershipInformationTitle,LegalDocuments.uyeSozlesmesi),
                  child: const Text(membershipInformation, style: TextStyle(decoration: TextDecoration.underline,color:Colors.black),
                ),
                ),
                value: _isMembershipChecked,
                onChanged: (value) => setState(() => _isMembershipChecked = value!),
              ),
              SizedBox(height: screenHeight * 0.02),
         ElevatedButton(
  onPressed: (_isKvkkChecked && _isMembershipChecked)
      ? () async {
          if (_formKey.currentState!.validate()) {
            var registerApi = AuthApi();
            final response = await registerApi.register(_emailController.text, _passwordController.text);
            if(response != null)
            {
              if(response.containsKey('userAlreadyExist')){
                String userAlreadyExist = response["userAlreadyExist"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(userAlreadyExist)));
            }
            else if(response.containsKey('successMessage')){
              String successMessage = response["successMessage"];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(successMessage)));
                Navigator.pop(context);
            }
            else{
              String errorMessage = response['message'];
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
            }
            }
            
          }
        }
      : null,
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    minimumSize: Size(screenWidth * 0.8, screenHeight * 0.06),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  child: Text(
    register,
    style: TextStyle(
      fontSize: screenWidth * 0.05,
      fontWeight: FontWeight.bold,
      color: Colors.black38,
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