import 'package:event_invitation/services/invitation/invitation_notifier.dart';
import 'package:event_invitation/services/memento/file_upload_data.dart';
import 'package:event_invitation/services/memento/media_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'auth/firebase_auth.dart';
import 'firebase_opti.dart';

import 'navigation/nav_data.dart';
import 'navigation/path_parser.dart';
import 'navigation/router_deligate.dart';
import 'services/helper/language_provider.dart';
import 'services/helper/user_profile_provider.dart';
import 'services/memento/album_media_provider.dart';
import 'services/memento/album_provider.dart';
import 'ui/helpers/theme/mytheme.dart';
import 'ui/helpers/theme/font_provider.dart';

Future<void> main() async {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    //print('${record.level.name}: ${record.time}: ${record.message}');
  });

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventAppRouterDelegate>(create: (context) {
          return EventAppRouterDelegate(
            navData: EventAppNavigatorData.login({}),
          );
        }),
        ChangeNotifierProvider<ThemeChanger>(create: (_) {
          ThemeChanger themeChanger = ThemeChanger();
          themeChanger.themeData = DefaultTheme().buildTheme();
          return themeChanger;
        }),
        ChangeNotifierProvider<InvitationProvider>(create: (_) {
          return InvitationProvider();
        }),
        ChangeNotifierProvider<LanguageProvider>(create: (_) {
          return LanguageProvider();
        }),
        ChangeNotifierProvider<UserProfileProvider>(create: (_) {
          var userProfileProvider = UserProfileProvider();
          userProfileProvider.setUserProfile(null);
          return userProfileProvider;
        }),
        ChangeNotifierProvider<FontProvider>(create: (_) {
          return FontProvider();
        }),
        ChangeNotifierProvider<UploadManager>(create: (_) {
          return UploadManager();
        }),
        ChangeNotifierProvider<MediaProvider>(create: (_) {
          return MediaProvider();
        }),
        ChangeNotifierProvider<AlbumProvider>(create: (_) {
          return AlbumProvider();
        }),
        ChangeNotifierProvider<AlbumMediaProvider>(create: (_) {
          return AlbumMediaProvider();
        }),
      ],
      child: FutureBuilder<User?>(
        future: FirebaseAuthHelper().auth.userChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && !snapshot.data!.isAnonymous) {
              //print("Non-anonymous user found: ${snapshot.data!.email}");
              return _getBody(context);
            } else {
              //print("No user found.");
              return FutureBuilder<User?>(
                future: FirebaseAuthHelper().signInAnonymously,
                builder: (context, anonSnapshot) {
                  if (anonSnapshot.connectionState == ConnectionState.done) {
                    if (anonSnapshot.hasData) {
                      //print("Anonymous user logged in.");
                      return _getBody(context);
                    } else {
                      //print("Logging in...");
                      return const Center(child: CircularProgressIndicator());
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  MaterialApp _getBody(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    final delegator = Provider.of<EventAppRouterDelegate>(context);
    //print("App loading = ${delegator.navData}");
    return MaterialApp.router(
      title: 'Occurr',
      theme: themeChanger.getTheme,
      debugShowCheckedModeBanner: false,
      routerDelegate: delegator,
      routeInformationParser: EventAppRouteParser(),
    );
  }
}
