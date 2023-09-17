import 'package:flutter/material.dart';
import 'package:money_tracking/screens/account/account_screen.dart';
import 'package:money_tracking/screens/card-stat/card.dart';
import 'package:money_tracking/screens/home/home_screen.dart';
import 'package:money_tracking/screens/intro/intro_screen.dart';
import 'package:money_tracking/screens/new-expense/new_expense.dart';

Map<String, WidgetBuilder> routes = {
  IntroScreen.routeName: (context) => const IntroScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  NewExpense.routeName: (context) => const NewExpense(),
  Account.routeName: (context) => const Account(),
  CardStat.routeName: (context) => const CardStat(),
};
