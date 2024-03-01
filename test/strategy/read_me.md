**Strategy Design Pattern**

The Strategy Design Pattern is a __behavioral design pattern__ that allows you to define a family of algorithms, encapsulate each one of them, and make them interchangeable. It enables the client to choose an algorithm from a family of algorithms at runtime without altering the code that uses them.


**Implementation in dart**

```dart
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

```

In the above code, we have a `ConsoleApp` class which serves as the context. It encapsulates two strategies: `OfflineDataSource` and `OnlineDataSource`, representing retrieving data from local storage and an online API, respectively. The `updateNetworkStatus()` method dynamically switches between these strategies based on the network status.

This implementation aligns perfectly with the Strategy Design Pattern as it:

- Defines a family of algorithms (`DataSource` interface and its implementations).
- Encapsulates each algorithm (`OfflineDataSource` and `OnlineDataSource` classes).
- Makes the algorithms interchangeable (`updateNetworkStatus()` method allows switching between strategies at runtime).


The code demonstrates how to seamlessly switch between online and offline data retrieval strategies while maintaining a consistent interface. This flexibility ensures that the application remains robust and adaptable to different network conditions.

**Test Cases:**

1. **Get name in online mode**: Verifies that the application retrieves the name from an online API when the network is online.
2. **Get name in offline mode**: Ensures that the application retrieves the name from local storage when the network is offline.

```dart
void main() {
  final mockSharedPreferences = MockSharedPreferences();
  final mockClient = MockClient();

  final consoleApp = ConsoleApp(
    isOnline: true,
    offlineDataSource: OfflineDataSource(sharedPreferences:mockSharedPreferences),
    onlineDataSource: OnlineDataSource(client: mockClient),
  );
  when(()=> mockSharedPreferences.getString('name')).thenReturn('name from offline');
  when(() => mockClient.get(Uri.https('example.com', 'api/getName')))
  .thenAnswer((_) async => Response(jsonEncode({'name':'name from online'}), 200));

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
```

