import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/login/login_model.dart';
import 'package:weather_app/widget/login_button.dart';

class LogInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ViewModelBuilder<LogInModel>.nonReactive(
            disposeViewModel: false,
            viewModelBuilder: () => LogInModel(),
            builder: (context, model, _) => Container(
                  alignment: Alignment.center,
                  decoration: background,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome To WeatherApp',
                        textAlign: TextAlign.center,
                        style: heading1.copyWith(fontSize: 30),
                      ),
                      SizedBox(height: 30),
                      SignInButton()
                    ],
                  ),
                )));
  }
}

class SignInButton extends ViewModelWidget<LogInModel> {
  @override
  Widget build(BuildContext context, LogInModel model) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: LoginButton(
        title: 'SIGN IN',
        onpressed: () => model.navigateToMobile(),
      ),
    );
  }
}
