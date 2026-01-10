import 'package:flutter/material.dart';
import 'package:pawpal_app/models/petsubmission.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';
import 'package:pawpal_app/view/pet_donation_form.dart'; // import the form

class PetDonationDetailsScreen extends StatefulWidget {
  final Petsubmission pet;
  final User user;

  const PetDonationDetailsScreen({
    super.key,
    required this.pet,
    required this.user,
  });

  @override
  State<PetDonationDetailsScreen> createState() =>
      _PetDonationDetailsScreenState();
}

class _PetDonationDetailsScreenState extends State<PetDonationDetailsScreen> {
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

            /// Pet Name
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

            /// Donate Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PetDonationForm(pet: widget.pet, user: widget.user),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(222, 91, 61, 0.941),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text("Make a Donation"),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable info row
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
}
