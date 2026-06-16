// lib/screens/sales_history_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database_helper.dart';
import '../model/product_model.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late Future<List<Sale>> _salesFuture;

  // للتصفية حسب التاريخ
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedFilter = 'الكل'; // القيمة الافتراضية

  // خيارات التصفية
  final List<String> _filterOptions = [
    'الكل',
    'آخر 10 معاملات',
    'آخر أسبوع',
    'آخر شهر',
    'آخر 3 أشهر',
    'تحديد مدة',
  ];

  // للبحث عن منتج
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // إحصائيات سريعة
  double _todayTotal = 0;
  int _todayCount = 0;
  double _monthTotal = 0;
  int _monthCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSales();
    _loadStatistics();
  }

  // تحميل المبيعات حسب الفلتر المحدد
  void _loadSales() {
    setState(() {
      switch (_selectedFilter) {
        case 'آخر 10 معاملات':
          _salesFuture = _dbHelper.getLastTransactions(10);
          break;
        case 'آخر أسبوع':
          DateTime now = DateTime.now();
          DateTime weekAgo = now.subtract(const Duration(days: 7));
          _salesFuture = _dbHelper.getSalesByDateRange(weekAgo, now);
          break;
        case 'آخر شهر':
          DateTime now = DateTime.now();
          DateTime monthAgo = DateTime(now.year, now.month - 1, now.day);
          _salesFuture = _dbHelper.getSalesByDateRange(monthAgo, now);
          break;
        case 'آخر 3 أشهر':
          DateTime now = DateTime.now();
          DateTime threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
          _salesFuture = _dbHelper.getSalesByDateRange(threeMonthsAgo, now);
          break;
        case 'تحديد مدة':
          if (_startDate != null && _endDate != null) {
            _salesFuture = _dbHelper.getSalesByDateRange(_startDate!, _endDate!);
          } else {
            _salesFuture = _dbHelper.getAllSales();
          }
          break;
        default: // الكل
          _salesFuture = _dbHelper.getAllSales();
      }
    });
  }

  // تحميل الإحصائيات
  Future<void> _loadStatistics() async {
    // مبيعات اليوم
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    List<Sale> todaySales = await _dbHelper.getSalesByDateRange(todayStart, todayEnd);
    _todayTotal = todaySales.fold(0, (sum, sale) => sum + sale.totalAmount);
    _todayCount = todaySales.length;

    // مبيعات الشهر
    DateTime monthStart = DateTime(now.year, now.month, 1);
    DateTime monthEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    List<Sale> monthSales = await _dbHelper.getSalesByDateRange(monthStart, monthEnd);
    _monthTotal = monthSales.fold(0, (sum, sale) => sum + sale.totalAmount);
    _monthCount = monthSales.length;

    setState(() {});
  }

  // اختيار نطاق تاريخ مخصص
  Future<void> _selectCustomDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'اختر نطاق التاريخ',
      confirmText: 'موافق',
      cancelText: 'إلغاء',
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedFilter = 'تحديد مدة';
      });
      _loadSales();
    }
  }

  // تغيير الفلتر
  void _onFilterChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        _selectedFilter = newValue;
        if (newValue == 'تحديد مدة') {
          _selectCustomDateRange();
        } else {
          _startDate = null;
          _endDate = null;
          _loadSales();
        }
      });
    }
  }

  // إزالة تصفية التاريخ
  void _clearDateFilter() {
    setState(() {
      _selectedFilter = 'الكل';
      _startDate = null;
      _endDate = null;
      _searchController.clear();
      _searchQuery = '';
    });
    _loadSales();
  }

  // تنسيق التاريخ
  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd - hh:mm a').format(date);
  }

  // تنسيق العملة
  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} ج.م';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل المبيعات'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.08),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
              vertical: screenHeight * 0.01,
            ),
            child: Row(
              children: [
                // قائمة منسدلة للتصفية
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedFilter,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                      elevation: 16,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.035,
                      ),
                      underline: Container(),
                      onChanged: _onFilterChanged,
                      items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                if (_selectedFilter != 'الكل') ...[
                  SizedBox(width: screenWidth * 0.02),
                  // زر إلغاء التصفية
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: _clearDateFilter,
                      tooltip: 'إزالة التصفية',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // عرض النطاق المحدد (إذا كان تحديد مدة)
            if (_startDate != null && _endDate != null && _selectedFilter == 'تحديد مدة')
              Container(
                margin: EdgeInsets.all(screenWidth * 0.03),
                padding: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'من: ${DateFormat('yyyy/MM/dd').format(_startDate!)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.03,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Flexible(
                      child: Text(
                        'إلى: ${DateFormat('yyyy/MM/dd').format(_endDate!)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.03,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            // شريط البحث
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'بحث عن منتج...',
                  prefixIcon: const Icon(Icons.search, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.015,
                  ),
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            // قائمة المبيعات
            Expanded(
              child: FutureBuilder<List<Sale>>(
                future: _salesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 60, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(
                              'حدث خطأ: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadSales,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final sales = snapshot.data ?? [];

                  // تصفية حسب البحث
                  List<Sale> filteredSales = sales.where((sale) {
                    if (_searchQuery.isEmpty) return true;
                    return sale.items.any((item) =>
                        item.productName.toLowerCase().contains(_searchQuery)
                    );
                  }).toList();

                  // حساب إحصائيات البحث
                  int totalSoldQuantity = 0;
                  double totalSoldAmount = 0;

                  if (_searchQuery.isNotEmpty) {
                    for (var sale in filteredSales) {
                      for (var item in sale.items) {
                        if (item.productName.toLowerCase().contains(_searchQuery)) {
                          totalSoldQuantity += item.quantity;
                          totalSoldAmount += item.total;
                        }
                      }
                    }
                  }

                  if (filteredSales.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: screenWidth * 0.15,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'لا توجد نتائج للبحث'
                                  : 'لا توجد مبيعات',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_searchQuery.isNotEmpty) ...[
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'لم يتم العثور على "$_searchQuery"',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.grey.shade500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  // عرض نتائج البحث
                  return Column(
                    children: [
                      if (_searchQuery.isNotEmpty)
                        Container(
                          margin: EdgeInsets.all(screenWidth * 0.03),
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'المنتج: $_searchQuery',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      'عدد مرات البيع: ${filteredSales.length}',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'الكمية: $totalSoldQuantity',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      _formatCurrency(totalSoldAmount),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          itemCount: filteredSales.length,
                          itemBuilder: (context, index) {
                            final sale = filteredSales[index];
                            return Card(
                              margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () => _showSaleDetails(sale, _searchQuery, screenWidth, screenHeight),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: EdgeInsets.all(screenWidth * 0.03),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // رقم الفاتورة والتاريخ
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(screenWidth * 0.02),
                                            decoration: BoxDecoration(
                                              color: Colors.green.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.receipt,
                                              color: Colors.green,
                                              size: screenWidth * 0.05,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.02),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  sale.saleId,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: screenWidth * 0.035,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  _formatDate(sale.saleDate),
                                                  style: TextStyle(
                                                    fontSize: screenWidth * 0.025,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: screenHeight * 0.01),

                                      // المنتجات
                                      ...sale.items.take(2).map((item) {
                                        bool isHighlighted = _searchQuery.isNotEmpty &&
                                            item.productName.toLowerCase().contains(_searchQuery);

                                        return Container(
                                          margin: EdgeInsets.only(bottom: screenHeight * 0.005),
                                          padding: EdgeInsets.all(screenWidth * 0.01),
                                          decoration: BoxDecoration(
                                            color: isHighlighted
                                                ? Colors.blue.shade50
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: screenWidth * 0.03,
                                                backgroundColor: isHighlighted
                                                    ? Colors.blue
                                                    : Colors.green.shade100,
                                                child: Text(
                                                  '${item.quantity}',
                                                  style: TextStyle(
                                                    fontSize: screenWidth * 0.025,
                                                    color: isHighlighted
                                                        ? Colors.white
                                                        : Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: screenWidth * 0.02),
                                              Expanded(
                                                child: Text(
                                                  item.productName,
                                                  style: TextStyle(
                                                    fontWeight: isHighlighted
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                    color: isHighlighted
                                                        ? Colors.blue
                                                        : Colors.black,
                                                    fontSize: screenWidth * 0.03,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                '${item.total.toStringAsFixed(2)} ج.م',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isHighlighted
                                                      ? Colors.blue
                                                      : Colors.green,
                                                  fontSize: screenWidth * 0.03,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),

                                      if (sale.items.length > 2)
                                        Padding(
                                          padding: EdgeInsets.only(top: screenHeight * 0.005),
                                          child: Text(
                                            '+${sale.items.length - 2} منتجات أخرى',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: screenWidth * 0.025,
                                            ),
                                          ),
                                        ),

                                      Divider(height: screenHeight * 0.02),

                                      // الإجمالي
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${sale.items.length} منتج',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: screenWidth * 0.03,
                                            ),
                                          ),
                                          Text(
                                            _formatCurrency(sale.totalAmount),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.04,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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

  // عرض تفاصيل الفاتورة
  void _showSaleDetails(Sale sale, String searchQuery, double screenWidth, double screenHeight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(screenWidth * 0.05),
        height: screenHeight * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // عنوان الفاتورة
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.receipt, color: Colors.green, size: screenWidth * 0.06),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sale.saleId,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _formatDate(sale.saleDate),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.02),

            // قائمة المنتجات
            const Text(
              'المنتجات:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            Expanded(
              child: ListView.separated(
                itemCount: sale.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = sale.items[index];
                  bool isHighlighted = searchQuery.isNotEmpty &&
                      item.productName.toLowerCase().contains(searchQuery);

                  return Container(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: isHighlighted ? Colors.blue.shade50 : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: screenWidth * 0.04,
                          backgroundColor: isHighlighted
                              ? Colors.blue
                              : Colors.green.shade100,
                          child: Text(
                            '${item.quantity}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: isHighlighted ? Colors.white : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: TextStyle(
                                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                                  color: isHighlighted ? Colors.blue : Colors.black,
                                  fontSize: screenWidth * 0.035,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${item.price} ج.م',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${item.total.toStringAsFixed(2)} ج.م',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isHighlighted ? Colors.blue : Colors.green,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Divider(height: screenHeight * 0.03),

            // الإجمالي
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الإجمالي:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _formatCurrency(sale.totalAmount),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}