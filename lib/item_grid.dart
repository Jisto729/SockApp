import 'package:flutter/material.dart';
import 'package:sockapp/clothing_item.dart';
import 'package:sockapp/db.dart';
import 'package:sockapp/item_detail.dart';

class ClothingListView extends StatefulWidget {
  const ClothingListView({super.key});

  @override
  State<ClothingListView> createState() => _ClothingListViewState();
}

class _ClothingListViewState extends State<ClothingListView> {
  ClothingItemDatabase db = ClothingItemDatabase.instance;

  List<ClothesModel> items = [];

  @override
  void initState() {
    refreshItems();
    super.initState();
  }

  @override
  dispose() {
    //close the database
    db.close();
    super.dispose();
  }

  ///Gets all the notes from the database and updates the state
  refreshItems() {
    db.readAll().then((value) {
      setState(() {
        items = value;
      });
    });
  }

  ///Navigates to the NoteDetailsView and refreshes the notes after the navigation
  goToItemDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClothingDetailView(itemId: id)),
    );
    refreshItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: items.isEmpty
            ? const Text(
                'No Notes yet',
                style: TextStyle(color: Colors.white),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return GestureDetector(
                    onTap: () => goToItemDetailsView(id: item.id),
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.amber,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: Colors.amber,
                              child: Text(
                                item.owner,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                            Container(
                                color: Colors.red, child: Icon(Icons.abc)),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToItemDetailsView,
        tooltip: 'Create Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
