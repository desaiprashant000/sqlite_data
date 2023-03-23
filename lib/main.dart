import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqlite_data/sqlite.dart';
import 'package:sqlite_data/viewdata.dart';

void main() {
  runApp(MaterialApp(
    home: myapp(
      method: "insert",
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class myapp extends StatefulWidget {
  String? method;
  Map? map;

  myapp({this.method, this.map});

  @override
  State<myapp> createState() => _myappState();
}

class _myappState extends State<myapp> {
  TextEditingController t = TextEditingController();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  mydatabase m = mydatabase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    m.creatdb().then((value) {
      print(value);
    });
    if (widget.map != null) {
      t.text = widget.map!["name"];
      t1.text = widget.map!["contact"];
      t2.text = widget.map!["email"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextField(
              controller: t,
              decoration: InputDecoration(
                hintText: 'Enter name',
                labelText: 'name',
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: t1,
              decoration: InputDecoration(
                hintText: 'Enter contact',
                labelText: 'contact',
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: t2,
              decoration: InputDecoration(
                hintText: 'Enter email',
                labelText: 'email',
                border: InputBorder.none,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  String name = t.text;
                  String contact = t1.text;
                  String email = t2.text;

                  if (widget.method == "insert") {
                    m.creatdb().then((value) async {
                      String q =
                          await "insert into contact (id,name,contact,email) values (null,'$name','$contact','$email')";
                      value.rawInsert(q).then((value) {
                        print(value);
                        if (value >= 1) {
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return viewdata("all");
                            },
                          ));
                        }
                      });
                    });
                  } else {
                    String qry =
                        "update contact  set name='${name}',contact='${contact}',email='${email}' where id =${widget.map!['id']}";
                    m.creatdb().then((value) {
                      value.rawUpdate(qry).then((value) {
                        print(value);
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => viewdata("all"),
                          ));
                    });
                  }
                },
                child: Text("${widget.method}")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return viewdata("all");
                    },
                  ));
                },
                child: Text("view")),
          ],
        ),
      ),
      onWillPop: onback,
    );
  }

  Future<bool> onback() {
    showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text("do you wnat to Exit"),
          actions: [
            TextButton(onPressed: () {SystemNavigator.pop();}, child: Text("yes")),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No")),
          ],
        );
      },
      context: context,
    );
    return Future.value(true);
  }
}
