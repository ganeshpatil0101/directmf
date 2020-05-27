import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:DirectMF/common/auth.dart';
import 'package:DirectMF/main.dart';
import 'package:DirectMF/models/category.dart';
import 'package:DirectMF/models/entry.dart';
import 'package:DirectMF/models/mfData.dart';
import 'package:DirectMF/redux/actions.dart';
import 'package:DirectMF/redux/selectors.dart';
import 'package:DirectMF/redux/state.dart';
import 'package:DirectMF/services/mf_api_service.dart';
import 'package:DirectMF/ui/home.dart';

class DirectMFMiddleware extends MiddlewareClass<AppState> {
  final GlobalKey<NavigatorState> navigatorKey;
  final Authentication auth;

  StreamSubscription<QuerySnapshot> categoriesListener;
  StreamSubscription<QuerySnapshot> mfDataListener;
  StreamSubscription<QuerySnapshot> entryListener;

  DirectMFMiddleware(this.navigatorKey)
      : this.auth = FirebaseEmailAuthentication();

  @override
  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    if (action is RetrieveUser) {
      auth.getCurrentUser().then((user) => attemptUserRetrieval(store, user));
    } else if (action is SignIn) {
      auth
          .signIn(action.email, action.password)
          .then((user) => attemptSignIn(store, user))
          .catchError((e) => store.dispatch(ReportAuthenticationError(e.code)));
    } else if (action is SignOut) {
      await categoriesListener?.cancel();
      await entryListener?.cancel();
      await mfDataListener?.cancel();
      auth
          .signOut()
          .then((_) =>
              navigatorKey.currentState.pushReplacementNamed(InitialPage.route))
          .then((value) => store.dispatch(SetUserDetails(id: "", email: "")));
    } else if (action is Register) {
      store.dispatch(StartRegistration());
      auth
          .signUp(action.email, action.password)
          .then((value) => store.dispatch(SendVerificationEmail()))
          .then((value) => store.dispatch(ReportRegistrationSuccess()))
          .catchError((e) => store.dispatch(ReportAuthenticationError(e.code)));
    } else if (action is SendVerificationEmail) {
      auth.sendEmailVerification();
    } else if (action is RehydrateState) {
      final database = getRepository(store.state);
      categoriesListener = database.categories
          .orderBy('name', descending: false)
          .snapshots()
          .listen((qs) => reloadCategories(store, qs));

      mfDataListener = database.mfdatacollection
          .snapshots()
          .listen((qs) => reloadMfData(store, qs));
      store.dispatch(LoadFirstEntry());
    } else if (action is LoadFirstEntry) {
      final database = getRepository(store.state);
      entryListener = database.getFirstEntry().listen(
            (event) => loadMonths(store, event),
          );
    } else if (action is AddEntry) {
      final database = getRepository(store.state);
      database.create(action.entry);
    } else if (action is DeleteEntry) {
      final database = getRepository(store.state);
      database.delete(action.entry);
    } else if (action is UndoDelete) {
      final database = getRepository(store.state);
      Entry lastRemoved = getLastRemoved(store.state);
      database.create(lastRemoved);
    } else if (action is EditEntry) {
      final database = getRepository(store.state);
      database.create(action.entry);
    } else if (action is CreateCategory) {
      final database = getRepository(store.state);
      database.createCategory(action.category);
    } else if (action is CreateMf) {
      final database = getRepository(store.state);
      database.createMf(action.mf);
    } else if (action is EditMf) {
      final database = getRepository(store.state);
      database.createMf(action.mf);
    } else if (action is LastNavSync) {
      final database = getRepository(store.state);
      database.updateLastNavSync(action.lastNavSync).then((res) {
        store.dispatch(SetLastNavSync(action.lastNavSync));
      }).catchError((e) => print(e));
    } else if (action is ReloadNavPrice) {
      final navDataTxt = await MfApiService.getAllMfNavPrice();
      reloadNavPrice(store, navDataTxt);
    }
    next(action);
  }

  void attemptUserRetrieval(Store<AppState> store, FirebaseUser user) {
    if (user != null && user.isEmailVerified) {
      final userId = user.uid.toString();
      store.dispatch(SetUserDetails(id: userId, email: user.email));
      store.dispatch(InitializeDatabase(user.uid));
      store.dispatch(RehydrateState());
      navigatorKey.currentState.popAndPushNamed(HomeScreen.route);
    } else {
      store.dispatch(SetUserDetails(id: "", email: ""));
      navigatorKey.currentState.popAndPushNamed(InitialPage.route);
    }
  }

  void attemptSignIn(Store<AppState> store, FirebaseUser user) {
    // temporary disabled isEmailVerified check
    if (user.isEmailVerified || true) {
      store.dispatch(SetUserDetails(id: user.uid, email: user.email));
      store.dispatch(InitializeDatabase(user.uid));
      store.dispatch(ReportSignInSuccess());
      store.dispatch(RehydrateState());
      navigatorKey.currentState.popAndPushNamed(HomeScreen.route);
    } else {
      store.dispatch(SignOut());
      store.dispatch(ReportAuthenticationError("Email is not verified."));
    }
  }

  void reloadCategories(Store<AppState> store, QuerySnapshot event) {
    Set<Category> categories = Set();
    event.documents.forEach((ds) => categories.add(Category.fromSnapshot(ds)));
    store.dispatch(ReloadCategories(categories));
    store.dispatch(ReloadColors(categories.map((c) => c.color).toSet()));
  }

  void reloadMfData(Store<AppState> store, QuerySnapshot event) {
    Set<MFData> mfDataList = Set();
    event.documents.forEach((ds) => mfDataList.add(MFData.fromSnapshot(ds)));
    store.dispatch(ReloadMfDataList(mfDataList));
  }

  void reloadNavPrice(Store<AppState> store, String allMfNavPriceTxt) {
    store.dispatch(ReloadNavPrice(allMfNavPriceTxt));
    //store.dispatch(LastNavSync(DateTime.now()));
  }

  void loadMonths(Store<AppState> store, QuerySnapshot event) {
    if (event.documents.isNotEmpty) {
      var firstEntry = Entry.fromSnapshot(event.documents.first).date;
      store.dispatch(LoadMonths(firstEntry, DateTime.now()));
    } else {
      store.dispatch(LoadMonths(DateTime.now(), DateTime.now()));
    }
  }
}
