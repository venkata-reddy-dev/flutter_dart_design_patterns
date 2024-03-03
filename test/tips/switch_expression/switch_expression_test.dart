import 'package:flutter_test/flutter_test.dart';

double calculateCommissionOld({
  required double amount,
  double? fixedCommissionAmount,
  double? commissionPercentage,
}) {
  if (fixedCommissionAmount != null && commissionPercentage != null) {
    if (fixedCommissionAmount == 0 && commissionPercentage == 0) {
      return 0;
    } else {
      throw Exception(
          'Both commission parameter are passed. Please pass any one of them');
    }
  } else if (fixedCommissionAmount != null) {
    return fixedCommissionAmount;
  } else if (commissionPercentage != null) {
    return (amount * commissionPercentage) / 100;
  } else if (fixedCommissionAmount == null || commissionPercentage == null) {
    return 0;
  }

  return 0;
}

double calculateCommissionNew({
  required double amount,
  double? fixedCommissionAmount,
  double? commissionPercentage,
}) {
  return switch ((fixedCommissionAmount, commissionPercentage)) {
    (null, null) => 0,
    (double amount, null) => amount,
    (null, double percentage) => (amount * percentage) / 100,
    (0, 0) => 0,
    (double _, double _) => throw Exception(
        'Both commission parameter are passed. Please pass any one of them'),
  };
}

void main() {
  test('c-amount is null and c-percentage is null then commission is 0', () {
    final commission = calculateCommissionNew(amount: 300);
    expect(commission, 0);
  });

  test(
      'c-fixed-amount is 12.5 and c-percentage is null then commission is 12.5',
      () {
    final commission = calculateCommissionNew(amount: 300, fixedCommissionAmount: 12.5);
    expect(commission, 12.5);
  });

  test('c-fixed-amount is null and c-percentage is 15% then commission is 15',
      () {
    final commission = calculateCommissionNew(amount: 300, commissionPercentage: 15);
    expect(commission, 45);
  });

  test('c-fixed-amount is Zero and c-percentage is Zero% then commission is 0',
      () {
    final commission = calculateCommissionNew(amount: 300, fixedCommissionAmount: 0, commissionPercentage: 0);
    expect(commission, 0);
  });

  test('c-fixed-amount is 12.5 and c-percentage is 15% then throws exception',
      () {
    expect(
      () {
        calculateCommissionNew(
          amount: 300,
          fixedCommissionAmount: 12.5,
          commissionPercentage: 15,
        );
      },
      throwsException,
    );
  });
}
