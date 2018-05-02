import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:gramola/config/theme.dart' as Theme;
import 'package:gramola/model/event.dart';

class EventRow extends StatelessWidget {
  final String _imagesBaseUrl;
  final Event _event;

  EventRow(this._imagesBaseUrl, this._event);

  Widget _buildCardContent(BuildContext context) {
    return new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            //leading: const Icon(Icons.event_available),
            title: new Text(_event.name),
            subtitle: new Text(_event.artist),
          ),
          
        ]
      );
  }

  Widget _buildCardContent2(BuildContext context) {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Expanded(child: const SizedBox()),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Text(_event.name)]
          ),
          const Expanded(child: const SizedBox()),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Text(_event.artist)]
          ),
          const Expanded(child: const SizedBox()),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              const Expanded(child: const SizedBox()),
              new Column(children: <Widget>[new Text(_event.date)]),
              const Expanded(child: const SizedBox()),
              new Column(children: <Widget>[new Text(_event.location)]),
              const Expanded(child: const SizedBox())
            ]
          ),
          const Expanded(child: const SizedBox())
        ]
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new SizedBox(
        height: 160.0,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image.network(this._imagesBaseUrl + '/' + this._event.image, fit: BoxFit.cover),
            new BackdropFilter(
              filter: new ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
              child: new Container(
                color: Colors.black.withOpacity(0.2),
                // TODO: child: _buildContent(),
                //child: _buildCardContent(context)
              ),
            ),
            _buildCardContent2(context)
          ]
        )
      )
    );
  }

  _navigateTo(context, String id) {
    print ("TODO Event Detail: $id");
    //Navigator.pushReplacementNamed(context, '/event/$id');
  }
}