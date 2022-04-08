import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:durood_together_app/AppReserved/constants.dart';
import 'package:durood_together_app/AppReserved/translators.dart';
import 'package:durood_together_app/Models/ReportsScreenData.dart';
import 'package:durood_together_app/Models/city_reports_data.dart';
import 'package:durood_together_app/Models/country_reports_data.dart';
import 'package:durood_together_app/Models/user_log.dart';
import 'package:durood_together_app/Models/user_reports_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FireStoreServiceForReports {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<ReportsScreenData> getCountryReportsData(int month, int year) {
    return _db
        .collection("CountryData")
        .doc("${Constants.months[month]}-$year")
        .snapshots()
        .map((snapshot) {
      return translateCountryDataForReports(
          CountryReportsData.fromFirestore(snapshot.data()));
    });
  }

  Stream<ReportsScreenData> getCityReportsData(int month, int year) {
    return _db
        .collection("CityData")
        .doc("${Constants.months[month]}-$year")
        .snapshots()
        .map((snapshot) {
      return translateCityDataForReports(
          CityReportsData.fromFirestore(snapshot.data()));
    });
  }

  Stream<ReportsScreenData> getUserDataFromReports(
      UserReportsData data, int month, int year) {
    final String monthCollection = "${Constants.months[month]}-$year";
    return _db
        .collection('UserReportData')
        .doc(auth.currentUser?.uid)
        .collection('UserData')
        .doc(monthCollection)
        .snapshots()
        .map((snapshot) {
      if (snapshot.data()?.keys.contains('countryCount') ?? false) {
        data.userCountryCount = snapshot['countryCount'];
      }
      if (snapshot.data()?.keys.contains('countryName') ?? false) {
        data.userCountryName = snapshot['countryName'];
      }
      if (snapshot.data()?.keys.contains('cityCount') ?? false) {
        data.userCityCount = snapshot['cityCount'];
      }
      if (snapshot.data()?.keys.contains('cityName') ?? false) {
        data.userCityName = snapshot["cityName"];
      }
      if (snapshot.data()?.keys.contains('globalRank') ?? false) {
        data.globalRank = snapshot['globalRank'];
      }
      if (snapshot.data()?.keys.contains('cityRank') ?? false) {
        data.cityRank = snapshot['cityRank'];
      }
      if (snapshot.data()?.keys.contains('countryRank') ?? false) {
        data.countryRank = snapshot['countryRank'];
      }
      return translateUserDataForReports(data);
    });
  }

  Stream<Map<String, dynamic>> getUserMonthLogs(int month, int year) {
    final String monthCollection = "${Constants.months[month]}-$year";
    return Stream.fromFuture(
      _db
          .collection('UserCounts')
          .doc(auth.currentUser?.uid)
          .collection(monthCollection)
          .get()
          .then(
        (snapshot) {
          List<Map<String, dynamic>> allData = snapshot.docs.map((doc) {
            return doc.data();
          }).toList();
          Map<String, dynamic> result = {
            "count": 0,
            "logs": [],
          };
          List<UserLog> userlogs = [];
          int count = 0;
          for (Map<String, dynamic> map in allData) {
            num temp = 0;
            if(map.values.isNotEmpty) {
              temp = map.values.reduce((sum, element) => sum + element);
              count += int.tryParse(temp.toString()) ?? 0;
              DateFormat formatter = DateFormat('yyyy-MM-dd');
              DateTime date = formatter.parse(map.keys.first);
              final String formatted = DateFormat('dd-MM-yyyy').format(date);
              UserLog log = UserLog(formatted, temp.toString());
              userlogs.add(log);
            }
          }
          userlogs.sort(((a, b) => a.date.compareTo(b.date)));
          result['count'] = count;
          result['logs'] = userlogs;
          return result;
        },
      ),
    );
  }
}
