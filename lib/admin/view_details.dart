import 'package:flutter/material.dart';
import 'package:herbit/admin/fever.dart';
class view extends StatefulWidget {
  const view({Key? key}) : super(key: key);

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            children:[
              GestureDetector( onTap: (){ Navigator.push(
                  context, MaterialPageRoute(builder:(context) => const Fever()));
              },
         child: Container(

            height: 50,

            decoration: BoxDecoration(

                color: Colors.green[900], borderRadius: BorderRadius.circular(5)

            ),

            width:200,

            child: const Center(child: Text('fever')),



          ),),
          const SizedBox(height: 20,),

          Container(

            height: 50,

            decoration: BoxDecoration(

                color: Colors.green[900], borderRadius: BorderRadius.circular(5)

            ),

            width:200,

            child: const Center(child: Text('head ache')),



          ),const SizedBox(height: 20,),
          Container(

            height: 50,

            decoration: BoxDecoration(

                color: Colors.green[900], borderRadius: BorderRadius.circular(5)

            ),

            width:200,

            child: const Center(child: Text('diabetes')),



          ),const SizedBox(height: 20,),

          Container(

            height: 50,

            decoration: BoxDecoration(

                color: Colors.green[900], borderRadius: BorderRadius.circular(5)

            ),

            width:200,

            child: const Center(child: Text('obesity')),



          ),const SizedBox(height: 20,),
          Container(

            height: 50,

            decoration: BoxDecoration(

                color: Colors.green[900], borderRadius: BorderRadius.circular(5)

            ),

            width:200,

            child: const Center(child: Text('dandruff')),



          ),const SizedBox(height: 20,),
],),
        ),
      ),

    );
  }
}
