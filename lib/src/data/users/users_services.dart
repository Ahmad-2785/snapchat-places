import 'package:firebase_database/firebase_database.dart';

class UserServices {
  static searchUsers(String searchText, String username) async {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('Users');
    DatabaseEvent event = await usersRef
        .orderByChild('username')
        .startAt(searchText)
        .endAt("$searchText\uf8ff")
        .once();
    dynamic snapshotValue = event.snapshot.value;
    List<String> userKeys = [];
    if (snapshotValue is Map) {
      snapshotValue.forEach((key, value) {
        print(">>>>>>>>");
        print(value['disabled']);
        print(value['username']);
        if (value['username'] != username && value['disabled'] == false ) {
          userKeys.add(key);
        }
      });
    }
    return userKeys;
  }
}
