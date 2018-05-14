![A sample modular Flutter App](https://raw.githubusercontent.com/cvicens/flutter-gramola/master/images/modular-flutter-a.png)
# Building a Flutter App that fits in with your micro-services strategy in three acts
Have you ever waked up at night feeling uneasy and sweaty wondering if your mobile app is a monolith? I have, which makes sense because I spend most of my time fostering container based architectures that help you breaking the monolith in the back-end and the rest of my time building and helping others to build mobile apps.
To illustrate this I've create a sample live events app (the horrible monolith) to then add a timeline functionality as a module to show a log of comments during the live show.

Code samples should work straight away in Red Hat Mobile Application Platform, but could be adapted to run somewhere else.

## Repos Cast

* Flutter App [here](https://github.com/cvicens/flutter-gramola)
* Flutter Timeline Module [here](https://github.com/cvicens/flutter-gramola-timeline)
* API (as a Red Hat Mobile Cloud App) [here](https://github.com/cvicens/gramola-cloud-app)


# TL;DR
I'll show how to add functionalities to a Flutter App in a modular way and explain why it fits quite well with a micro-services strategy.
The code of the App is here and the added functionality is here.

# Act 1 - Falling in love
So, one of those days I was helping customers to follow the Zombieland rules applied to innovation I talked to a friend about Flutter, I just brought up the subject because we use React Native at that event but I had heard about Flutter for quite some time and I wanted to know his opinion. I started saying I wasn't convinced at all, a new language Dart, no signs of Javascript around... I was in love with RN I couldn't help it... He replied that Dart wasn't that different to Javascript and it was a strong typed language, so I ended up promising myself to give it a try. And I did.
I was really excited... It took me minutes to understand how to create a Flutter Plugin and run the sample code (I can tell that with React Native it took me way longer) so I had a crash, I couldn't stop typing... Dart, to be honest at the beginning I didn't even notice it was Dart... it just feels normal after Java, Javascript and Typescript. End result? I spent 2 days to create the first version of an SDK for our mobile services that run on Openshift.
You don't believe me [install Flutter](https://flutter.io/get-started/install/) and just do [flutter create --org com.example --template=plugin hello](https://flutter.io/developing-packages/#plugin) and see it with your own eyes.
So as a proof of true love I created a Flutter App where you can login and see present and future live events. Not very useful to be honest, but enough to get the idea.
This App uses data it gets invoking a REST API 'events', see diagram below.

![The Gramola App](https://raw.githubusercontent.com/cvicens/flutter-gramola/master/images/flutter-app-before.png)

Relevant elements, I'm using Fluro for routing and Flutter Flux as a redux library.

If you have a look to the code you'll find a pretty straightforward structure I spent some time looking out there for a nice structure and finally I took Sergi's [planets](https://github.com/sergiandreplace/planets-flutter) app as a reference, I also scavenged some nice pieces of code as well ;-)

The code is divided into config, model and components.

* **config**: where routes, redux store, constants, etc. are defined
* **components**: basically where screens are
* **model**: where business object are

# Act 2 - Recurrent nightmare
So I was in love with Flutter, I could create nice looking and responsive apps for iOS and Android very fast, my life was full... but I kept having this recurrent nightmare at night (you know the 'Pennywise the Clown' saying: boo, your App is a monolith! kind of nightmare).

![Boo!](https://raw.githubusercontent.com/cvicens/flutter-gramola/master/images/boo-your-app-is-a-monolith.jpg)

## Was my app really a monolith? 
Yes, it's was a binary (actually two, iOS and Android) right? Adding new features means adding code to the base code, adding tests, ... so yes, pretty much a monolith at this point.

## Is it possible to 'break it'?
Yes and no, the truth is that in order to truly break this monolith I would need to be able not only to take it apart into pieces (mini-apps, modules) but to deliver those parts independently, potentially over the air (no need for a full app update).

**Those modules should be able to work independently and have a sole purpose.** A good in-depth explanation about modularization can be found [here](https://medium.com/@alexmngn/why-react-developers-should-modularize-their-applications-d26d381854c1).
 
Long story short, with Flutter you can create modules for your App that can be used also independently (the first part of breaking the monolith) but as of today you cannot deliver those modules independently.

In any case, although you cannot comply with the second part of the deal (as far as I know and as of today, May 2018), it's way better to use a modularized approach than none at all.

## Creating a new feature as a module
I remembered that the Flutter 'create' command had a type flag with three options, create and App, create a Plugin and [create a Package](https://flutter.io/developing-packages/#step-1-create-the-package)... So next day I decided to modify my app to add a module (package) and test if I could give that module a completely separated and autonomous lifecycle. My idea was simple, I wanted to have a separate Git repo for this module including an example App to test it (something usual in Flutter packages, as you can see [here](https://pub.dartlang.org/packages/image_picker) tab 'Example'). This way I could add this module to my App (or others) while maintaining a separate line of development, testing, etc.

Something like this.
![Gramola App diagram](https://raw.githubusercontent.com/cvicens/flutter-gramola/master/images/flutter-app-after.png)

As you can see I wanted to 'use' a module called 'timeline' which sole purpose was request timeline entries for a specific user and event, as in the next picture.

![Timeline detail](https://raw.githubusercontent.com/cvicens/flutter-gramola/master/images/timeline-detail.png)

To achieve this I had to create a module (Flutter package) as follows. For those eager to see code, the repo is [here](https://github.com/cvicens/flutter-gramola-timeline).

```
flutter create --org com.redhat -t package gramola_timeline
```

Then I created a Flutter App inside the package.

```
cd gramola_timeline
flutter create --org com.redhat example
```

Then I added the following dependency to the 'pubspec.yaml' of our 'example' project. As you can see the example project points to the module package 'gramola_timeline' using a relative path.

``` yaml
  gramola_timeline:
    path: ../
```

The entry point for our Flutter package is './lib/<package-name>.dart', in our case './lib/gramola_timeline.dart'.

After minimally testing the example project could use the sample class Calculator (sample code generated with 'flutter create -t package') in 'gramola_timeline/lib/gramola_timeline.dart' it was time to develop the component that I actually needed, a timeline.

With that purpose in mind I created a Widget called [EventTimelineComponent](https://github.com/cvicens/flutter-gramola-timeline/blob/master/lib/gramola_timeline.dart) that you can use easily as in the following snippet.

``` dart
Navigator.push(
  context,
  new MaterialPageRoute(
    builder: (context) => new EventTimelineComponent(
      new TimelineConfiguration(
        eventId: _eventIdFieldController.text, 
        userId: _userIdFieldController.text, 
        imagesBaseUrl: ''
      )
    )
  ),
);
                      
```

In the snippet above I create the timeline component by providing an eventId and userId, (the imageBaseUrl is for a future update); then I push the Timeline component as a route in the navigator.

Once instantiated the component will look for a specific API, invoke it and render the results if any. Results should have the following shape.

``` json
{
    "id": "0002",
    "eventId": "0001",
    "userId": "trever",
    "title": "About to start ;-)",
    "date": "2018-04-27",
    "time": "18:30",
    "description": "Presumably epic... let's see!",
    "image": ""
}
```

As you can check our timeline widget is stateful and uses '[flutter_flux](https://github.com/google/flutter_flux)' to manage the component state, if you haven't exposed yourself to the Flux pattern you could start [here]() for an introduction.

I'd like to highlight that at the time of writing I couldn't find a timeline component to show the timeline entries as I wanted, so I coded a CustomPainter for that. Go to './lib/timeline_entry_row.dart' and look for LinePainter. Needless to say how useful was the hot-reload to fine tune the LinePainter :-)

After all the coding this was the result.

![Timeline example app running ](https://raw.githubusercontent.com/cvicens/flutter-gramola/master/images/timeline-example-app-1500px.png)

# Act 3 - Defeating Pennywise the Clown
The idea is simple, our app should use the component in the same fashion as the example app, the only difference is that instead of defining the dependency of the 'gramola_timeline' package using a relative path, we want to depend of a certain version. To do so you could:

* publish your package in https://pub.dartlang.org and consume it as any other package
* publish your package to your own package server
* or just point to a git repo

For simplicity I used the latter approach as in the following snippet.

``` yaml
  # Gramola timeline 
  gramola_timeline:
    git:
      url: https://github.com/cvicens/flutter-gramola-timeline
      ref: v0.0.6
```

Finally, let me show you how I use the timeline component in Gramola, our horrible monolith, now not that monolithic any more.

Because I'm using 'fluro', you have to go first to file [events_row_component.dart](https://github.com/cvicens/flutter-gramola/blob/master/lib/components/events/events_row_component.dart) and look for function '_navigateToTimeline()'. There you'll see I use a query like URL syntax to navigate to the timeline module providing values to query like variables 'eventId' and 'userId'.

``` dart
 _navigateToTimeline(context, String eventId, String userId) {
    Navigator.pushNamed(context, '/timeline?eventId=$eventId&userId=$userId');
  }
```

So where's the actual use of our timeline component? To find the answer you have to take a look at '[routes.dart](https://github.com/cvicens/flutter-gramola/blob/master/lib/config/routes.dart)' specifically where '/timeline' route is defined and attached to 'timelineRouteHandler'.

``` dart
static void configureRoutes(Router router) {
    ...
    router.define("/timeline", handler: timelineRouteHandler);
    ...
  }
```

Finally have a look below to 'timelineRouteHandler', defined in file '[route_handlers](https://github.com/cvicens/flutter-gramola/blob/master/lib/config/route_handlers.dart)', as you can see this handler expects two parameters, 'eventId' and 'userId' to create our timeline component.

``` dart
...
var timelineRouteHandler = new Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
  String eventId = params["eventId"]?.first;
  String userId = params["userId"]?.first;
  return new EventTimelineComponent(
    new TimelineConfiguration(
      eventId: eventId,
      userId: userId,
      imagesBaseUrl: ''
    )
  );
});
...
```

So, in the end I have defined a navigation rule to navigate to the component defined in a module which has it's own lifecycle, navigation, assets, widgets, etc.

Let me show you an image that illustrates a possible lifecycle of our app including yet another feature 'ticketing', just to give you a view of the whole repos scenario.

![Whole lifecycle view of a modular flutter app](https://raw.githubusercontent.com/cvicens/flutter-gramola/master/images/modular-flutter-b.png)

Let's see the result, note that colors are different because the theme is different, so our module is Theme aware, not a bad thing to do by the way.

![Gramola App complete](https://raw.githubusercontent.com/cvicens/flutter-gramola/master/images/gramola-app-1500px.png)

# Before the curtain falls
[Voiceover]

Let me go back to my previous love, RN, remember? Well, with React Native by using 'npm' modules and 'Code Push' it's possible to inject new modules without deploying a new binary (unless new native libraries are involved), basically it is possible to provide a tradeoff solution to the second part of the 'breaking the monolith' deal.
 For a thorough insight into mini-apps it could be worth to have a look to [this article](https://medium.com/@prashantramnyc/microservices-architecture-for-mobile-application-development-part-i-20b4f4089a24), there Prashant Ram speaks explains the Walmart Labs approach to breaking the mobile app monolith by using React Native and an OTA server to push new mini-apps to a core app.
 
Having said that and spent quality time with both Flutter and React Native it's difficult to rule out one of them, in fact I think both are really good multi-platform frameworks that can help you create applications in a modular fashion while having a common (mostly) code base.

I hope these ideas will hopefully help you creating mobile apps that can keep the pace of innovation of your micro-services based back-end ;-)