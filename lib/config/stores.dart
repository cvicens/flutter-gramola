import 'package:flutter/services.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:fh_sdk/fh_sdk.dart';

import 'package:gramola/model/event.dart';

class Location {
  final String country;
  final String city;

  const Location({this.country, this.city});

}

class BaseStore extends Store {
  bool _fetching = false;
  bool _error = false;
  
  String _errorMessage = '';

  bool get isFetching => _fetching;
  bool get isError => _error;

  String get errorMessage => _errorMessage;

  BaseStore() {
  }
}

class InitStore extends BaseStore {
  bool _pluginInitialized = false;
  bool _sdkInitialized = false;

  dynamic _lastPushNotification;
  
  bool get isPluginInitialized => _pluginInitialized;
  bool get isSdkInitialized => _sdkInitialized;

  dynamic get lastPushNotification => _lastPushNotification;

  InitStore() {
    triggerOnAction(initPluginRequestAction, (String _) {
        _fetching = true;
        _pluginInitialized = false;
    });

    triggerOnAction(initPluginSuccessAction, (String result) {
        _fetching = false;
        _pluginInitialized = true;
    });

    triggerOnAction(initPluginFailureAction, (String errorMessage) {
      _fetching = false;
      _errorMessage = errorMessage;
    });

    triggerOnAction(initSdkRequestAction, (String _) {
        _fetching = true;
        _sdkInitialized = false;
    });

    triggerOnAction(initSdkSuccessAction, (String result) {
        _fetching = false;
        _sdkInitialized = true;
    });

    triggerOnAction(initSdkFailureAction, (String errorMessage) {
      _fetching = false;
      _errorMessage = errorMessage;
    });

    triggerOnAction(pushNotificationReceivedAction, (dynamic lastPushNotification) {
      _lastPushNotification = lastPushNotification;
    });
  }

  // This method takes care of push notifications
  void notificationHandler (MethodCall call) {
    assert(call != null);
    if ('push_message_received' == call.method) {
        print ('push_message_received ' + call.toString());
        if (call.arguments != null && call.arguments['userInfo'] != null) {
          var userInfo = call.arguments['userInfo'];
          //showSnackBarMessage(userInfo['aps']['alert']['body']);
          print(userInfo['aps']['alert']['body']);
        } else {
          //showSnackBarMessage(call.toString());
          print(call.toString());
        }
      }
  }
}

class EventsStore extends Store {
  bool _fetching = false;
  bool _error = false;

  String _errorMessage = '';

  String _currentCountry = 'SPAIN';
  String _currentCity = 'MADRID';

  final List<Event> _events = <Event>[];
  Event _currentEvent;
  
  bool get isFetching => _fetching;
  bool get isError => _error;

  String get errorMessage => _errorMessage;

  String get currentCountry => _currentCountry;
  String get currentCity => _currentCity;

  List<Event> get events => new List<Event>.unmodifiable(_events);
  Event get currentEvent => _currentEvent;

  EventsStore() {
    triggerOnAction(fetchEventsAction, (Null _) {
      
    });

    triggerOnAction(setLocationAction, (Location location) {
      assert(location != null);
      _currentCountry = location.country;
      _currentCity = location.city;
    });

    triggerOnAction(selectEvent, (Event event) {
      assert(event != null);
      _currentEvent = event;
    });
  }
}

final StoreToken eventStoreToken = new StoreToken(new EventsStore());
final StoreToken initStoreToken = new StoreToken(new InitStore());


final Action<String> initPluginRequestAction = new Action<String>();
final Action<String> initPluginSuccessAction = new Action<String>();
final Action<String> initPluginFailureAction = new Action<String>();

final Action<String> initSdkRequestAction = new Action<String>();
final Action<String> initSdkSuccessAction = new Action<String>();
final Action<String> initSdkFailureAction = new Action<String>();

final Action<dynamic> pushNotificationReceivedAction = new Action<dynamic>();

final Action<Null> fetchEventsAction = new Action<Null>();
final Action<Location> setLocationAction = new Action<Location>();
final Action<Event> selectEvent = new Action<Event>();
