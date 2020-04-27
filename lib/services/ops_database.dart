import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';

class OpsDatabaseService {
  // collection references ops will be listening to

  final CollectionReference onGoingEmergencies =
      Firestore.instance.collection('OngoingEmergencies');
  final CollectionReference pendingEmergencies =
      Firestore.instance.collection('PendingEmergencies');
  final CollectionReference availableMfrs =
      Firestore.instance.collection('Mfrs');

  //Declined emergency list from snapshot
  List<DeclinedEmergencyModel> _declinedEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return DeclinedEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'],
        declines: doc.data['declines'],
        declinedBy: doc.data['declinedBy'],
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'] ?? '',
      );
    }).toList();
  }

  //Declined emergency list from snapshot
  List<PendingEmergencyModel> _pendingEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return PendingEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'],
        declines: doc.data['declines'],
        declinedBy: doc.data['declinedBy'],
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'] ?? '',
        reportingTime : doc.data['reportingTime'].toDate() ?? null,
      );
    }).toList();
  }

  //Severe emergency list from snapshot
  List<SevereEmergencyModel> _severeEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return SevereEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'],
        declines: doc.data['declines'],
        declinedBy: doc.data['declinedBy'],
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'] ?? '',
      );
    }).toList();
  }

  //Ongoingemergency list from snapshot
  List<OngoingEmergencyModel> _onGoingEmergencyListFromSnapshot(
      QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return OngoingEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        genderPreference: doc.data['genderPreference'],
        location: doc.data['location'],
        severity: doc.data['severity'],
        patientContactNo: doc.data['patientContactNo'] ?? '',
        mfr: doc.data['mfr'],
        mfrDetails: {
          'contact': doc.data['mfrDetails']['contact'],
          'name': doc.data['mfrDetails']['name'],
        },
        reportingTime: doc.data['reportingTime'].toDate() ?? null,
      );
    }).toList();
  }

  //Declined emergency list from snapshot
  List<AvailableMfrs> _availableMfrsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return AvailableMfrs(
        contact: doc.data['contact'],
        gender: doc.data['gender'],
        isActive: doc.data['isActive'],
        isHostelite: doc.data['isHostelite'],
        isOccupied: doc.data['isOccupied'],
        isSenior: doc.data['isSenior'],
        location: doc.data['location'],
        name: doc.data['name'],
      );
    }).toList();
  }

  //get pending emergencies
  Stream<List<DeclinedEmergencyModel>> get declinedStream {
    return pendingEmergencies
        .where('declines', isGreaterThanOrEqualTo: 4)
        .snapshots()
        .map(_declinedEmergencyListFromSnapshot);
  }

  //get severe emergencies
  Stream<List<SevereEmergencyModel>> get severeStream {
    return pendingEmergencies
        .where('severity', whereIn: ['high', 'critical'])
        .snapshots()
        .map(_severeEmergencyListFromSnapshot);
  }

  //get pending emergencies
  Stream<List<PendingEmergencyModel>> get pendingStream {
    return pendingEmergencies
        .snapshots()
        .map(_pendingEmergencyListFromSnapshot);
  }

  //get onGoing emergencies
  Stream<List<OngoingEmergencyModel>> get onGoingStream {
    return onGoingEmergencies
        .snapshots()
        .map(_onGoingEmergencyListFromSnapshot);
  }

  //get available mfrs
  Stream<List<AvailableMfrs>> get availableMfrStream {
    return availableMfrs
        .where('isActive', isEqualTo: true)
        .where('isOccupied', isEqualTo: false)
        .snapshots()
        .map(_availableMfrsListFromSnapshot);
  }
}
