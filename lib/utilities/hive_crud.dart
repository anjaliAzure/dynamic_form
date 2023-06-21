
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test2/utilities/common_widgets.dart';

class HiveHelper
{
   initHive()
   async
   {
    try
    {
      Directory directory = await getApplicationDocumentsDirectory();
      Hive.init(directory.path);
      Box box = await Hive.openBox("test_1");
      for(int i = 0 ; i < 10 ; i++)
        {
          box.add({
            "name" : "Dhaval",
            "age" : 23
          });
        }
    }
    catch(e)
     {
       CommonWidgets.showToast("Failed initialising database!");
     }
   }

   insert(Map<int , dynamic> value)
   async {
     try
     {
       Box box = await Hive.openBox("test_1");
       box.add(value);
     }
     catch(e)
     {
       CommonWidgets.showToast("Failed inserting values!");
     }
   }

   read()
   async {
     try
     {
       Box box = await Hive.openBox("test_1");

       for(int i = 0 ; i < box.length ; i++)
       {
         CommonWidgets.printLog(box.getAt(i).toString());
       }
     }
     catch(e)
     {
       CommonWidgets.showToast("Failed reading values!");
     }
   }

   update(int index , dynamic value)
   async {
     try
     {
       Box box = await Hive.openBox("test_1");

       box.putAt(index, value);
     }
     catch(e)
     {
       CommonWidgets.showToast("Failed updating values!");
     }
   }

   delete(int index)
   async {
     try
     {
       Box box = await Hive.openBox("test_1");

       box.deleteAt(index);
     }
     catch(e)
     {
       CommonWidgets.showToast("Failed deleting values!");
     }
   }

   clear()
   async {
     try
     {
       Box box = await Hive.openBox("test_1");

       box.clear();
     }
     catch(e)
     {
       CommonWidgets.showToast("Failed deleting values!");
     }
   }

}
