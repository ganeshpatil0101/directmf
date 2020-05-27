import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:DirectMF/common/auth.dart';
import 'package:DirectMF/common/calendar.dart';
import 'package:DirectMF/common/exceptions.dart';
import 'package:DirectMF/models/category.dart';
import 'package:DirectMF/models/entry.dart';
import 'package:DirectMF/models/mfData.dart';
import 'package:DirectMF/redux/state.dart';
import 'package:DirectMF/repository/firestore.dart';

Entry getLastRemoved(AppState state) => state.removed.last;

Set<Color> getUsedColors(AppState state) =>
    state.categories.map((category) => category.color).toSet();

Set<Color> getAvailableColors(AppState state) => state.availableColors;

Set<Category> getCategories(AppState state) => state.categories;

Set<MFData> getMfDataList(AppState state) => state.mfdatalist;

Set<Category> getExpenseCategories(AppState state) => state.categories
    .where((category) => category.type == CategoryType.EXPENSE)
    .toSet();

Set<Category> getIncomeCategories(AppState state) => state.categories
    .where((category) => category.type == CategoryType.INCOME)
    .toSet();

Category getCategory(AppState state, String id) =>
    state.categories.firstWhere((category) {
      return category.id == id;
    }, orElse: () {
      throw CategoryNotFound("Could not find a category with id[$id]");
    });

Color getCategoryColor(AppState state, String id) =>
    getCategory(state, id).color;

bool areCategoriesLoading(AppState state) => state.areCategoriesLoading;

bool areMfLoading(AppState state) => state.areMfLoading;

DateTime getStatisticsMonthStart(AppState state) =>
    firstDay(state.selectedMonth.element);

DateTime getStatisticsMonthEnd(AppState state) =>
    lastDay(state.selectedMonth.element);

DoubleLinkedQueue<DateTime> getViewableMonths(AppState state) =>
    state.viewableMonths;

DoubleLinkedQueueEntry<DateTime> getSelectedMonth(AppState state) =>
    state.selectedMonth;

DoubleLinkedQueueEntry<DateTime> getMonthEntryByDate(
  AppState state,
  DateTime date,
) =>
    DoubleLinkedQueueEntry<DateTime>(
      state.viewableMonths.firstWhere((entry) => entry.month == date.month),
    );

AuthenticationStatus getAuthStatus(AppState state) => state.authStatus;

bool isRegistrationInProgress(AppState state) => state.registrationInProgress;

bool isSignInInProgress(AppState state) => state.signInInProgress;

String getAuthenticationErrorMessage(AppState state) =>
    state.authenticationErrorMessage;

bool isRegistrationSuccessful(AppState state) => state.registrationSuccess;

String getUserId(AppState state) => state.userId;

String getUserEmail(AppState state) => state.userEmail;

FirestoreDatabase getRepository(AppState state) => state.database;

DateTime getLastNavSync(AppState state) => state.lastNavSync;

String getAllMfNavTxt(AppState state) => state.allMfNavTxt;
