import 'package:flutter/material.dart';
import 'package:kiranjaapp_driver/services/firebase_services.dart';
import 'package:kiranjaapp_driver/widgets/order_summary_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

   User _user = FirebaseAuth.instance.currentUser;
    FirebaseServices _services = FirebaseServices();
    String status;

     int tag = 0;
  List<String> options = [
    "All",     
    "Accepted", 
    "Picked Up", 
    "On the Way", 
    "Delivered"
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.2),
      appBar: AppBar(title: const Text("Orders", 
      style: TextStyle(color: Colors.white),), centerTitle: true,),
      body: Column(
        children: [
            SizedBox(
                        height: 56, 
                        width: MediaQuery.of(context).size.width,
                        child: ChipsChoice<int>.single(
                          choiceStyle: C2ChoiceStyle(borderRadius: const BorderRadius.all(Radius.circular(3),),),
                          value: tag, 
                          onChanged: (val){
                            if(val == 0){
                              setState(() {
                                status = null;
                              });
                            }
                            setState((){
                            tag = val;
                            if(val == 0){
                              status = options[val];
                            }
                          });
                          },
                          choiceItem: C2Choice.listFrom<int, String>(
                            source: options, 
                            value: (i, v) => i, 
                            label: (i, v) => v,
                          ),
                        ),
                      ),

          Container(
            child: StreamBuilder<QuerySnapshot>(
            stream: _services.orders
            .where("deliveryBoy.email", isEqualTo: _user.email)
            .where("orderStatus", isEqualTo: tag == 0 ? null : status )
            .snapshots(), 
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return const Text("Something went wrong");
              }  
 
          
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),);
              }     

              if(snapshot.data.size == 0){
              return Center(child: Text("No $status orders"));
              } 

          
              return Expanded(
                child: ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document){
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child: OrderSummaryCard(document: document),
                    );
                  }).toList(),
                ),
              );
            },
            ),
          ),
        ],
      ),
    );
  }
}