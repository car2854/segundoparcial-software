// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_dialogflow_v2/flutter_dialogflow_v2.dart';

class DialogFlow{

  DialogFlow();

  Future<String> sendMessage(String texto, String userName) async{

    AuthGoogle authGoogle = await AuthGoogle(
      fileJson: 'assets/services.json'
    ).build();

    Dialogflow dialogFlow = Dialogflow(authGoogle: authGoogle, sessionId: '123456');


    Map<String, String> payload = {
      "UserName": userName
    };


    DetectIntentResponse aiResponse = await dialogFlow.detectIntent(
      DetectIntentRequest(
        queryInput: QueryInput(
          text: TextInput(
            text: texto,
            languageCode: Language.spanish,
          ),
        ),
        queryParams: QueryParameters(
          resetContexts: false,
          payload: payload
        ),
      ),
    );

    String respuesta = aiResponse.queryResult.fulfillmentText;

    return respuesta;
  }

}