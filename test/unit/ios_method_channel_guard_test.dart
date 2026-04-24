import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('iOS method channel guard', () {
    test('deleteByClientRecordId is registered and implemented', () {
      final pluginSource = File('ios/Classes/SwiftHealthPlugin.swift').readAsStringSync();
      final operationsSource = File('ios/Classes/HealthDataOperations.swift').readAsStringSync();

      expect(pluginSource, contains('case "deleteByClientRecordId"'));
      expect(pluginSource, contains('healthDataOperations.deleteByClientRecordId(call: call, result: result)'));
      expect(
        operationsSource,
        contains('func deleteByClientRecordId(call: FlutterMethodCall, result: @escaping FlutterResult) throws'),
      );
      expect(operationsSource, contains('metadata.%K == %@'));
      expect(operationsSource, contains('clientRecordId'));
    });

    test('writer falls back to quantity types for iOS 11 quantity writes', () {
      final writerSource = File('ios/Classes/HealthDataWriter.swift').readAsStringSync();
      final pluginSource = File('ios/Classes/SwiftHealthPlugin.swift').readAsStringSync();

      expect(writerSource, contains('let dataQuantityTypesDict: [String: HKQuantityType]'));
      expect(writerSource, contains('dataTypesDict[type] ?? dataQuantityTypesDict[type]'));
      expect(pluginSource, contains('dataQuantityTypesDict: dataQuantityTypesDict'));
    });

    test('delete falls back to quantity types for update flows', () {
      final operationsSource = File('ios/Classes/HealthDataOperations.swift').readAsStringSync();
      final pluginSource = File('ios/Classes/SwiftHealthPlugin.swift').readAsStringSync();

      expect(operationsSource, contains('let dataQuantityTypesDict: [String: HKQuantityType]'));
      expect(operationsSource, contains('dataTypesDict[dataTypeKey] ?? dataQuantityTypesDict[dataTypeKey]'));
      expect(pluginSource, contains('dataQuantityTypesDict: dataQuantityTypesDict'));
    });
  });
}
