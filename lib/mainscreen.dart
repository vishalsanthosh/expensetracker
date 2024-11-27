import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final title = TextEditingController();
  final amount = TextEditingController();
  final date = TextEditingController();
  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date.text =
            "${selectedDate!.day.toString()}/${selectedDate!.month.toString()}/${selectedDate!.year.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        title: Text("Expense Tracker"),
        centerTitle: true,
        backgroundColor: Colors.red[50],
      ),
      body: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Text(title.text),
              subtitle: Text(amount.text),
              trailing: Text(date.text),
            );
          }),
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
                                controller: title,
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
                                controller: amount,
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
                              controller: date,
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
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.red[600]),
                                  child: Icon(Icons.cancel),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {},
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
