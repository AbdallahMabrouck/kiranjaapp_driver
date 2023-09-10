import 'package:flutter/material.dart';
import 'package:kiranjaapp_driver/screens/home_screen.dart';

import '../provider/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
   final _formKey = GlobalKey<FormState>();
   var _emailTextControler = TextEditingController();
   var _passwordTextControler = TextEditingController();
   var _cPasswordTextControler = TextEditingController();
   var _addressTextControler = TextEditingController();
   String email: 
   String password: 
   String name; 
   String mobile; 
   bool _isLoading = false;


   Future<String> uploadFile(filePath) async {
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref("boyProfilePic/${_nameTextController.text}").putFile(file);
    } on FirebaseException catch (e) {
      // e.g e.code == "cancelled"
      print(e.code);
    }
    // after upload file, we need file path to save to database
    String downloadURL = await _storage
    .ref("boyProfilePic/${_nameTextController.text}").getDownloadURL();
    return downloadURL;
   }


  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    setState(() {
      _emailTextControler.text = _authData.email;
      email = _authData.email;
    });
    scaffoldMessage(message){
      return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(message)));
    }
    return _isLoading ? CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
    ) : 
    Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return "Enter Name";
                }
                setState(() {
                  _nameTextController.text = value;
                });
                setState(() {
                  name = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline), 
                labelText: "Name", 
                contentPadding: EdgeInsets.zero, 
                enabledBorder: const OutlineInputBorder(), 
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, 
                    color: Theme.of(context).primaryColor
          
                  ),
                ),
                focusColor: Theme.of(context).primaryColor
              ),
            ),
          ),

            Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value){
                if(value.isEmpty){
                  return "Enter Mobile Number";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.phone_android), 
                labelText: "Mobile Number", 
                contentPadding: EdgeInsets.zero, 
                enabledBorder: const OutlineInputBorder(), 
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, 
                    color: Theme.of(context).primaryColor
          
                  ),
                ),
                focusColor: Theme.of(context).primaryColor
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              enabled: false,
              controller: _emailTextControler,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email_outlined), 
                labelText: "Email", 
                contentPadding: EdgeInsets.zero, 
                enabledBorder: const OutlineInputBorder(), 
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, 
                    color: Theme.of(context).primaryColor
          
                  ),
                ),
                focusColor: Theme.of(context).primaryColor
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              validator: (value){
                if(value.isEmpty){
                  return "Enter Password";
                }
                if(value?.length<6){
                  return "Minimum 6 characters";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.vpn_key_outlined), 
                labelText: "New Password", 
                contentPadding: EdgeInsets.zero, 
                enabledBorder: const OutlineInputBorder(), 
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, 
                    color: Theme.of(context).primaryColor
          
                  ),
                ),
                focusColor: Theme.of(context).primaryColor
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value){
                if(value.isEmpty){
                  return "Confirm Password";
                }
                if(value?.length<6){
                  return "Minimum 6 characters";
                }
                if(_passwordTextControler.text != _cPasswordTextControler.text){
                  return "Password does not match";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.add_business), 
                labelText: "Confirm Password", 
                contentPadding: EdgeInsets.zero, 
                enabledBorder: const OutlineInputBorder(), 
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, 
                    color: Theme.of(context).primaryColor
          
                  ),
                ),
                focusColor: Theme.of(context).primaryColor
              ),
            ),
          ),

            Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _addressTextControler,
              maxLines: 6,
              validator: (value){
                if(value.isEmpty){
                  return "Please Press Navigation Button";
                }
                if(_authData.shopLatitude == null){
                  return "Please Press Navigation Button";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.contact_mail_outlined), 
                labelText: "Business Location", 
                suffixIcon: IconButton(
                  onPressed: () {
                    _addressTextControler.text = "Locating ...  \n Please wait ...";
                    _authData.getCurentAddress().then((address){
                      if(address != null){
                        setState(() {
                          _addressTextControler.text = "${_authData.placeName} \n ${_authData.shopAddress}";
                        });
                      } else {
                        ScaffoldMessenger
                        .of(context).showSnackBar(const SnackBar(content: Text("Could not find location ..Try again")));
                      }
                    });
                  }, 
                  icon: const Icon(Icons.location_searching)),
                enabledBorder: const OutlineInputBorder(), 
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2, 
                    color: Theme.of(context).primaryColor
          
                  ),
                ),
                focusColor: Theme.of(context).primaryColor
              ),
            ),
          ),

         

          const SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  // color: Theme.of(context).primaryColor
                  onPressed: () {
                    // first will validate profile picture
                  if(_authData.isPicAvail == true){
                     // then will validate forms
                     if(_formKey.currentState.validate()){
                     setState(() {
                       _isLoading = true;
                     });
                     _authData.registerBoys(email, password).then((credential){
                      if(credential.user.uid != null){
                        // user registered
                        // now will upload profile pic to firestore
                        uploadFile(_authData.image.path).then((url){
                          if(url == null){
                            // save details to database
                            _authData.saveBoysDataToDb (
                              url: url, 
                              mobile: mobile, 
                              name: name, 
                              password: password
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushReplacementNamed(context, HomeScreen.id);
                          } else{
                            ScaffoldMessenge("Failed to Upload Profile ")
                                             
                          }
                          
                        });
                      }
                     });
                    }
                  }
                   
                   
                  } else {
                    
                  },
                  child:const Text("Register", style: TextStyle(color: Colors.white),),
                  ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}