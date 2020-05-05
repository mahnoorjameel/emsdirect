import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:ems_direct/shared/loading.dart';
import 'package:ems_direct/shared/reported_emergency_tile.dart';
import "package:flutter/material.dart";


class ReportedEmergenciesOps extends StatefulWidget {
  @override
  _ReportedEmergenciesOpsState createState() => _ReportedEmergenciesOpsState();
}

class _ReportedEmergenciesOpsState extends State<ReportedEmergenciesOps> {

  int _maxDocs = 20;
  var collectionRef = Firestore.instance.collection('ReportedEmergencies');
  var docs;

  List<ReportedEmergencyModel> _getEmergencyList(snapshot){
    return snapshot.documents.map((doc){
      return ReportedEmergencyModel(
        patientRollNo: doc.data['patientRollNo'],
        patientGender: doc.data['patientGender'],
        emergencyDate: doc.data['date'].toDate(),
        primaryMfrRollNo: doc.data['primaryMfrRollNo'],
        primaryMfrName: doc.data['primaryMfrName'],
        additionalMfrs: doc.data['additionalMfrs'] ?? "",
        severity: doc.data['severity'],
        patientIsHostelite: doc.data['patientIsHostelite'],
        emergencyType: doc.data['type'],
        emergencyLocation: doc.data['location'] ?? "",
        transportUsed: doc.data['transportUsed'],
        emergencyDetails: doc.data['details'] ?? "",
        bagUsed: doc.data['bagUsed'],
        equipmentUsed: doc.data['equipmentUsed'],
      );
    }).toList();
}
  List<ReportedEmergencyModel> _reportedEmergencies = [];

  Future _getInitialDocs() async { //used to perform the initial fetch
    try{
      var snapshot = await collectionRef.orderBy('date').limit(20).getDocuments();
      if(snapshot!= null)
        this._reportedEmergencies = _getEmergencyList(snapshot);
      return snapshot;
    }
    catch(e) {
      print(e);
      return null;
    }
  }




  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      appBar: AppBar(
        backgroundColor: const Color(0xff142850),
        title: Text(
          "Reported Emergencies",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'HelveticaNeueLight',
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      
      body: FutureBuilder(
        future: _getInitialDocs(),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          if(snapshot.connectionState == ConnectionState.done) {

              if(snapshot.hasData){ //!if there is data retrieved

                
                
                return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[

                    Expanded(
                      child: ListView.builder(
                        itemCount: _reportedEmergencies.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: ReportedEmergencyTile(
                              patientRollNo: _reportedEmergencies[index].patientRollNo,
                              patientGender: _reportedEmergencies[index].patientGender,
                              emergencyDate: _reportedEmergencies[index].emergencyDate,
                              primaryMfrRollNo: _reportedEmergencies[index].primaryMfrRollNo,
                              primaryMfrName: _reportedEmergencies[index].primaryMfrName,
                              additionalMfrs: _reportedEmergencies[index].additionalMfrs,
                              severity: _reportedEmergencies[index].severity,
                              patientIsHostelite: _reportedEmergencies[index].patientIsHostelite,
                              emergencyType: _reportedEmergencies[index].emergencyType,
                              emergencyLocation: _reportedEmergencies[index].emergencyLocation,
                              transportUsed: _reportedEmergencies[index].transportUsed,
                              emergencyDetails: _reportedEmergencies[index].emergencyDetails,
                              bagUsed: _reportedEmergencies[index].bagUsed,
                              equipmentUsed: "",
                            ),
                          );
                        }
                      ),
                    ),

                  ],)
                );
              }
              else{ //! There is no data in snapshot
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "No emergencies reported :(",
                    style: TextStyle(
                      fontFamily: "HelveticalNeueLight",
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),

                  ),
                );
              }
          } else { //!display loading as fetch isnt compelete
            return Loading();
          }
        }
      ),
    );
  }
}