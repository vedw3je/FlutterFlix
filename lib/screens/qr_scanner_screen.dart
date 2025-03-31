import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;

class QRScannerScreen extends StatefulWidget {
  final String planName;
  const QRScannerScreen({Key? key, required this.planName}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController scannerController = MobileScannerController();
  final ImagePicker _picker = ImagePicker();

  void _processPayment(BuildContext context, String scannedData) {
    if (scannedData.contains("PAYMENT_LINK_${widget.planName}_123")) {
      Fluttertoast.showToast(
          msg: "✅ Payment Successful for ${widget.planName}!",
          backgroundColor: Colors.green);
      Navigator.pop(context); // Close scanner
    } else {
      Fluttertoast.showToast(
          msg: "❌ Invalid QR Code", backgroundColor: Colors.red);
    }
  }

  Future<void> _pickQRCodeFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      Fluttertoast.showToast(
          msg: "No image selected", backgroundColor: Colors.red);
      return;
    }

    final mlkit.InputImage inputImage =
        mlkit.InputImage.fromFilePath(image.path);
    final mlkit.BarcodeScanner barcodeScanner = mlkit.BarcodeScanner();

    try {
      final List<mlkit.Barcode> barcodes =
          await barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        String qrData = barcodes.first.rawValue ?? "Invalid QR Code";
        Fluttertoast.showToast(
            msg: "Scanned: $qrData", backgroundColor: Colors.green);
        Navigator.pop(context);
        Navigator.pop(context);
        // Process the QR data
      } else {
        Fluttertoast.showToast(
            msg: "No QR code found!", backgroundColor: Colors.red);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error scanning QR", backgroundColor: Colors.red);
    } finally {
      barcodeScanner.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Scan QR Code")),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: scannerController,
              onDetect: (barcode) {
                if (barcode.raw != null) {
                  _processPayment(context, barcode.raw.toString()!);
                }
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: _pickQRCodeFromGallery,
            icon: const Icon(Icons.photo),
            label: const Text("Pick QR from Gallery"),
          ),
        ],
      ),
    );
  }
}
