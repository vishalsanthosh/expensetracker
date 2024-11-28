import 'package:expensetracker/appwriteservices.dart';
import 'package:expensetracker/tracks.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final titleC = TextEditingController();
  final amountC = TextEditingController();
  final dateC = TextEditingController();
  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateC.text =
            "${selectedDate!.day.toString()}/${selectedDate!.month.toString()}/${selectedDate!.year.toString()}";
      });
    }
  }

  late Appwriteservices _appwriteservices;
  late List<Note> _notes;

  @override
  void initState() {
    super.initState();
    _appwriteservices = Appwriteservices();
    _notes = [];
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final tasks = await _appwriteservices.getExpns();
      setState(() {
        _notes = tasks.map((e) => Note.fromDocument(e)).toList();
      });
    } catch (e) {
      print("Error Loading Tasks:$e");
    }
  }

  Future<void> _addExpns() async {
    final title = titleC.text;
    final amount = amountC.text;
    final date = dateC.text;

    if (title.isNotEmpty && amount.isNotEmpty && date.isNotEmpty) {
      try {
        await _appwriteservices.addExpns(title, amount, date);
        titleC.clear();
        amountC.clear();
        dateC.clear();
        _loadNotes();
      } catch (e) {
        print("Error Loading Data:$e");
      }
    }
  }

  Future<void> _deleteExpns(String taskId) async {
    try {
      await _appwriteservices.deleteExpns(taskId);
      _loadNotes();
    } catch (e) {
      print("Error Deleting Task:$e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text("Expense Tracker"),
        centerTitle: true,
        backgroundColor: Colors.red[50],
      ),
      body: Expanded(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
            itemCount: _notes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              final notes = _notes[index];
              return Container(
                decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.red,
                          offset: Offset(0.0, 0.1),
                          blurRadius: 6)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      notes.title,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      "\$${notes.amount}/-",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      notes.date,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    IconButton(
                        onPressed: () => _deleteExpns(notes.id),
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.red,
                        ))
                  ],
                ),
              );
            }),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[50],
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.red[50]),
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(children: [
                          SizedBox(
                              height: 50,
                              width: 300,
                              child: TextField(
                                controller: titleC,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "   Title",
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              height: 60,
                              width: 300,
                              child: TextField(
                                controller: amountC,
                                maxLength: 20,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixText: "\$ ",
                                  hintText: "Amount",
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: 300,
                            child: TextField(
                              onTap: () => _selectDate(context),
                              controller: dateC,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "   Date"),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.red[600]),
                                    child: Icon(Icons.cancel),
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    _addExpns();
                                  },
                                  child: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.green),
                                    child: Icon(
                                      Icons.savings,
                                      size: 25,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ])));
              });
        },
        child: Icon(
          Icons.add_task,
          color: Colors.black54,
        ),
      ),
    );
  }
}
