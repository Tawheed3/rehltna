import 'package:auth_app_fixed/note/viewNote.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNote extends StatefulWidget {
  final String docid;
  final String categoryName; // نضيف هذا المتغير

  const AddNote({
    super.key,
    required this.docid,
    required this.categoryName, // نجعله مطلوب
  });

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mission = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // حالة التحميل
  bool _isLoading = false;

  Future<void> _addNote() async {
    CollectionReference _missionNote =
    FirebaseFirestore.instance.collection("categories").doc(widget.docid).collection("Note");

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _missionNote.add({
        "name": _mission.text.trim(),
        "description": _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        "isCompleted": false,
        "createdAt": FieldValue.serverTimestamp(),
      });

      // رسالة نجاح
      _showSnackBar('تم إضافة المهمة بنجاح', isError: false);

      // نرجع لصفحة المهام مع اسم الفولدر
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => NoteView(
            categoryid: widget.docid,
            categoryName: widget.categoryName, // نمرر اسم الفولدر
          ),
        ),
      );

      // تفريغ الحقول بعد الإضافة
      _mission.clear();
      _descriptionController.clear();

      // تحديث حالة النموذج
      _formKey.currentState!.reset();

    } catch (error) {
      // رسالة خطأ
      _showSnackBar('❌ فشل إضافة المهمة: $error', isError: true);
      print('Firestore Error: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ... باقي الكود بدون تغيير ...
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _mission.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('add new mission'),
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // صورة أو أيقونة
                  Container(
                    margin: const EdgeInsets.only(bottom: 30, top: 20),
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.category,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),

                  // العنوان
                  const Text(
                    'add new mission',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'add new mission to your category',
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  // حقل اسم التصنيف
                  TextFormField(
                    controller: _mission,
                    decoration: InputDecoration(
                      labelText: 'mission name',
                      hintText: 'enter the name',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // زر الإضافة
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _addNote,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'add the mission',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // زر عرض التصنيفات المضافة
                  TextButton.icon(
                    onPressed: () {
                      // الانتقال لصفحة عرض التصنيفات
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoriesPage()));
                    },
                    icon: const Icon(Icons.list, color: Colors.grey),
                    label: const Text(
                      'عرض جميع التصنيفات',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}