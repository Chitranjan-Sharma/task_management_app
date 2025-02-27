import 'package:firebase_core/firebase_core.dart';
import 'package:task_management_app/core/utils/firebase_const.dart';

class FirebaseInit {
  static init() async {
    await Firebase.initializeApp(
            options: FirebaseOptions(
                apiKey: FirebaseConst().API_KEY,
                appId: FirebaseConst().APP_ID,
                messagingSenderId: FirebaseConst().SENDER_ID,
                projectId: FirebaseConst().PROJECT_ID))
        .then((onValue) {
      
    });
  }
}
