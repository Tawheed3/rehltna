class PaymentMethodModel {
  final String id; // بقى String مش int
  final String titleAr;
  final String titleEn;
  final String code;
  final String banner; // بقى banner واحدة مش bannerAr/bannerEn
  final Map<String, dynamic> config;
  final String mode;

  PaymentMethodModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.code,
    required this.banner,
    required this.config,
    required this.mode,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '0',
      titleAr: json['title_ar'] ?? '',
      titleEn: json['title_en'] ?? '',
      code: json['code'] ?? '',
      banner: json['banner'] ?? '',
      config: json['config'] ?? {},
      mode: json['mode'] ?? 'live',
    );
  }

  // جلب العنوان حسب اللغة
  String getTitle(String langCode) {
    return langCode == 'ar' ? titleAr : titleEn;
  }

  // هل هي طريقة دفع نشطة؟ (كلها نشطة في الـ API الجديد)
  bool get isActive => true;

  // هل هي تحويل بنكي؟
  bool get isBankTransfer => code.startsWith('bank_transfer');

  // هل هي تمارا؟
  bool get isTamara => code == 'tamara';

  // جلب الـ config حسب نوع الدفع
  BankTransferConfig? get bankTransferConfig {
    if (!isBankTransfer) return null;
    return BankTransferConfig.fromJson(config);
  }

  // جلب تمارا config
  TamaraConfig? get tamaraConfig {
    if (!isTamara) return null;
    return TamaraConfig.fromJson(config);
  }
}

// Model لمعلومات التحويل البنكي
class BankTransferConfig {
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String iban;
  final String bankAddress;
  final String instructions;

  BankTransferConfig({
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.iban,
    required this.bankAddress,
    required this.instructions,
  });

  factory BankTransferConfig.fromJson(Map<String, dynamic> json) {
    return BankTransferConfig(
      bankName: json['bank_name'] ?? '',
      accountName: json['account_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      iban: json['iban'] ?? '',
      bankAddress: json['bank_address'] ?? '',
      instructions: json['instructions'] ?? '',
    );
  }
}

// Model لتهيئة تمارا
class TamaraConfig {
  final String publicKey;

  TamaraConfig({
    required this.publicKey,
  });

  factory TamaraConfig.fromJson(Map<String, dynamic> json) {
    return TamaraConfig(
      publicKey: json['public_key'] ?? '',
    );
  }
}