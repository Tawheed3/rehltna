import 'package:auth_app_fixed/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PointsPage extends StatefulWidget {
  final String categoryId;
  final String noteId;
  final String noteName;

  const PointsPage({
    super.key,
    required this.categoryId,
    required this.noteId,
    required this.noteName,
  });

  @override
  State<PointsPage> createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  final TextEditingController _pointController = TextEditingController();
  bool _isAddingPoint = false;

  Future<void> _addPoint() async {
    if (_pointController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال اسم النقطة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isAddingPoint = true);

    try {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .collection("Note")
          .doc(widget.noteId)
          .collection("points")
          .add({
        "name": _pointController.text.trim(),
        "isCompleted": false,
        "createdAt": FieldValue.serverTimestamp(),
      });

      _pointController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إضافة النقطة بنجاح'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ: $error'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isAddingPoint = false);
    }
  }

  Future<void> _togglePoint(String pointId, bool currentStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .collection("Note")
          .doc(widget.noteId)
          .collection("points")
          .doc(pointId)
          .update({
        "isCompleted": !currentStatus,
        "completedAt": !currentStatus ? FieldValue.serverTimestamp() : null,
      });
    } catch (error) {
      print('Error toggling point: $error');
    }
  }

  Future<void> _deletePoint(String pointId) async {
    try {
      await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .collection("Note")
          .doc(widget.noteId)
          .collection("points")
          .doc(pointId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حذف النقطة'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في الحذف: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteDialog(String pointId) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.rightSlide,
      title: 'تأكيد الحذف',
      desc: 'هل أنت متأكد من حذف هذه النقطة؟',
      btnCancelText: 'إلغاء',
      btnOkText: 'حذف',
      btnCancelOnPress: () {},
      btnOkOnPress: () => _deletePoint(pointId),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('نقاط المهمة'),
              Text(
                widget.noteName,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          backgroundColor: Colors.blue[700],
        ),
        body: Column(
          children: [
            // حقل إضافة نقطة جديدة
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pointController,
                      decoration: InputDecoration(
                        hintText: 'أدخل نقطة جديدة...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _addPoint(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isAddingPoint ? null : _addPoint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    child: _isAddingPoint
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),

            // قائمة النقاط
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("categories")
                    .doc(widget.categoryId)
                    .collection("Note")
                    .doc(widget.noteId)
                    .collection("points")
                    .orderBy("createdAt", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.red, size: 60),
                          const SizedBox(height: 20),
                          Text('خطأ: ${snapshot.error}'),
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
                            Icons.list_alt,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'لا توجد نقاط بعد',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'أضف أول نقطة للمهمة',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  var points = snapshot.data!.docs;

                  // حساب الإحصائيات
                  int totalPoints = points.length;
                  int completedPoints = points
                      .where((doc) => doc['isCompleted'] == true)
                      .length;
                  double progress = totalPoints > 0
                      ? completedPoints / totalPoints
                      : 0;

                  return Column(
                    children: [
                      // شريط التقدم
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'التقدم: $completedPoints/$totalPoints',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${(progress * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.blue,
                              ),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                      ),

                      const Divider(),

                      // قائمة النقاط
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: points.length,
                          itemBuilder: (context, index) {
                            var point = points[index];
                            bool isCompleted = point['isCompleted'] ?? false;

                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: isCompleted ? Colors.green[50] : Colors.white,
                              child: ListTile(
                                leading: Checkbox(
                                  value: isCompleted,
                                  onChanged: (value) {
                                    _togglePoint(point.id, isCompleted);
                                  },
                                  shape: const CircleBorder(),
                                ),
                                title: Text(
                                  point['name'],
                                  style: TextStyle(
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: isCompleted ? Colors.grey : Colors.black,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  onPressed: () => _showDeleteDialog(point.id),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pointController.dispose();
    super.dispose();
  }
}