import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:DirectMF/common/auth.dart';
import 'package:DirectMF/common/calendar.dart';
import 'package:DirectMF/models/category.dart';
import 'package:DirectMF/models/entry.dart';
import 'package:DirectMF/models/mfData.dart';
import 'package:DirectMF/repository/firestore.dart';
import 'package:DirectMF/theme/palette.dart';

@immutable
class AppState {
  final String userId;
  final String userEmail;
  final AuthenticationStatus authStatus;
  final bool registrationInProgress;
  final bool registrationSuccess;
  final bool signInInProgress;
  final String authenticationErrorMessage;
  final List<Entry> removed;
  final Set<Category> categories;
  final Set<MFData> mfdatalist;
  // TODO: must be at least one default category
  final bool areCategoriesLoading;
  final bool areMfLoading;
  final Set<Color> availableColors;
  final DoubleLinkedQueueEntry<DateTime> selectedMonth;
  final DoubleLinkedQueue<DateTime> viewableMonths;
  final FirestoreDatabase database;
  final String allMfNavTxt;
  final bool areMfNavLoading;
  final DateTime lastNavSync;
  AppState(
      {userId,
      userEmail,
      authStatus,
      registrationInProgress,
      registrationSuccess,
      signInInProgress,
      authenticationErrorMessage,
      removed,
      categories,
      mfdatalist,
      allMfNavTxt,
      areMfNavLoading,
      areCategoriesLoading,
      areMfLoading,
      availableColors,
      selectedMonth,
      viewableMonths,
      database,
      lastNavSync})
      : this.userId = userId,
        this.userEmail = userEmail,
        this.authStatus = authStatus ?? AuthenticationStatus.ANONYMOUS,
        this.registrationInProgress = registrationInProgress ?? false,
        this.registrationSuccess = registrationSuccess ?? false,
        this.signInInProgress = signInInProgress ?? false,
        this.authenticationErrorMessage = authenticationErrorMessage ?? "",
        this.removed = removed ?? List(),
        this.categories = categories ?? Set(),
        this.mfdatalist = mfdatalist ?? Set(),
        this.allMfNavTxt = allMfNavTxt ?? "",
        this.areMfNavLoading = areMfNavLoading ?? false,
        this.areCategoriesLoading = areCategoriesLoading ?? true,
        this.availableColors = availableColors ?? Set.from(materialColors),
        this.areMfLoading = areCategoriesLoading ?? true,
        this.selectedMonth = selectedMonth,
        this.viewableMonths = viewableMonths ??
            DoubleLinkedQueue.from([firstDay(DateTime.now())]),
        this.database = database,
        this.lastNavSync = lastNavSync ?? null;

  AppState copyWith(
      {String userId,
      String userEmail,
      AuthenticationStatus authStatus,
      bool registrationInProgress,
      bool registrationSuccess,
      bool signInInProgress,
      String authenticationErrorMessage,
      List<Entry> removed,
      Set<Category> categories,
      Set<MFData> mfdatalist,
      String allMfNavTxt,
      bool areMfNavLoading,
      bool areCategoriesLoading,
      bool areMfLoading,
      Set<Color> availableColors,
      DoubleLinkedQueueEntry<DateTime> selectedMonth,
      DoubleLinkedQueue<DateTime> viewableMonths,
      FirestoreDatabase database,
      DateTime lastNavSync}) {
    return AppState(
        userId: chooseOldOrNull(this.userId, userId),
        userEmail: chooseOldOrNull(this.userEmail, userEmail),
        authStatus: authStatus ?? this.authStatus,
        registrationInProgress:
            registrationInProgress ?? this.registrationInProgress,
        registrationSuccess: registrationSuccess ?? this.registrationSuccess,
        signInInProgress: signInInProgress ?? this.signInInProgress,
        authenticationErrorMessage:
            authenticationErrorMessage ?? this.authenticationErrorMessage,
        removed: removed ?? this.removed,
        categories: categories ?? this.categories,
        mfdatalist: mfdatalist ?? this.mfdatalist,
        allMfNavTxt: allMfNavTxt ?? this.allMfNavTxt,
        areMfNavLoading: areMfNavLoading ?? this.areMfNavLoading,
        areCategoriesLoading: areCategoriesLoading ?? this.areCategoriesLoading,
        areMfLoading: areMfLoading ?? this.areMfLoading,
        availableColors: availableColors ?? this.availableColors,
        selectedMonth: selectedMonth ?? this.selectedMonth,
        viewableMonths: viewableMonths ?? this.viewableMonths,
        database: database ?? this.database,
        lastNavSync: lastNavSync ?? this.lastNavSync);
  }
}

String chooseOldOrNull(String old, String fresh) {
  if (fresh == null) {
    return old;
  } else if (fresh == "") {
    return null;
  } else {
    return fresh;
  }
}
