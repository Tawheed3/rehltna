import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
class _CurrencyCalculatorScreenState extends State<CurrencyCalculatorScreen> {
  late final Map<String, double> _fullRates;
  String _from = 'SAR';
  String _to   = 'USD';
  final _ctrl  = TextEditingController(text: '1');
  double _amount = 1.0;

  @override
  void initState() {
    super.initState();
    _fullRates = {...widget.rates, 'SAR': 1.0};
    _ctrl.addListener(() {
      final v = double.tryParse(_ctrl.text) ?? 0;
      if (v != _amount) setState(() => _amount = v);
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  // ── Conversion ──

  double get _result {
    final fr = _fullRates[_from] ?? 0;
    final tr = _fullRates[_to]   ?? 0;
    if (fr == 0) return 0;
    return (_amount / fr) * tr;
  }

  void _swap() => setState(() {
    final t = _from; _from = _to; _to = t;
  });

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

  String _rateHint() {
    if (_from == _to) return '';
    final fr = _fullRates[_from] ?? 0;
    final tr = _fullRates[_to]   ?? 0;
    if (fr == 0 || tr == 0) return '';
    final fwdRate  = tr / fr;          // 1 FROM = ? TO
    final backRate = fr / tr;          // 1 TO   = ? FROM
    return '1 $_from = ${_fmt(fwdRate)} $_to   •   1 $_to = ${_fmt(backRate)} $_from';
  }

  // ── Currency picker ──

  void _openPicker(bool isFrom) {
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: onDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: onDark ? Colors.white.withOpacity(0.25) : Colors.black.withOpacity(0.1),
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(sym, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
              color: onDark ? Colors.white : const Color(0xFF2d5016))),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(code, style: TextStyle(fontSize: 10,
                color: onDark ? Colors.white60 : Colors.grey.shade500)),
            Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,
                color: onDark ? Colors.white : Colors.black87)),
          ]),
          const SizedBox(width: 6),
          Icon(Icons.keyboard_arrow_down_rounded, size: 18,
              color: onDark ? Colors.white60 : Colors.grey.shade600),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? const Color(0xFF0f1723) : const Color(0xFFF0F2F5);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2d5016),
        foregroundColor: Colors.white,
        title: const Text('💱 حاسبة العملات',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [

          // ── FROM card (green) ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2d5016), Color(0xFF4a8a1a)],
                begin: Alignment.topRight, end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: const Color(0xFF2d5016).withOpacity(0.3),
                  blurRadius: 14, offset: const Offset(0, 6))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('من', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                _currencyBtn(_from, true, true),
              ]),
              const SizedBox(height: 12),
              TextField(
                controller: _ctrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.white30, fontSize: 40),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                textAlign: TextAlign.end,
              ),
            ]),
          ),

          // ── Swap button ──
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: GestureDetector(
                onTap: _swap,
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1c2333) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12),
                        blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: const Center(
                    child: Text('⇅', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ),

          // ── TO card (white/dark) ──
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1c2333) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07),
                  blurRadius: 14, offset: const Offset(0, 4))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('إلى', style: TextStyle(fontSize: 13,
                    color: isDark ? Colors.white60 : Colors.grey.shade500)),
                _currencyBtn(_to, false, false),
              ]),
              const SizedBox(height: 12),
              Text(
                _fmt(_result),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ]),
          ),

          // ── Rate hint ──
          if (_rateHint().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                _rateHint(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),

          const SizedBox(height: 20),
        ]),
      ),
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
              const Text('💱', style: TextStyle(fontSize: 20)),
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
            child: ListView.builder(
              controller: scroll,
              itemCount: entries.length,
              itemBuilder: (_, i) {
                final code = entries[i].key;
                final info = entries[i].value;
                final isSelected = code == widget.selected;
                // compute rate hint: 1 code = X SAR
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
                        ? const Color(0xFF2d5016).withOpacity(0.08)
                        : Colors.transparent,
                    child: Row(children: [
                      // Symbol box
                      Container(
                        width: 46, height: 46,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2d5016).withOpacity(0.15)
                              : (isDark ? Colors.white.withOpacity(0.07) : Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(info.$2,
                              style: TextStyle(
                                  fontSize: info.$2.length > 2 ? 11 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? const Color(0xFF2d5016)
                                      : (isDark ? Colors.white70 : Colors.black87))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(info.$1,
                            style: TextStyle(fontSize: 14,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? const Color(0xFF2d5016) : textColor)),
                        if (rateStr.isNotEmpty)
                          Text(rateStr,
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                      ])),
                      Text(code,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade400,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded,
                            color: Color(0xFF4a8a1a), size: 20),
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
