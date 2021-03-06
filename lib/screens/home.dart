import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';
import '../code/global_state.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // this makes the global state accessible from here
  GlobalState _store = GlobalState.instance;

  @override
  void initState() {
    // init state to just put all the variables where it's supposed to be
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
    {"icon": Icons.home, "name": "Home", "onTap": "/home"},
    {"icon": Icons.archive, "name": "Archive", "onTap": '/archive'},
    {"icon": Icons.history, "name": "History", "onTap": '/history'}
  ];

  List _toDos;
  List _archived;
  List _history;

  void _add() {
    if (_value != '') {
      int Index = _toDos.length;
      setState(() {
        Map item = {'check': false, 'label': _value};
        _toDos.insert(Index, item);
        _value = '';
      });
    }
  }

  String _value = '';

  void _onSubmit(String value) {
    setState(() => _value = value);
  }

  void _onChange(String value) {
    setState(() => _value = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: PrimaryScrollController.of(context) ?? ScrollController(),
        slivers: [
          SliverAppBar(
            actions: [IconButton(icon: Icon(Icons.search), onPressed: null)],
            backgroundColor: Colors.green,
            collapsedHeight: 60.0,
            expandedHeight: 200.0,
            elevation: 10.0,
            forceElevated: true,
            floating: false,
            pinned: true,
            snap: false,
            title: Text('To-Do List'),
            centerTitle: true,
          ),
          ReorderableSliverList(
            onReorder: (int oldIndex, int Index) {
              setState(() {
                Map item = _toDos.removeAt(oldIndex);
                _toDos.insert(Index, item);
              });
            },
            delegate: ReorderableSliverChildBuilderDelegate(
                (BuildContext context, int index) {
              // get out map from the list
              Map item = _toDos[index];
              return Card(
                  child: Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  // Remove the dismissed item from the list
                  var value = _toDos[index];
                  _toDos.removeAt(index);

                  String action;
                  if (direction == DismissDirection.startToEnd) {
                    // archiveItem();
                    action = "archived";
                    _archived.add(value);
                  } else {
                    // deletedItem();
                    action = "deleted";
                    _history.add(value['label']);
                  }
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                          label: 'undo',
                          textColor: Colors.red,
                          onPressed: () {
                            setState(() {
                              _toDos.insert(index, item);
                            });
                            if (action == 'archived') {
                              _archived.removeLast();
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
            }, childCount: _toDos.length),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.all(10.0),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('  To-Do'),
                content: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '  Item',
                    hintText: 'Input task',
                  ),
                  autocorrect: true,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  onSubmitted: _onSubmit,
                  onChanged: _onChange,
                ),
                actions: [
                  FlatButton(
                    textColor: Colors.green,
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL'),
                  ),
                  FlatButton(
                    textColor: Colors.green,
                    onPressed: () {
                      _add();
                      Navigator.pop(context);
                    },
                    child: Text('ADD'),
                  ),
                ], // actions
              );
            }),
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
