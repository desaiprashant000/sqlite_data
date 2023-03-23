import 'package:flutter/material.dart';
import 'package:sqlite_data/main.dart';
import 'package:sqlite_data/sqlite.dart';

class viewdata extends StatefulWidget {
  String? data;

  viewdata(this.data);

  @override
  State<viewdata> createState() => _viewdataState();
}

class _viewdataState extends State<viewdata> {
  List<Map<String, Object?>> list = [];
  mydatabase my = mydatabase();
  String s = "";

  getdata() {
    if (widget.data == "favorite") {
      s = "select * from contact where favorite=1";
    } else {
      s = "select * from contact";
    }
    my.creatdb().then((value) {
      value.rawQuery(s).then((value) {
        setState(() {
          list = value as List<Map<String, Object?>>;
        });
        print(list);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions:[
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return viewdata("favorite");
                    },
                  ));
                },
                icon: Icon(Icons.favorite)),
          ],
        ),
        body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            Map m = list[index];
            return ListTile(
              onTap: () {},
              title: Text('${m['name']}'),
              subtitle: Text('${m['contact']}'),
              leading: Text('${m['id']}'),
              trailing: Wrap(
                children: [
                  m['favorite'] == 0
                      ? IconButton(
                          onPressed: () {
                            String qry =
                                "update contact  set favorite = 1 where id =${m['id']}";
                            my.creatdb().then((value) {
                              value.rawUpdate(qry).then((value) {
                                getdata();
                              });
                            });
                          },
                          icon: Icon(Icons.favorite_border_outlined))
                      : IconButton(
                          onPressed: () {
                            String qry =
                                "update contact  set favorite = 0 where id =${m['id']}";
                            my.creatdb().then((value) {
                              value.rawUpdate(qry).then((value) {
                                getdata();
                              });
                            });
                          },
                          icon: Icon(Icons.favorite)),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Column(
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return myapp(
                                        map: m,
                                        method: "upadate",
                                      );
                                    },
                                  ));
                                },
                                child: Text('Edit')),
                            TextButton(
                                onPressed: () {
                                  String q =
                                      "delete from contact where id =${m['id']}";
                                  mydatabase().creatdb().then((value) {
                                    value.rawDelete(q).then((value) {
                                      getdata();
                                    });
                                  });
                                },
                                child: Text('Delete')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      onWillPop: onback,
    );
  }

  Future<bool> onback() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return myapp(
          method: "insert",
        );
      },
    ));
    return Future.value(true);
  }
}
