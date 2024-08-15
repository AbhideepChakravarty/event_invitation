import 'package:flutter/material.dart';

import 'nav_data.dart';

class EventAppRouteParser
    extends RouteInformationParser<EventAppNavigatorData> {
  @override
  Future<EventAppNavigatorData> parseRouteInformation(
      RouteInformation routeInformation) async {
    //print("parseRouteInformation is called.");
    final uri = Uri.parse(routeInformation.location.toString());
    final queryParams = uri.queryParameters;
    //print("Received URI - $uri - ${uri.pathSegments.length}");
    //print("Qp in parser = $queryParams");
    EventAppNavigatorData navData;
    //handle '/'
    if (uri.pathSegments.isEmpty) {
      if (uri.toString() != "/") {
        //print("Paring for home page but instantiating login page");
        navData = EventAppNavigatorData.login({});
      } else {
        //print("Paring for home page");
        navData = EventAppNavigatorData.home({});
      }
    }

    //handle '/login'
    else if (uri.pathSegments.length == 1) {
      //print("Path length is 1 and path is = " + uri.pathSegments.elementAt(0));
      switch (uri.pathSegments.elementAt(0)) {
        case "login":
          //print("Login triggered.");
          navData = EventAppNavigatorData.login(queryParams);
          break;
        case "signup":
          //print("Signup triggered.");
          navData = EventAppNavigatorData.signup();
          break;
        case "userProfile":
          //print("Menus triggered.");
          navData = EventAppNavigatorData.userProfile(queryParams, null);
          break;
        case "dashboards":
          //print("Menus triggered.");
          navData = EventAppNavigatorData.dashboards();
          break;
        case "manage":
          //print("Menus triggered.");
          navData = EventAppNavigatorData.manage();
          break;
        case "counters":
          //print("COunters triggered.");
          navData = EventAppNavigatorData.counters();
          break;
        default:
          //print("Unknown triggered.");
          navData = EventAppNavigatorData.unknown();
      }
    }

    //Handle path with id
    else if (uri.pathSegments.length == 2) {
      final second = uri.pathSegments.elementAt(1);
      final first = uri.pathSegments.elementAt(0);
      if (first == "invitations") {
        navData = EventAppNavigatorData.invitationDetails(second);
      } else if (first == "pages") {
        navData = EventAppNavigatorData.page(second, {});
      } else if (first == "people") {
        navData = EventAppNavigatorData.people(second);
      } else if (first == "qnas") {
        navData = EventAppNavigatorData.qna(second);
      } else if (first == "mementoes") {
        navData = EventAppNavigatorData.memento(second);
      } else if (first == "upload") {
        navData = EventAppNavigatorData.upload(second, queryParams);
      } else if (first == "albums") {
        navData = EventAppNavigatorData.albumDetails(second, queryParams);
      } else {
        navData = EventAppNavigatorData.unknown();
      }
    } else if (uri.pathSegments.length == 3) {
      final id = uri.pathSegments.elementAt(2);
      final second = uri.pathSegments.elementAt(1);
      final first = uri.pathSegments.elementAt(0);
      if (second == "edit" && first == "menus") {
        navData = EventAppNavigatorData.menuEdit(id);
      } else if (second == "edit" && first == "menuItems") {
        navData = EventAppNavigatorData.menuItemEdit(id);
      } else if (second == "serve" && first == "counters") {
        navData = EventAppNavigatorData.counterServe(id);
      } else if (second == "history" && first == "counters") {
        navData = EventAppNavigatorData.counterOrderHistory(id);
      } else if (first == "dashboards" && second == "entity") {
        navData = EventAppNavigatorData.dashboardsEntity(id);
      } else if (first == "dashboards" && second == "servedItems") {
        navData = EventAppNavigatorData.dashboardsServedItems(id);
      } else if (first == "dashboards" && second == "rejectedItems") {
        navData = EventAppNavigatorData.dashboardsRejectedItems(id);
      } else if (first == "dashboards" && second == "orders") {
        navData = EventAppNavigatorData.dashboardsOrders(id);
      } else {
        navData = EventAppNavigatorData.unknown();
      }
    } else {
      navData = EventAppNavigatorData.unknown();
    }
    //print("Nav = $navData");
    return navData;
  }

  @override
  RouteInformation restoreRouteInformation(
      EventAppNavigatorData configuration) {
    //print("In restoreRouteInformation navDats is  = $configuration");
    String location2 = configuration.getPathURL();
    //print("In restoreRouteInformation path = $location2");
    RouteInformation routeInfo = RouteInformation(location: location2);
    return routeInfo;
  }
}
