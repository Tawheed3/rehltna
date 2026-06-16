import 'package:auth_app_fixed/category/addCategory.dart';
import 'package:auth_app_fixed/setting/settings_page.dart';
import 'package:auth_app_fixed/note/viewNote.dart';
import 'package:auth_app_fixed/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'category/editeCategory.dart';

class HomePage extends StatefulWidget {
  final Function(Locale)? onLanguageChanged;  // أضف هذا

  const HomePage({super.key, this.onLanguageChanged});  // أضف parameter

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getFolderColor(int index) {
    List<Color> colors = [
      Colors.amber,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.orange,
      Colors.indigo,
    ];
    return colors[index % colors.length];
  }

  // دالة لعدد المهام
  String _getTaskCountText(int count, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context);
    if (locale.languageCode == 'ar') {
      return count == 1 ? '$count مهمة' : '$count مهام';
    } else {
      return count == 1 ? '$count task' : '$count tasks';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.folders),
          actions: [
            // زر الإعدادات
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      currentLocale: locale,
                      onLocaleChanged: widget.onLanguageChanged ?? (locale) {},
                    ),
                  ),
                );
              },
              tooltip: l10n.settings,
            ),
          ],
        ),
        body: currentUserId == null
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("categories")
              .where("id", isEqualTo: currentUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.loading,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 60),
                    const SizedBox(height: 20),
                    Text(
                      l10n.error,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => setState(() {}),
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.ok),
                    ),
                  ],
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 100,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.noFolders,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.addFirstFolder,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Addcategory(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addFolder),
                    ),
                  ],
                ),
              );
            }

            var data = snapshot.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: data.length,
              itemBuilder: (context, i) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteView(
                            categoryid: data[i].id,
                            categoryName: data[i]["name"],
                          ),
                        ),
                      );
                    },
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.bottomSlide,
                        title: l10n.confirm,
                        desc: l10n.editOrDeleteFolder,
                        btnCancelText: l10n.edit,
                        btnOkText: l10n.delete,
                        btnCancelOnPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Editcategory(
                                oldName: data[i]["name"],
                                docid: data[i].id,
                              ),
                            ),
                          );
                        },
                        btnOkOnPress: () async {
                          try {
                            // حذف جميع المهام أولاً
                            final notesSnapshot = await FirebaseFirestore
                                .instance
                                .collection("categories")
                                .doc(data[i].id)
                                .collection("Note")
                                .get();

                            final batch = FirebaseFirestore.instance.batch();
                            for (var note in notesSnapshot.docs) {
                              batch.delete(note.reference);
                            }
                            await batch.commit();

                            // ثم حذف الفولدر
                            await FirebaseFirestore.instance
                                .collection("categories")
                                .doc(data[i].id)
                                .delete();

                            _showSnackBar(l10n.folderDeleted,
                                isError: false);
                          } catch (error) {
                            _showSnackBar(
                                '${l10n.error}: ${error.toString()}',
                                isError: true);
                          }
                        },
                      ).show();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // أيقونة الفولدر
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: _getFolderColor(i).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.folder,
                              size: 40,
                              color: _getFolderColor(i),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // اسم الفولدر
                          Expanded(
                            child: Text(
                              "${data[i]["name"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // عدد المهام
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("categories")
                                .doc(data[i].id)
                                .collection("Note")
                                .snapshots(),
                            builder: (context, notesSnapshot) {
                              int taskCount = 0;
                              int completedCount = 0;

                              if (notesSnapshot.hasData) {
                                taskCount = notesSnapshot.data!.docs.length;
                                completedCount = notesSnapshot.data!.docs
                                    .where((note) {
                                  var noteData = note.data()
                                  as Map<String, dynamic>;
                                  return noteData.containsKey(
                                      "isCompleted") &&
                                      noteData["isCompleted"] == true;
                                })
                                    .length;
                              }

                              return Column(
                                children: [
                                  Text(
                                    _getTaskCountText(taskCount, l10n),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (taskCount > 0)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: completedCount == taskCount
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.orange.withOpacity(0.1),
                                        borderRadius:
                                        BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${completedCount}/${taskCount} ${l10n.completed.toLowerCase()}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: completedCount == taskCount
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Addcategory(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: Text(l10n.addFolder),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          tooltip: l10n.addFolder,
          elevation: 4,
        ),
      ),
    );
  }
}
