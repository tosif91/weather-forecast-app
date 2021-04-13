import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/login/otp/otp_model.dart';
import 'package:weather_app/widget/login_button.dart';

class OTPView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ViewModelBuilder<OTPModel>.nonReactive(
        viewModelBuilder: () => OTPModel(),
        onModelReady: (model) => model.initialize(),
        builder: (context, model, _) => WillPopScope(
          onWillPop: () => model.onBackPressed(),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: background,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Enter the verification code",
                          style: heading1),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: [
                        Text("  Sent to: ",
                            style: subheading.copyWith(fontSize: 13)),
                        Text(model.mobileNumber,
                            style: subheading.copyWith(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: 7,
                        ),
                        InkWell(
                          child: Text('(change phone number)',
                              style: subheading.copyWith(
                                  color: orange,
                                  decoration: TextDecoration.underline)),
                          onTap: () => model.changeNo(),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    DynamicItem()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DynamicItem extends ViewModelWidget<OTPModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, OTPModel model) {
    double insetvalue = MediaQuery.of(context).viewInsets.bottom;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (model.otpTimer == 0)
                ? 'auto retrieve failed'
                : 'auto reterieving otp in ${model.otpTimer} sec',
            style: TextStyle(color: Colors.deepOrangeAccent[300]),
            textAlign: TextAlign.center,
          ),
          // (model.otpSend)?Text('otp valid till ${model.otpTimer} sec'):Container(),
          const SizedBox(
            height: 10,
          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              maxLength: 6,
              maxLines: 1,
              style: headingwhite.copyWith(
                  letterSpacing: 22, fontWeight: FontWeight.w500, fontSize: 25),
              validator: (value) => model.validateOTP(value.trim()),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                focusedErrorBorder: null,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: const BorderSide(color: containerbg)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: const BorderSide(color: containerbg)),
                filled: true,
                hintStyle: TextStyle(
                  letterSpacing: 10,
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
                hintText: 'Enter OTP',
              ),
              controller: model.otpController,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoginButton(
                title: (model.isBusy) ? 'verifying otp..' : 'SUBMIT OTP',
                onpressed: () {
                  if (_formKey.currentState.validate())
                    model.handleOTP(); //todo: uncomment
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: (model.otpTimer == 0) ? true : false,
                child: InkWell(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                          (model.resendingOTP)
                              ? 'sending OTP...'
                              : 'resend OTP',
                          style: subheading.copyWith(
                              color: orange, fontSize: 17))),
                  onTap: () => model.resendSMS(),
                ),
              ),
              SizedBox(
                height: insetvalue - 90 < 0 ? 0 : insetvalue - 90,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
