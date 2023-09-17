import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:money_tracking/model/transaction.dart';
import 'package:money_tracking/provider/cards.dart';

import '../../model/card.dart';

String _inputValue = '';
double _number = 0.0;
NumberFormat formatter = NumberFormat('#,###.00', 'en_US');

String _selectedOption = "Transport";
String _selectedCardOption = "Select Card";
String _selectedCardID = "";

class NewExpense extends ConsumerStatefulWidget {
  static const routeName = "/new-expense";
  const NewExpense({super.key});

  @override
  ConsumerState<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends ConsumerState<NewExpense> {
  Future<void> _showCards(BuildContext context) async {
    final cards = ref.watch(cardProvider);
    _selectedCardOption = cards[0].nomFCard;
    final selectedOption = await showMenu<String>(
      context: context,
      color: Colors.white,
      position:
          RelativeRect.fromLTRB(500, 80, 0, 0), // Adjust the position as needed
      items: List.generate(
        cards.length,
        (index) => PopupMenuItem<String>(
          onTap: () {
            _selectedCardID = cards[index].id;
          },
          value: cards[index].nomFCard,
          child: SizedBox(
            width: 100,
            child: Text(cards[index].nomFCard,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black87,
                    )),
          ),
        ),
      ),

      // Add more PopupMenuItem widgets as needed
    );

    if (selectedOption != null) {
      setState(() {
        _selectedCardOption = selectedOption;
      });
    }
  }

  void _showOptions(BuildContext context) async {
    final selectedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Select an Option',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.black),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  'Transport',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context, 'Transport');
                },
                leading: Icon(
                  Icons.local_taxi_rounded,
                  color: Colors.black87,
                ),
              ),
              ListTile(
                title: Text(
                  'Grocery',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context, 'Grocery');
                },
                leading: Icon(
                  Icons.store_mall_directory_rounded,
                  color: Colors.black87,
                ),
              ),
              ListTile(
                title: Text(
                  'Shopping',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.black),
                ),
                leading: Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.black87,
                ),
                onTap: () {
                  Navigator.pop(context, 'Shopping');
                },
              ),
              ListTile(
                title: Text(
                  'Subscription',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.black),
                ),
                leading: const Icon(
                  Icons.monetization_on,
                  color: Colors.black87,
                ),
                onTap: () {
                  Navigator.pop(context, 'Subscription');
                },
              ),
              // Add more options as needed
            ],
          ),
        );
      },
    );

    if (selectedOption != null) {
      setState(() {
        _selectedOption = selectedOption;
      });
    }
  }

  void _handleKeyTap(String key) {
    setState(() {
      _inputValue += key;
      _number = double.tryParse(_inputValue) ?? 0.0;
    });
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No Card Found !'),
        showCloseIcon: true,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleDelete() {
    setState(() {
      if (_inputValue.isNotEmpty) {
        _inputValue = _inputValue.substring(0, _inputValue.length - 1);
        _number = double.tryParse(_inputValue) ?? 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        actions: [
          GestureDetector(
            onTap: () =>
                cards.isNotEmpty ? _showCards(context) : _showSnackBar(context),
            child: Row(
              children: [
                Text(_selectedCardOption),
                const Icon(
                  Icons.arrow_drop_down,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.symmetric(horizontal: 55),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45), topRight: Radius.circular(45))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),
            Text(
              "New Expense",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* Text("\$ ",
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5),
                        fontSize: 50,
                        fontWeight: FontWeight.w400)),*/
                SizedBox(
                    width: 205,
                    /* formatter.format(_number),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineLarge,*/
                    child: AutoSizeText.rich(
                      TextSpan(children: [
                        const TextSpan(text: "\$ "),
                        TextSpan(
                          text: formatter.format(_number),
                        )
                      ]),
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineLarge,
                    )),
              ],
            ),
            Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
            Row(
              children: [
                Text(
                  "Type here",
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () => _showOptions(context),
              child: Container(
                height: 55,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 15),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ),
                child: Row(children: [
                  const Icon(Icons.category_rounded),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    _selectedOption,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                  )
                ]),
              ),
            ),
            AddExpenseButton(),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0.5,
                    crossAxisSpacing: 0.5,
                    childAspectRatio: 1.8),
                itemCount: 12,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      index != 11
                          ? _handleKeyTap(((index != 9 && index != 10)
                                  ? index + 1
                                  : index == 10
                                      ? 0
                                      : ".")
                              .toString())
                          : _handleDelete();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: index != 11
                          ? Text(
                              index == 9
                                  ? '.'
                                  : index == 10
                                      ? '0'
                                      : (index + 1).toString(),
                              style: const TextStyle(fontSize: 20.0),
                            )
                          : InkWell(child: const Icon(CupertinoIcons.back)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddExpenseButton extends ConsumerStatefulWidget {
  const AddExpenseButton({
    super.key,
  });

  @override
  ConsumerState<AddExpenseButton> createState() => _AddExpenseButtonState();
}

class _AddExpenseButtonState extends ConsumerState<AddExpenseButton> {
  @override
  Widget build(BuildContext context) {
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                              (value.isNotEmpty &&
                                  double.tryParse(value)! < 0)) {
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
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

    return GestureDetector(
      onTap: () {
        final card = ref.read(cardProvider);
        if (_selectedCardOption != "Select Card") {
          ref.read(cardProvider.notifier).addNewTransaction(
                _selectedCardID,
                Transaction(
                    amount: _number,
                    createdAt: DateTime.now(),
                    id: DateTime.now().toString(),
                    type: _selectedOption),
              );

          setState(() {
            _selectedOption = "Transport";
            _selectedCardOption = "Select Card";
            _selectedCardID = "";
            _inputValue = "";
            _number = 0.0;
          });
          Navigator.of(context).pop();
        } else if (card.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              // showCloseIcon: true,

              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('No Card Added Yet!'),
                  GestureDetector(
                    onTap: () {
                      _addCard(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).colorScheme.primary),
                      child: Text(
                        "Add Card",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                ],
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              // showCloseIcon: true,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Please select a card on top'),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        height: 55,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Text(
          "Continue",
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: 16),
        ),
      ),
    );
  }
}

String generateRandomString(int length) {
  final random = Random.secure();
  final values = List<int>.generate(length, (i) => random.nextInt(256));
  final bytes = Uint8List.fromList(values);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
