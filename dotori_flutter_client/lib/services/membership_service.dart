// lib/services/membership_service.dart

import 'dart:async';

class MembershipPlan {
  final int level;
  final String name;
  final int price;
  final String description;
  final int dailySummaryLimit;
  final int dailyImageLimit;
  final int dailyDetectorLimit;
  final int pointPerAction;

  const MembershipPlan({
    required this.level,
    required this.name,
    required this.price,
    required this.description,
    required this.dailySummaryLimit,
    required this.dailyImageLimit,
    required this.dailyDetectorLimit,
    required this.pointPerAction,
  });
}

class PointHistory {
  final DateTime timestamp;
  final String title;
  final String detail;
  final int amount;

  PointHistory({
    required this.timestamp,
    required this.title,
    required this.detail,
    required this.amount,
  });
}

class MembershipStatus {
  final int level;
  final DateTime? paidUntil;
  MembershipStatus({required this.level, this.paidUntil});
}

class PointsStatus {
  final int totalPoints;
  final int todayEarned;
  final int dailyLimit;
  final List<PointHistory> histories;

  PointsStatus({
    required this.totalPoints,
    required this.todayEarned,
    required this.dailyLimit,
    required this.histories,
  });
}

class MembershipService {
  MembershipService._internal();
  static final MembershipService instance = MembershipService._internal();

  int _currentLevel = 1;
  DateTime? _paidUntil;

  DateTime _today = _normalize(DateTime.now());
  int _summaryUsed = 0;
  int _imageUsed = 0;
  int _detectorUsed = 0;

  int _totalPoints = 0;
  final List<PointHistory> _history = [];
  static const int _dailyPointLimit = 100;

  static const List<MembershipPlan> _plans = [
    MembershipPlan(
      level: 1,
      name: '1단계 (무료)',
      price: 0,
      description: '하루 요약 10회 / 이미지 0회 / 디텍터 3회',
      dailySummaryLimit: 10,
      dailyImageLimit: 0,
      dailyDetectorLimit: 3,
      pointPerAction: 1,
    ),
    MembershipPlan(
      level: 2,
      name: '2단계',
      price: 9900,
      description: '요약 무제한 / 이미지 3회 / 디텍터 15회',
      dailySummaryLimit: -1,
      dailyImageLimit: 3,
      dailyDetectorLimit: 15,
      pointPerAction: 5,
    ),
    MembershipPlan(
      level: 3,
      name: '3단계',
      price: 14900,
      description: '요약 무제한 / 이미지 20회 / 디텍터 50회',
      dailySummaryLimit: -1,
      dailyImageLimit: 20,
      dailyDetectorLimit: 50,
      pointPerAction: 10,
    ),
  ];

  static DateTime _normalize(DateTime d) => DateTime(d.year, d.month, d.day);

  void _resetIfNeeded() {
    final today = _normalize(DateTime.now());
    if (today.isAfter(_today)) {
      _today = today;
      _summaryUsed = 0;
      _imageUsed = 0;
      _detectorUsed = 0;
    }
  }

  MembershipPlan get currentPlan =>
      _plans.firstWhere((p) => p.level == _currentLevel);

  int get currentLevel => _currentLevel;

  int get todaySummaryLeft {
    final limit = currentPlan.dailySummaryLimit;
    if (limit < 0) return -1;
    return limit - _summaryUsed;
  }

  int get todayImageLeft {
    final limit = currentPlan.dailyImageLimit;
    if (limit < 0) return -1;
    return limit - _imageUsed;
  }

  int get todayDetectorLeft {
    final limit = currentPlan.dailyDetectorLimit;
    if (limit < 0) return -1;
    return limit - _detectorUsed;
  }

  Future<List<MembershipPlan>> getPlans() async {
    return _plans;
  }

  Future<MembershipStatus> getMyMembership() async {
    return MembershipStatus(level: _currentLevel, paidUntil: _paidUntil);
  }

  Future<PointsStatus> getMyPoints() async {
    _resetIfNeeded();
    final todayStart =
        DateTime(_today.year, _today.month, _today.day);

    final todayEarned = _history
        .where((h) => h.amount > 0 && h.timestamp.isAfter(todayStart))
        .fold(0, (sum, h) => sum + h.amount);

    return PointsStatus(
      totalPoints: _totalPoints,
      todayEarned: todayEarned,
      dailyLimit: _dailyPointLimit,
      histories: _history,
    );
  }

  Future<bool> useSummary() async {
    _resetIfNeeded();
    final limit = currentPlan.dailySummaryLimit;
    if (limit >= 0 && _summaryUsed >= limit) return false;
    _summaryUsed++;
    return true;
  }

  Future<bool> useImage() async {
    _resetIfNeeded();
    final limit = currentPlan.dailyImageLimit;
    if (limit >= 0 && _imageUsed >= limit) return false;
    _imageUsed++;
    return true;
  }

  Future<bool> useDetector() async {
    _resetIfNeeded();
    final limit = currentPlan.dailyDetectorLimit;
    if (limit >= 0 && _detectorUsed >= limit) return false;
    _detectorUsed++;
    return true;
  }

  Future<void> rewardAction({
    required String title,
    required String detail,
  }) async {
    final plus = currentPlan.pointPerAction;
    await fakeEarnPoints(
      amount: plus,
      title: title,
      detail: detail,
    );
  }

  Future<void> fakeEarnPoints({
    required int amount,
    required String title,
    required String detail,
  }) async {
    _resetIfNeeded();
    final todayStart =
        DateTime(_today.year, _today.month, _today.day);
    final todayEarned = _history
        .where((h) => h.amount > 0 && h.timestamp.isAfter(todayStart))
        .fold(0, (s, h) => s + h.amount);

    final remain = _dailyPointLimit - todayEarned;
    if (remain <= 0) return;

    final add = amount > remain ? remain : amount;

    _totalPoints += add;
    _history.add(
      PointHistory(
        timestamp: DateTime.now(),
        title: title,
        detail: detail,
        amount: add,
      ),
    );
  }

  ///  백엔드 플랜 코드 적용 (BASIC/PLUS/PREMIUM)
  void applyBackendPlan(String code, {DateTime? expiresAt}) {
    switch (code) {
      case 'PLUS':
        _currentLevel = 2;
        break;
      case 'PREMIUM':
        _currentLevel = 3;
        break;
      case 'BASIC':
      default:
        _currentLevel = 1;
        break;
    }
    _paidUntil = expiresAt;
  }
}
