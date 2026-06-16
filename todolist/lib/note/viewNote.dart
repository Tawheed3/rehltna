import 'package:auth_app_fixed/note/addNote.dart';
import 'package:auth_app_fixed/note/editNote.dart';
import 'package:auth_app_fixed/note/points_page.dart';
import 'package:auth_app_fixed/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class NoteView extends StatefulWidget {
  final String categoryid;
  final String categoryName;

  const NoteView({
    super.key,
    required this.categoryid,
    required this.categoryName,
  });

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  Future<void> _toggleComplete(String noteId, bool currentStatus, BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    try {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryid)
          .collection("Note")
          .doc(noteId)
          .update({
        "isCompleted": !currentStatus,
        "completedAt": !currentStatus ? FieldValue.serverTimestamp() : null,
      });

      _showSnackBar(
        !currentStatus
            ? '✅ ${l10n?.taskUpdated ?? "Task completed"}'
            : '🔄 ${l10n?.markIncomplete ?? "Task reopened"}',
        isError: false,
      );
    } catch (error) {
      _showSnackBar('❌ ${l10n?.error ?? "Error"}: $error', isError: true);
    }
  }

  Future<void> _deleteNote(String noteId, BuildContext context) async {
    final l10n = AppLocalizations.of(context);

    try {
      // أولاً: حذف جميع النقاط المرتبطة بالمهمة
      final pointsSnapshot = await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryid)
          .collection("Note")
          .doc(noteId)
          .collection("points")
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (var point in pointsSnapshot.docs) {
        batch.delete(point.reference);
      }
      await batch.commit();

      // ثانياً: حذف المهمة نفسها
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryid)
          .collection("Note")
          .doc(noteId)
          .delete();

      _showSnackBar('🗑️ ${l10n?.taskDeleted ?? "Task deleted"}', isError: false);
    } catch (error) {
      _showSnackBar('❌ ${l10n?.deleteFailed ?? "Delete failed"}: $error', isError: true);
    }
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    if (l10n == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.tasks, style: const TextStyle(fontSize: 18)),
              Text(
                widget.categoryName,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("categories")
              .doc(widget.categoryid)
              .collection("Note")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
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
                      Icons.note_add,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.noTasks,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.addFirstTask,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            var data = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: data.length,
              itemBuilder: (context, i) {
                bool isCompleted = data[i]["isCompleted"] ?? false;
                DateTime? createdAt = data[i]["createdAt"] != null
                    ? (data[i]["createdAt"] as Timestamp).toDate()
                    : null;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isCompleted ? Colors.green[50] : Colors.white,
                  child: InkWell(
                    onTap: () {
                      // الانتقال لصفحة النقاط الخاصة بالمهمة
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PointsPage(
                            categoryId: widget.categoryid,
                            noteId: data[i].id,
                            noteName: data[i]["name"],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (value) {
                          _toggleComplete(data[i].id, isCompleted, context);
                        },
                        shape: const CircleBorder(),
                      ),
                      title: Text(
                        "${data[i]["name"]}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (createdAt != null)
                            Text(
                              "${l10n.createdOn}: ${_formatDate(createdAt, isArabic)}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          // عرض عدد النقاط المكتملة
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("categories")
                                .doc(widget.categoryid)
                                .collection("Note")
                                .doc(data[i].id)
                                .collection("points")
                                .snapshots(),
                            builder: (context, pointsSnapshot) {
                              if (!pointsSnapshot.hasData) return const SizedBox();

                              int totalPoints = pointsSnapshot.data!.docs.length;
                              int completedPoints = pointsSnapshot.data!.docs
                                  .where((doc) => doc['isCompleted'] == true)
                                  .length;

                              if (totalPoints == 0) return const SizedBox();

                              return Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '📋 $completedPoints/$totalPoints',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditNote(
                                    noteId: data[i].id,
                                    categoryId: widget.categoryid,
                                    oldName: data[i]["name"],
                                    oldDescription: data[i]["description"],
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                            onPressed: () {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: l10n.confirm,
                                desc: l10n.editOrDeleteTask,
                                btnCancelText: l10n.cancel,
                                btnOkText: l10n.delete,
                                btnCancelOnPress: () {},
                                btnOkOnPress: () {
                                  _deleteNote(data[i].id, context);
                                },
                              ).show();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddNote(
                  docid: widget.categoryid,
                  categoryName: widget.categoryName,
                ),
              ),
            );
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue,
          tooltip: l10n.addTask,
        ),
      ),
    );
  }

  String _formatDate(DateTime date, bool isArabic) {
    if (isArabic) {
      return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
    } else {
      final monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final period = date.hour < 12 ? 'AM' : 'PM';
      final hour12 = date.hour > 12 ? date.hour - 12 : date.hour;
      return '${monthNames[date.month - 1]} ${date.day}, ${date.year} $hour12:${date.minute.toString().padLeft(2, '0')} $period';
    }
  }
}