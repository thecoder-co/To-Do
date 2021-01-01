import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import '../code/GlobalState.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
                child: FlexibleSpaceBar(title: Text("History")),
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
                        action = "Archived";
                        _archived.add(value);
                      } else {
                        // homeitem();
                        action = "Back to Home";
                        _toDos.add(value['label']);
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
                                if (action == 'Archived') {
                                  _archived.removeLast();
                                } else if (action == 'Back to Home') {
                                  _toDos.removeLast();
                                }
                              }),
                          content: Text("${item['label']} $action"),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(item['label']),
                    ),
                    secondaryBackground: Container(
                      color: Colors.blue,
                      child: Align(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            Text(
                              " Back to Home",
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
                              Icons.archive,
                              color: Colors.white,
                            ),
                            Text(
                              " Archive",
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
                }, childCount: _history.length),
                onReorder: (int oldIndex, int Index) {
                  setState(() {
                    Map item = _history.removeAt(oldIndex);
                    _history.insert(Index, item);
                  });
                })
          ]),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.book),
                  title: Text('To-Do List'),
                  onTap: null),
              ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Home', (Route<dynamic> route) => false);
                  }),
              ListTile(
                  leading: Icon(Icons.archive),
                  title: Text('Archive'),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Archive', (Route<dynamic> route) => false);
                  }),
              ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('History'),
                  onTap: () {
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Close'),
                  onTap: () => Navigator.pop(context))
            ],
          ),
        ),
      ),
    );
  }
}
