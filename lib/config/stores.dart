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
        _error = false;
        _pluginInitialized = false;
    });

    triggerOnAction(initPluginSuccessAction, (String result) {
        _fetching = false;
        _pluginInitialized = true;
    });

    triggerOnAction(initPluginFailureAction, (String errorMessage) {
      _fetching = false;
      _error = true;
      _errorMessage = errorMessage;
    });

    triggerOnAction(initSdkRequestAction, (String _) {
        _fetching = true;
        _error = false;
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

class LoginStore extends BaseStore {
  bool _authenticated = false;
  String _username;
  dynamic _result;
  
  bool get isAuthenticated => _authenticated;
  String get username => _username;
  dynamic get result => _result;

  LoginStore() {
    triggerOnAction(authenticateRequestAction, (String username) {
        _fetching = true;
        _error = false;
        _authenticated = false;
        _username = username;
    });

    triggerOnAction(authenticateSuccessAction, (dynamic result) {
        _fetching = false;
        _authenticated = true;
        _result = result;
    });

    triggerOnAction(authenticateFailureAction, (String errorMessage) {
      _fetching = false;
      _error = true;
      _errorMessage = errorMessage;
    });
  }
}

class EventsStore extends BaseStore {
  String _currentCountry = 'SPAIN';
  String _currentCity = 'MADRID';

  String _imagesBaseUrl;

  dynamic _result;

  List<Event> _events = <Event>[];
  Event _currentEvent;
  
  String get currentCountry => _currentCountry;
  String get currentCity => _currentCity;

  String get imagesBaseUrl => _imagesBaseUrl;

  dynamic get result => _result;

  List<Event> get events => new List<Event>.unmodifiable(_events);
  Event get currentEvent => _currentEvent;

  EventsStore() {
    triggerOnAction(fetchEventsRequestAction, (String _) {
        _fetching = true;
        _error = false;
    });

    triggerOnAction(fetchEventsSuccessAction, (dynamic result) {
        _fetching = false;
        if (result is List) {
          _result = result;
          _events = List<Event>();
          _result.forEach((element) {
            _events.add(new Event(artist: element['artist'], date: element['date'], 
              description: element['description'], id: element['id'], 
              image: element['image'], location:  element['location'], 
              name:  element['name']));
          });
        }
    });

    triggerOnAction(fetchEventsFailureAction, (String errorMessage) {
      _fetching = false;
      _errorMessage = errorMessage;
    });

    triggerOnAction(fetchCloudUrlRequestAction, (String _) {
        _fetching = true;
        _error = false;
    });

    triggerOnAction(fetchCloudUrlSuccessAction, (String result) {
        _fetching = false;
        _imagesBaseUrl = result;
    });

    triggerOnAction(fetchCloudUrlFailureAction, (String errorMessage) {
      _fetching = false;
      _errorMessage = errorMessage;
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

final Action<String>  authenticateRequestAction = new Action<String>();
final Action<dynamic> authenticateSuccessAction = new Action<dynamic>();
final Action<String>  authenticateFailureAction = new Action<String>();


final Action<String>  fetchEventsRequestAction = new Action<String>();
final Action<dynamic> fetchEventsSuccessAction = new Action<dynamic>();
final Action<String>  fetchEventsFailureAction = new Action<String>();

final Action<String> fetchCloudUrlRequestAction = new Action<String>();
final Action<String> fetchCloudUrlSuccessAction = new Action<String>();
final Action<String> fetchCloudUrlFailureAction = new Action<String>();

final Action<Location> setLocationAction = new Action<Location>();
final Action<Event> selectEvent = new Action<Event>();
