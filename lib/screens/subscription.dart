import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflix/screens/qr_payment_screen.dart';

class SubscriptionScreen extends StatelessWidget {
  final List<Map<String, dynamic>> plans = [
    {
      "name": "Mobile",
      "price": "₹149 INR/month",
      "features": [
        "Unlimited ad-free movies, TV shows, and mobile games",
        "Watch on 1 phone or tablet at a time",
        "Watch in 480p (SD)",
        "Download on 1 phone or tablet at a time",
      ],
    },
    {
      "name": "Basic",
      "price": "₹199 INR/month",
      "features": [
        "Unlimited ad-free movies, TV shows, and mobile games",
        "Watch on 1 supported device at a time",
        "Watch in 720p (HD)",
        "Download on 1 supported device at a time",
      ],
    },
    {
      "name": "Standard",
      "price": "₹499 INR/month",
      "features": [
        "Unlimited ad-free movies, TV shows, and mobile games",
        "Watch on 2 supported devices at a time",
        "Watch in 1080p (Full HD)",
        "Download on 2 supported devices at a time",
      ],
    },
    {
      "name": "Premium",
      "price": "₹649 INR/month",
      "features": [
        "Unlimited ad-free movies, TV shows, and mobile games",
        "Watch on 4 supported devices at a time",
        "Watch in 4K (Ultra HD) + HDR",
        "Download on 6 supported devices at a time",
        "Netflix spatial audio",
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Plan",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Color.fromARGB(255, 33, 0, 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Pick the best plan for you",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: plans.map((plan) {
                  return _buildSubscriptionCard(context, plan);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(
      BuildContext context, Map<String, dynamic> plan) {
    return GestureDetector(
      onTap: () => _showPurchaseDialog(context, plan["name"]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          alignment: Alignment.center,
          width: 330,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.redAccent, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan["name"],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                plan["price"],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...plan["features"].map<Widget>((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  // Function to show AlertDialog
  void _showPurchaseDialog(BuildContext context, String planName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            "Confirm Purchase",
            style: TextStyle(
                color: Colors.red.shade400, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Do you want to purchase the $planName membership?",
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRPaymentScreen(planName: planName),
                  ),
                );
                _executePurchaseFunction(context, planName);
              },
              child: const Text("Yes", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _executePurchaseFunction(BuildContext context, String planName) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'subscription': planName,
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Subscription updated to $planName!")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Failed to update subscription: $e")),
        );
      }
    }
  }
}
