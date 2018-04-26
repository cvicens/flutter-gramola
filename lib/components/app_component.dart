import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_flux/flutter_flux.dart';
import 'package:fluro/fluro.dart';
import 'package:fh_sdk/fh_sdk.dart';

import 'package:gramola/config/application.dart';
import 'package:gramola/config/routes.dart';
import 'package:gramola/config/stores.dart';

class AppComponent extends StatefulWidget {

  @override
  State createState() => new AppComponentState();
}

class AppComponentState extends State<AppComponent> 
            with StoreWatcherMixin<AppComponent> {

  // Never write to these stores directly. Use Actions.
  EventsStore eventStore;
  InitStore initStore;

  AppComponentState() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  // This method takes care of push notifications
  void notificationHandler (MethodCall call) {
    assert(call != null);
    if ('push_message_received' == call.method) {
        print ('push_message_received ' + call.toString());
        if (call.arguments != null && call.arguments['userInfo'] != null) {
          var userInfo = call.arguments['userInfo'];
          print(userInfo['aps']['alert']['body']);
        } else {
          print(call.toString());
        }
      }
  }

  // Initialize plugin this allows us to receive push notification messages
  initPlugin() async {
    try {
      initPluginRequestAction('');
      FhSdk.initialize(notificationHandler);
      initPluginSuccessAction('plugin channel ready');
    } on PlatformException catch (e) {
      initPluginFailureAction(e.message);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initSDK() async {
    String result;
    try {
      initSdkRequestAction('');
      result = await FhSdk.init();
      initSdkSuccessAction(result);
    } on PlatformException catch (e) {
      initSdkFailureAction(e.message);
    }
  }

  /// Override this function to configure which stores to listen to.
  ///
  /// This function is called by [StoreWatcherState] during its
  /// [State.initState] lifecycle callback, which means it is called once per
  /// inflation of the widget. As a result, the set of stores you listen to
  /// should not depend on any constructor parameters for this object because
  /// if the parent rebuilds and supplies new constructor arguments, this
  /// function will not be called again.
  @override
  void initState() {
    super.initState();

    // Demonstrates using a custom change handler.
    eventStore = listenToStore(eventStoreToken, handleEventStoreChanged);

    // Demonstrates using the default handler, which just calls setState().
    initStore = listenToStore(initStoreToken);

    initPlugin();
    initSDK();
  }

  void handleEventStoreChanged(Store store) {
    EventsStore eventStore = store;
    if (eventStore.currentEvent == null) {
        // Cleaning
        print('>>>> Cleaning... text controllers...');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final app = new MaterialApp(
      title: 'Fluro',
      theme: initStore.isFetching ? ThemeData.light() : ThemeData.dark(),
      onGenerateRoute: Application.router.generator,
    );
    print("initial route = ${app.initialRoute}");
    return app;
  }
}

