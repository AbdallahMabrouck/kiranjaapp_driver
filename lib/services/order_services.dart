import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiranjaapp_driver/services/firebase_services.dart';


class OrderServices {

  FirebaseServices _services = FirebaseServices();


     Color statusColor(document){
    if(document.data()["orderStatus"] == "Accepted"){
      return Colors.blueGrey.shade400;
    }
    if(document.data()["orderStatus"] == "Picked Up"){
      return Colors.pink.shade900;
    }
    if(document.data()["orderStatus"] == "On the Way"){
      return Colors.purple.shade900; 
    }
    if(document.data()["orderStatus"] == "Delivered"){
      return Colors.green;
    }
    return Colors.orange;
  }


  Icon statusIcon(document){
    if(document.data()["orderStatus"] == "Accepted"){
      return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),) ;
    }
    if(document.data()["orderStatus"] == "Picked Up"){
       return Icon(Icons.cases, color: statusColor(document),) ;
    }
    if(document.data()["orderStatus"] == "On the Way"){
       return Icon(Icons.delivery_dining, color: statusColor(document),) ;
    }
    if(document.data()["orderStatus"] == "Delivered"){
       return Icon(Icons.shopping_bag_outlined, color: statusColor(document),) ;
    }
     return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),) ;
  }



  Widget statusContainer(document, context){
    if(document.data()["deliveryBoy"]["name"].length >1){
     if(document.data()["orderStatus"] == "Accepted"){
    return  Container(
         color: Colors.grey.shade300,
             height: 50,
          width: MediaQuery.of(context).size.width,
         child:  Padding(
          padding: const EdgeInsets.fromLTRB(40, 8 , 40, 8),
           child: ElevatedButton(
           style: ButtonStyle(
            backgroundColor: ButtonStyleButton.allOrNull<Color>(statusColor(document)),
           ),
           onPressed: () {
            EasyLoading.show();
             _services.updateStatus(
              id: document.id, 
              status: "Picked Up"
             ).then((value){
              EasyLoading.showSuccess("order status is now Picked Up");
             });
             }, 
           child: const Text("Update Status to Picked Up", 
        style: TextStyle(color: Colors.white),)
               ),
              ), 
            );
  }

    if(document.data()["orderStatus"] == "Picked Up"){
    return  Container(
         color: Colors.grey.shade300,
             height: 50,
          width: MediaQuery.of(context).size.width,
         child:  Padding(
          padding: const EdgeInsets.fromLTRB(40, 8 , 40, 8),
           child: ElevatedButton(
           style: ButtonStyle(
            backgroundColor: ButtonStyleButton.allOrNull<Color>(statusColor(document)),
           ),
           onPressed: () {
            EasyLoading.show();
             _services.updateStatus(
              id: document.id, 
              status: "On the way"
             ).then((value){
              EasyLoading.showSuccess("order status is now On the Way");
             });
             }, 
           child: const Text("Update Status to On the Way", 
        style: TextStyle(color: Colors.white),)
               ),
              ), 
            );
  }


  if(document.data()["orderStatus"] == "On the Way"){
    return  Container(
         color: Colors.grey.shade300,
             height: 50,
          width: MediaQuery.of(context).size.width,
         child:  Padding(
           padding: const EdgeInsets.fromLTRB(40, 8 , 40, 8),
           child: ElevatedButton(
           style: ButtonStyle(
            backgroundColor: ButtonStyleButton.allOrNull<Color>(statusColor(document)),
           ),
           onPressed: () {
            if(document.data()["cod"] == true){
              return showMyDialog("Receive Payment", "Delivered", document.id, context);
            } else {
              EasyLoading.show();
             _services.updateStatus(
              id: document.id, 
              status: "Delivered"
             ).then((value){
              EasyLoading.showSuccess("order status is now Delivered");
             });
            }
            
             }, 
           child: const Text("Deliver Order", 
                 style: TextStyle(color: Colors.white),)
               ),
         ), 
            );
  }


  
    return  Container(
         color: Colors.grey.shade300,
             height: 30,
          width: MediaQuery.of(context).size.width,
         child:  ElevatedButton(
         style: ButtonStyle(
          backgroundColor: ButtonStyleButton.allOrNull<Color>(Colors.green),
         ),
         onPressed: () {
          
           }, 
         child: const Text("Order Completed", 
        style: TextStyle(color: Colors.white),)
             ), 
            );
  }
    
  

  }


   void launchCall(number) async =>
  await canLaunch(number) ? await launch(number) : throw "Could not launch $number";


   void launchMap (lat, long, name) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: Coords(lat, long), 
      title: name
    );
  }



   showMyDialog(title, status, documentId, context){
       OrderServices _orderServices = OrderServices();
    showCupertinoDialog(
      context: context, 
      builder: (BuildContext context){
        return CupertinoAlertDialog(
          title: Text(title),
          content: const Text("Make sure you have received payment "),
          actions: [
            ElevatedButton(
              onPressed: () {
                EasyLoading.show();
                 _services.updateStatus(
                  id: documentId, 
                  status: "Delivered"
                 ).then((value){
                  EasyLoading.showStatus("order status is now Delivered");
                  Navigator.pop(context);
                 });
            }, 
            child: Text("RECEIVE", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
            ),

            ElevatedButton(onPressed: () {
            
              Navigator.pop(context);
            }, 
            child: Text("Cancel", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
            ),
          ],
        );
      }
      );
  }


}