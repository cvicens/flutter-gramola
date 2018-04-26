import 'package:flutter/material.dart';
import 'package:gramola/model/event.dart';
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

class _EventsComponentState extends State<EventsComponent> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  List<Event> _events;
  Event _selectedEvent;

 @override
  void initState() {
    super.initState();
    //_events = new List<Event>()
    _events = [
    const Event(
      id: "1",
      name: "Nirvana Death Tour",
      date: "21-04-2018",
      location: "Milkyway Galaxy",
      artist: "Nirvana",
      description: "Lorem ipsum...",
      image: "assets/img/nirvana.png",
    ),
    const Event(
      id: "2",
      name: "Aerosmith Zombies Tour",
      date: "22-04-2018",
      location: "Milkyway Galaxy",
      artist: "Aerosmith",
      description: "Lorem ipsum...",
      image: "assets/img/aerosmith.png",
    )];
  }

@override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: new Container(
            color: Theme.Colors.eventPageBackground,
            child: new ListView.builder(
              itemExtent: 160.0,
              itemCount: _events.length,
              itemBuilder: (_, index) => new EventRow(_events[index]),
            ),
          ),
        )
      ]
    );
  }
}