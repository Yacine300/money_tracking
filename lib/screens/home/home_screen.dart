import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:money_tracking/provider/cards.dart';
import 'package:money_tracking/provider/years.dart';
import 'package:money_tracking/provider/months.dart';
import 'package:money_tracking/screens/account/account_screen.dart';
import 'package:money_tracking/screens/card-stat/card.dart';
import 'package:money_tracking/screens/new-expense/new_expense.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../model/card.dart';
import '../../model/transaction.dart';

List<String> months = List.generate(12, (index) {
  DateTime date = DateTime(DateTime.now().year, index + 1);
  return DateFormat('MMMM').format(date);
});

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = "/home";
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  int currentMonth = DateTime.now().month;
  int? currentIndex;

  String _selectedOption = "Transport";
  @override
  void initState() {
    super.initState();
    currentIndex = currentMonth - 1;
    double itemWidth = 35.0; // width of each item in the ListView

    // Calculate the offset based on the current month
    double initialOffset = (currentMonth) * itemWidth;

    // Set the initial scroll offset
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
  }

  void _openSideMenu() {
    _scaffoldKey.currentState!.openDrawer();
  }

  String generateRandomString(int length) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    final bytes = Uint8List.fromList(values);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _addCard(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // GlobalKey to manage form state
    String name = '';
    double amount = 0.0;
    String randomString = generateRandomString(9);

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Form(
                key: _formKey, // Assign the GlobalKey to the Form
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Text('Add New Card',
                            style: Theme.of(context).textTheme.bodySmall),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                          hintText: "Master Card",
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // Customize the underline color
                          ),
                          hintStyle: TextStyle(color: Colors.white12),
                          labelText: 'Card Name',
                          labelStyle: Theme.of(context).textTheme.bodySmall),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        name = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    StatefulBuilder(builder: (context, setState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: randomString,
                              style: Theme.of(context).textTheme.bodySmall,
                              cursorColor:
                                  Theme.of(context).colorScheme.secondary,
                              cursorHeight: 20,
                              decoration: InputDecoration(
                                  hintText: "***AZS**7",
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Customize the underline color
                                  ),
                                  hintStyle: TextStyle(color: Colors.white12),
                                  labelText: 'Card Num',
                                  labelStyle:
                                      Theme.of(context).textTheme.bodySmall),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a Card Num';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                randomString = value;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              randomString = generateRandomString(9);
                            }),
                            child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Icon(
                                  Icons.refresh_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                          )
                        ],
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),

                    /* GestureDetector(
                          onTap: () => generateRandomString(9),
                          child: Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Icon(
                                Icons.refresh_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        )*/
                    SizedBox(height: 10),
                    TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      cursorHeight: 20,
                      decoration: InputDecoration(
                          /*focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary), // Customize the border color
                          ),*/
                          hintText: '\$ 144.99',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // Customize the underline color
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors
                                    .white), // Customize the underline color
                          ),
                          hintStyle: TextStyle(color: Colors.white12),
                          labelText: 'Initial Amount',
                          labelStyle: Theme.of(context).textTheme.bodySmall),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null ||
                            (value.isNotEmpty && double.tryParse(value)! < 0)) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        amount = double.tryParse(value) ?? 0.0;
                      },
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Perform actions after clicking the button
                            // Here, you can use the 'name' and 'amount' variables
                            // to perform your desired actions
                            print('Name: $name');
                            print('Amount: $amount');

                            // Add the new card using Riverpod
                            ref.read(cardProvider.notifier).addNewCard(
                                  FCard(
                                    id: DateTime.now().toIso8601String(),
                                    cardNum: randomString,
                                    nomFCard: name, // Use the entered name
                                    totalAmount:
                                        amount, // Use the entered amount
                                    initialAmount: amount,
                                    transactions: [],
                                  ),
                                );

                            // Close the bottom sheet when done
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "Add",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    final transactions = ref.watch(cardProvider.notifier).extractTransaction();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
          height: 500,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 3,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Expanses',
                      style: TextStyle(fontSize: 20),
                    ),
                    Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white12),
                      child: Text('September'),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) =>
                      Expense(transaction: transactions[index]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showOptions(BuildContext context) async {
    final selectedOption = await showMenu<String>(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromLTRB(
          50, 100, 100, 0), // Adjust the position as needed
      items: [
        PopupMenuItem<String>(
          value: '2023',
          child: Container(
            width: 80,
            child: Text(
              '2023',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.7)),
            ),
          ),
        ),

        // Add more PopupMenuItem widgets as needed
      ],
    );

    if (selectedOption != null) {
      setState(() {
        _selectedOption = selectedOption;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardProvider);
    final transactions = ref.watch(cardProvider.notifier).extractTransaction();
    final currentYear = ref.watch(currentYearProvider.notifier).getYear();

    final currentBalance =
        ref.watch(cardProvider.notifier).calculateAmountAll();
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.primary,
        bottomNavigationBar: Container(
          height: 60,
          width: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.white10),
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: months.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () => setState(() {
                  ref.read(monthProvider.notifier).selectMonth(index + 1);
                }),
                child: Text(
                  months[index],
                  style: ref.watch(monthProvider) - 1 == index
                      ? Theme.of(context).textTheme.bodySmall
                      : TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              // padding: EdgeInsets.symmetric(vertical: 50),
              children: [
                DrawerHeader(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Yacine_',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'balance',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            /*  Text(
                            
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),*/

                            AutoSizeText.rich(
                              TextSpan(children: [
                                const TextSpan(text: "\$ "),
                                TextSpan(
                                  text: formatter.format(currentBalance),
                                ),
                              ]),
                              maxLines: 1,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ],
                        )
                      ],
                    )),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    // Handle navigation to settings
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    'Profile',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    // Handle navigation to settings
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.currency_bitcoin),
                  title: Text(
                    'Expenses',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  onTap: () {
                    // Handle navigation to settings
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    'About',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showOptions(context);
            },
            child: Row(
              children: [
                Text(currentYear.toString()),
                const Icon(Icons.arrow_drop_down_rounded)
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(Account.routeName),
              child: const Icon(
                Icons.person_outlined,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
          leading: GestureDetector(
            onTap: () => _openSideMenu(),
            child: const Icon(
              Icons.menu_rounded,
            ),
          ),
        ),
        body: (cards.isNotEmpty && cards.first.id == "")
            ? Center(child: CircularPercentIndicator(radius: 20))
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current Balance",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      CurrentBalance(),
                      GestureDetector(
                          onTap: () => Navigator.of(context)
                              .pushNamed(NewExpense.routeName),
                          child: AccountInfo()),
                      const SizedBox(
                        height: 15,
                      ),
                      cards.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Your Card",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      _addCard(context);

                                      /* ref.read(cardProvider.notifier).addNewCard(
                                    FCard(
                                        id: DateTime.now().toIso8601String(),
                                        nomFCard: "my Card",
                                        totalAmount: 0.0,
                                        transactions: []),
                                  );*/
                                    },
                                    child: const Icon(Icons.add))
                              ],
                            )
                          : Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  const Text(
                                    "No card added yet",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _addCard(context);
                                      /*ref.read(cardProvider.notifier).addNewCard(FCard(
                                  id: DateTime.now().toIso8601String(),
                                  nomFCard: "my Card",
                                  totalAmount: 0.0,
                                  transactions: []));*/
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: cards.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(
                                    CardStat.routeName,
                                    arguments: cards[index].id),
                                child: Dismissible(
                                  key: Key(cards[index].id),
                                  background: Container(
                                      color: Colors.transparent,
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(Icons.delete,
                                              color: Colors.white),
                                          Icon(Icons.delete,
                                              color: Colors.white),
                                        ],
                                      )),
                                  confirmDismiss: (direction) async {
                                    return await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: Text(
                                              'Are you sure you want to delete the card "${cards[index].nomFCard}"?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(
                                                      true), // Confirm deletion
                                              child: Text(
                                                'Delete',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary
                                                            .withOpacity(0.5)),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(
                                                      false), // Cancel deletion
                                              child: Text(
                                                'Cancel',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  onDismissed: (direction) => ref
                                      .watch(cardProvider.notifier)
                                      .deleteCard(cards[index].id),
                                  child: OneCard(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      oneCard: cards[index]),
                                ),
                              )),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Expenses",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          GestureDetector(
                            onTap: () => _showBottomSheet(context),
                            child: Container(
                              height: 35,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline)),
                              child: Text(
                                "View all",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            transactions.length > 3 ? 3 : transactions.length,
                        itemBuilder: (context, index) =>
                            Expense(transaction: transactions[index]),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ));
  }
}

