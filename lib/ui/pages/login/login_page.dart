import 'package:event_invitation/auth/firebase_auth.dart';
import 'package:event_invitation/navigation/nav_data.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter_signin_button/button_builder.dart';
import 'package:provider/provider.dart';

import '../../../navigation/router_deligate.dart';
import '../../../services/invitation/invitation_data.dart';
import '../../../services/invitation/invitation_notifier.dart';
import '../../../services/invitation/invitation_service.dart';

// ignore: must_be_immutable
class LoginPage2 extends StatelessWidget {
  final ValueChanged<EventAppNavigatorData> onTap;
  final EventAppNavigatorData? targetPage;
  final _formKey = GlobalKey<FormState>();
  final _myLoginController = TextEditingController();
  final _myPwdController = TextEditingController();
  late BuildContext localContext;

  LoginPage2({Key? key, required this.onTap, this.targetPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //AuthVerifier.verifyLogin(context, onTap, null);
    print("Login page loading starts");
    /*FirebaseAuth.instance.userChanges().listen((event) {
      print("User check on login page.");
      if (event != null) print("User found on login page.");
      //print("I am happening");
      this.targetPage == null
          ? onTap(FastServeAdminNavigatorData.menus())
          : onTap(targetPage!);
    });*/
    //print("User not found on login page.");
    return Container();

    /*SignInScreen(
      showAuthActionSwitch: false,
      providers: [
        EmailAuthProvider(),
      ],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) async {
          await Singleton().loadConfig();
          FirebaseAuthenticationService().subscribeToTopics();
          this.targetPage == null
              ? onTap(FastServeAdminNavigatorData.menus())
              : onTap(targetPage!);
        }),
      ],
      headerBuilder: (context, constraints, shrinkOffset) {
        return Container(
          height: 200,
          margin: EdgeInsets.only(top: 10),
          child: Image(image: AssetImage("images/undraw_sign_in.png")),
        );
      },
      //headerBuilder: headerImage('assets/images/flutterfire_logo.png'),
    );*/
    /*this.localContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: Form(
                key: this._formKey, child: Column(children: getLoginForm()))),
      ),
    );*/
  }

  List<Widget> getLoginForm() {
    List<Widget> column = [];
    var email = Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(10),
        child: TextFormField(
          controller: this._myLoginController,
          textAlign: TextAlign.center,
          autocorrect: false,
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
              hintText: 'abc@xyz.com'),
          validator: (value) {},
        ));
    var pwd = Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(10),
        child: TextFormField(
          controller: this._myPwdController,
          textAlign: TextAlign.center,
          obscureText: true,
          autocorrect: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            labelText: 'Password',
          ),
          validator: (value) {
            if (value!.trim().isEmpty) {
              return 'Please enter password.';
            }
            return null;
          },
        ));
    Widget image = Container(
      height: 200,
      margin: EdgeInsets.only(top: 10),
      child: Image(image: AssetImage("images/undraw_sign_in.png")),
    );
    Widget button = ElevatedButton(
      onPressed: () async {
        //print("Trying to sign in.");
        if (_formKey.currentState!.validate()) {
          /*var firebaseAuth = FirebaseAuthenticationService();
          String msg = await firebaseAuth.signInWithEmail(
              this._myLoginController.text, this._myPwdController.text);
          if (msg.contains("Sign in successful!")) {
            this.targetPage == null
                ? onTap(FastServeAdminNavigatorData.menus())
                : onTap(targetPage!);*/
        } else {
          final snackBar = SnackBar(content: Text("msg"));
          ScaffoldMessenger.of(this.localContext).showSnackBar(snackBar);
        }
      },
      child: Text("Login"),
    );
    column.add(image);
    column.add(email);
    column.add(pwd);
    column.add(button);
    return column;
  }
}

class MyVertRectClipper extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, 100, 100);
  }

  bool shouldReclip(oldClipper) {
    return false;
  }
}

/////////////////////////////////////////////////////////////////////////
///
///

class LoginPage extends StatefulWidget {
  final ValueChanged<EventAppNavigatorData> onTap;
  Map<String, dynamic>? queryParams = {};
  EventAppNavigatorData? targetPath;
  LoginPage({Key? key, required this.onTap, this.queryParams, this.targetPath})
      : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final FirebaseAuthHelper _authHelper = FirebaseAuthHelper();
  String dropdownValue = '+91';
  String? _verificationId;
  final InvitationService _invitationService = InvitationService();
  late Future<InvitationData> _invitationData;

