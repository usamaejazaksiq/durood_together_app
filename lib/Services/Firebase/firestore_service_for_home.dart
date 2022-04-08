import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/Models/home_screen_general_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durood_together_app/Models/home_screen_user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FireStoreServiceForHome {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> saveHomeScreenData(HomeScreenGeneralData data) async {
    return await _db
        .collection('Test')
        .doc(
            "${Constants.months[DateTime.now().month - 1]}-${DateTime.now().year}")
        .set(data.createMap());
  }

  Future<void> saveLastCount(int count) async {
    // print(auth.currentUser?.uid);
    final String monthCollection =
        "${Constants.months[DateTime.now().month - 1]}-${DateTime.now().year}";
    final String dayDoc = "${DateTime.now().day}";
    final String countTimeStamp = "${DateTime.now()}";

    //Update main Count
    await _db
        .collection('UserCounts')
        .doc(auth.currentUser?.uid)
        .collection(monthCollection)
        .doc(dayDoc)
        .set(
      {countTimeStamp: count},
      SetOptions(merge: true),
    );

    //Update for User stats
    final checkDoc = await _db
        .collection('UserSpecificHomeData')
        .doc(auth.currentUser?.uid)
        .get();
    if (checkDoc.exists) {
      await _db
          .collection('UserSpecificHomeData')
          .doc(auth.currentUser?.uid)
          .update(
        {
          "lastCount": {
            "time": countTimeStamp,
            "count": count,
          },
        },
      );
    } else {
      await _db
          .collection('UserSpecificHomeData')
          .doc(auth.currentUser?.uid)
          .set(
        {
          "lastCount": {
            "time": countTimeStamp,
            "count": count,
          },
        },
      );
    }
  }

  Stream<Map<String, String>> getRecentStats() {
    String monthCollection =
        "${Constants.months[DateTime.now().month - 1]}-${DateTime.now().year}";
    return Stream.fromFuture(
      _db
          .collection('UserCounts')
          .doc(auth.currentUser?.uid)
          .collection(monthCollection)
          .get()
          .then(
        (snapshot) {
          List<Map<String, dynamic>> allData = snapshot.docs.map(
            (doc) {
              return doc.data();
            },
          ).toList();
          Map<String, String> result = {
            "yesterday": "0",
            "today": "0",
            "weekly": "0",
          };
          List<Map<DateTime, int>> counts = [];
          int count = 0;
          for (Map<String, dynamic> map in allData) {
            num temp = 0;
            if(map.values.isNotEmpty){
              temp = map.values.reduce((sum, element) => sum + element);
              count += int.tryParse(temp.toString()) ?? 0;
              DateFormat formatter = DateFormat('yyyy-MM-dd');
              DateTime date = formatter.parse(map.keys.first);
              counts.add(
                {
                  date: count,
                },
              );
            }
            count = 0;
          }
          counts.sort((b, a) {
            return a.keys.elementAt(0).compareTo(b.keys.elementAt(0));
          });
          int weekCount = 0;
          DateTime todayDate = DateTime.now();
          DateTime yesterdayDate =
              DateTime.now().subtract(const Duration(hours: Duration.hoursPerDay));
          DateTime lastDate = DateTime.now()
              .subtract(const Duration(hours: Duration.hoursPerDay * 7));
          if (counts.isNotEmpty) {
            for (int i = 0; i < 7; i++) {
              if (i > counts.length - 1) {
                break;
              }
              Map<DateTime, int> tempMap = counts[i];
              DateTime date = tempMap.keys.elementAt(0);

              if (isSameDate(date, todayDate)) {
                result["today"] = tempMap[date].toString();
              } else if (isSameDate(date, yesterdayDate)) {
                result["yesterday"] = tempMap[date].toString();
              }
              if (isLessThan(date, lastDate)) {
                weekCount += tempMap[date] ?? 0;
              }
            }
          }
          result["weekly"] = weekCount.toString();

          return result;
        },
      ),
    );
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool isLessThan(DateTime a, DateTime b) {
    return a.compareTo(b) > 0;
  }

  //Get Universal Home Data
  Stream<HomeScreenGeneralData> getHomeScreenGeneralData() {
    return _db
        .collection("HomeData")
        .doc(
            "${Constants.months[DateTime.now().month - 1]}-${DateTime.now().year}")
        .snapshots()
        .map(
            (snapshot) => HomeScreenGeneralData.fromFirestore(snapshot.data()));
  }

  //Get User Home Data
  Stream<HomeScreenUserData> getHomeScreenUserData() {
    return _db
        .collection("UserSpecificHomeData")
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map((snapshot) => HomeScreenUserData.fromFirestore(snapshot.data()));
  }

  //ToDelete
  Future<void> removeItem(String docId) {
    return _db.collection('HomeData').doc(docId).delete();
  }

  Future<void> dismissLastCount() async {
    await _db
        .collection('UserSpecificHomeData')
        .doc(auth.currentUser?.uid)
        .update(
      {
        "lastCount": {
          "time": "",
          "count": 0,
        },
      },
    );
  }

  Future<void> deleteLastCount() async {
    String countTimeStamp = "";
    int count = 0;
    await _db
        .collection('UserSpecificHomeData')
        .doc(auth.currentUser?.uid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
      // Get value of field date from document dashboard/totalVisitors
      countTimeStamp = documentSnapshot.data()!['lastCount']['time'];
      count = documentSnapshot.data()!['lastCount']['count'];
    });

    final String monthCollection =
        "${Constants.months[DateTime.now().month - 1]}-${DateTime.now().year}";
    final String dayDoc = "${DateTime.now().day}";

    await _db
        .collection('UserCounts')
        .doc(auth.currentUser?.uid)
        .collection(monthCollection)
        .doc(dayDoc)
        .set(
      {countTimeStamp: FieldValue.delete()},
      SetOptions(
        merge: true,
      ),
    );

    await _db
        .collection('UserSpecificHomeData')
        .doc(auth.currentUser?.uid)
        .update(
      {
        "lastCount": {
          "time": "",
          "count": 0,
        },
      },
    );
  }
}