class CurrentBalance extends ConsumerStatefulWidget {
  const CurrentBalance({
    super.key,
  });

  @override
  ConsumerState<CurrentBalance> createState() => _CurrentBalanceState();
}

class _CurrentBalanceState extends ConsumerState<CurrentBalance> {
  @override
  Widget build(BuildContext context) {
    final currentBalance =
        ref.watch(cardProvider.notifier).calculateAmountAll();
    return /*Text(
      currentBalance.toString(),
      style: Theme.of(context).textTheme.headlineLarge,
    );*/
        AutoSizeText.rich(
      TextSpan(children: [
        const TextSpan(text: "\$ "),
        TextSpan(
          text: formatter.format(currentBalance),
        ),
      ]),
      maxLines: 1,
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}

class AccountInfo extends ConsumerStatefulWidget {
  const AccountInfo({
    super.key,
  });

  @override
  ConsumerState<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends ConsumerState<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    final amountAll = ref.watch(cardProvider.notifier).calculateAmountAll();
    final spentAll = ref.watch(cardProvider.notifier).spentAll();
    return Container(
      height: 120,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 37.5),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.tertiary.withOpacity(0.7),
            Theme.of(context).colorScheme.tertiary.withOpacity(0.6)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "income",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            ),
            /* Text(
              amountAll.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            )*/
            AutoSizeText.rich(
              TextSpan(children: [
                const TextSpan(text: "\$ "),
                TextSpan(
                  text: formatter.format(amountAll),
                )
              ]),
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            )
          ],
        ),
        VerticalDivider(
          color: Colors.white54,
          thickness: 0.6,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Spent",
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(color: Colors.white),
            ),
            AutoSizeText.rich(
              TextSpan(children: [
                const TextSpan(text: "\$ "),
                TextSpan(
                  text: formatter.format(spentAll),
                )
              ]),
              maxLines: 1,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ]),
    );
  }
}

