import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pawpal_app/view/my_donation.dart';
import 'package:pawpal_app/view/pet_donation_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/shared/animated_route.dart';
import 'package:pawpal_app/view/home_screen.dart';
import 'package:pawpal_app/view/pets_screen.dart';
import 'package:pawpal_app/view/profile_screen.dart';
import 'package:pawpal_app/view/login_screen.dart';

class MyDrawer extends StatefulWidget {
  final User? user;
  const MyDrawer({super.key, this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late double screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    // SAFE INITIAL
    final String initial =
        (widget.user?.userName != null && widget.user!.userName!.isNotEmpty)
        ? widget.user!.userName![0].toUpperCase()
        : "?";

    ImageProvider? profileImage;

    if (widget.user?.userImage != null && widget.user!.userImage!.isNotEmpty) {
      profileImage = MemoryImage(base64Decode(widget.user!.userImage!));
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.orange,
              backgroundImage: profileImage,
              child: profileImage == null
                  ? Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            accountName: Text(widget.user?.userName ?? 'Guest'),
            accountEmail: Text(widget.user?.userEmail ?? 'Guest'),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(MainScreen(user: widget.user!)),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.room_service),
            title: const Text('All Pets'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(PetsScreen(user: widget.user!)),
              );
            },
          ),


          ListTile(
            leading: const Icon(Icons.pets),
            title: const Text('My Donations'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(MyDonation(user: widget.user!)),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.volunteer_activism),
            title: const Text('Donate a Pet'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(
                  PetDonationScreen(user: widget.user!),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                AnimatedRoute.slideFromRight(ProfilePage(user: widget.user!)),
              );
            },
          ),

          const Divider(color: Colors.grey),

          // LOGOUT BUTTON
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _confirmLogout(context),
          ),

          SizedBox(
            height: screenHeight / 4.5,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Version 0.1b", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _logout(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear all session data

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false, // remove all previous routes
    );
  }
}
