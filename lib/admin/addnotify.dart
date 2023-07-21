
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:herbit/admin/home_admin.dart';



class AddNotify extends StatefulWidget {
  const AddNotify({Key? key}) : super(key: key);

  @override
  State<AddNotify> createState() => _AddNotifyState();
}

class _AddNotifyState extends State<AddNotify> {

   void deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notify')
          .doc(userId)
          .delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[900],
          title: const Text("User Suggestions"),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25),
                bottomLeft: Radius.circular(25),
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const home_admin(),
                      ));
                },
                icon: const Icon(Icons.home))
          ],
        ),
        body:Padding(
            padding: const EdgeInsets.all(8.0),
            child:StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('notify').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final appointments = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index].data() as Map<String, dynamic>;
                      final appointmentId = appointments[index].id;
                      final patientName = appointment['notification'];

                      return Container(
                        child: Column(
                          children: [
                            Container(height:80,
                              margin: const EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Suggestions:  " +patientName, style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),),
                                    IconButton(onPressed: (){
                                      deleteUser(appointmentId);
                                    }, icon: const Icon(Icons.delete))
                                  ],
                                ),
                              ),
                            ),
                          ],),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )

        )


    );

  }
}



/*
import 'package:flutter/material.dart';

import 'details_user.dart';
class pending_details extends StatefulWidget {
  const pending_details({Key? key}) : super(key: key);

  @override
  State<pending_details> createState() => _pending_detailsState();
}

class _pending_detailsState extends State<pending_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 70),
          child: Column(
            children: [  GestureDetector(onTap: (){ Navigator.push(
              context, MaterialPageRoute(builder:(context) => const details_user()),
            );},
             child: Container(
               color: Colors.green[900],
            height: 60,
            width:199,
            child: Center(child: Text('user 1')),

          ),),SizedBox(height: 10,),
          GestureDetector(onTap: (){ Navigator.push(
          context, MaterialPageRoute(builder:(context) => const details_user()),
    );},
            child: Container(
              color: Colors.green[900],
              height: 60,
              width:199,
              child: Center(child: Text('user 2')),

            )
              ),SizedBox(height: 10,),
    GestureDetector(onTap: (){ Navigator.push(
    context, MaterialPageRoute(builder:(context) => const details_user()),
    );},
    child: Container(
          color: Colors.green[900],
    height: 60,
    width:199,
    child: Center(child: Text('user 3')),

    )
    ),  ],
          ),
        ),
      ),
    );



  }
}
*/
