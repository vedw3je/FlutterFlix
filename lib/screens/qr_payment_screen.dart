import 'package:flutter/material.dart';
import 'package:flutterflix/screens/qr_scanner_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRPaymentScreen extends StatelessWidget {
  final String planName;

  const QRPaymentScreen({Key? key, required this.planName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String qrData = "PAYMENT_LINK_${planName}_123"; // Dummy payment link

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Scan to Pay")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              size: 250,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 20),
            const Text("Scan this QR code to complete the payment",
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRScannerScreen(planName: planName),
                  ),
                );
              },
              child: const Text("Scan QR Code After Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
