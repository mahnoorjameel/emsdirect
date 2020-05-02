import 'package:cloud_firestore/cloud_firestore.dart';

class SevereEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final String patientContactNo;
  final DateTime reportingTime;

  SevereEmergencyModel(
      {this.patientRollNo,
      this.genderPreference,
      this.location,
      this.declines,
      this.declinedBy,
      this.severity,
      this.patientContactNo,
      this.reportingTime});
}

class DeclinedEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final String patientContactNo;
  final DateTime reportingTime;

  DeclinedEmergencyModel(
      {this.patientContactNo,
      this.patientRollNo,
      this.genderPreference,
      this.location,
      this.declines,
      this.declinedBy,
      this.severity,
      this.reportingTime});
}

class PendingEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final int declines;
  final List declinedBy;
  final String severity;
  final DateTime reportingTime;
  final String patientContactNo;

  PendingEmergencyModel(
      {this.patientRollNo,
      this.genderPreference,
      this.location,
      this.declines,
      this.declinedBy,
      this.severity,
      this.patientContactNo,
      this.reportingTime});
}

class AvailableMfrs {
  final String contact;
  final String gender;
  final bool isActive;
  final bool isHostelite;
  final bool isOccupied;
  final bool isSenior;
  final GeoPoint location;
  final String name;
  final String rollNo;

  AvailableMfrs(
      {this.contact,
      this.gender,
      this.isActive,
      this.isHostelite,
      this.isOccupied,
      this.isSenior,
      this.location,
      this.name,
      this.rollNo});
}

class OngoingEmergencyModel {
  final String patientRollNo;
  final String genderPreference;
  final GeoPoint location;
  final String mfr;
  final Map mfrDetails;
  final DateTime reportingTime;
  final String severity;
  final String patientContactNo;

  OngoingEmergencyModel(
      {this.patientRollNo,
      this.genderPreference,
      this.location,
      this.mfr,
      this.mfrDetails,
      this.reportingTime,
      this.severity,
      this.patientContactNo});
}