import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

void main() {
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<MyApp> {
  // Will generate out list as Maps so we can update the check for each of them
  List<Map> _toDos = List.generate(
      0, (int index) => {'check': false, 'label': 'index $index'});

  void _add() {
    int newIndex = _toDos.length;
    setState(() {
      Map item = {'check': false, 'label': _value};
      _toDos.insert(newIndex, item);
    });
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
    return new Scaffold(
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
              flexibleSpace: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 250,
                    child: FlexibleSpaceBar(title: Text("To-Do List")),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.archive),
                    onPressed: () {},
                    color: Colors.green[900],
                    iconSize: 35,
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                    color: Colors.green[900],
                    iconSize: 35,
                  ),
                  Spacer()
                ],
              )),
          ReorderableSliverList(
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                Map item = _toDos.removeAt(oldIndex);
                _toDos.insert(newIndex, item);
              });
            },
            delegate: ReorderableSliverChildBuilderDelegate(
                (BuildContext context, int index) {
              // get out map from the list
              Map item = _toDos[index];
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    setState(() {
                      _toDos.removeAt(index);
                    });
                    // Show a snackbar. This snackbar could also contain "Undo" actions.
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("${item['label']} dismissed")));
                  },
                  child: CheckboxListTile(
                      value: item['check'],
                      onChanged: (v) {
                        // set the 'check' value to the new checkbox value(v)
                        item['check'] = v;
                        setState(() {});
                      },
                      title: Text(item['label'])));
            }, childCount: _toDos.length),
          ),
        ],
      ),
      drawer: new Drawer(
        child: new Container(
          padding: EdgeInsets.all(30.0),
          child: new Column(
            children: <Widget>[
              new Text('To-Do List'),
              new FlatButton(onPressed: null, child: new Text('Archive')),
              new FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: new Text('close'))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('New To-Do'),
                content: TextField(
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    labelText: 'New Item',
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
                    onPressed: null,
                    child: Text('CANCEL'),
                  ),
                  FlatButton(
                    textColor: Colors.green,
                    onPressed: () => _add,
                    child: Text('ADD'),
                  ),
                ],
              );
            }),
        child: new Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
