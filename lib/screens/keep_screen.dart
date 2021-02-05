import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salmankeep/helpers/database_helper.dart';
import 'package:salmankeep/models/keep_model.dart';
import 'package:salmankeep/screens/add_keep_screen.dart';
import 'package:salmankeep/constans.dart';

class KeepScreen extends StatefulWidget {
  @override
  _KeepScreenState createState() => _KeepScreenState();
}

class _KeepScreenState extends State<KeepScreen> {
  Future<List<Keep>> _keepList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateKeepList();
  }

  _updateKeepList() {
    setState(() {
      _keepList = DatabaseHelper.instance.getKeepList();
    });
  }

  Widget _buildKeep(Keep keep) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            ListTile(
              title: Text(keep.title, style: TextStyle(fontSize: 18.0, decoration: keep.status == 0 ? TextDecoration.none : TextDecoration.lineThrough),),
              subtitle: Text('${_dateFormatter.format(keep.date)} - ${keep.priority}', style: TextStyle(fontSize: 15.0, decoration: keep.status == 0 ? TextDecoration.none : TextDecoration.lineThrough),),
              trailing: Checkbox(
                onChanged: (value) {
                  keep.status = value ? 1 : 0;
                  DatabaseHelper.instance.updateKeep(keep);
                  _updateKeepList();
                },
                activeColor: Theme.of(context).primaryColor,
                value: keep.status == 1 ? true : false,
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddKeepScreen(updateKeepList: _updateKeepList, keep: keep,),
                ),
              ),
            ),
            Divider(),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddKeepScreen(
              updateKeepList: _updateKeepList,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: _keepList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final int completedKeepCount = snapshot.data.where((Keep keep) => keep.status == 1).toList().length;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 80.0),
              itemCount: 1 + snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if(index == 0){
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kHeader,
                          style: kHeaderStyle,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          '${snapshot.data.length} tane görevden $completedKeepCount tanesi yapıldı. ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return _buildKeep(snapshot.data[index - 1]);
              },
            );
          }
      ),
    );
  }
}