import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/login/mobile/mobile_model.dart';
import 'package:weather_app/widget/login_button.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class MobileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double insetvalue = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: ViewModelBuilder<MobileModel>.nonReactive(
        onModelReady: (model) => model.initialize(),
        //disposeViewModel: false,
        viewModelBuilder: () => MobileModel(),
        builder: (context, model, _) => WillPopScope(
          onWillPop: () => model.handleBackPressed(),
          child: Container(
            decoration: background,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Enter Your phone number",
                                  style: heading1),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                  "We will send an OTP via sms to your phone number for verification.",
                                  style: subheading),
                              const SizedBox(
                                height: 45,
                              ),
                              TextFormField(
                                style: headingwhite,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) =>
                                    model.validateMobile(value.trim()),
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  errorMaxLines: 1,
                                  errorStyle: TextStyle(color: Colors.red[300]),
                                  focusedErrorBorder: null,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide:
                                          BorderSide(color: containerbg)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      borderSide:
                                          const BorderSide(color: containerbg)),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.grey[700], fontSize: 18),
                                  hintText: 'Enter your phone number',
                                ),
                                controller: model.mobileController,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: double.infinity,
                                child: Button(),
                              ),
                              SizedBox(
                                height:
                                    insetvalue - 90 < 0 ? 0 : insetvalue - 90,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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

class Button extends ViewModelWidget<MobileModel> {
  @override
  Widget build(BuildContext context, MobileModel model) {
    return LoginButton(
        title: (model.isBusy) ? 'sending otp...' : 'VERIFY',
        onpressed: () {
          if (_formKey.currentState.validate()) model.sendOTP();
        });
  }
}
