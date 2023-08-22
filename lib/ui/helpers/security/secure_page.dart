import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../auth/firebase_auth.dart';
import '../../../navigation/nav_data.dart';
//import 'package:sito/ui/helper/processing_loader.dart';

class SecurePage extends StatelessWidget {
  final ValueChanged<EventAppNavigatorData> onTap;
  final Map<String, dynamic> qpMap;
  final Widget child;
  final EventAppNavigatorData targetPath;
  const SecurePage(
      {Key? key,
      required this.child,
      required this.onTap,
      required this.targetPath,
      required this.qpMap})
      : super(key: key);

  //bool loginInProgress = false;
  @override
  Widget build(BuildContext context) {
    Widget con = Container();
    final firebaseUser = FirebaseAuthHelper().getUser;
    print("Is user anonymous? " + firebaseUser!.isAnonymous.toString());
    if (firebaseUser == null || firebaseUser.isAnonymous) {
      Future.delayed(Duration.zero, () async {
        if (this.targetPath != null) {
          onTap(EventAppNavigatorData.loginWithTarget(targetPath, qpMap));
        } else {
          onTap(EventAppNavigatorData.login({}));
        }
      });
    } else {
      con = child;
    }
    //print(child);

    return con;
    //_getSecureBody(context);
  }

  /*

  Scaffold _getSecureBody(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Access Denied!"),
        ),
        body: Container(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ..._getComponents(context),
            ],
          ),
        )));
  }

  List<Widget> _getLoginComponents(BuildContext context) {
    return [
      Text("To view this page, you need to login."),
      const SizedBox(
        height: 15,
      ),
      ElevatedButton(
          onPressed: () async {
            setState(() {
              loginInProgress = true;
            });
            bool result = await FirebaseAuthHelper().handleAuth(context);
            setState(() {
              loginInProgress = false;
            });
            if (result) {
              Navigator.of(context).pop();
            }
          },
          child: Text("Login"))
    ];
  }

  List<Widget> _getLoginProgressComponents(BuildContext context) {
    return [CircularProgressIndicator.adaptive()];
  }

  List<Widget> _getComponents(BuildContext context) {
    if (loginInProgress) {
      return _getLoginProgressComponents(context);
    } else {
      return _getLoginComponents(context);
    }
  }
  */
}
