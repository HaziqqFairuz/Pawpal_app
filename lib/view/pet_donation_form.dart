import 'package:flutter/material.dart';
import 'package:pawpal_app/models/petsubmission.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/view/payment.dart';

class PetDonationForm extends StatefulWidget {
  final Petsubmission pet;
  final User user;

  const PetDonationForm({super.key, required this.pet, required this.user});

  @override
  State<PetDonationForm> createState() => _PetDonationFormState();
}

class _PetDonationFormState extends State<PetDonationForm> {
  final _formKey = GlobalKey<FormState>();
  String donationType = "Food";
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make a Donation"),
        backgroundColor: const Color(0xFF0B7C44),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                widget.pet.petName ?? "Donate to Pet",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: donationType,
                items: ["Food", "Medical", "Money"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    donationType = val!;
                    amountController.clear();
                    descriptionController.clear();
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Donation Type",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (donationType == "Money")
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter Amount (RM)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter amount";
                    if (double.tryParse(value) == null) return "Enter a valid number";
                    return null;
                  },
                )
              else
                TextFormField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Enter Description ($donationType)",
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter description";
                    return null;
                  },
                ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : goToPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(222, 91, 61, 0.941),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: Text(isSubmitting ? "Processing..." : "Donate"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToPayment() {
    if (!_formKey.currentState!.validate()) return;

    if (donationType == "Money") {
      int credits = int.tryParse(amountController.text) ?? 0;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(
            user: widget.user,
            credits: credits,
            petId: widget.pet.petId.toString(), // Passing petId for database record
          ),
        ),
      );
    } else {
      // Handle Non-Money donations (Food/Medical) here via your API
      print("Direct donation logic for $donationType");
    }
  }
}