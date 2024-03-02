import 'package:flutter_test/flutter_test.dart';

abstract class Notifier {
  final listenerList = <Listener>[];

  void addListener(Listener listener) {
    listenerList.add(listener);
  }

  void removeListener(Listener listener) {
    listenerList.remove(listener);
  }

  void notifyListener(dynamic data) {
    for (final sub in listenerList) {
      sub.update(this, data);
    }
  }
}

abstract class Listener {
  void update(Notifier notifier, dynamic data);
}

class CountNotifier extends Notifier {
  final int initialCount;

  int get count => _count;
  late int _count;

  CountNotifier({required this.initialCount}) {
    _count = initialCount;
  }

  void incrementCount() {
    _count++;
    notifyListener(count);
  }

  void decrementCount() {
    _count--;
    notifyListener(count);
  }
}

class CountListener extends Listener {
  final CountNotifier notifier;

  int get count => _count;
  late int _count;

  CountListener({required this.notifier}) {
    _count = notifier.count;
    notifier.addListener(this);
  }
  @override
  void update(Notifier n, data) {
    if (n is CountNotifier && data is int) {
      _count = data;
    }
  }

  void dispose() {
    notifier.removeListener(this);
  }
}

/// Test cases

void main() {
  final countNotifier = CountNotifier(initialCount: 0);
  final countListener1 = CountListener(notifier: countNotifier);
  final countListener2 = CountListener(notifier: countNotifier);

  test('Count equals to 0', () {
    expect(countListener1.count, equals(0));
    expect(countListener2.count, equals(0));
  });

  test('Count increment by 1 then equals to 1', () async {
    countNotifier.incrementCount();
    expect(countListener1.count, equals(1));
    expect(countListener2.count, equals(1));
  });

  test('Count decrement by 1 then equals to 0', () async {
    countNotifier.decrementCount();
    expect(countListener1.count, equals(0));
    expect(countListener2.count, equals(0));
  });

  tearDownAll(() {
    countListener1.dispose();
    countListener2.dispose();
  });
}
