import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Will generate out list as Maps so we can update the check for each of them
  List<Map> _toDos = List.generate(
      0, (int index) => {'check': false, 'label': 'index $index'});

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
              return Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  // Remove the dismissed item from the list
                  _toDos.removeAt(index);

                  String action;
                  if (direction == DismissDirection.startToEnd) {
                    // archiveItem();
                    action = "archived";
                  } else {
                    // deletedItem();
                    action = "deleted";
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
              );
            }, childCount: _toDos.length),
          ),
        ],
      ),
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
                    Navigator.pop(context);
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
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/History', (Route<dynamic> route) => false);
                  }),
              ListTile(
                  leading: Icon(Icons.close),
                  title: Text('Close'),
                  onTap: () => Navigator.pop(context))
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
