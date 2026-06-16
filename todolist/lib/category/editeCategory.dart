import 'package:auth_app_fixed/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Editcategory extends StatefulWidget {

  final String oldName ;
  final String docid ;
  const Editcategory({super.key, required this.docid, required this.oldName});

  @override
  State<Editcategory> createState() => _EditcategoryState();
}

class _EditcategoryState extends State<Editcategory> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  // حالة التحميل
  bool _isLoading = false;

  // مرجع collection في Firestore
  final CollectionReference _categories =
  FirebaseFirestore.instance.collection("categories");

  Future<void> _addCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // إضافة التصنيف مع timestamp
      await _categories.doc(widget.docid).update({
        "name" : _nameController.text,
        "updatedAt": FieldValue.serverTimestamp(),
      }) ;


      // رسالة نجاح
      _showSnackBar('✅ تم تعديل التصنيف بنجاح', isError: false);
      Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route)=> false);
      // تفريغ الحقل بعد الإضافة
      _nameController.clear();

      // تحديث حالة النموذج
      _formKey.currentState!.reset();

    } catch (error) {
      // رسالة خطأ
      _showSnackBar('❌ فشل إضافة التصنيف: $error', isError: true);
      print('Firestore Error: $error');
    } finally {
      setState(() => _isLoading = false);
    }
  }
  @override
  void initState(){
    super.initState();
    _nameController.text = widget.oldName ;
  }


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
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('edit Category'),
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





                  const SizedBox(height: 30),

                  // حقل اسم التصنيف
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'اسم التصنيف',
                      hintText: 'أدخل اسم التصنيف',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم التصنيف';
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
                      onPressed: _isLoading ? null : _addCategory,
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
                          Icon(Icons.edit, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            ' edit the category',
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