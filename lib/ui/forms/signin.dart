import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:DirectMF/redux/actions.dart';
import 'package:DirectMF/redux/selectors.dart';
import 'package:DirectMF/redux/state.dart';
import 'package:DirectMF/ui/common/buttons.dart';
import 'package:DirectMF/ui/common/form_errors.dart';
import 'package:DirectMF/ui/common/text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SignInFormState();
}

class SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;

  void _onEmailSaved(String value) {
    _email = value.trim();
  }

  void _onPasswordSaved(String value) {
    _password = value;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _SignInViewModel>(
      converter: _SignInViewModel.fromState,
      builder: (context, vm) {
        final errorMessage = vm.errorMessage;
        final signingIn = vm.signInInProgress;
        final button = signingIn
            ? LoadingButton()
            : RoundedButton(
                text: "Sign In",
                onPressed: () => _save(() => vm.signIn(_email, _password)),
              );

        var baseForm = <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text('Smart Direct MF',
                  style: Theme.of(context).textTheme.headline3),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child:
                  Text('Sign In', style: Theme.of(context).textTheme.headline5),
            ),
          ),
          EmailFormField(
            showHelpText: false,
            key: ValueKey("SignIn email"),
            onSaved: _onEmailSaved,
          ),
          PasswordFormField(
            key: ValueKey("SignIn password"),
            onSaved: _onPasswordSaved,
            showHelpText: false,
          ),
          if (errorMessage != "") FormError(errorMessage),
          button,
        ];

        return Center(
          child: Form(
            key: _formKey,
            child: ListView(shrinkWrap: true, children: baseForm),
          ),
        );
      },
    );
  }

  void _save(Function signIn) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signIn();
    }
  }
}

class _SignInViewModel {
  final Function(String, String) signIn;
  final bool signInInProgress;
  final String errorMessage;

  _SignInViewModel({
    @required this.signIn,
    @required this.signInInProgress,
    @required this.errorMessage,
  });

  static _SignInViewModel fromState(Store<AppState> store) {
    return _SignInViewModel(
      signIn: (String email, String password) async {
        store.dispatch(SignIn(email: email, password: password));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
      },
      signInInProgress: isSignInInProgress(store.state),
      errorMessage: getAuthenticationErrorMessage(store.state),
    );
  }
}
