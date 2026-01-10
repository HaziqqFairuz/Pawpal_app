import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_app/models/petsubmission.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';
import 'package:pawpal_app/shared/mydrawer.dart';
import 'package:pawpal_app/view/pet_donation_details_screen.dart';

class PetDonationScreen extends StatefulWidget {
  final User user;
  const PetDonationScreen({super.key, required this.user});

  @override
  State<PetDonationScreen> createState() => _PetDonationScreenState();
}

class _PetDonationScreenState extends State<PetDonationScreen> {
  List<Petsubmission> pets = [];

  String status = "Loading...";
  String selectedType = "All";

  final List<String> petTypes = ["All", "Cat", "Dog", "Other"];

  @override
  void initState() {
    super.initState();
    loadAllPets();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) screenWidth = 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Donate Pet"),
        backgroundColor: const Color(0xFF0B7C44),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: showSearchDialog,
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadAllPets),
        ],
      ),
      drawer: MyDrawer(user: widget.user),
      backgroundColor: const Color(0xFFD3F5ED),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: pets.isEmpty
              ? Center(child: Text(status))
              : ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            /// PET IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                "${MyConfig.baseUrl}/pawpal/assets/pets/pet_${pet.petId}_0.png",
                                width: screenWidth * 0.28,
                                height: screenWidth * 0.22,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: screenWidth * 0.28,
                                      height: screenWidth * 0.22,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.pets, size: 50),
                                    ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// PET INFO
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pet.petName ?? "",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    pet.petType ?? "",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),

                                  /// AGE
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blueGrey.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      pet.petAge ?? "-",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  /// DONATE BUTTON
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(222, 91, 61, 0.941),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PetDonationDetailsScreen(
                                                  pet: pet,
                                                  user: widget.user,
                                                ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Donate",
                                        
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  // ================= API =================

  void loadAllPets() async {
    Uri url = Uri.parse(
      "${MyConfig.baseUrl}/pawpal/api/get_all_pets.php?category=Donation Request",
    );

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);

        if (jsondata['status'] == 'success') {
          setState(() {
            pets = (jsondata['data'] as List)
                .map((e) => Petsubmission.fromJson(e))
                .toList();
            status = "Loaded";
          });
        } else {
          setState(() {
            pets.clear();
            status = "No donation pets found";
          });
        }
      } else {
        setState(() => status = "Server error");
      }
    } catch (e) {
      setState(() => status = "Connection error");
    }
  }

  void loadPetsByType(String type) async {
  String url =
      "${MyConfig.baseUrl}/pawpal/api/get_all_pets.php?category=Donation Request";

  if (type != "All") {
    url += "&type=$type";
  }

  Uri uri = Uri.parse(url);
  var response = await http.get(uri);

  if (response.statusCode == 200) {
    var jsondata = jsonDecode(response.body);
    if (jsondata['status'] == 'success') {
      setState(() {
        pets = (jsondata['data'] as List)
            .map((e) => Petsubmission.fromJson(e))
            .toList();
      });
    } else {
      setState(() {
        pets.clear();
        status = "No donation pets found";
      });
    }
  }
}


  // ================= UI DIALOGS =================

  void showSearchDialog() {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Search Pet"),
        content: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: "Enter pet name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              searchPets(searchController.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Search"),
          ),
        ],
      ),
    );
  }

  void searchPets(String keyword) async {
    Uri url = Uri.parse(
      "${MyConfig.baseUrl}/pawpal/api/get_all_pets.php?search=$keyword",
    );

    var response = await http.get(url);
    var jsondata = jsonDecode(response.body);

    if (jsondata['status'] == 'success') {
      setState(() {
        pets = (jsondata['data'] as List)
            .map((e) => Petsubmission.fromJson(e))
            .toList();
      });
    }
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Filter by Type"),
        content: DropdownButtonFormField<String>(
          value: selectedType,
          items: petTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: (value) {
            selectedType = value!;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              loadPetsByType(selectedType);
              Navigator.pop(context);
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}
