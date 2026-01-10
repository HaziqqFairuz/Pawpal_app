import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';
import 'package:pawpal_app/shared/mydrawer.dart'; // <-- Import MyDrawer

class MyDonation extends StatefulWidget {
  final User user;
  const MyDonation({super.key, required this.user});

  @override
  State<MyDonation> createState() => _MyDonationState();
}

class _MyDonationState extends State<MyDonation> {
  List<dynamic> donationList = [];
  String status = "Loading your donations...";

  @override
  void initState() {
    super.initState();
    loadMyDonations();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) screenWidth = 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Donation History"),
        backgroundColor: const Color(0xFF0B7C44),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadMyDonations,
          ),
        ],
      ),
      drawer: MyDrawer(user: widget.user), // <-- Add the drawer here
      backgroundColor: const Color(0xFFD3F5ED),
      body: Center(
        child: SizedBox(
          width: screenWidth,
          child: donationList.isEmpty
              ? Center(
                  child: Text(
                    status,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  itemCount: donationList.length,
                  itemBuilder: (context, index) {
                    final donation = donationList[index];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF0B7C44),
                          child: Icon(Icons.monetization_on, color: Colors.white),
                        ),
                        title: Text(
                          "Donated to: ${donation['pet_name']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text("Type: ${donation['donation_type']}"),
                            Text("Date: ${donation['donation_date']}"),
                            if (donation['description'] != null &&
                                donation['description'] != "")
                              Text(
                                "Note: ${donation['description']}",
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 12),
                              ),
                          ],
                        ),
                        trailing: Text(
                          "RM ${donation['amount']}",
                          style: const TextStyle(
                            color: Color.fromRGBO(222, 91, 61, 0.941),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  void loadMyDonations() async {
    setState(() => status = "Loading...");
    
    Uri url = Uri.parse(
      "${MyConfig.baseUrl}/pawpal/api/get_my_donation.php?userid=${widget.user.userId}",
    );

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          setState(() {
            donationList = jsondata['data'];
          });
        } else {
          setState(() {
            donationList.clear();
            status = "No donation records found.";
          });
        }
      } else {
        setState(() => status = "Server error");
      }
    } catch (e) {
      setState(() => status = "Connection error");
    }
  }
}
