import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_app/models/petsubmission.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';
import 'package:pawpal_app/shared/mydrawer.dart';
import 'package:pawpal_app/view/submit_pet_screen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Petsubmission> pets = [];
  late double screenWidth, screenHeight;

  String status = "Loading...";

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    if (screenWidth > 600) screenWidth = 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
        backgroundColor: const Color(0xFF0B7C44),
        foregroundColor: Colors.white,
      ),

      backgroundColor: const Color(0xFFD3F5ED),

      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: Column(
            children: [
              pets.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.find_in_page_outlined, size: 64),
                            const SizedBox(height: 12),
                            Text(
                              status,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: pets.length,
                        itemBuilder: (context, index) {
                          final pet = pets[index];
                          final imageUrl =
                              '${MyConfig.baseUrl}/pawpal/assets/pets/pet_${pet.petId}_0.png';

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                              vertical: 6,
                              horizontal: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: screenWidth * 0.28,
                                      height: screenWidth * 0.22,
                                      color: Colors.grey[200],
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.broken_image,
                                                size: 60,
                                                color: Colors.grey,
                                              );
                                            },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pet.petName ?? "",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          pet.petType ?? "",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blueGrey.withOpacity(
                                              0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            pet.category ?? "",
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        Text(
                                          pet.description ?? "",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
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
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SubmitPetScreen(user: widget.user),
            ),
          ).then((_) => loadPets()); // refresh on return
        },
        backgroundColor: const Color.fromRGBO(222, 91, 61, 0.941),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      drawer: MyDrawer(user: widget.user), //Drawer (hameburger menu)
    );
  }

  
  /// LOAD PETS FROM get_my_pets.php (GET request!)
  void loadPets() async {
    setState(() {
      status = "No submissions yet";
    });

    Uri url = Uri.parse(
      "${MyConfig.baseUrl}/pawpal/api/get_my_pets.php?userid=${widget.user.userId}",
    );

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);

      if (jsondata['status'] == 'success') {
        pets = (jsondata['data'] as List)
            .map((item) => Petsubmission.fromJson(item))
            .toList();

        setState(() {
          status = "Loaded";
        });
      } else {
        setState(() {
          pets.clear();
          status = "No pets found";
        });
      }
    } else {
      setState(() {
        status = "Failed to load pets";
      });
    }
  }
}
