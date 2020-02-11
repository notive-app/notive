import 'package:flutter/material.dart';
import 'package:notive_app/components/reusable_list_card.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:notive_app/models/list_data.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ListData>(
      builder: (context, listData, child) {
        return ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              child: Center(
//              child: Container(
//                color: Colors.red,
//                width: 48.0,
//                height: 48.0,
//              ),
                child: ReusableListCard(
                  color: RandomColor().randomColor(),
                  listName: listData.lists[index].listName,
                ),
              ),
            );

//              ReusableListCard(
//              color: RandomColor().randomColor(),
//              listName: listData.lists[index].listName,
////              checkCallback: (bool isMuted) {
////                listData.changeListName(listData.lists[index]);
////              },
////              deleteCallback: () {
////                listData.deleteList(listData.lists[index]);
////              },
//            );
          },
          itemCount: listData.itemsCount,
        );
      },
    );
  }
}

//GridView.count(
////                 crossAxisCount: 2,
////                 padding: EdgeInsets.all(3.0),
////                 children: <Widget>[
////                   ReusableListCard(color: Colors.blue,),
////                   ReusableListCard(color: Colors.red,),
////                   ReusableListCard(color: Colors.yellow,),
////                   ReusableListCard(color: Colors.pink,),
////                   ReusableListCard(color: Colors.purple,),
////                   ReusableListCard(color: Colors.cyanAccent,),
////                   ReusableListCard(color: Colors.indigo,)
////                 ],
////               ),
//
//

//GridView.count(
//crossAxisCount: 2,
//padding: EdgeInsets.all(3.0),
//children: <Widget>[
//ReusableListCard(
//color: RandomColor().randomColor(),
//),
//ReusableListCard(
//color: RandomColor().randomColor(),
//),
//ReusableListCard(
//color: RandomColor().randomColor(),
//),
//],
//)
