import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return FadeInDown(
      duration: const Duration(seconds: 1),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flash(
              duration: const Duration(seconds: 5),
              infinite: true,
              child: Text(
                'Açılışa Özel Tüm Ürünlerde %20 İndirim!',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 5),
            // BounceInLeft(
            //   duration: const Duration(seconds: 10),
            //   child: Text(
            //     'Acele Et! Tükenmeden Sipariş Ver.',
            //     style: GoogleFonts.poppins(
            //       fontSize: screenWidth * 0.045,
            //       fontWeight: FontWeight.w500,
            //       color: Colors.yellowAccent,
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
