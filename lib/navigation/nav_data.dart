class EventAppNavigatorData {
  final List<String> pathParts;
  final String? id;
  Map<String, dynamic> qp = {};
  EventAppNavigatorData? targetPath;
  List<String> allowedPaths = [
    "/login",
    "/404",
    "/",
    "/invitations",
    "/pages",
    "/qnas",
    "/people",
    "/userProfile",
    "/mementoes",
    "/upload",
    "/albums",
    //---------------
    "/counters/serve",
    "/counters/history",
    "/dashboards",
    "/dashboards/entity",
    "/manage/entity",
    "/dashboards/servedItems",
    "/dashboards/rejectedItems",
    "/dashboards/orders",
    "/menus/edit",
    "/menuItems/edit",
    "/menuItems/create",
    "/signup"
  ];

  List<String> securedPaths = [
    "/",
    //"/invitations",
  ];

  EventAppNavigatorData(
      {required this.pathParts, required this.qp, this.id, this.targetPath}) {
    //print("Path Parts : " + pathParts.toString());
    //this.pathURL = getPathURL(pathParts, id);
  }

  String getPathURL() {
    String url = "";
    String urlPart = "";
    for (String part in pathParts) {
      print("URL part = $part");
      if (part == "/") {
        url = part;
        continue;
      }
      url = "$url/$part";
    }
    urlPart = url;
    if (id != null) {
      url = "$url/$id";
    }
    if (qp.isNotEmpty) {
      url = "$url?";
      for (String key in qp.keys) {
        url = "$url$key=${qp[key]}&";
      }
      url = url.substring(0, url.length - 1);
    }
    print("ND URL part collected = $urlPart");
    print("ND URL collected = $url");
    print("ND Query Params = $qp");
    String finalPath = allowedPaths.contains(urlPart) ? url : "/404";
    print("Final path = $finalPath");
    return finalPath;
  }

  EventAppNavigatorData.home(Map<String, String> queryParams)
      : id = null,
        qp = queryParams,
        pathParts = ["/"];
  EventAppNavigatorData.login(Map<String, dynamic> queryParams)
      : id = null,
        qp = queryParams,
        pathParts = ["login"];
  EventAppNavigatorData.userProfile(
      Map<String, dynamic> queryParams, EventAppNavigatorData? targetPath)
      : id = null,
        targetPath = targetPath,
        qp = queryParams,
        pathParts = ["userProfile"];
  EventAppNavigatorData.loginWithTarget(
      EventAppNavigatorData pTargetPath, Map<String, dynamic> queryParams)
      : id = null,
        targetPath = pTargetPath,
        pathParts = ["login"];
  EventAppNavigatorData.invitationDetails(String invitationCode)
      : id = invitationCode,
        pathParts = ["invitations"];
  EventAppNavigatorData.page(String pageRef, Map<String, dynamic> queryParams)
      : id = pageRef,
        qp = queryParams,
        pathParts = ["pages"];
  EventAppNavigatorData.qna(String qnaRef)
      : id = qnaRef,
        pathParts = ["qnas"];

  EventAppNavigatorData.memento(String mementoRef)
      : id = mementoRef,
        pathParts = ["mementoes"];

  EventAppNavigatorData.people(String peopleRef)
      : id = peopleRef,
        pathParts = ["people"];

  EventAppNavigatorData.upload(String pageRef, Map<String, dynamic> queryParams)
      : id = pageRef,
        qp = queryParams,
        pathParts = ["upload"];
  EventAppNavigatorData.albumDetails(
      String pageRef, Map<String, dynamic> queryParams)
      : id = pageRef,
        qp = queryParams,
        pathParts = ["albums"];
  //-------------------------------------------------------------------------------
  //pathURL = "/login";
  EventAppNavigatorData.menus()
      : id = null,
        pathParts = ["menus"];
  EventAppNavigatorData.counters()
      : id = null,
        pathParts = ["counters"];
  EventAppNavigatorData.dashboards()
      : id = null,
        pathParts = ["dashboards"];
  EventAppNavigatorData.manage()
      : id = null,
        pathParts = ["manage"];
  //pathURL = "/menus";
  EventAppNavigatorData.signup()
      : id = null,
        pathParts = ["signup"];
  //pathURL = "/menus";
  EventAppNavigatorData.unknown()
      : id = null,
        pathParts = ["404"];
  //pathURL = "/404";
  EventAppNavigatorData.menuEdit(String menuCode)
      : id = menuCode,
        pathParts = ["menus", "edit"];
  EventAppNavigatorData.menuItemEdit(String foodItemCode)
      : id = foodItemCode,
        pathParts = ["menuItems", "edit"];
  EventAppNavigatorData.menuItemCreate()
      : id = null,
        pathParts = ["menuItems", "create"];
  //pathURL = "/menus/edit/" + menuCode;

  EventAppNavigatorData.counterServe(String counterCode)
      : id = counterCode,
        pathParts = ["counters", "serve"];

  EventAppNavigatorData.counterOrderHistory(String counterCode)
      : id = counterCode,
        pathParts = ["counters", "history"];

  EventAppNavigatorData.dashboardsEntity(String entityCode)
      : id = entityCode,
        pathParts = ["dashboards", "entity"];

  EventAppNavigatorData.dashboardsServedItems(String entityCode)
      : id = entityCode,
        pathParts = ["dashboards", "servedItems"];

  EventAppNavigatorData.dashboardsRejectedItems(String entityCode)
      : id = entityCode,
        pathParts = ["dashboards", "rejectedItems"];

  EventAppNavigatorData.dashboardsOrders(String entityCode)
      : id = entityCode,
        pathParts = ["dashboards", "orders"];

  @override
  String toString() {
    return "id = $id pathParts = $pathParts qp = $qp targetPath = $targetPath";
  }

  bool isEqual(EventAppNavigatorData other) {
    if (id != other.id || targetPath != other.targetPath) {
      return false;
    }

    if (!_mapEquals(qp, other.qp)) {
      return false;
    }

    if (pathParts.length != other.pathParts.length) {
      return false;
    }

    for (var i = 0; i < pathParts.length; i++) {
      if (pathParts[i] != other.pathParts[i]) {
        return false;
      }
    }
    return true;
  }

  bool _mapEquals(Map<dynamic, dynamic> map1, Map<dynamic, dynamic> map2) {
    if (map1.length != map2.length) return false;

    for (var key in map1.keys) {
      if (!map2.containsKey(key) || map1[key] != map2[key]) {
        return false;
      }
    }
    return true;
  }

  //Method returns true if pathParts concatenated string is part of securedPaths
  // else returns false
  bool isSecuredPage() {
    String url = "";
    for (String part in pathParts) {
      if (part == "/") {
        url = part;
        continue;
      }
      url = "$url/$part";
    }
    print("$url is secured page = ${securedPaths.contains(url)}");
    return securedPaths.contains(url);
  }
}
