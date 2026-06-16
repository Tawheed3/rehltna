import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

// ─────────────────────────────────────────────────────────────
//  Full currency list — static so mosque_screen can reference it
// ─────────────────────────────────────────────────────────────
class CurrencyCalculatorScreen extends StatefulWidget {
  /// rates from open.er-api.com/v6/latest/SAR — "X per 1 SAR"
  final Map<String, double> rates;

  const CurrencyCalculatorScreen({super.key, required this.rates});

  /// (Arabic name, symbol)
  static const allCurrencies = <String, (String, String)>{
    // ── الخليج ──
    'SAR': ('ريال سعودي',        '﷼'),
    'AED': ('درهم إماراتي',      'د.إ'),
    'KWD': ('دينار كويتي',       'د.ك'),
    'BHD': ('دينار بحريني',      'د.ب'),
    'QAR': ('ريال قطري',         'ر.ق'),
    'OMR': ('ريال عماني',        'ر.ع'),
    // ── عالمية رئيسية ──
    'USD': ('دولار أمريكي',      '\$'),
    'EUR': ('يورو',               '€'),
    'GBP': ('جنيه إسترليني',     '£'),
    'CHF': ('فرانك سويسري',      'Fr'),
    'CAD': ('دولار كندي',        'C\$'),
    'AUD': ('دولار أسترالي',     'A\$'),
    'NZD': ('دولار نيوزيلندي',   'NZ\$'),
    // ── الشرق الأوسط وأفريقيا ──
    'TRY': ('ليرة تركية',        '₺'),
    'EGP': ('جنيه مصري',         'ج.م'),
    'IQD': ('دينار عراقي',       'IQD'),
    'SYP': ('ليرة سورية',        'LS'),
    'MAD': ('درهم مغربي',        'DH'),
    'TND': ('دينار تونسي',       'DT'),
    'ZAR': ('راند جنوب أفريقي',  'R'),
    // ── أوروبا ──
    'PLN': ('زلوتي بولندي',      'zł'),
    'CZK': ('كورونا تشيكية',     'Kč'),
    'NOK': ('كرونة نرويجية',     'kr'),
    'SEK': ('كرونة سويدية',      'kr'),
    'DKK': ('كرونة دنماركية',    'kr'),
    'RON': ('ليو روماني',         'lei'),
    'BGN': ('ليف بلغاري',         'лв'),
    'BAM': ('مارك بوسني',         'KM'),
    'ALL': ('ليك ألباني',         'L'),
    'RUB': ('روبل روسي',          '₽'),
    // ── القوقاز ──
    'AZN': ('مانات أذربيجاني',   '₼'),
    'GEL': ('لاري جورجي',         '₾'),
    // ── آسيا ──
    'CNY': ('يوان صيني',          '¥'),
    'JPY': ('ين ياباني',          '¥'),
    'KRW': ('وون كوري جنوبي',    '₩'),
    'INR': ('روبية هندية',        '₹'),
    'SGD': ('دولار سنغافوري',     'S\$'),
    'MYR': ('رينغيت ماليزي',      'RM'),
    'THB': ('بات تايلاندي',       '฿'),
    'IDR': ('روبية إندونيسية',    'Rp'),
    'VND': ('دونج فيتنامي',       '₫'),
    'PHP': ('بيسو فلبيني',        '₱'),
    'MXN': ('بيسو مكسيكي',       'MX\$'),
    // ── جزر ──
    'MVR': ('روفية مالديفية',     'Rf'),
    'MUR': ('روبية موريشيوسية',   'Rs'),
  };

  @override
  State<CurrencyCalculatorScreen> createState() => _CurrencyCalculatorScreenState();
}

