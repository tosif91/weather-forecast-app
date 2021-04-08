import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int resendToken;

  String mobileNo;

  String getUid() {
    return _auth.currentUser.uid;
  }

  bool checkUser() {
    if (_auth.currentUser != null) {
      return true;
    }
    return false;
  }

  Future<bool> signOut() async {
    try {
      //locator.reset();
      print('user logout successfully');
      return await _auth.signOut().then((value) {
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  static String verifID;

  Future<bool> submitOTP(String otp, Function handleError) async {
    final _credential =
        PhoneAuthProvider.credential(verificationId: verifID, smsCode: otp);
    return await _auth
        .signInWithCredential(_credential)
        .then((value) => true)
        .catchError((onError) {
      // if (onError.message == 'network-request-failed') {                .. ..... no need
      //   handleError();
      //   return null;
      // }
      print('its internal error ${onError.message}');
      return false;
    });
  }

  Future resendVerificationSms(
      String mobile,
      Function codeSent,
      Function verifCompleted,
      Function verifFailed,
      Function autoRetrievalTimeOut,
      Function signError) async {
    mobile = '+91' + mobile; // country code added

    try {
      await _auth.verifyPhoneNumber(
          forceResendingToken: resendToken,
          phoneNumber: mobile,
          timeout: const Duration(seconds: 10),
          verificationCompleted: (AuthCredential credential) {
            _auth
                .signInWithCredential(credential)
                .then((UserCredential userCredential) async {
              //success here
              //      uid=userCredential.user.uid; ///                   assign value to uid
              verifCompleted();
            }).catchError((e) {
              print('an error $e');
              signError();
            });
          },
          verificationFailed: (FirebaseAuthException authException) {
            verifFailed();
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            codeSent();
            resendToken = forceResendingToken;
            verifID = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            //   verifID=verificationId;
            print('autoreteirve failed');
          });
    } catch (e) {
      print('error in phone auth');
    }
  }

  Future registerUser(
      String mobile,
      Function codeSent,
      Function verifCompleted,
      Function verifFailed,
      Function autoRetrievalTimeOut,
      Function signInError) async {
    // var result;
    mobile = '+91' + mobile; // country code added
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: mobile,
          timeout: const Duration(seconds: 10),
          verificationCompleted: (AuthCredential authCredential) {
            print('verification compeleted');
            _auth
                .signInWithCredential(authCredential)
                .then((UserCredential userCredential) async {
              //success here
              verifCompleted();
            }).catchError((e) {
              print('an signIn error $e');
              signInError();
            });
          },
          verificationFailed: (FirebaseAuthException authException) {
            verifFailed();
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            codeSent();
            resendToken = forceResendingToken;
            // print('code sent sucessfully');
            verifID = verificationId;
          },
          codeAutoRetrievalTimeout: (value) {
            //  verifID=value;
            print('autoretrieve failed ');
          });
    } catch (e) {
      print('somethin went wrong');
    }
    print('ending of register user');
  }
}
