import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_app/models/petsubmission.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';

class PetDetailsScreen extends StatefulWidget {
  final Petsubmission pet;
  final User user;

  const PetDetailsScreen({super.key, required this.pet, required this.user});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pet = widget.pet;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Details"),
        backgroundColor: const Color(0xFF0B7C44),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🖼 Pet Image
            Image.network(
              "${MyConfig.baseUrl}/pawpal/assets/pets/pet_${pet.petId}_0.png",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 100),
            ),

            const SizedBox(height: 16),

            /// 🐾 Pet Name
            Text(
              pet.petName ?? "",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            infoRow("Type", pet.petType),
            infoRow("Gender", pet.petGender),
            infoRow("Age", pet.petAge),
            infoRow("Health", pet.petHealth),
            infoRow("Category", pet.category),
            infoRow("Description", pet.description),
            infoRow("Posted By", pet.postedBy),

            const SizedBox(height: 24),

            /// 🟢 Request Button
            ElevatedButton(
              onPressed: showAdoptionDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(222, 91, 61, 0.941),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Request to Adopt"),
            ),
          ],
        ),
      ),
    );
  }

  ///  Reusable info row
  Widget infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, color: Colors.black),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value ?? "-"),
          ],
        ),
      ),
    );
  }

  void submitAdoptionRequest() async {
    String message = messageController.text.trim();

    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Motivation message cannot be empty")),
      );
      return;
    }

    Uri url = Uri.parse("${MyConfig.baseUrl}/pawpal/api/insert_adoption.php");

    var response = await http.post(
      url,
      body: {
        "user_id": widget.user.userId.toString(),
        "pet_id": widget.pet.petId.toString(),
        "message": message,
      },
    );

    var jsondata = jsonDecode(response.body);

    if (jsondata['status'] == 'success') {
      Navigator.pop(context, true); // pass 'true' to indicate success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adoption request submitted'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(jsondata['message'] ?? "Failed")));
    }
  }

  /// 📝 Adoption dialog
  void showAdoptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Adoption Request"),
        content: TextField(
          controller: messageController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: "Why do you want to adopt this pet?",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: submitAdoptionRequest,
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
