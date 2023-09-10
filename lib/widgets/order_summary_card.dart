import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/firebase_services.dart';
import '../services/order_services.dart';


class OrderSummaryCard extends StatefulWidget {
  final DocumentSnapshot document;
  const OrderSummaryCard({super.key, this.document});

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {

   OrderServices _orderServices = OrderServices();
   FirebaseServices _services = FirebaseServices();

   DocumentSnapshot _customer;

   @override
  void initState() {
    _services.getCustomerDetails(widget.document.data()["userId"]).then((value){
     if(value != null){
       setState(() {
        _customer = value;
      });
     } else {
      print("No data");
     }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  horizontalTitleGap: 0,
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 14, 
                                    child:_orderServices.statusIcon(widget.document)
                                  ), 
                                  title: Text(
                                    widget.document.data()["orderStatus"], 
                                  style: TextStyle(fontSize: 12, 
                                  color: _orderServices.statusColor(widget.document),
                                  fontWeight: FontWeight.bold),),
                                  subtitle: Text("On ${DateFormat.yMMMd().format(
                                    DateTime.parse(widget.document.data()["timestamp"]))}", 
                                    style: const TextStyle(fontSize: 12) ,),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Payment Type : ${widget.document.data()["cod"] == true ? "Cash on Delivery" : "Paid Online"}", 
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        
                                          Text(
                                          "Amount : \$${widget.document.data()["total"].toStringAsFixed(0)}", 
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        
                                      ],
                                    ),
                                ),
                                // need to bring customer details
                                _customer != null ?
                                ListTile(
                                  
                                  title: Row(
                                    children: [
                                      const Text
                                      ("Customer:  ", 
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      Text
                                      ("${_customer.data()["firstName"]} ${_customer.data()["lastName"]}", 
                                     
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                      
                                    ],
                                  ),
                                  subtitle:Text( _customer.data()["address"], 
                                  style: const TextStyle(fontSize: 12),  maxLines: 1,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                           _orderServices.launchMap(
                                            _customer.data()["latitude"],
                                            _customer.data()["longitude"],
                                            _customer.data()["firstName"],                                            
                                            );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(4)
                                          ) ,
                                          child: const Padding(
                                            padding: EdgeInsets.only(left: 8, right: 8, bottom: 2),
                                            child: Icon(Icons.map, color: Colors.white,),
                                          )
                                          ),
                                      ),
                                    const SizedBox(width: 10,),
                                       InkWell(
                                        onTap: () {
                                           _orderServices.launchCall("tel: ${_customer.data()["number"]}");
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(4)
                                          ) ,
                                          child: const Padding(
                                            padding: EdgeInsets.only(left: 8, right: 8, bottom: 2),
                                            child: Icon(Icons.phone_in_talk, color: Colors.white,),
                                          )
                                          ),
                                      ),
                                    ],
                                  ),
                                ) : Container(),
                               ExpansionTile(title: const Text("Order details", 
                                style: TextStyle(fontSize: 12, color: Colors.black),
                                ),
                                subtitle: const Text("View order details", 
                                 style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index){
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image.network(widget.document.data()["products"][index]["productImage"]),
                                        ),
                                        title: Text(widget.document.data()['products'][index]["productName"], 
                                        style: const TextStyle(fontSize: 12) ,),
                                        subtitle: Text("${widget.document.data()["products"][index]["qty"]} x \$${widget.document.data()["products"][index]["price"].toStringAsFixed(0)} = \$${widget.document.data()["products"][index]["total"].toStringAsFixed(0)}", 
                                        style: const TextStyle(color: Colors.grey, fontSize: 12),),
                                        
                                      );
                                    }, 
                                    itemCount: widget.document.data()["products"].length,
                                    ), 
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                                      child: Card(
                                      elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Text("Seller : ",
                                                   style: TextStyle( 
                                                   fontWeight: FontWeight.bold, fontSize: 12),
                                                   ),
                                                   Text(widget.document.data()["seller"]["shopName"], 
                                                   style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                   ),
                                                ],
                                              ), 
                                              const SizedBox(height: 10,),
                                              if(int.parse(widget.document.data()["discount"]) > 0)
                                              // this will show up only if discount is available
                                              Container(
                                                child: Column(
                                                  children: [
                                                     Row(
                                                children: [
                                                  const Text("Discount : ",
                                                   style: TextStyle( 
                                                   fontWeight: FontWeight.bold, fontSize: 12) ,
                                                   ),
                                                   
                                                   Text("${widget.document.data()["discount"]}",
                                                   style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                   ),
                                                ],
                                              ), 
                                        
                                              const SizedBox(height: 10,),
                                        
                                               Row(
                                                children: [
                                                  const Text("Discount Code: ",
                                                   style: TextStyle( 
                                                   fontWeight: FontWeight.bold, fontSize: 12) ,
                                                   ),
                                                   
                                                   Text("${widget.document.data()["discountCode"]}",
                                                   style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                   ),
                                                ],
                                              ), 
                                                  ],
                                                ),
                                              ),
                                        
                                              const SizedBox(height: 10,),
                                        
                                                Row(
                                                children: [
                                                  const Text("Delivery Fee: ",
                                                   style: TextStyle( 
                                                   fontWeight: FontWeight.bold, fontSize: 12) ,
                                                   ),
                                                   
                                                   Text("\$${widget.document.data()["deliveryFee"].toString()}",
                                                   style: const TextStyle(color: Colors.grey, fontSize: 12),
                                                   ),
                                                ],
                                              ), 
                                        
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                                ),
                                const Divider(height: 3, color: Colors.grey,),
                                
                               _orderServices.statusContainer(widget.document, context),
                        
                                const Divider(height: 3, color: Colors.grey,),
                              ],
                            ),
                          );
  }
}