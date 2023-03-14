import 'package:flutter/material.dart';
import 'package:todo_list/db_handler.dart';
import 'package:todo_list/notes.dart';
import 'package:async/async.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> noteslist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }
  loadData()async{
    noteslist = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                 future: noteslist,
                  builder: (context, AsyncSnapshot<List<NotesModel>> snapshot){
                   if(snapshot.hasData){
                     return ListView.builder(
                         reverse: false,
                         shrinkWrap: true,
                         itemCount: snapshot.data?.length,
                         itemBuilder: (context, index){
                           return InkWell(
                             onTap: (){
                               dbHelper!.update(
                                 NotesModel(
                                   id: snapshot.data![index].id!,
                                     title: 'First Flutter Note',
                                     age: '31',
                                     description: 'Pakistan Zindabad',
                                     email: 'ishaq@gmail.com',
                                 )
                               );
                               setState(() {
                                 noteslist = dbHelper!.getNotesList();
                               });
                             },
                             child: Dismissible(
                               direction: DismissDirection.endToStart,
                               background: Container(
                                 color: Colors.red,
                                 child: Icon(Icons.delete_forever),
                               ),
                               onDismissed: (DismissDirection direction){
                                 setState(() {
                                   dbHelper!.delete(snapshot.data![index].id!);
                                   noteslist = dbHelper!.getNotesList();
                                   snapshot.data!.remove(snapshot.data![index]  );
                                 });
                               },
                               key: ValueKey<int>(snapshot.data![index].id!),
                               child: Card(
                                 child: ListTile(
                                   leading: Text(snapshot.data![index].title.toString()),
                                   title: Text(snapshot.data![index].description.toString()),
                                   subtitle: Text(snapshot.data![index].email.toString()),
                                   trailing: Text(snapshot.data![index].age.toString()),
                                 ),
                               ),
                             ),
                           );
                         });
                   }
                   else{
                     return CircularProgressIndicator();
                     
                   }
                }
                ),
            )

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper!.insert(NotesModel(
              title: 'Firsadedfweefwefst Note',
              age: '21',
              description: ' Zinhvjhfvjhfjhcfvhcfvyudabad',
              email: 'issshaqfarid2@gmail.com')
          ).then((value){
            print('Data added');
            setState(() {

            });
            setState(() {
              noteslist = dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace){
            print(error.toString());
          });
        },
        child: Icon(Icons.add),
      ),

    );
  }
}
