import 'package:firebase_database/firebase_database.dart';
import 'package:proyecto/models/user.dart';

class UserServices{

  static var usuario = new UserModel();
  var ref;

  UserServices(){
    final referenceDatabase = FirebaseDatabase.instance;
    this.ref = referenceDatabase.reference();
  }

  Future<bool> registro(data) async{

    bool status = false;
    print(data["username"]);

    await this.ref.child('users').child(data["username"]).get().then((DataSnapshot? snapshot) async{
      var dato = snapshot!.value;

      if(dato==null){

        await this.ref.child('users').child(data["username"]).set(data).asStream();
        usuario.nombre = data['nombre'];
        usuario.username = data['username'];
        usuario.contrasenia = data['contrasenia'];
        status = true;

      }

    });

    return status;
  }

  Future<bool> login(userName, contrasenia) async{

    bool status = false;

    await this.ref.child('users').child(userName).get().then((DataSnapshot? snapshot) {
      var data = snapshot!.value;

      if(data!=null){

        if (contrasenia == data['contrasenia']){
          usuario.nombre = data['nombre'];
          usuario.username = data['username'];
          usuario.contrasenia = data['contrasenia'];
          status = true;
        }
      }
    });
    return status;
  }

}