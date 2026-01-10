import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';
import 'package:pawpal_app/shared/mydrawer.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  late User _user;
  bool isLoading = false;

  File? _image;
  String? _base64Image;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadUserData();
  }

  void _loadUserData() {
    nameController.text = _user.userName ?? '';
    phoneController.text = _user.userPhone ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ================= PICK IMAGE =================
  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _image = File(picked.path);
        _base64Image = base64Encode(bytes);
      });
    }
  }

  // ================= UPDATE PROFILE =================
  Future<void> _updateProfile() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${MyConfig.baseUrl}/pawpal/api/updateprofile.php'),
        body: {
          'user_id': _user.userId,
          'name': nameController.text,
          'phone': phoneController.text,
          'image': _base64Image ?? "", // 🔥 SEND BASE64
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          await loadProfile();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile updated successfully"),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          throw data['message'] ?? "Update failed";
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // ================= LOAD PROFILE =================
  Future<void> loadProfile() async {
    final response = await http.get(
      Uri.parse(
        '${MyConfig.baseUrl}/pawpal/api/getuserdetails.php?userid=${_user.userId}',
      ),
    );

    if (response.statusCode == 200) {
      final resarray = jsonDecode(response.body);
      log(response.body);

      if (resarray['status'] == 'success') {
        _user = User.fromJson(resarray['data'][0]);
        _loadUserData();
        if (mounted) setState(() {});
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final String initial =
        (_user.userName != null && _user.userName!.isNotEmpty)
        ? _user.userName![0].toUpperCase()
        : "?";

    ImageProvider avatarImage;

    if (_image != null) {
      avatarImage = FileImage(_image!);
    } else if (_user.userImage != null && _user.userImage!.isNotEmpty) {
      avatarImage = MemoryImage(base64Decode(_user.userImage!));
    } else {
      avatarImage = const AssetImage('assets/blank.png');
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color.fromARGB(255, 11, 124, 68),
        foregroundColor: Colors.white,
      ),
      drawer: MyDrawer(user: _user),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: avatarImage,
                          child:
                              (_image == null &&
                                  (_user.userImage == null ||
                                      _user.userImage!.isEmpty))
                              ? Text(
                                  initial,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),

                      const SizedBox(height: 8),
                      const Text(
                        "Tap to change photo",
                        style: TextStyle(color: Colors.grey),
                      ),

                      const SizedBox(height: 20),

                      _readonlyField("User ID", _user.userId),
                      _readonlyField("Email", _user.userEmail),

                      const SizedBox(height: 12),

                      _inputField(
                        controller: nameController,
                        label: "Name",
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 12),

                      _inputField(
                        controller: phoneController,
                        label: "Phone Number",
                        icon: Icons.phone,
                        keyboard: TextInputType.phone,
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 48,

                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromRGBO(
                              222,
                              91,
                              61,
                              0.941,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _updateProfile,
                          child: const Text("Save Changes"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  Widget _readonlyField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        readOnly: true,
        controller: TextEditingController(text: value ?? "-"),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
