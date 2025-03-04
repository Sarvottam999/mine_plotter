import 'package:flutter/material.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/molecules/Buttons/outline_filled_button.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/utils/contant.dart';
import 'package:provider/provider.dart';

 

class BookmarkePanel extends StatefulWidget {
  const BookmarkePanel({super.key});

  @override
  _BookmarkePanelState createState() => _BookmarkePanelState();
}

class _BookmarkePanelState extends State<BookmarkePanel> {
  void _showRenameDialog(BuildContext context, int index) {
    final provider = context.read<DrawingProvider>();
    final TextEditingController controller =
        TextEditingController(text: provider.pageNames[index]);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Rename Page"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter new page name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                provider.renamePage(index, controller.text);
                Navigator.pop(dialogContext); // Close dialog after renaming
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // void _showDropdownMenu(BuildContext context, Offset position) async {
  //   final provider = context.read<DrawingProvider>();

  //   await showMenu(
  //     context: context,
  //     position: RelativeRect.fromLTRB(0, 65, 0, 0),
  //     items: List.generate(provider.savedStates.length, (index) {
  //       return PopupMenuItem<int>(
  //         value: index,
  //         child: GestureDetector(
  //           onLongPress: () {
  //             Navigator.pop(context); // Close menu before renaming
  //             _showRenameDialog(context, index);
  //           },
  //           child: ListTile(
  //             title: Text(provider.pageNames[index]), // Display custom name
  //             trailing: IconButton(
  //               icon: Icon(Icons.delete, color: Colors.red),
  //               onPressed: () {
  //                 provider.deleteState(index);
  //                 Navigator.pop(context); // Close dropdown after delete
  //               },
  //             ),
  //             onTap: () {
  //               provider.switchToState(index);
  //               Navigator.pop(context); // Close dropdown on selection
  //             },
  //           ),
  //         ),
  //       );
  //     }),
  //   );
  // }
  void _showDropdownMenu(BuildContext context, Offset position) async {
  final provider = context.read<DrawingProvider>();

  // 🛑 Prevent menu from opening if there are no items
  if (provider.savedStates.isEmpty || provider.pageNames.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No saved states available")),
    );
    return;
  }

  await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(0, 65, 0, 0),
    items: List.generate(provider.savedStates.length, (index) {
      return PopupMenuItem<int>(
        value: index,
        child: GestureDetector(
          onLongPress: () {
            Navigator.pop(context); // Close menu before renaming
            _showRenameDialog(context, index);
          },
          child: ListTile(
            title: Text(provider.pageNames[index]), // Display custom name
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                provider.deleteState(index);
                Navigator.pop(context); // Close dropdown after delete
              },
            ),
            onTap: () {
              provider.switchToState(index);
              Navigator.pop(context); // Close dropdown on selection
            },
          ),
        ),
      );
    }),
  );
}


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              context.read<DrawingProvider>().createNewState();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: my_orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "New",
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 10),
          Consumer<DrawingProvider>(
            builder: (context, provider, _) {
              String currentPageText = provider.currentStateIndex >= 0
                  ? provider.pageNames[provider.currentStateIndex]
                  : "No Page Selected";

              return GestureDetector(
                onTapDown: (TapDownDetails details) {
                  _showDropdownMenu(context, details.globalPosition);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(currentPageText),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

