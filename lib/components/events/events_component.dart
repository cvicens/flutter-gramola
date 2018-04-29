import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:flutter_flux/flutter_flux.dart';

import 'package:fh_sdk/fh_sdk.dart';

import 'package:gramola/config/stores.dart';

import 'package:gramola/components/events/events_row_component.dart';

import 'package:gramola/config/theme.dart' as Theme;

class EventsComponent extends StatefulWidget {

  EventsComponent({String country, String city})
      : this.country = country,
        this.city = city;

  final String country;
  final String city;

  @override
  _EventsComponentState createState() => new _EventsComponentState();
}

class _EventsComponentState extends State<EventsComponent> 
  with StoreWatcherMixin<EventsComponent>{

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();

  // Never write to these stores directly. Use Actions.
  EventsStore eventsStore;

  @override
  void initState() {
    super.initState();

    // Demonstrates using a custom change handler.
    eventsStore = listenToStore(eventStoreToken);

    _fetchEvents();
    _getImagesUrl();

    //_events = eventsStore.events;
  }

  void _fetchEvents() async {
    try {
      fetchEventsRequestAction('');
       Map<String, dynamic> options = {
        "path": "/events/" + eventsStore.currentCountry + "/" + eventsStore.currentCity + "/2018-04-27",
        "method": "GET",
        "contentType": "application/json",
        "timeout": 25000 // timeout value specified in milliseconds. Default: 60000 (60s)
      };
      dynamic result = await FhSdk.cloud(options);
      fetchEventsSuccessAction(result);
    } on PlatformException catch (e) {
      fetchEventsFailureAction(e.message);
      _showSnackbar('Authentication failed!');
    }
  }

  void _getImagesUrl() async {
    try {
      fetchCloudUrlRequestAction('');
      String result = await FhSdk.getCloudUrl();
      fetchCloudUrlSuccessAction(result);
    } on PlatformException catch (e) {
      fetchCloudUrlFailureAction(e.message);
      _showSnackbar('getCloudUrl failed!');
    }
  }

  void _showSnackbar (String message) {
    // This is just a demo, so no actual login here.
    final snackbar = new SnackBar(
      content: new Text(message),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('List of events'),
        leading: new IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
             //Navigator.pop(scaffoldKey.currentContext);
             Navigator.pushReplacementNamed(scaffoldKey.currentContext, '/');
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        toolbarOpacity: 0.5,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new Container(
              //color: Theme.GramolaColors.eventPageBackground,
              child: new ListView.builder(
                //itemExtent: 160.0,
                itemCount: eventsStore.events.length,
                itemBuilder: (_, index) => new EventRow(eventsStore.imagesBaseUrl, eventsStore.events[index]),
              ),
            ),
          )
        ]
      )
    );
  }
}