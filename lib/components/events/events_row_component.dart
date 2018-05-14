import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:gramola/config/theme.dart';
import 'package:gramola/model/event.dart';

class EventRow extends StatelessWidget {
  final String _imagesBaseUrl;
  final Event _event;
  final String _userId;

  EventRow(this._imagesBaseUrl, this._event, this._userId);

  Widget _buildCardContent(BuildContext context) {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Expanded(child: const SizedBox()),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Text(_event.name, style: TextStyles.eventTitle)]
          ),
          const Expanded(child: const SizedBox()),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[new Text(_event.artist, style: TextStyles.eventArtist)]
          ),
          const Expanded(child: const SizedBox()),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              const Expanded(child: const SizedBox()),
              new Column(children: <Widget>[new Text(_event.date, style: TextStyles.eventDate)]),
              const Expanded(child: const SizedBox()),
              new Column(children: <Widget>[new Text(_event.location, style: TextStyles.eventLocation)]),
              const Expanded(child: const SizedBox())
            ]
          ),
          const Expanded(child: const SizedBox())
        ]
      );
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => _navigateToTimeline(context, this._event.id, this._userId), 
      child: new Card(
        child: new SizedBox(
          height: 160.0,
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image.network(this._imagesBaseUrl + '/' + this._event.image, fit: BoxFit.cover),
              new BackdropFilter(
                filter: new ui.ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: new Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              _buildCardContent(context)
            ]
          )
        )
      )
    );
  }

  _navigateToTimeline(context, String eventId, String userId) {
    print ("About to navigate to /timeline?eventId=$eventId&userId=$userId");
    Navigator.pushNamed(context, '/timeline?eventId=$eventId&userId=$userId');
  }
}