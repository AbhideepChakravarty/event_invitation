import 'package:event_invitation/auth/firebase_auth.dart';
import 'package:event_invitation/navigation/nav_data.dart';
import 'package:event_invitation/services/userProfile/user_profile_service.dart';
import 'package:event_invitation/ui/helpers/theme/font_provider.dart';
import 'package:event_invitation/ui/pages/login/components/isd_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter_signin_button/button_builder.dart';
import 'package:provider/provider.dart';

import '../../../navigation/router_deligate.dart';
import '../../../services/helper/user_profile_provider.dart';
import '../../../services/invitation/invitation_data.dart';
import '../../../services/invitation/invitation_notifier.dart';
import '../../../services/invitation/invitation_service.dart';
import '../../../services/userProfile/user_profile_data.dart';

class LoginPage extends StatelessWidget {
  final ValueChanged<EventAppNavigatorData> onTap;
  final Map<String, dynamic>? queryParams;
  final EventAppNavigatorData? targetPath;

  LoginPage({Key? key, required this.onTap, this.queryParams, this.targetPath})
      : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final FirebaseAuthHelper _authHelper = FirebaseAuthHelper();
  String dropdownValue = '+91';
  String? _verificationId;
  final InvitationService _invitationService = InvitationService();
  final UserProfileService _userProfileService = UserProfileService();

  late Future<InvitationData> _invitationData;

  void _onVerificationCompleted(BuildContext context) {
    _loadUser(context);
  }

  void _onVerificationFailed(BuildContext context, FirebaseAuthException e) {
    // Show a dialog with the error message
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Verification Failed'),
          content: Text(
            e.message ?? 'An unknown error occurred.' + e.message! + e.code,
          ),
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

  void _onCodeSent(
      String verificationId, int? resendToken, BuildContext context) {
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
                  _onVerificationCompleted(context);
                }).onError((error, stackTrace) {
                  FirebaseAuthException ex = FirebaseAuthException(
                      message: error.toString(), code: 'ERROR');
                  _onVerificationFailed(context, ex);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _onCodeAutoRetrievalTimeout(
      String verificationId, BuildContext context) {
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
  Widget build(BuildContext context) {
    if (queryParams!["inv"] != null) {
      _invitationData = _invitationService
          .fetchData(queryParams!["inv"], context)
          .then((value) async {
        Provider.of<InvitationProvider>(context, listen: false)
            .setInvitation(value);
        return value;
      });
    }
    print("LP Query Paramas: " + queryParams.toString());
    return Scaffold(
      body: queryParams!["inv"] != null
          ? _getInvitationLoginPage()
          : _getSimpleLoginPage(context),
    );
  }

  Container _getSimpleLoginPage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purple.shade700,
            const Color.fromARGB(255, 234, 199, 240),
          ],
        ),
      ),
      child: _getPhoneLoginWidgets(context),
    );
  }

  Align _getPhoneLoginWidgets(BuildContext context) {
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
                  ISDDropdownWidget(
                    initialValue: dropdownValue,
                    onChanged: (newValue) {
                      // Handle the value change here
                      dropdownValue = newValue;
                      // You can update your state or perform other actions based on the new value
                    },
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
                      _openOTPDialog(confirmationResult, context);
                    });
                  } else {
                    _authHelper.verifyPhoneNumber(
                      phoneNumber,
                      () => _onVerificationCompleted(context),
                      (e) => _onVerificationFailed(context, e),
                      (verificationId, resendToken) =>
                          _onCodeSent(verificationId, resendToken, context),
                      (verificationId) =>
                          _onCodeAutoRetrievalTimeout(verificationId, context),
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
                        style: Provider.of<FontProvider>(context)
                            .primaryTextFont
                            .copyWith(
                              fontSize: 50,
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      //const SizedBox(height: 20),
                      SizedBox(
                        //height: 105,
                        child: Text(
                          invitation.secondaryText,
                          style: Provider.of<FontProvider>(context)
                              .secondaryTextFont
                              .copyWith(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Expanded(child: _getPhoneLoginWidgets(context)),
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

  void _openOTPDialog(
      ConfirmationResult confirmationResult, BuildContext context) {
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
                await _authHelper.verifyOTP(
                  confirmationResult,
                  _codeController.text.trim(),
                  () => _onVerificationCompleted(context),
                  (e) => _onVerificationFailed(context, e),
                );
              },
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void _loadUser(BuildContext context) {
    _userProfileService.getUserProfile().then((value) {
      if (value != null) {
        Provider.of<UserProfileProvider>(context, listen: false)
            .setUserProfile(value);
        _gotoNextPage(context);
      } else {
        _createUser(context);
      }
    });
  }

  void _createUser(BuildContext context) {
    String phoneNumber = FirebaseAuthHelper().getUser!.phoneNumber!;
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController firstNameController =
            TextEditingController();
        final TextEditingController lastNameController =
            TextEditingController();

        return AlertDialog(
          title: Text('Enter Your First Name and Last Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText: 'First Name',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText: 'Last Name',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final firstName = firstNameController.text;
                final lastName = lastNameController.text;
                var userProfileData = UserProfileData(
                  firstName: firstName,
                  lastName: lastName,
                  phoneNumber: phoneNumber,
                );
                _userProfileService.createUser(userProfileData);
                Provider.of<UserProfileProvider>(context, listen: false)
                    .setUserProfile(userProfileData);
                firstNameController.dispose();
                lastNameController.dispose();
                Navigator.of(context).pop();
                _gotoNextPage(context);
              },
              child: const Text('Save'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () async {
                await FirebaseAuthHelper().logout();
                await FirebaseAuthHelper().signInAnonymously;
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _gotoNextPage(BuildContext context) {
    print("Go to home page");
    // Navigate to the home page
    final delegator =
        Provider.of<EventAppRouterDelegate>(context, listen: false);
    print("Delegator: $delegator");
    ValueChanged<EventAppNavigatorData> onTap = delegator.routeTrigger;
    if (targetPath != null) {
      onTap(targetPath!);
      return;
    } else {
      var invitationCode = queryParams!["inv"];
      print("Invitation code: $invitationCode");
      invitationCode == null
          ? onTap(EventAppNavigatorData.home({}))
          : onTap(EventAppNavigatorData.invitationDetails(invitationCode));
    }
  }
}
