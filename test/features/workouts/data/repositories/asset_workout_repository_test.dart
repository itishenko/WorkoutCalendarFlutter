import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_calendar_flutter/core/constants/app_assets.dart';
import 'package:workout_calendar_flutter/features/workouts/data/repositories/asset_workout_repository.dart';

void main() {
  group('AssetWorkoutRepository', () {
    test('parses workouts, metadata, diagram data and caches results', () async {
      final repository = AssetWorkoutRepository(
        assetBundle: _InMemoryAssetBundle(
          <String, String>{
            AppAssets.workouts: '''
            {
              "description": "GET /list_workouts",
              "data": [
                {
                  "workoutKey": "w1",
                  "workoutActivityType": "Walking/Running",
                  "workoutStartDate": "2025-11-25 09:30:00"
                }
              ]
            }
            ''',
            AppAssets.metadata: '''
            {
              "description": "GET /metadata",
              "workouts": {
                "w1": {
                  "workoutKey": "w1",
                  "workoutActivityType": "Walking/Running",
                  "workoutStartDate": "2025-11-25 09:30:00",
                  "distance": "5230.50",
                  "duration": "2700.00",
                  "maxLayer": 2,
                  "maxSubLayer": 4,
                  "avg_humidity": "65.00",
                  "avg_temp": "12.50",
                  "comment": "Morning run",
                  "photoBefore": null,
                  "photoAfter": null,
                  "heartRateGraph": null,
                  "activityGraph": null,
                  "map": null
                }
              }
            }
            ''',
            AppAssets.diagramData: '''
            {
              "description": "GET /get_diagram_data",
              "workouts": {
                "w1": {
                  "description": "Walking/Running - November 25",
                  "states": [],
                  "data": [
                    {
                      "time_numeric": 0,
                      "heartRate": 72,
                      "speed_kmh": 0.0,
                      "distanceMeters": 0,
                      "steps": 0,
                      "elevation": 45.2,
                      "latitude": 55.7558,
                      "longitude": 37.6173,
                      "temperatureCelsius": 12.5,
                      "currentLayer": 0,
                      "currentSubLayer": 0,
                      "currentTimestamp": "2025-11-25 09:30:00"
                    }
                  ]
                }
              }
            }
            ''',
          },
        ),
      );

      final workouts = await repository.fetchWorkouts();
      final metadata = await repository.fetchAllMetadata();
      final diagramData = await repository.fetchDiagramData('w1');
      final cachedWorkouts = await repository.fetchWorkouts();

      expect(workouts, hasLength(1));
      expect(workouts.first.workoutKey, 'w1');
      expect(workouts.first.startedAt, DateTime(2025, 11, 25, 9, 30));

      expect(metadata['w1']?.distanceMeters, 5230.5);
      expect(metadata['w1']?.avgTemperature, 12.5);

      expect(diagramData?.data, hasLength(1));
      expect(diagramData?.data.first.heartRate, 72);

      expect(identical(workouts, cachedWorkouts), isTrue);
    });
  });
}

class _InMemoryAssetBundle extends CachingAssetBundle {
  _InMemoryAssetBundle(this._values);

  final Map<String, String> _values;

  @override
  Future<ByteData> load(String key) async {
    final value = _values[key];
    if (value == null) {
      throw StateError('Missing asset: $key');
    }

    final bytes = Uint8List.fromList(utf8.encode(value));
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final value = _values[key];
    if (value == null) {
      throw StateError('Missing asset: $key');
    }

    return value;
  }
}
