
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:herbit/admin/home_admin.dart';
import 'package:herbit/utils/notifications.dart';



class pending_details extends StatefulWidget {
  const pending_details({Key? key}) : super(key: key);

  @override
  State<pending_details> createState() => _pending_detailsState();
}

class _pending_detailsState extends State<pending_details> {

  final notification = FirebaseNotificatios();

   acceptAppointment(String appointmentId) async{
    FirebaseFirestore.instance
        .collection('user_Tb')
        .doc(appointmentId)
        .update({
      'isAccepted': true,
      'status': 'accepted',
    });
    FirebaseFirestore.instance
        .collection('login')
        .doc(appointmentId)
        .update({
      'isAccepted': true,
      
    });


    final token =  await  notification.getUserToken(appointmentId);

     await  notification.sendNotification(
      deviceToken: token,
      body: 'Admin Accepted!!!',
      title: 'Accepted'
     );


    
  }

// Function to reject an appointment
   rejectAppointment(String appointmentId) async{
    FirebaseFirestore.instance
        .collection('user_Tb')
        .doc(appointmentId)
        .update({
      'isRejected': true,
      'status': 'rejected',
    });

    final token =  await  notification.getUserToken(appointmentId);

     await  notification.sendNotification(
      deviceToken: token,
      body: 'Admin Rejected!!!',
      title: 'Rejected'
     );

  }
  void deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_Tb')
          .doc(userId)
          .delete();

     
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[900],
          title: const Text("User Manage"),
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
              stream: FirebaseFirestore.instance.collection('user_Tb').where('isAccepted',isEqualTo: false).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final appointments = snapshot.data!.docs;
                
                  return  ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index].data() as Map<String, dynamic>;
                      final appointmentId = appointments[index].id;
                      final patientName = appointment['fullname'];
                      final patientPhone = appointment['phone'];
                      final isAccepted = appointment['isAccepted'];
                      final isRejected = appointment['isRejected'];
                      final status = appointment['status'];

                      return Column(
                        children: [
                          Container(height: 120,
                            margin: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.black)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text("Name:" +patientName, style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),),
                                  Text("Phone:" +patientPhone, style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),),

                                  const SizedBox(height: 10,),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width:90,
                                        height: 40,
                                        color: Colors.green[900],
                                        child: TextButton(
                                          onPressed: () async{
                                            await acceptAppointment(appointmentId);
                                            
                                          },
                                          child:  Text(status == 'accepted'?'Accepted':'Accept',style: const TextStyle(color: Colors.white),),),
                                      ),
                                      const SizedBox(width: 10,),
                                      Container(
                                        width: 90,
                                        height: 40,
                                        color: Colors.green[900],
                                        child: TextButton(onPressed: (){
                                          rejectAppointment(appointmentId);
                                          deleteUser(appointmentId);
                                        },
                                          child: Text(status == 'rejected'?'Rejected':'Reject ',style: const TextStyle(color: Colors.white),),),
                                      ),
                                    ],
                                  ),

                                ],),
                            ),
                          ),
                        ],);
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
