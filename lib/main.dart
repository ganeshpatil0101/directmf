import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:DirectMF/redux/actions.dart';
import 'package:DirectMF/redux/middleware.dart';
import 'package:DirectMF/redux/reducers.dart';
import 'package:DirectMF/redux/state.dart';
import 'package:DirectMF/theme/theme.dart';
import 'package:DirectMF/ui/categories/category_list.dart';
import 'package:DirectMF/ui/common/buttons.dart';
import 'package:DirectMF/ui/entries/add_entry_page.dart';
import 'package:DirectMF/ui/entries/edit_entry_page.dart';
import 'package:DirectMF/ui/forms/category_form.dart';
import 'package:DirectMF/ui/forms/registration.dart';
import 'package:DirectMF/ui/forms/signin.dart';
import 'package:DirectMF/ui/home.dart';
import 'package:DirectMF/ui/mf/addEditMfPage.dart';
import 'package:DirectMF/ui/mf/addMf.dart';
import 'package:DirectMF/ui/mf/mfList.dart';
import 'package:DirectMF/ui/mf/upload_pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';

Store globalStore;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final navigatorKey = GlobalKey<NavigatorState>();
  globalStore = Store<AppState>(
    reduce,
    distinct: true,
    initialState: AppState(areCategoriesLoading: true),
    middleware: [DirectMFMiddleware(navigatorKey)],
  );
  globalStore.dispatch(RetrieveUser());
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  print('====>');
  print(email);
  runApp(DirectMF(navigatorKey, globalStore, (email == null) ? false : true));
}

class DirectMF extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Store<AppState> store;
  final bool navigateToHome;

  DirectMF(this.navigatorKey, this.store, this.navigateToHome);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'DirectMF',
        theme: appTheme,
        navigatorKey: navigatorKey,
        routes: {
          InitialPage.route: (context) => InitialPage(),
          RegistrationForm.route: (context) => RegistrationForm(),
          CategoryList.route: (context) => CategoryList(),
          MfList.route: (context) => MfList(),
          CategoryForm.route: (context) => CategoryForm(),
          HomeScreen.route: (context) => HomeScreen(),
          AddExpensePage.route: (context) => AddExpensePage(),
          AddEditMfPage.route: (context) => AddEditMfPage(),
          EditExpensePage.route: (context) => EditExpensePage(),
          UploadPdf.route: (context) => UploadPdf()
        },
        initialRoute:
            (this.navigateToHome) ? HomeScreen.route : InitialPage.route,
      ),
    );
  }
}

class InitialPage extends StatelessWidget {
  static const route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SignInForm(),
              RoundedButton(
                text: 'Register',
                buttonColor: Colors.blue,
                onPressed: () => Navigator.pushNamed(
                  context,
                  RegistrationForm.route,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
