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
class MockDateTime extends Mock implements DateTime {}

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
                  time: DateTime.now(),
                );
              } else if (count == 1) {
                return UserActivity(
                  type: UserActivityType.notDriving,
                  time: DateTime.now(),
                );
              } else {
                return UserActivity(
                  type: UserActivityType.notDriving,
                  time: DateTime.now(),
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
              speed: 30,
            ),
          ]),
        );
        when(locationService.getLocation()).thenAnswer(
          (_) => Future.value(
            const LatitudeLongitude(1, 1),
          ),
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
                  time: DateTime(2021, 1, 1, 0, 0, 0),
                );
              } else {
                return UserActivity(
                  type: UserActivityType.notDriving,
                  time: DateTime(2021, 1, 1, 0, count + 1, 0),
                );
              }
            },
          );
        });

        cubit = MovementCubit(locationService, activityService);

        fakeAsync.elapse(const Duration(milliseconds: 1));
        fakeAsync.elapse(const Duration(minutes: 1));

        expect(cubit.state.lastSwitchOfActivity, isNotNull);
        expect(cubit.state.userActivity, isNotNull);
        UserActivityType? currentActivity = cubit.state.userActivity?.type;
        expect(currentActivity, equals(UserActivityType.driving));

        expect(cubit.state.lastParkedLocation, isNull);

        fakeAsync.elapse(const Duration(minutes: 1));
        currentActivity = cubit.state.userActivity?.type;
        expect(currentActivity, equals(UserActivityType.notDriving));
        expect(cubit.state.lastParkedLocation, isNotNull);
        expect(cubit.state.lastParkedLocation!.latitude, equals(1));
        expect(cubit.state.lastParkedLocation!.longitude, equals(1));

        fakeAsync.elapse(const Duration(minutes: 6));

        expect(cubit.state.lastParkedLocation, isNotNull);
        expect(cubit.state.lastParkedTime, isNotNull);
      });
    });

    test(
        'Test a drive where the user switches back and fort between driving and not driving in less than 1, 2, 3 minutes interval',
        () {
      fakeAsync((fakeAsync) {
        when(locationService.getLiveLocation()).thenAnswer(
          (_) => Stream<LiveLocation>.fromIterable([
            LiveLocation(
              location: const LatitudeLongitude(1, 1),
              speed: 30,
            ),
          ]),
        );
        when(locationService.getLocation()).thenAnswer(
          (_) => Future.value(
            const LatitudeLongitude(1, 1),
          ),
        );

        when(activityService.askForActivityPermission())
            .thenAnswer((_) => Future.value(true));

        when(activityService.getActivityStream()).thenAnswer((_) {
          return Stream<UserActivity>.periodic(
            const Duration(minutes: 1),
            (count) {
              if (count.isEven) {
                return UserActivity(
                  type: UserActivityType.driving,
                  time: DateTime(2021, 1, 1, 0, count + 1, 0),
                );
              } else {
                return UserActivity(
                  type: UserActivityType.notDriving,
                  time: DateTime(2021, 1, 1, 0, count + 1, 0),
                );
              }
            },
          );
        });

        cubit = MovementCubit(locationService, activityService);

        fakeAsync.elapse(const Duration(milliseconds: 1));

        for (var i = 0; i < 10; i++) {
          fakeAsync.elapse(const Duration(minutes: 1));
          expect(cubit.state.lastSwitchOfActivity, isNotNull);
          expect(cubit.state.userActivity, isNotNull);
          expect(cubit.state.lastSwitchOfActivity, isNotNull);
          expect(
              cubit.state.lastSwitchOfActivity!
                  .difference(DateTime(2021, 1, 1, 0, i, 0)),
              equals(const Duration(minutes: 1)));
          UserActivityType? currentActivity = cubit.state.userActivity?.type;
          if (i.isEven) {
            expect(currentActivity, equals(UserActivityType.driving));
          } else {
            expect(currentActivity, equals(UserActivityType.notDriving));
          }
        }
      });
    });
  });
}
