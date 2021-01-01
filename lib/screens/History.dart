import 'package:flutter/material.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
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
            )
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
