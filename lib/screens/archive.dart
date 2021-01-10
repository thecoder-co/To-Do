import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import '../code/global_state.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  GlobalState _store = GlobalState.instance;
  @override
  void initState() {
    List toDos = _store.get('main');
    List archived = _store.get('archived');
    List history = _store.get('history');

    if (toDos != []) {
      _toDos = toDos;
    } else {
      toDos = List.generate(
          0, (int index) => {'check': false, 'label': 'index $index'});
      _toDos = toDos;
    }

    if (archived != []) {
      _archived = archived;
    } else {
      toDos = List.generate(
          0, (int index) => {'check': false, 'label': 'index $index'});
      _archived = archived;
    }

    if (history != []) {
      _history = history;
    } else {
      toDos = List.generate(
          0, (int index) => {'check': false, 'label': 'index $index'});
      _history = history;
    }
  }

  List drawerItems = [
    {"icon": Icons.archive, "name": "Archive", "onTap": '/archive'},
    {"icon": Icons.home, "name": "Home", "onTap": "/home"},
    {"icon": Icons.history, "name": "History", "onTap": '/history'}
  ];

  List _toDos;
  List _archived;
  List _history;

  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          controller: PrimaryScrollController.of(context) ?? ScrollController(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.green,
              collapsedHeight: 60.0,
              expandedHeight: 200.0,
              elevation: 10.0,
              forceElevated: true,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: Container(
                width: 250,
                child: FlexibleSpaceBar(title: Text("Archive")),
              ),
            ),
            ReorderableSliverList(
                delegate: ReorderableSliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  // get out map from the list
                  Map item = _archived[index];
                  return Card(
                      child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      // Remove the dismissed item from the list
                      var value = _archived[index];
                      _archived.removeAt(index);

                      String action;
                      if (direction == DismissDirection.startToEnd) {
                        // archiveItem();
                        action = "unarchived";
                        _toDos.add(value);
                      } else {
                        // deletedItem();
                        action = "deleted";
                        _history.add(value['label']);
                      }
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                          action: SnackBarAction(
                              label: 'undo',
                              textColor: Colors.red,
                              onPressed: () {
                                setState(() {
                                  _archived.insert(index, item);
                                });
                                if (action == 'unarchived') {
                                  _toDos.removeLast();
                                } else if (action == 'deleted') {
                                  _history.removeLast();
                                }
                              }),
                          content: Text("${item['label']} $action"),
                        ),
                      );
                    },
                    child: CheckboxListTile(
                        value: item['check'],
                        onChanged: (v) {
                          // set the 'check' value to the   checkbox value(v)
                          item['check'] = v;
                          setState(() {});
                        },
                        title: Text(item['label'])),
                    secondaryBackground: Container(
                      color: Colors.red,
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            Text(
                              " Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        alignment: Alignment.centerRight,
                      ),
                    ),
                    background: Container(
                      color: Colors.green,
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.unarchive,
                              color: Colors.white,
                            ),
                            Text(
                              " Unarchive",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ));
                }, childCount: _archived.length),
                onReorder: (int oldIndex, int Index) {
                  setState(() {
                    Map item = _archived.removeAt(oldIndex);
                    _archived.insert(Index, item);
                  });
                })
          ]),
      drawer: Drawer(
        child: Container(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  "TO-DO LIST",
                  style: TextStyle(color: Colors.white),
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: drawerItems.length,
                itemBuilder: (BuildContext context, int index) {
                  Map item = drawerItems[index];
                  return ListTile(
                    leading: Icon(item['icon']),
                    title: Text(item['name']),
                    onTap: index == 0
                        ? () {
                            Navigator.pop(context);
                          }
                        : () {
                            _store.set('main', _toDos);
                            _store.set('archived', _archived);
                            _store.set('history', _history);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                item['onTap'], (Route<dynamic> route) => false);
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
