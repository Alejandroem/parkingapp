import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:parking/application/cubits/movement_cubit.dart';
import 'package:parking/domain/models/lat_lng.dart';
import 'package:parking/domain/models/live_location.dart';
import 'package:parking/domain/models/user_activity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:parking/domain/services/activity_service.dart';
import 'package:parking/domain/services/location_service.dart';

import 'movement_cubit_test.mocks.dart';

//test for movement cubit

@GenerateNiceMocks([MockSpec<ActivityService>(), MockSpec<LocationService>()])
void main() {
  group('MovementCubit', () {
    //Create a stream that returns driving as user activity then returns walking after 1 minute then returns walking for 6 minutes
    late MovementCubit cubit;
    late MockLocationService locationService;
    late MockActivityService activityService;

    setUp(() {
      locationService = MockLocationService();
      activityService = MockActivityService();
      cubit = MovementCubit(locationService, activityService);
    });

    tearDown(() {
      cubit.close();
    });

    //test for initial state

    test('initial state is correct', () {
      expect(
          cubit.state,
          MovementState(
            lastKnownLocation: const LatitudeLongitude(0, 0),
            speed: 0,
            maxSpeed: 0,
          ));
    });

    //test for initial state

    blocTest<MovementCubit, MovementState>(
      'Test Initial state',
      build: () {
        when(activityService.getActivityStream()).thenAnswer(
          (_) => Stream<UserActivity>.periodic(
            const Duration(minutes: 1),
            (count) {
              if (count == 0) {
                return UserActivity(
                  type: UserActivityType.driving,
                  timestamp: DateTime.now(),
                );
              } else if (count == 1) {
                return UserActivity(
                  type: UserActivityType.notDriving,
                  timestamp: DateTime.now(),
                );
              } else {
                return UserActivity(
                  type: UserActivityType.notDriving,
                  timestamp: DateTime.now(),
                );
              }
            },
          ),
        );
        when(activityService.askForActivityPermission())
            .thenAnswer((_) => Future.value(true));
        return cubit;
      },
      act: (cubit) {
        // This is necessary to trigger the logic inside the cubit.
        // You can add any actions here if needed.
      },
      expect: () => [],
    );

    test('Test a drive, walk 5 minutes and should mark a parking time', () {
      fakeAsync((fakeAsync) {
        when(locationService.getLiveLocation()).thenAnswer(
          (_) => Stream<LiveLocation>.fromIterable([
            LiveLocation(
              location: const LatitudeLongitude(1, 1),
              speed: 30, // You can change this value
            ),
          ]),
        );

        when(activityService.askForActivityPermission())
            .thenAnswer((_) => Future.value(true));

        when(activityService.getActivityStream()).thenAnswer((_) {
          return Stream<UserActivity>.periodic(
            const Duration(minutes: 1),
            (count) {
              if (count == 0) {
                return UserActivity(
                  type: UserActivityType.driving,
                  timestamp: DateTime.now(),
                );
              } else {
                return UserActivity(
                  type: UserActivityType.notDriving,
                  timestamp: DateTime.now(),
                );
              }
            },
          );
        });

        cubit = MovementCubit(locationService, activityService);

        fakeAsync.elapse(const Duration(milliseconds: 1));

        fakeAsync.elapse(const Duration(minutes: 1));
        expectLater(
          cubit.state.lastSwitchOfActivity,
          isNotNull,
        );
        expectLater(
          cubit.state.userActivity,
          isNotNull,
        );
        expectLater(
          cubit.state.userActivity?.type,
          equals(UserActivityType.driving),
        );

        fakeAsync.elapse(const Duration(minutes: 1));

        expectLater(
          cubit.state.userActivity?.type,
          equals(UserActivityType.notDriving),
        );
        expectLater(
          cubit.state.lastKnownLocation,
          isNotNull,
        );
        expectLater(
          cubit.state.lastKnownLocation.latitude,
          equals(1),
        );
        expectLater(
          cubit.state.lastKnownLocation.longitude,
          equals(1),
        );

        fakeAsync.elapse(const Duration(minutes: 10));

        expectLater(
          cubit.state.lastParkedLocation,
          isNotNull,
          reason:
              'Should have a parking location because was updated when the last activity was driving and it changed',
        );

        expectLater(
          cubit.state.lastParkedTime,
          isNotNull,
          reason:
              'Should have a parking time because user has been on foot for 5 minutes',
        );
      });
    });
  });
}
