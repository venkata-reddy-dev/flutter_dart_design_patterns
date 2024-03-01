import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DataSource {
  Future<String> getName();
}

class OfflineDataSource extends DataSource {
  final SharedPreferences sharedPreferences;

  OfflineDataSource({required this.sharedPreferences});

  @override
  Future<String> getName() async {
    return sharedPreferences.getString('name') ?? '';
  }
}

class OnlineDataSource extends DataSource {
  final Client client;

  OnlineDataSource({required this.client});

  @override
  Future<String> getName() async {
    final url = Uri.https('example.com', 'api/getName');
    final response = await client.get(url);

    /// json body {"name":"some name"}
    final bodyMap = jsonDecode(response.body) as Map<String, dynamic>;
    return bodyMap['name']?.toString() ?? '';
  }
}

class ConsoleApp {
  bool isOnline;
  final DataSource offlineDataSource;
  final DataSource onlineDataSource;
  late DataSource dataSource;

  ConsoleApp({
    required this.isOnline,
    required this.offlineDataSource,
    required this.onlineDataSource,
  }) {
    updateNetworkStatus(isOnline: isOnline);
  }

  void updateNetworkStatus({required bool isOnline}) {
    this.isOnline = isOnline;
    dataSource = isOnline ? onlineDataSource : offlineDataSource;
  }

  Future<String> getName() {
    return dataSource.getName();
  }
}

/// Test cases

void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final mockClient = MockClient();

  final consoleApp = ConsoleApp(
    isOnline: true,
    offlineDataSource: OfflineDataSource(sharedPreferences:mockSharedPreferences),
    onlineDataSource: OnlineDataSource(client: mockClient),
  );
  when(()=> mockSharedPreferences.getString('name')).thenReturn('name from offline');
  when(() => mockClient.get(Uri.https('example.com', 'api/getName'))).thenAnswer((_) async => Response(jsonEncode({'name':'name from online'}), 200));

  test('get name in online mode', () {
    consoleApp.updateNetworkStatus(isOnline: true); /// Strategy as Online ✅
    expectLater(consoleApp.getName(), completion(equals('name from online')));
  });
  test('get name in offline mode', () {
    consoleApp.updateNetworkStatus(isOnline: false); /// Strategy as Offline ❎
    expectLater(consoleApp.getName(), completion(equals('name from offline')));
  });
}
class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockClient extends Mock implements Client {}

