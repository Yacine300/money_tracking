import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_tracking/provider/months.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../provider/cards.dart';
import '../home/home_screen.dart';

List<Map<String, int>> letterWeek = [
  {'S': 7}, // Sunday
  {'M': 1}, // Monday
  {'T': 2}, // Tuesday
  {'W': 3}, // Wednesday
  {'T': 4}, // Thursday
  {'F': 5}, // Friday
  {'S': 6}, // Saturday
];

final List<String> months = [
  'January',
  'Fabruary',
  'March',
  'April',
  'May',
  'Juin',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];
List<String> menuItems = ["Week", "Year"];
late int currentMonth;
String _selectedCardOption = "Week";
late String _selectedMonthOption;
late String _selectedYearOption;

double mapValue(
    double currentValue, double totalValue, double minRange, double maxRange) {
  return ((currentValue / totalValue) * (maxRange - minRange)) + minRange;
}

class CardStat extends ConsumerStatefulWidget {
  static const routeName = "/card-stat";
  const CardStat({super.key});

  @override
  ConsumerState<CardStat> createState() => _CardStatState();
}

class _CardStatState extends ConsumerState<CardStat> {
  int currentIndex = 0;
  Future<void> _showOptions(BuildContext context) async {
    currentMonth = ref.watch(monthProvider);
    final selectedOption = await showMenu<String>(
      context: context,
      color: Colors.white,
      position:
          RelativeRect.fromLTRB(500, 80, 0, 0), // Adjust the position as needed
      items: List.generate(
        menuItems.length,
        (index) => PopupMenuItem<String>(
          onTap: () {
            _selectedCardOption = menuItems[index];
            if (_selectedCardOption == menuItems[0]) {
              setState(() {
                currentMonth = ref.watch(monthProvider);
              });
            }
          },
          value: menuItems[index],
          child: SizedBox(
            width: 100,
            child: Text(menuItems[index],
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

  Future<void> _showYear(BuildContext context) async {
    final yearOption = await showMenu<String>(
      context: context,
      color: Colors.white,
      position:
          RelativeRect.fromLTRB(500, 80, 0, 0), // Adjust the position as needed
      items: List.generate(
        1,
        (index) => PopupMenuItem<String>(
          onTap: () {
            /* _selectedCardOption = menuItems[index];
            if (_selectedCardOption == menuItems[0])
              setState(() {
                currentMonth = ref.watch(monthProvider.notifier).getMonth();
              });*/
          },
          value: "2023",
          child: SizedBox(
            width: 100,
            child: Text("2023",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black87,
                    )),
          ),
        ),
      ),

      // Add more PopupMenuItem widgets as needed
    );

    if (yearOption != null) {
      setState(() {
        _selectedYearOption = yearOption;
      });
    }
  }

  Future<void> _showMonth(BuildContext context) async {
    final monthOption = await showMenu<String>(
      context: context,
      color: Colors.white,
      position:
          RelativeRect.fromLTRB(500, 80, 0, 0), // Adjust the position as needed
      items: List.generate(
        months.length,
        (index) => PopupMenuItem<String>(
          onTap: () {
            currentMonth = index + 1;
            ref.read(monthProvider.notifier).selectMonth(currentMonth);
          },
          value: months[index],
          child: SizedBox(
            width: 100,
            child: Text(months[index],
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Colors.black87,
                    )),
          ),
        ),
      ),

      // Add more PopupMenuItem widgets as needed
    );

    if (monthOption != null) {
      setState(() {
        _selectedMonthOption = monthOption;
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    currentMonth = ref.watch(monthProvider);
    _selectedMonthOption = months[currentMonth - 1];
    _selectedYearOption = "2023";
  }

  @override
  Widget build(BuildContext context) {
    final String cardID = ModalRoute.of(context)!.settings.arguments as String;
    final transactions = ref
        .watch(cardProvider.notifier)
        .extractSpecificTransaction(cardID, currentMonth);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        centerTitle: true,
        actions: const [
          Icon(
            Icons.person_outlined,
          ),
          SizedBox(
            width: 10,
          ),
        ],
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(
              onTap: () => _showMonth(context),
              child: Row(
                children: [
                  Text(
                    months[currentMonth - 1],
                    style: TextStyle(fontSize: 14),
                  ),
                  Icon(Icons.arrow_drop_down_rounded)
                ],
              )),
          GestureDetector(
              onTap: () => _showYear(context),
              child: Row(
                children: [
                  Text(
                    _selectedYearOption,
                    style: TextStyle(fontSize: 14),
                  ),
                  Icon(Icons.arrow_drop_down_rounded)
                ],
              )),
        ]),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Card Activity",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                            InfoColor(),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => _showOptions(context),
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.black12),
                            child: Row(
                              children: [
                                Text(
                                  _selectedCardOption,
                                  style: TextStyle(color: Colors.black),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _selectedCardOption == menuItems[0]
                        ? Expanded(
                            child: PageView.builder(
                                itemCount: 4,
                                onPageChanged: (value) {
                                  setState(() {
                                    currentIndex = value;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return StatWeek(index: index);
                                }),
                          )
                        : Expanded(
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // Number of columns
                              ),
                              itemCount: months.length,
                              itemBuilder: (context, index) {
                                final double opacity = ref
                                    .watch(cardProvider.notifier)
                                    .spendMedian(cardID, index + 1);
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    _selectedCardOption = menuItems[0];
                                    currentMonth = index + 1;
                                    ref
                                        .read(monthProvider.notifier)
                                        .selectMonth(currentMonth);
                                  }),
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary
                                            .withOpacity(
                                                /*mapValue(
                                                opacity, 1.0, 0.0, 1.0)*/
                                                1),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      months[index],
                                      style: const TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    if (_selectedCardOption == menuItems[0])
                      BuildDot(currentIndex: currentIndex),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
            Container(
              height: 200,
              width: double.infinity,
              alignment: Alignment.center,
              //margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: transactions.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                              "All transactions of ${months[currentMonth - 1]}"),
                          SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transactions.length > 3
                                ? 3
                                : transactions.length,
                            itemBuilder: (context, index) =>
                                Expense(transaction: transactions[index]),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      "No ${months[currentMonth - 1]} transactions Found..."),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildDot extends StatelessWidget {
  final currentIndex;
  const BuildDot({
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 3,
      // color: Colors.amber,
      alignment: Alignment.center,
      child: ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear,
              width: currentIndex == index ? 10 : 5,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: currentIndex == index
                      ? Theme.of(context).colorScheme.tertiary
                      : Colors.grey),
            );
          }),
    );
  }
}

class InfoColor extends StatelessWidget {
  const InfoColor({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("expenses",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 10)),
              Container(
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.tertiary),
              )
            ],
          ),
        ),
        SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("wallet",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 10)),
              Container(
                height: 3,
                width: 20,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.grey),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class StatWeek extends ConsumerStatefulWidget {
  final index;
  const StatWeek({
    required this.index,
    super.key,
  });

  @override
  ConsumerState<StatWeek> createState() => _StatWeekState();
}

class _StatWeekState extends ConsumerState<StatWeek> {
  @override
  Widget build(BuildContext context) {
    final String cardID = ModalRoute.of(context)!.settings.arguments as String;
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: letterWeek.length,
          itemBuilder: (context, index) {
            double initial =
                ref.watch(cardProvider.notifier).getInitialAmount(cardID);
            double expenses = ref
                .watch(cardProvider.notifier)
                .extractSomeTransactionByDay(letterWeek[index].values.first,
                    cardID, widget.index, currentMonth);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: StatField(
                expenses: mapValue(expenses, initial, 0, 200),
                lastTotal: 200,
                letterWeek: letterWeek[index].keys.first,
              ),
            );
          }),
    );
  }
}

class StatField extends StatelessWidget {
  final letterWeek;
  final expenses;
  final lastTotal;
  const StatField({
    required this.letterWeek,
    required this.expenses,
    required this.lastTotal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: lastTotal - expenses,
          width: 5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.grey),
        ),
        Container(
          height: expenses,
          width: 5,
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.tertiary),
        ),
        Text(
          letterWeek,
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}
