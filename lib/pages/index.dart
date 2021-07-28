import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:proyecto/config.dart';
import 'package:proyecto/services/dialogflow.dart';
import 'package:proyecto/services/userServices.dart';
import 'package:speech_to_text/speech_to_text.dart';

class IndexPage extends StatefulWidget {

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {

  var user = UserServices.usuario;
  var dialogFlow = DialogFlow();
  

  SpeechToText _speech = SpeechToText();
  FlutterTts _flutterTts = FlutterTts();
  final textController = TextEditingController();
  bool _isListening = false;
  bool _loading = false;
  bool _isPlaying = false;

  List<Map> messages = [];

  @override
  void initState() {
    super.initState();
    this._initializateTts();
  }

  @override
  void dispose() {
    super.dispose();
    this._flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: colorPrincipal,
          child: Column(
            children: [

              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                color: colorSecundario,
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        this.user.nombre,
                        style: TextStyle(
                          color: colorText
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'login');
                      }, 
                      style: ElevatedButton.styleFrom(
                        primary: colorPrincipal,
                      ),
                      child: Text('Cerrar Sesion')
                    )
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.only(bottom: 15, right: 15, left: 15),
                  child: ListView.builder(
                    // physics: BouncingScrollPhysics(),
                    reverse: true,
                    itemCount: this.messages.length,
                    itemBuilder: (context, index) => Container(
                      child: Align(
                        alignment: (this.messages[index]["status"] == "user") ? Alignment.centerRight:Alignment.centerLeft,
                        child: Container(
                          margin: (this.messages[index]["status"] == "user") ? EdgeInsets.only(top: 5, bottom: 5, left: 50) : EdgeInsets.only(top: 5, bottom: 5, right: 50),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: (this.messages[index]["status"] == "user") ? BorderRadius.only(bottomLeft: Radius.circular(12), topLeft: Radius.circular(12)) : BorderRadius.only(bottomRight: Radius.circular(12), topRight: Radius.circular(12))
                          ),
                          child: Text(this.messages[index]["text"].toString()),
                        ),
                      )
                    )
                  ),
                ),
              ),

              Container(
                color: colorSecundario,
                child: Column(
                  children: [

                    Container(
                      margin: EdgeInsets.only(top: 30, right: 20, left: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorTerceario,
                        borderRadius: BorderRadius.circular(35)
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Introduzca el texto aqui'
                        ),
                        controller: this.textController,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Expanded(child: Container()),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: colorSecundario,
                            ),
                            onPressed: (){
                              _onListen();
                            },
                            child: Container(
                              child: Icon(
                                (!this._isListening)? Icons.mic: Icons.mic_off,
                                color: colorTerceario,
                                size: 30,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: colorSecundario
                            ),
                            onPressed: (){
                              if (this.textController.text.trim().length > 0)
                                _enviarMensaje(this.textController.text.trim());
                            },
                            child: Container(
                              child: Icon(
                                Icons.send,
                                color: colorTerceario,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                  ],
                ),
              )

            ],
          )
        ),
      ),
   );
  }

  void _enviarMensaje(String texto) async{

  this.textController.text = '';

    setState(() {
      this.messages.insert(0, {
        "status": "user",
        "text": texto
      });
    });

    this._loading = true;

    var text = await dialogFlow.sendMessage(texto, user.username);

    if (text==null){
      text = "Error en los servidores";
    }

    this.textController.text = '';
    this._loading = false;
    
    setState(() {
      this.messages.insert(0, {
        "status": "bot",
        "text": text
      });
      
      this._speak(text);
      
    });


  }



  
  void _onListen() async{
    if (!this._isListening){
      bool available = await this._speech.initialize(
        onStatus: (val){
          print('onStatus: $val');
          if (val == 'notListening'){
            setState(() {
              this._isListening = false;
              this._speech.stop();
              if (this.textController.text.trim().length > 0) this._enviarMensaje(this.textController.text.trim());
            });
          }
        },
        onError: (val) => print('onError: $val'),
      );
      if (available){
        setState(() {
          this._isListening = true;
        });
        this._speech.listen(
          onResult: (val) => setState(() {
            this.textController.text = val.recognizedWords;
          })
        );
      }
    } else {
      setState(() {
        this._isListening = false;
        this._speech.stop();
      });
    }
  }

  void _initializateTts() {

    this._setTtsLanguaje();
    this._speechSetting();

    this._flutterTts.setStartHandler(() {
      setState(() {
        _isPlaying = true;
      });
    });

    this._flutterTts.setCompletionHandler(() {
      setState(() {
        this._isPlaying = false;
      });
    });

    this._flutterTts.setErrorHandler((err) {
      setState(() {
        print("error ocurred" + err);
        this._isPlaying = false;
      });
    });
  }

  void _setTtsLanguaje() async{
    this._flutterTts.setLanguage("es-ES");
    // print(await this._flutterTts.getVoices);
  }

  void _speechSetting() {
    this._flutterTts.setVoice({"name": "Karen", "locale": "en-AU"});
    
    this._flutterTts.setPitch(1.0);
    this._flutterTts.setSpeechRate(0.5);
  }

  Future _speak(String text) async{
    if (text.length > 0){
      var result = await _flutterTts.speak(text);
      if (result == 1){
        setState(() {
          this._isPlaying = true;
        });
      }
    }
  }

  Future _stop() async{
    var result = await this._flutterTts.stop();
    if (result == 1){
      setState(() {
        this._isPlaying = false;
      });
    }
  }
}
