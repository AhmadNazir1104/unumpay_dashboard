class TransactionSummary {
  final int total;
  final int success;
  final int failed;
  final int pending;
  final double successRate;
  final double failureRate;

  TransactionSummary({
    required this.total,
    required this.success,
    required this.failed,
    required this.pending,
    required this.successRate,
    required this.failureRate,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      total:       json['total']        ?? 0,
      success:     json['success']      ?? 0,
      failed:      json['failed']       ?? 0,
      pending:     json['pending']      ?? 0,
      successRate: (json['success_rate'] ?? 0).toDouble(),
      failureRate: (json['failure_rate'] ?? 0).toDouble(),
    );
  }
}

class PaymentSourceStat {
  final String source;
  final int failed;
  final int success;
  final int pending;
  final int total;
  final double failRate;

  PaymentSourceStat({
    required this.source,
    required this.failed,
    required this.success,
    required this.pending,
    required this.total,
    required this.failRate,
  });

  factory PaymentSourceStat.fromJson(Map<String, dynamic> json) {
    return PaymentSourceStat(
      source:  json['payment_source'] ?? '',
      failed:  (json['failed']  ?? 0).toInt(),
      success: (json['success'] ?? 0).toInt(),
      pending: (json['pending'] ?? 0).toInt(),
      total:   (json['total']   ?? 0).toInt(),
      failRate: (json['fail_rate'] ?? 0).toDouble(),
    );
  }
}

class CityStat {
  final String city;
  final int failures;

  CityStat({required this.city, required this.failures});

  factory CityStat.fromJson(Map<String, dynamic> json) {
    return CityStat(
      city:     json['city']     ?? '',
      failures: json['failures'] ?? 0,
    );
  }
}

class CountryStat {
  final String countryCode;
  final int failures;

  CountryStat({required this.countryCode, required this.failures});

  factory CountryStat.fromJson(Map<String, dynamic> json) {
    return CountryStat(
      countryCode: json['country_code'] ?? '',
      failures:    json['failures']     ?? 0,
    );
  }
}

class HourlyStat {
  final int hour;
  final int success;
  final int failed;
  final int pending;

  HourlyStat({
    required this.hour,
    required this.success,
    required this.failed,
    required this.pending,
  });

  factory HourlyStat.fromJson(Map<String, dynamic> json) {
    return HourlyStat(
      hour:    (json['hour']    ?? 0).toInt(),
      success: (json['success'] ?? 0).toInt(),
      failed:  (json['failed']  ?? 0).toInt(),
      pending: (json['pending'] ?? 0).toInt(),
    );
  }
}

class MonthlyStat {
  final String month;
  final int success;
  final int failed;
  final int pending;

  MonthlyStat({
    required this.month,
    required this.success,
    required this.failed,
    required this.pending,
  });

  factory MonthlyStat.fromJson(Map<String, dynamic> json) {
    return MonthlyStat(
      month:   json['month']   ?? '',
      success: (json['success'] ?? 0).toInt(),
      failed:  (json['failed']  ?? 0).toInt(),
      pending: (json['pending'] ?? 0).toInt(),
    );
  }
}

class TransactionReport {
  final TransactionSummary summary;
  final List<PaymentSourceStat> byPaymentSource;
  final List<CityStat> byCity;
  final List<CountryStat> byCountry;
  final List<HourlyStat> byHour;
  final List<MonthlyStat> byMonth;

  TransactionReport({
    required this.summary,
    required this.byPaymentSource,
    required this.byCity,
    required this.byCountry,
    required this.byHour,
    required this.byMonth,
  });

  factory TransactionReport.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return TransactionReport(
      summary: TransactionSummary.fromJson(data['summary']),
      byPaymentSource: (data['by_payment_source'] as List)
          .map((e) => PaymentSourceStat.fromJson(e))
          .toList(),
      byCity: (data['by_city'] as List)
          .map((e) => CityStat.fromJson(e))
          .toList(),
      byCountry: (data['by_country'] as List)
          .map((e) => CountryStat.fromJson(e))
          .toList(),
      byHour: (data['by_hour'] as List)
          .map((e) => HourlyStat.fromJson(e))
          .toList(),
      byMonth: (data['by_month'] as List)
          .map((e) => MonthlyStat.fromJson(e))
          .toList(),
    );
  }
}
