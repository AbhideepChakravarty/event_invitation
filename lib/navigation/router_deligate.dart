import 'package:event_invitation/main.dart';
import 'package:event_invitation/services/userProfile/user_profile_data.dart';
import 'package:event_invitation/ui/pages/invitationDetails/invitation_details.dart';
import 'package:event_invitation/ui/pages/people/people_page.dart';
import 'package:event_invitation/ui/pages/qna/qna_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../ui/helpers/security/secure_page.dart';
import '../ui/memento/memento_page.dart';
import '../ui/pages/login/login_page.dart';
import '../ui/pages/page/page_page.dart';
import '../ui/pages/userInvitation/home_page.dart';
import '../ui/pages/userProfile/user_profile_page.dart';
import '../ui/unknown.dart';
import 'nav_data.dart';

class EventAppRouterDelegate extends RouterDelegate<EventAppNavigatorData>
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<EventAppNavigatorData> {
  EventAppNavigatorData? navData;
  Function eq = const ListEquality().equals;
  EventAppRouterDelegate({required this.navData}) {
    _pages.add(_buildMaterialPage(navData as EventAppNavigatorData));
  }

  ValueChanged<EventAppNavigatorData> get routeTrigger {
    print("Router trigger set.");
    return _loadPageByNavData;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _pages,
      onPopPage: (route, result) {
        //print("onPopPage is being called.");
        if (!route.didPop(result)) return false;
        popRoute();
        return true;
      },
    );
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      navData = null;
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false); //_confirmAppExit(context) as Future<bool>;
  }

  MaterialPage _buildMaterialPage(EventAppNavigatorData data) {
    MaterialPage? page;
    print("RD load page by nav data: " + data.toString());
    //Check is data is secured Page
    if (data.isSecuredPage()) {
      //Check if user is logged in and anonymous user
      if (FirebaseAuth.instance.currentUser == null ||
          FirebaseAuth.instance.currentUser!.isAnonymous) {
        print("User is not logged in.");
        //if data pathParts conatains invitations and id is not null
        if (data.pathParts.contains("invitations") && data.id != null) {
          print("User not logged in and invitation details page.");
          //create map with key as inv and value as id
          Map<String, String> qp = {"inv": data.id.toString()};
          //then redirect to invitation details page
          page = MaterialPage(
              key: const ValueKey("LoginInvitationDetails"),
              child: LoginPage(
                onTap: _loadPageByNavData,
                queryParams: qp,
              ));
          navData = EventAppNavigatorData(pathParts: ["login"], qp: qp);
        } else {
          print("User not logged in and login page.");
          //If user is not logged in then redirect to login page
          page = MaterialPage(
              key: ValueKey("Login"),
              child: LoginPage(
                onTap: _loadPageByNavData,
                targetPath: data,
                queryParams: data.qp,
              ));
          navData = EventAppNavigatorData(
              pathParts: ["login"], qp: data.qp, targetPath: data);
        }
      } else {
        page = _buildPage(data);
      }
    } else {
      page = _buildPage(data);
    }

    print("Page: " + page!.key.toString());
    return page as MaterialPage;
  }

  final List<MaterialPage> _pages = <MaterialPage>[];
  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  @override
  Future<void> setNewRoutePath(EventAppNavigatorData configuration) async {
    print("RD New config: " + configuration.toString());
    /*if (configuration.pathParts.contains("login") &&
        FirebaseAuth.instance.currentUser != null) {
      //if anonymous user then continue else return
      if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
        return;
      }
    }*/
    _loadPageByNavData(configuration);
  }

  void _loadPageByNavData(EventAppNavigatorData configuration) {
    print("In load page by nav data: " + configuration.toString());
    print("Condition: " +
        (navData == null || !(navData!.isEqual(configuration))).toString());
    if (navData == null || !(navData!.isEqual(configuration))) {
      navData = configuration;

      _pages.add(_buildMaterialPage(navData as EventAppNavigatorData));
      notifyListeners();
    }
  }

  @override
  EventAppNavigatorData? get currentConfiguration {
    return navData;
  }

  MaterialPage? _buildPage(EventAppNavigatorData data) {
    MaterialPage? page;
    String pathURL = data.getPathURL().trim();
    print("RD Path URL = " + pathURL);
    print("RD Nav Data = " + data.toString());
    String? id = data.id;
    if (id == null) {
      print("id is null");
      if (pathURL.startsWith("/login")) {
        page = MaterialPage(
          key: ValueKey("Login"),
          child: LoginPage(
            onTap: _loadPageByNavData,
            queryParams: data.qp,
          ),
        );
      }
      if (pathURL.startsWith("/404")) {
        page = MaterialPage(
          key: const ValueKey("404"),
          child: Unknown(onTap: _loadPageByNavData),
        );
      }
      if (pathURL == "/") {
        print("Found Homepage.");
        page = const MaterialPage(key: ValueKey("HomePage"), child: HomePage());
      }
      if (pathURL == "/userProfile") {
        print("Found User Profile.");
        page = MaterialPage(
            key: const ValueKey("UserProfile"), child: UserProfilePage());
      }
    } else {
      //Here id is not null
      if (pathURL.startsWith("/invitations")) {
        print("Found Inv Details page.");
        page = MaterialPage(
            key: ValueKey("InvitationDetails"),
            child: InvitationDetailsPage(invitationCode: id.toString()));
      }

      if (pathURL.startsWith("/pages")) {
        print("Found pages page.");
        page = MaterialPage(
            key: ValueKey("Pages"), child: PagePage(pageRef: id.toString()));
      }

      if (pathURL.startsWith("/qnas")) {
        print("Found QnA page.");
        page = MaterialPage(
            key: const ValueKey("QnA"),
            child: QnAPage(
              qnaRef: id.toString(),
            ));
      }

      if (pathURL.startsWith("/mementos")) {
        print("Found Memento page.");
        page = MaterialPage(
            key: const ValueKey("Memento"),
            child: MementoPage(
              mementoRef: id.toString(),
            ));
      }

      if (pathURL.startsWith("/people")) {
        print("Found People page.");
        page = MaterialPage(
            key: const ValueKey("People"),
            child: PeoplePage(
              peopleRef: id.toString(),
            ));
      }
    }
    return page;
  }
}
