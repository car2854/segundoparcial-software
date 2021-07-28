import 'package:flutter/material.dart';
import 'package:proyecto/config.dart';
import 'package:proyecto/services/userServices.dart';
import 'package:proyecto/widgets/buttonText.dart';
import 'package:proyecto/widgets/formText.dart';
// import 'package:proyecto/widgets/loginButton.dart';
import 'package:proyecto/widgets/tittleContainer.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();

  final userPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    var userServices = UserServices();

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
                child: Container(

                  child: SingleChildScrollView(
                    child: Form(
                      key: this._formKey,
                      child: Column(
                        children: [
                                      
                          FormText(
                            textController: this.userNameController,
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
                          bool status = await userServices.login(this.userNameController.text, this.userPasswordController.text);

                          if (status){
                            Navigator.pushNamed(context, 'index');
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Usuario o Contraseña incorrecto"))
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
                          'Login'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            color: colorText,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ButtonText(
                    text: 'No tienes una cuenta?, create una', 
                    accion: 'register'
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