class Expense extends StatelessWidget {
  final Transaction transaction;
  const Expense({
    required this.transaction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String timeAgo = formatTimeAgo(transaction.createdAt);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10)),
            child: Icon(transaction.type == "Grocery"
                ? Icons.storefront_outlined
                : transaction.type == "Transport"
                    ? Icons.local_taxi
                    : transaction.type == "Shopping"
                        ? Icons.shopping_bag
                        : Icons.monetization_on),
          ),
          const SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.type,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text('Created $timeAgo',
                  style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500))
            ],
          ),
          const Spacer(),
          /*Text(
            transaction.amount.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),*/
          AutoSizeText.rich(
            TextSpan(children: [
              const TextSpan(text: "\$ "),
              TextSpan(
                text: formatter.format(transaction.amount),
              )
            ]),
            maxLines: 1,
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }

  String formatTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      final formatter = DateFormat('MMM dd, yyyy HH:mm');
      return formatter.format(createdAt);
    }
  }
}

class OneCard extends StatelessWidget {
  final Color color;
  final FCard oneCard;
  const OneCard({
    required this.color,
    required this.oneCard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String lastThreeCharacters =
        oneCard.cardNum.substring(oneCard.cardNum.length - 3);
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1)),
      child: Row(children: [
        Container(
          height: 50,
          width: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: color),
          child: Text(
            '****$lastThreeCharacters',
            style: TextStyle(
                fontSize: 12, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Text(
              oneCard.totalAmount.toString(),
              style: Theme.of(context).textTheme.bodySmall,
            ),*/
            AutoSizeText.rich(
              TextSpan(children: [
                const TextSpan(text: "\$ "),
                TextSpan(
                  text: formatter.format(oneCard.totalAmount),
                ),
              ]),
              maxLines: 1,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(oneCard.nomFCard,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    fontSize: 10))
          ],
        ),
        const Spacer(),
        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
        )
      ]),
    );
  }
}