// ─────────────────────────────────────────────────────────────
//  State
// ─────────────────────────────────────────────────────────────
class _CurrencyCalculatorScreenState extends State<CurrencyCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late final Map<String, double> _fullRates;
  String _from = 'SAR';
  String _to   = 'USD';
  final _ctrl  = TextEditingController(text: '1');
  final _focus = FocusNode();
  double _amount = 1.0;

  late final AnimationController _swapAnim;

  static const _quickAmounts = [1, 10, 100, 500, 1000];

  @override
  void initState() {
    super.initState();
    _fullRates = {...widget.rates, 'SAR': 1.0};
    _ctrl.addListener(() {
      final v = double.tryParse(_ctrl.text) ?? 0;
      if (v != _amount) setState(() => _amount = v);
    });
    _swapAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    _swapAnim.dispose();
    super.dispose();
  }

  // ── Conversion ──

  double get _result {
    final fr = _fullRates[_from] ?? 0;
    final tr = _fullRates[_to]   ?? 0;
    if (fr == 0) return 0;
    return (_amount / fr) * tr;
  }

  void _swap() {
    _swapAnim.forward(from: 0);
    setState(() {
      final t = _from; _from = _to; _to = t;
    });
  }

  void _setQuickAmount(int v) {
    _ctrl.text = v.toString();
    setState(() => _amount = v.toDouble());
  }

  // ── Formatting ──

  String _fmt(double v) {
    if (v == 0) return '0.00';
    final a = v.abs();
    if (a >= 1000000) return '${(v / 1000000).toStringAsFixed(2)} م';
    if (a >= 10000)   return v.toStringAsFixed(0);
    if (a >= 1000)    return v.toStringAsFixed(1);
    if (a >= 100)     return v.toStringAsFixed(2);
    if (a >= 1)       return v.toStringAsFixed(3);
    if (a >= 0.001)   return v.toStringAsFixed(4);
    return v.toStringAsFixed(6);
  }

  String _fwdRate() {
    if (_from == _to) return '';
    final fr = _fullRates[_from] ?? 0;
    final tr = _fullRates[_to]   ?? 0;
    if (fr == 0 || tr == 0) return '';
    return _fmt(tr / fr);
  }

  String _backRate() {
    if (_from == _to) return '';
    final fr = _fullRates[_from] ?? 0;
    final tr = _fullRates[_to]   ?? 0;
    if (fr == 0 || tr == 0) return '';
    return _fmt(fr / tr);
  }

  void _copyResult() {
    Clipboard.setData(ClipboardData(text: _fmt(_result)));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم نسخ النتيجة'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  // ── Currency picker ──

  void _openPicker(bool isFrom) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CurrencyPicker(
        selected: isFrom ? _from : _to,
        fullRates: _fullRates,
        onPick: (code) {
          setState(() { if (isFrom) _from = code; else _to = code; });
          Navigator.pop(context);
        },
      ),
    );
  }

  // ── UI helpers ──

  Widget _currencyBtn(String code, bool isFrom, bool onDark) {
    final info = CurrencyCalculatorScreen.allCurrencies[code];
    final sym  = info?.$2 ?? code;
    final name = info?.$1 ?? code;
    return GestureDetector(
      onTap: () => _openPicker(isFrom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: onDark ? Colors.white.withOpacity(0.18) : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: onDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.08),
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(sym, style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold,
              color: onDark ? Colors.white : AppColors.primary)),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(code, style: TextStyle(fontSize: 10,
                color: onDark ? Colors.white60 : Colors.grey.shade500)),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                color: onDark ? Colors.white : Colors.black87)),
          ]),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18,
              color: onDark ? Colors.white60 : Colors.grey.shade500),
        ]),
      ),
    );
  }

  Widget _quickAmountChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: _quickAmounts.map((v) {
          final selected = _amount == v.toDouble();
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => _setQuickAmount(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? Colors.white : Colors.white.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  v >= 1000 ? '${v ~/ 1000}K' : '$v',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: selected ? AppColors.primary : Colors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? const Color(0xFF0f1723) : const Color(0xFFF0F2F5);
    final fwd = _fwdRate();
    final bck = _backRate();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('حاسبة العملات',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [

            // ── FROM card ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 16, offset: const Offset(0, 8))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('من', style: TextStyle(fontSize: 13, color: Colors.white70)),
                  _currencyBtn(_from, true, true),
                ]),
                const SizedBox(height: 8),
                TextField(
                  controller: _ctrl,
                  focusNode: _focus,
                  onTap: () => _ctrl.selection = TextSelection(
                      baseOffset: 0, extentOffset: _ctrl.text.length),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.white30, fontSize: 44),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(height: 12),
                _quickAmountChips(),
              ]),
            ),

            // ── Swap button ──
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: GestureDetector(
                  onTap: _swap,
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.5).animate(
                        CurvedAnimation(parent: _swapAnim, curve: Curves.easeInOut)),
                    child: Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1c2333) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Icon(Icons.swap_vert_rounded,
                          size: 26, color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),

            // ── TO card ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1c2333) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 14, offset: const Offset(0, 4))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('إلى', style: TextStyle(fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.grey.shade500)),
                  _currencyBtn(_to, false, false),
                ]),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Copy button
                    GestureDetector(
                      onTap: _copyResult,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.copy_rounded,
                            size: 18, color: AppColors.primary),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _fmt(_result),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),

            // ── Rate info card ──
            if (fwd.isNotEmpty) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1c2333) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _rateChip('1 $_from', '$fwd $_to', isDark),
                    Container(width: 1, height: 32,
                        color: isDark ? Colors.white12 : Colors.grey.shade200),
                    _rateChip('1 $_to', '$bck $_from', isDark),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }

  Widget _rateChip(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(
            fontSize: 11, color: isDark ? Colors.white54 : Colors.grey.shade500)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Currency Picker Bottom Sheet
// ─────────────────────────────────────────────────────────────
class _CurrencyPicker extends StatefulWidget {
  final String selected;
  final Map<String, double> fullRates;
  final void Function(String) onPick;

  const _CurrencyPicker({
    required this.selected,
    required this.fullRates,
    required this.onPick,
  });

  @override
  State<_CurrencyPicker> createState() => _CurrencyPickerState();
}

class _CurrencyPickerState extends State<_CurrencyPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1c2333) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    final entries = CurrencyCalculatorScreen.allCurrencies.entries.where((e) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return e.key.toLowerCase().contains(q) || e.value.$1.contains(_query);
    }).toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.80,
      maxChildSize: 0.95,
      minChildSize: 0.50,
      builder: (_, scroll) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(children: [
          // Handle
          Container(width: 40, height: 4,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2))),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
            child: Row(children: [
              Icon(Icons.currency_exchange_rounded,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              Text('اختر العملة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            ]),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'ابحث باسم العملة أو الرمز...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                filled: true,
                fillColor: isDark ? const Color(0xFF2a3345) : const Color(0xFFF5F7FA),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),

          // List
          Expanded(
            child: ListView.separated(
              controller: scroll,
              itemCount: entries.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 74,
                color: isDark ? Colors.white10 : Colors.grey.shade100,
              ),
              itemBuilder: (_, i) {
                final code = entries[i].key;
                final info = entries[i].value;
                final isSelected = code == widget.selected;
                final rate = widget.fullRates[code] ?? 0;
                final sarVal = rate > 0 ? (1 / rate) : 0.0;
                final rateStr = rate > 0
                    ? '1 $code = ${sarVal < 0.001 ? sarVal.toStringAsFixed(6) : sarVal < 1 ? sarVal.toStringAsFixed(4) : sarVal.toStringAsFixed(2)} ﷼'
                    : '';

                return InkWell(
                  onTap: () => widget.onPick(code),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.07)
                        : Colors.transparent,
                    child: Row(children: [
                      // Symbol box
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.15)
                              : (isDark ? Colors.white.withOpacity(0.07) : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(info.$2,
                              style: TextStyle(
                                  fontSize: info.$2.length > 2 ? 11 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? Colors.white70 : Colors.black87))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(info.$1,
                            style: TextStyle(fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.primary : textColor)),
                        if (rateStr.isNotEmpty)
                          Text(rateStr,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                      ])),
                      Text(code,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      if (isSelected)
                        Icon(Icons.check_circle_rounded,
                            color: AppColors.primary, size: 20),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
