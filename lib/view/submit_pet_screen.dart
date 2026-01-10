import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawpal_app/models/user.dart';
import 'package:pawpal_app/myconfig.dart';

class SubmitPetScreen extends StatefulWidget {
  final User? user;

  const SubmitPetScreen({super.key, required this.user});

  @override
  State<SubmitPetScreen> createState() => _SubmitPetScreenState();
}

class _SubmitPetScreenState extends State<SubmitPetScreen> {
  List<XFile> multiImages = []; // For mobile
  List<Uint8List> webMultiImages = []; // For web

  List<String> pettype = ['Cat', 'Dog', 'Rabbit', 'Other'];

  List<String> petGender = ['Male', 'Female'];

  List<String> petHealth = ['Healthy', 'Sick'];

  List<String> submissioncategory = [
    'Adoption',
    'Donation Request',
    'Help/Rescue',
  ];

  TextEditingController petNameController = TextEditingController();
  TextEditingController petAgeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController postedbyController = TextEditingController(); 
  TextEditingController addressController = TextEditingController();

  String selectedpet = 'Cat';
  String selectedpetGender = 'Male';
  String selectedpetHealth = 'Healthy';
  String selectedsubmissioncategory = 'Adoption';

  late Position mypostion;
  String address = "";
  Uint8List? webImage;
  File? image;
  late double height, width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    if (width > 600) {
      width = 600;
    } else {
      width = width;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Submission Form'),
        backgroundColor: Color.fromARGB(255, 11, 124, 68),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // original
                      // if (kIsWeb) {
                      //   openGallery();
                      // } else {
                      //   pickimagedialog();
                      // }
                      if (kIsWeb) {
                        openMultiGallery();
                      } else {
                        pickimagedialog();
                      }
                    },

