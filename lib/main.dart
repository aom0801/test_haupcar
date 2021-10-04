import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_haupcar/api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List items = [];
  bool isLoading = true;
  var data;
  TextEditingController _name = TextEditingController();
  ApiProvider apiProvider = ApiProvider();

  //==> check API
  Future fetchPost() async {
    try {
      var response = await apiProvider.getPost();

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        setState(() {
          isLoading = false;
          items = jsonResponse['data'];
          print(items);
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print(error);
    }
  }

  Future<void> searchEmployee(String query) async {
    items = [];

    if (query.isNotEmpty) {

      items.forEach((item) {
        String firstName = item.firstName.toLowerCase();
        if (firstName.contains(query.toLowerCase())) {
          items.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(items);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(items);
      });
    }
  }


  void _loadData() {
    setState(() {
      data = ApiProvider();
    });
  }

  @override
  void initState() {
    fetchPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: h * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10.00),
                        topRight: const Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        /// ---------- search ---------------//
                        Padding(
                          padding: EdgeInsets.all(2),
                          child: Container(
                            height: 50.0,
                            width: 330,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white),
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              controller: _name,
                              decoration: InputDecoration(
                                hintText: "search",
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.only(left: 15.0, top: 15.0),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {

                                  },
                                  iconSize: 30.0,
                                ),
                              ),
                              onChanged: (value) {
                                searchEmployee(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: h * 0.03,
            ),
            Container(
                child: isLoading
                    ? Center(
                  child: Text('No Data'),
                )
                    : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    var item = items[index];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 0.0, right: 0.0, bottom: 4.0),
                      child: Container(
                        color: Colors.white,
                        child: ListTile(
                          onTap: () {
                          },
                          title: Text('${item['name']}'),
                          subtitle: Row(
                            children: <Widget>[
                              Text(' ${item['name']} '),
                            ],
                          ),
                        ),
                      ),
                    );
                  },

                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadData,
        tooltip: 'Data',
        child: isLoading == true ? Icon(Icons.file_download) : Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
