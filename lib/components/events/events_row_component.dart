import 'package:flutter/material.dart';
import 'package:gramola/config/theme.dart' as Theme;
import 'package:gramola/model/event.dart';

class EventRow extends StatelessWidget {

  final Event event;

  EventRow(this.event);

  @override
  Widget build(BuildContext context) {
    final eventThumbnail = new Container(
      alignment: new FractionalOffset(0.0, 0.5),
      margin: const EdgeInsets.only(left: 24.0),
      child: new Hero(
        tag: 'event-icon-${event.id}',
        child: new Image(
          image: new AssetImage(event.image),
          height: Theme.Dimens.eventHeight,
          width: Theme.Dimens.eventWidth,
        ),
      ),
    );

    final eventCard = new Container(
      margin: const EdgeInsets.only(left: 72.0, right: 24.0),
      decoration: new BoxDecoration(
        color: Theme.Colors.eventCard,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(color: Colors.black,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0))
        ],
      ),
      child: new Container(
        margin: const EdgeInsets.only(top: 16.0, left: 72.0),
        constraints: new BoxConstraints.expand(),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(event.name, style: Theme.TextStyles.eventTitle),
            new Text(event.location, style: Theme.TextStyles.eventLocation),
            new Container(
              color: const Color(0xFF00C6FF),
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0)
            ),
            new Row(
              children: <Widget>[
                new Icon(Icons.location_on, size: 14.0,
                  color: Theme.Colors.eventDate),
                new Text(
                  event.artist, style: Theme.TextStyles.eventDate),
                new Container(width: 24.0),
                new Icon(Icons.flight_land, size: 14.0,
                  color: Theme.Colors.eventDate),
                new Text(
                  event.date, style: Theme.TextStyles.eventDate),
              ],
            )
          ],
        ),
      ),
    );

    return new Container(
      height: 120.0,
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: new FlatButton(
        onPressed: () => _navigateTo(context, event.id),
        child: new Stack(
          children: <Widget>[
            eventCard,
            eventThumbnail,
          ],
        ),
      ),
    );
  }

  _navigateTo(context, String id) {
    print ("TODO Event Detail: $id");
    //Navigator.pushReplacementNamed(context, '/event/$id');
  }
}