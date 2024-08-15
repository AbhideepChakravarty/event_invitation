import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthHelper with ChangeNotifier {
  static FirebaseAuthHelper? _instance;

  FirebaseAuthHelper._internal() {
    _instance = this;
  }

  factory FirebaseAuthHelper() => _instance ?? FirebaseAuthHelper._internal();

  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isUserLoggedIn = false;
  User? user;
  User? get getUser => auth.currentUser;

  bool get isAnonymousUser => auth.currentUser!.isAnonymous;

  void get listenToAuthState {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      user == null ? isUserLoggedIn = false : isUserLoggedIn = true;
      notifyListeners();
    });
  }

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<User?> get signInAnonymously async {
    if (user == null) {
      await auth.signInAnonymously().then((value) => user = value.user);
      notifyListeners();
    }
    return user;
  }

  bool get isLoginRequired => FirebaseAuth.instance.currentUser!.isAnonymous;

  void setLoggedInUser(User? pUser) {
    user = pUser;
    notifyListeners();
  }

  void notifyAll() {
    notifyListeners();
  }

  Future<bool> handleAuth(BuildContext context) async {
    var result;
    if (FirebaseAuthHelper().isLoginRequired) {
      result = await showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (builder) => Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1)),
              child: Container())); //SitoSocialSignInWidget()));
    }
    if (result.runtimeType == Null) {
      result = false;
    }
    return result;
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber,
      Function onVerificationCompleted,
      Function onVerificationFailed,
      Function onCodeSent,
      Function onCodeAutoRetrievalTimeout) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        onVerificationCompleted();
      },
      verificationFailed: (FirebaseAuthException e) {
        //print("Verification failed");
        onVerificationFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        //print("Code is sent");
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        onCodeAutoRetrievalTimeout(verificationId);
      },
    );
  }

  Future<void> signInWithCredntials(
      String smsCode, String verificationId) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<ConfirmationResult> signInWithPhoneNumber(String phoneNumber) async {
    return await auth.signInWithPhoneNumber(phoneNumber);
  }

  verifyOTP(
      ConfirmationResult confirmationResult,
      String otp,
      void Function() onVerificationCompleted,
      void Function(FirebaseAuthException e) onVerificationFailed) {
    confirmationResult.confirm(otp).then((value) {
      onVerificationCompleted();
    }).catchError((error) {
      onVerificationFailed(error);
    });
  }

  Future<void> logout() async {
    await auth.signOut();
  }
}