  void _onVerificationCompleted() {
    print("Go to home page");
    // Navigate to the home page
    final delegator =
        Provider.of<EventAppRouterDelegate>(context, listen: false);
    print("Delegator: $delegator");
    ValueChanged<EventAppNavigatorData> onTap = delegator.routeTrigger;
    if (widget.targetPath != null) {
      onTap(widget.targetPath!);
      return;
    } else {
      var invitationCode = widget.queryParams!["inv"];
      print("Invitation code: $invitationCode");
      invitationCode == null
          ? onTap(EventAppNavigatorData.home({}))
          : onTap(EventAppNavigatorData.invitationDetails(invitationCode));
    }
  }

  void _onVerificationFailed(FirebaseAuthException e) {
    // Show a dialog with the error message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Verification Failed'),
          content: Text(
              e.message ?? 'An unknown error occurred.' + e.message! + e.code),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onCodeSent(String verificationId, int? resendToken) {
    _verificationId = verificationId;
    // Show dialog to enter the SMS code
    print("Code received.");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter the SMS Code'),
          content: TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'SMS OTP',
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Submit'),
              onPressed: () {
                _authHelper
                    .signInWithCredntials(
                        _codeController.text, _verificationId!)
                    .then((value) {
                  _onVerificationCompleted();
                }).onError((error, stackTrace) {
                  FirebaseAuthException ex = FirebaseAuthException(
                      message: error.toString(), code: 'ERROR');
                  _onVerificationFailed(ex);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _onCodeAutoRetrievalTimeout(String verificationId) {
    _verificationId = verificationId;
    // Show a dialog with a timeout message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Code Auto Retrieval Timeout'),
          content:
              Text('The SMS code retrieval has timed out. Please try again.'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.queryParams!["inv"] != null) {
      _invitationData = _invitationService
          .fetchData(widget.queryParams!["inv"])
          .then((value) async {
        Provider.of<InvitationProvider>(context, listen: false)
            .setInvitation(value);
        return value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("LP Query Paramas: " + widget.queryParams.toString());
    return Scaffold(
      body: widget.queryParams!["inv"] != null
          ? _getInvitationLoginPage()
          : _getSimpleLoginPage(),
    );
  }

  Container _getSimpleLoginPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: //Set a gradient of purple color
              [
            Colors.purple.shade700,
            const Color.fromARGB(255, 234, 199, 240)
          ],
        ),
      ),
      child: _getPhoneLoginWidgets(),
    );
  }

  Align _getPhoneLoginWidgets() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 50),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Login',
                style: TextStyle(
                  color: Colors.purple[700],
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.purple[700]),
                    underline: Container(
                      height: 2,
                      color: Colors.purple[700],
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!.toString();
                      });
                    },
                    items: <String>['+1', '+91', '+44', '+61']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: 'Phone Number',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple.shade700),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple.shade700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Implement login functionality here
                  String phoneNumber =
                      dropdownValue + _phoneController.text.trim();
                  print(phoneNumber); // for testing
                  if (kIsWeb) {
                    await _authHelper
                        .signInWithPhoneNumber(phoneNumber)
                        .then((confirmationResult) {
                      _openOTPDialog(confirmationResult);
                    });
                  } else {
                    _authHelper.verifyPhoneNumber(
                      phoneNumber,
                      _onVerificationCompleted,
                      _onVerificationFailed,
                      _onCodeSent,
                      _onCodeAutoRetrievalTimeout,
                    );
                  }
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getInvitationLoginPage() {
    return FutureBuilder<InvitationData>(
      future: _invitationData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('No invitation data available.');
        }

        final invitation = snapshot.data!;

        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(invitation.invitationImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.purple],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //A sized box with height of half the screen size
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      Text(
                        invitation.primaryText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily:
                              'WeddingStyleFont', // Use the desired wedding style font
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 105,
                        child: Text(
                          invitation.secondaryText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _getPhoneLoginWidgets(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openOTPDialog(ConfirmationResult confirmationResult) {
    // open a dialog to enter the OTP with 1 min countdown for resend OTP option
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'OTP',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple.shade700),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple.shade700),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive OTP? ',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Implement resend OTP functionality here
                      await _authHelper.signInWithPhoneNumber(
                        dropdownValue + _phoneController.text.trim(),
                      );
                    },
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: Colors.purple,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Implement verify OTP functionality here
                await _authHelper.verifyOTP(
                  confirmationResult,
                  _codeController.text.trim(),
                  _onVerificationCompleted,
                  _onVerificationFailed,
                );
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }
}