                    child: Container(
                      width: width,
                      height: height / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey.shade400),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        image: (image != null && !kIsWeb)
                            ? DecorationImage(
                                image: FileImage(image!),
                                fit: BoxFit.cover,
                              )
                            : (webImage != null)
                            ? DecorationImage(
                                image: MemoryImage(webImage!),
                                fit: BoxFit.cover,
                              )
                            : null, // no image → show icon instead
                      ),

                      child: (multiImages.isEmpty && webMultiImages.isEmpty)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Tap to add images",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(4),
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: kIsWeb
                                  ? webMultiImages.length
                                  : multiImages.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                  ),
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: kIsWeb
                                      ? Image.memory(
                                          webMultiImages[index],
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(
                                          File(multiImages[index].path),
                                          fit: BoxFit.cover,
                                        ),
                                );
                              },
                            ),
                    ),
                  ),

                  SizedBox(height: 10),
                  TextField(
                    controller: petNameController,
                    decoration: InputDecoration(
                      labelText: 'Pet Name',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10),
                  TextField(
                    controller: petAgeController,
                    decoration: InputDecoration(
                      labelText: 'Pet Age',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Pet Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: pettype.map((String selectserv) {
                      return DropdownMenuItem<String>(
                        value: selectserv,
                        child: Text(selectserv),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedpet = newValue!;
                        print(selectedpet);
                      });
                    },
                  ),

                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Pet Gender',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: petGender.map((String selectserv) {
                      return DropdownMenuItem<String>(
                        value: selectserv,
                        child: Text(selectserv),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedpetGender = newValue!;
                        print(selectedpetGender);
                      });
                    },
                  ),

                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Pet Health Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: petHealth.map((String selectserv) {
                      return DropdownMenuItem<String>(
                        value: selectserv,
                        child: Text(selectserv),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedpetHealth = newValue!;
                        print(selectedpetHealth);
                      });
                    },
                  ),

                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Submission Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    items: submissioncategory.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedsubmissioncategory = newValue!;
                      });
                    },
                  ),

                  SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  SizedBox(height: 10),
                  TextField(
                    controller: postedbyController,
                    decoration: InputDecoration(
                      labelText: 'Posted by',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 10),
                  //address from reverse geocoding
                  TextField(
                    maxLines: 3,
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () async {
                          mypostion = await _determinePosition(); // Geolocator
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                mypostion.latitude,
                                mypostion.longitude,
                              );
                          Placemark place = placemarks[0];
                          addressController.text =
                              "${place.name}, ${place.street}, ${place.postalCode}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
                        },
                        icon: Icon(Icons.location_on),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(222, 91, 61, 0.941),
                      minimumSize: Size(width, 50),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      showSubmitDialog();
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickimagedialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  openGallery();
                },
              ),
              ListTile(
                leading: Icon(Icons.collections),
                title: Text('Pick Multiple Images'),
                onTap: () {
                  Navigator.pop(context);
                  openMultiGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage();
      }
    }
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        webImage = await pickedFile.readAsBytes();
        setState(() {});
      } else {
        image = File(pickedFile.path);
        cropImage(); // only for mobile
      }
    }
  }

  Future<void> cropImage() async {
    if (kIsWeb) return; // skip cropping on web
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatio: CropAspectRatio(ratioX: 5, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Please Crop Your Image',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
        ),
        IOSUiSettings(title: 'Cropper'),
      ],
    );

    if (croppedFile != null) {
      image = File(croppedFile.path);
      setState(() {});
    }
  }

  Future<void> openMultiGallery() async {
    final picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      // Check if adding these images exceeds the max limit
      if (kIsWeb) {
        if (pickedFiles.length > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You can select up to 3 images only"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        webMultiImages.clear();
        for (var img in pickedFiles) {
          webMultiImages.add(await img.readAsBytes());
        }
      } else {
        if (pickedFiles.length > 3) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("You can select up to 3 images only"),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        multiImages = pickedFiles;
      }
      setState(() {});
    }
  }

  void showSubmitDialog() {
    // Pet Name validation
    if (petNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter pet name"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pet Age validation
    if (petAgeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter pet age"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pet Type validation
    if (selectedpet.isEmpty || !pettype.contains(selectedpet)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a valid pet type"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pet Gender validation
    if (selectedpetGender.isEmpty || !petGender.contains(selectedpetGender)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a valid pet gender"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pet Health validation
    if (selectedpetHealth.isEmpty || !petHealth.contains(selectedpetHealth)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a valid pet health status"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Submission Category validation
    if (selectedsubmissioncategory.isEmpty ||
        !submissioncategory.contains(selectedsubmissioncategory)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a valid submission category"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Image validation
    if (kIsWeb && webMultiImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (!kIsWeb && multiImages.isEmpty && image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an image"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Description validation
    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter description"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Posted by validation
    if (postedbyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter posted by"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Address validation
    if (addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Position validation
    if (mypostion.latitude.isNaN || mypostion.longitude.isNaN) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a valid address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Confirm submission dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit Service'),
          content: const Text('Are you sure you want to submit this service?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                submitPetForm();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void submitPetForm() {
    List<String> base64Images = [];

    if (kIsWeb) {
      for (var img in webMultiImages) {
        base64Images.add(base64Encode(img));
      }
    } else {
      for (var img in multiImages) {
        base64Images.add(base64Encode(File(img.path).readAsBytesSync()));
      }
    }

    String petname = petNameController.text.trim();
    String petage = petAgeController.text.trim(); //tambah sini
    String description = descriptionController.text.trim();
    String postedBy = postedbyController.text.trim();


    http
        .post(
          Uri.parse('${MyConfig.baseUrl}/pawpal/api/submit_pet.php'),
          body: {
            'userid': widget.user?.userId,
            'pet_name': petname,
            'pet_age': petage, //tambah sini
            'pet_type': selectedpet,
            'pet_gender': selectedpetGender, //tambah sini
            'pet_health': selectedpetHealth, //tambah sini
            'category': selectedsubmissioncategory,
            'description': description,
            'posted_by': postedBy, //tambah sini
            'lat': mypostion.latitude.toString(),
            'lng': mypostion.longitude.toString(),
            'image_list': jsonEncode(base64Images),
          },
        )
        .then((response) {
          print(response.body);
          if (response.statusCode == 200) {
            var jsonResponse = response.body;
            var resarray = jsonDecode(jsonResponse);
            if (resarray['status'] == 'success') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Service submitted successfully"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(resarray['message']),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        });
  }
}
