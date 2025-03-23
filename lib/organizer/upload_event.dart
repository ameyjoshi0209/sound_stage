import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:sound_stage/services/cloudinary_service.dart';
import 'package:sound_stage/services/database.dart';
import 'package:sound_stage/services/shared_pref.dart';

class UploadEvent extends StatefulWidget {
  final bool edit;
  String? eventId; // Pass the event ID to edit the specific event
  UploadEvent({super.key, this.eventId, required this.edit});

  @override
  State<UploadEvent> createState() => _UploadEventState();
}

class _UploadEventState extends State<UploadEvent> {
  String? id;

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  bool isLoading = false; // Track loading state

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getOrganizerId();
    setState(() {});
  }

  final List<String> eventcategory = [
    "Jazz",
    "Metal",
    "Classical",
    "Rock Band",
  ];
  String? value, imageurl;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getEventData() async {
    DocumentSnapshot eventDoc =
        await FirebaseFirestore.instance
            .collection(
              'Event',
            ) // Assuming your events are in a collection named 'events'
            .doc(widget.eventId)
            .get();

    if (eventDoc.exists) {
      var eventData = eventDoc.data() as Map<String, dynamic>;

      nameController.text = eventData['Name'];
      priceController.text = eventData['Price'];
      detailController.text = eventData['Details'];
      locationController.text = eventData['Location'];
      ageController.text = eventData['AgeAllowed'];
      value = eventData['Category'];
      selectedDate = DateFormat('dd-mm-yyy').parse(eventData['Date']);
      DateTime parsedTime = DateFormat.jm().parse(eventData['Time']);
      selectedTime = TimeOfDay(
        hour: parsedTime.hour,
        minute: parsedTime.minute,
      );
      imageurl = eventData['Image'];
    }
  }

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage = File(image.path);
    }
    setState(() {});
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 10, minute: 0);

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    return DateFormat.jm().format(dateTime);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  ontheload() async {
    await getthesharedpref();
    if (widget.edit) {
      await getEventData(); // Fetch event data when loading the scree
    }
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: EdgeInsets.only(top: 40, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back_ios_new_outlined),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 4.5),
                  Text(
                    "Upload Event",
                    style: TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (selectedImage == null && imageurl == null)
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xffececf8),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.deepPurple, width: 1),
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                )
              else if (selectedImage != null || imageurl == null)
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        selectedImage!, // Fallback to selectedImage if imageUrl is null
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              else if (selectedImage == null && imageurl != null)
                GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        imageurl!, // Fallback to selectedImage if imageUrl is null
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 20),
              Text(
                "Event name",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter event name",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Ticket Price",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter ticket price",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Select Category",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items:
                        eventcategory
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged:
                        ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: Text("Select Category"),
                    iconSize: 36,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: value,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Age Restrictions",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter minimum allowed age (eg. 18)",
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Event Location",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter event location",
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pickDate();
                    },
                    child: Icon(
                      Icons.calendar_month,
                      color: Color(0xff6351ec),
                      size: 30,
                    ),
                  ),
                  Text(
                    DateFormat("dd-MM-yyyy").format(selectedDate),
                    style: TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      _pickTime();
                    },
                    child: Icon(
                      Icons.access_time,
                      color: Color(0xff6351ec),
                      size: 30,
                    ),
                  ),
                  Text(
                    formatTimeOfDay(selectedTime),
                    style: TextStyle(
                      color: Color(0xff6351ec),
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Event Details",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xffececf8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: detailController,
                  maxLines: 7,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter event description",
                  ),
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap:
                    isLoading
                        ? null
                        : () async {
                          setState(() {
                            isLoading = true;
                          });
                          HapticFeedback.lightImpact();
                          String addId = randomAlphaNumeric(10);
                          if (selectedImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Please select an image!",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ),
                            );
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                          String url = await uploadtoCloudinary(selectedImage);
                          String? uploadedImageUrl;
                          if (widget.edit) {
                            if (imageurl == null) {
                              uploadedImageUrl = url;
                            } else {
                              if (imageurl == url) {
                                uploadedImageUrl = url;
                              } else {
                                await deleteFromCloudinary(imageurl!);
                                uploadedImageUrl = url;
                              }
                            }
                          }
                          Map<String, dynamic> uploadevent = {
                            "Image": widget.edit ? uploadedImageUrl : url,
                            "Name": nameController.text,
                            "Price": priceController.text,
                            "Category": value ?? "",
                            "AgeAllowed": ageController.text,
                            "Location": locationController.text,
                            "Details": detailController.text,
                            "Date": DateFormat(
                              "dd-MM-yyyy",
                            ).format(selectedDate),
                            "Time": formatTimeOfDay(selectedTime),
                            "OrganizerId": id,
                            "EventApproved": false,
                            "EventId": widget.edit ? widget.eventId : addId,
                          };
                          await DatabaseMethods()
                              .addEvent(
                                uploadevent,
                                widget.edit ? widget.eventId! : addId,
                              )
                              .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "Event uploaded successfully!",
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                );
                                widget.edit
                                    ? setState(() {
                                      isLoading = false;
                                    })
                                    : setState(() {
                                      isLoading = false;
                                      nameController.clear();
                                      priceController.clear();
                                      detailController.clear();
                                      locationController.clear();
                                      ageController.clear();
                                      selectedImage = null;
                                      value = null;
                                      imageurl = null;
                                      selectedDate = DateTime.now();
                                    });
                              });
                        },
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 50),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xff6351ec),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    width: double.infinity,
                    child: Center(
                      child:
                          isLoading
                              ? SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                  strokeWidth:
                                      3, // For a smooth Google-like animation
                                ),
                              )
                              : Text(
                                "Upload",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
