import 'package:ems_direct/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:ems_direct/notification_data.dart';
import 'package:ems_direct/models/emergency_models.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class NotificationItem {
  String category;
  dynamic item;

  NotificationItem({this.category, this.item});
}


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var notificationData = NotificationData.data;
  var hello = NotificationData.hello;
  var timeList = NotificationData.timeList;


 List<NotificationItem> _listToNotificationData(List<dynamic> itemList,String category) {
    return itemList.map((item) {
      return NotificationItem(
        item : item,
        category: category,
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;

    //providers
    var _declinedEmergenciesList = Provider.of<List<DeclinedEmergencyModel>>(context);
    var _severeEmergenciesList = Provider.of<List<SevereEmergencyModel>>(context);

    // to add later equipment
    List<NotificationItem> _notificationList = _listToNotificationData(_declinedEmergenciesList, "decliend");
    print(_notificationList);

    TimeOfDay timeOfDay = TimeOfDay.fromDateTime(DateTime.now());
    String res = timeOfDay.format(context);

    return Scaffold(
      backgroundColor: const Color(0xff27496d),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            
            Expanded(
              child: ListView.builder(
                itemCount: notificationData.length,
                itemBuilder: (context, index) {

                  //card logic here

                  return Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 100,
                      ),
                      child: NotificationCard(
                          notificationData[index]['text'],
                          notificationData[index]['category'],
                          timeList[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
