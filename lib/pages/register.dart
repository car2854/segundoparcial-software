import 'package:flutter/material.dart';
import 'package:proyecto/services/userServices.dart';
import 'package:proyecto/widgets/buttonText.dart';
import 'package:proyecto/widgets/formText.dart';
// import 'package:proyecto/widgets/registerButton.dart';
import 'package:proyecto/widgets/tittleContainer.dart';

import '../config.dart';


class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final userNameController = TextEditingController();

  final userUserNameController = TextEditingController();

  final userPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var userService = UserServices();

    return Scaffold(
        body: SafeArea(
        
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: colorPrincipal,
          child: Column(
            children: [
              TittleContainer(),
              Expanded(
                child: Form(
                  key: this._formKey,
                  child: Container(
                
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                    
                          FormText(
                            textController: this.userNameController,
                            nameText: 'nombre de usuario',
                          ),
                          FormText(
                            textController: this.userUserNameController,
                            nameText: 'username',
                          ),
                          FormText(
                            textController: userPasswordController,
                            nameText: 'password',
                            isPassword: true,
                          )
                        ],
                      ),
                    ),
                
                  ),
                )
              ),
              Column(
                children: [
                  Container(
                    child: TextButton(
                      onPressed: () async{ 

                        if (this._formKey.currentState!.validate()){



                          var newUserData = {
                            'nombre': this.userNameController.text,
                            'username': this.userUserNameController.text,
                            'contrasenia': this.userPasswordController.text
                          };

                          bool status = await userService.registro(newUserData);
                          if (status){
                            Navigator.pushNamed(context, 'index');
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Ya existe ese username"))
                            );
                            print("Error de datos");
                          }

                        
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 75,
                          vertical: 10
                        ),
                        color: colorSecundario,
                        child: Text(
                          'Registrar'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            color: colorText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ButtonText(
                    text: 'Ya tienes una cuenta?, inicia sesion', 
                    accion: 'login'
                  )
                ],
              )
            ],
          ),
        )
      ),
    
   );
  }
}