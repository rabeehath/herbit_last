import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:herbit/user/pdf_prescriptions.dart';
import 'package:intl/intl.dart';

import 'doctor.dart';
import 'home_user.dart';

class prescription extends StatefulWidget {
  final List<String> selectedSymptomList;

  const prescription({
    super.key,
    required this.selectedSymptomList,
  });

  @override
  State<prescription> createState() => _prescriptionState();
}

class _prescriptionState extends State<prescription> {
  String userId = '';
  User? user;
  String age = '';
  String name = '';
  String description = '';
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool loading = false;

  void fetchUserData() {
    user = FirebaseAuth.instance.currentUser;
    userId = user!.uid;
    FirebaseFirestore.instance
        .collection('user_Tb')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        name = data['fullname'] as String;
        age = data['age'] as String;
      } else {}
    }).catchError((error) {});
  }

  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];

  String datas = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAgeWithMedicine(widget.selectedSymptomList);
  }

  List treatmentList = [];
  List medList = [];
  List disList = [];

  getAgeWithMedicine(List<String> selectedSymptomList) async {
    setState(() {
      loading = true;
    });

   fetchUserData();
    final snapshot = await FirebaseFirestore.instance
        .collection('symptom')
        .where('symptoms', whereIn: widget.selectedSymptomList)
        .get();

    snapshot.docs.forEach((e) {
      Map<String, dynamic> data = e.data();
      treatmentList.addAll(data['treatment']);
      disList.addAll(data['disease']);
    });

    final checkAge =  int.parse(age);

    List filteredList = treatmentList.where(
      (data) {
        if (checkAge <= 10) {
          return data['age'] == 10;
        } else if (checkAge <= 20) {
          return data['age'] == 20;
        } else if (checkAge <= 30) {
          return data['age'] == 30;
        } else if (checkAge <= 50) {
          return data['age'] == 50;
        } else if (checkAge <= 70) {
          return data['age'] == 70;
        } else if (checkAge <= 80) {
          return data['age'] == 80;
        } else if (checkAge <= 100) {
          return data['age'] == 100;
        } else {
          return false;
        }
      },
    ).toList();

    filteredList.forEach((element) {
      medList.addAll(element['medicine']);
      
    });

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Homeuser(),
                    ));
              },
              icon: const Icon(Icons.home))
        ],
      ),
      body:loading ?const Center(child: CircularProgressIndicator(),) :SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(border: Border.all()),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'Date:$formattedDate',
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Name :',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Age :',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          age,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Symptoms :',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const SizedBox(
                  height: 10,
                ),
                widget.selectedSymptomList.isNotEmpty
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.selectedSymptomList
                            .map((e) => Text(
                                  e,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ))
                            .toList(),
                      )
                    : const Text('not found'),
                

                const SizedBox(height: 30,),
                const Text(
                  'Medicines :',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                const SizedBox(
                  height: 10,
                ),
                medList.isNotEmpty
                    ? Column(
                        children: medList
                            .map((e) => Text(
                                  e,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ))
                            .toList(),
                      )
                    : const Text('not found'),
                const SizedBox(
                  height: 5,
                ),



                
                
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                 
                  children: [

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),

                    
                     
                      
                      height: 50,
                      color: Colors.green[900],
                      child: TextButton(
                        child: const Text(
                          'Consulting',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  doctor(userName:name,),
                              ));
                        },
                      ),
                    ),

                    Container(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                      
                      height: 50,
                      color: Colors.green[900],
                      child: TextButton(
                        child: const Text(
                          'Download',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  PdfPrescription(
                                  name: name, 
                                  age: age, 
                                  formattedDate: formattedDate,
                                  selectedSymptomList: widget.selectedSymptomList.isNotEmpty ? widget.selectedSymptomList : ['no found'],
                                  medList: medList.isNotEmpty ? medList : ['not found'],

                                )
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    
    
    );
  }
}
