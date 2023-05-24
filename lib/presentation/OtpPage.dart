import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_2/presentation/home_page.dart';
import 'package:flutter_app_2/presentation/phone_page.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_app_2/common/firebase_instances.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/snack_show.dart';
import '../providers/auth_provider.dart';
import '../states/auth_state.dart';


class OtpPage extends ConsumerWidget {



  var smsCode = '';

  // Future<void> verifyOtp() async {
  // try{
  //   // Create a PhoneAuthCredential with the code
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: PhonePage.verificationId, smsCode: smsCode);
  //
  //   // Sign the user in (or link) with the credential
  //   await auth.signInWithCredential(credential);
  //   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
  // } catch(e){
  //   print(e);
  // }
  //
  // }

  @override
  Widget build(BuildContext context, ref) {
    final auth = ref.watch(authProvider);
    ref.listen(authProvider, (previous, next) {
      if (next is AuthState){

        if(next.errorMessage.isNotEmpty){
          SnackShow.showFailure(context, next.errorMessage);
        }else if(next.isSuccess){
          SnackShow.showSuccess(context, 'Login Successful' );
        }else if (next.isLogOut){
          SnackShow.showSuccess(context, 'LogOut Successful');
        }
      }
    });
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    if(auth.isSuccess){
      return HomePage();
    }else{
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(

            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          elevation: 0,
        ),
        body: Container(

          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "OTP verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Please enter the code sent to your number",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                Pinput(
                  length: 6,
                  onChanged: (value){
                    smsCode = value;
                  },
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,

                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {

                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: PhonePage.verificationId, smsCode: smsCode);

                        // Sign the user in (or link) with the credential
                        await ref.watch(authProvider.notifier).signInWithPhoneCredential(phoneAuthCredential: credential);


                      },
                      child: Text("Enter Code")),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context, MaterialPageRoute(builder: (context) => PhonePage())
                          );
                        },
                        child: Text(
                          "Edit Phone Number ?",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}