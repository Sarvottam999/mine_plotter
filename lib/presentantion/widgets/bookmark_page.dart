import 'package:flutter/material.dart';
import 'package:myapp/molecules/Buttons/icon_button.dart';
import 'package:myapp/molecules/Buttons/outline_filled_button.dart';
import 'package:myapp/molecules/custom_dialog.dart';
import 'package:myapp/presentantion/providers/drawing_provider.dart';
import 'package:myapp/utils/contant.dart';
import 'package:myapp/molecules/snakbar.dart';
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
          backgroundColor: Colors.white,
          title: Text("Rename Page"),
          content: TextField(
              cursorColor: Colors.black,
              controller: controller,
              decoration: InputDecoration(
                hoverColor: my_orange,
                labelStyle: TextStyle(color: Colors.black),
                hintText: 'Enter new page name',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: my_orange, width: 2.0),
                  // borderRadius: BorderRadius.circular(25.0),
                ),
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
              },
              child: Text("Cancel", style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              onPressed: () {
                provider.renamePage(index, controller.text);
                Navigator.pop(dialogContext); // Close dialog after renaming
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: my_orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDropdownMenu(BuildContext context, Offset position) async {
    final provider = context.read<DrawingProvider>();

    if (provider.savedStates.isEmpty || provider.pageNames.isEmpty) {
      CustomSnackbar.show(
        context,
        message: "No saved pages available!! Create new page.",
        type: SnackbarType.info,
      );
      return;
    }

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final double screenHeight = overlay.size.height - 200;

    await showMenu(
      color: Colors.white,
      context: context,
      position: RelativeRect.fromLTRB(
        10, 
        screenHeight, 
        10,
        0, 
      ),
      items: List.generate(provider.savedStates.length, (index) {
        return PopupMenuItem<int>(
          value: index,
          child: GestureDetector(
            onLongPress: () {
              Navigator.pop(context); // Close menu before renaming
              _showRenameDialog(context, index);
            },
            child: Container(
              color: const Color.fromARGB(255, 255, 255, 255),
              child: ListTile(
                minVerticalPadding: 0,
                style: ListTileStyle.drawer,
                title: Text(provider.pageNames[index]), // Display custom name
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.grey.shade400),
                  onPressed: () {
                    Navigator.pop(context); // Close dropdown after delete
                    _showDeleteConfirmationDialog(
                        context, index); // Show confirmation dialog
                  },
                ),
                onTap: () {
                  provider.switchToState(index);
                  Navigator.pop(context); // Close dropdown on selection
                },
              ),
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

void _showDeleteConfirmationDialog(BuildContext context, int index) {
  final provider = context.read<DrawingProvider>();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return CustomDialog(
        title: "Delete Page?",
        message:
            "Are you sure you want to delete this page? This action cannot be undone.",
        onConfirm: () {
          provider.deleteState(index);
          Navigator.pop(dialogContext); // Close dialog after delete
        },
        onCancel: () {
          Navigator.pop(dialogContext); // Close dialog
        },
        iconColor: my_orange, // Using your existing color
      );
    },
  );
}
