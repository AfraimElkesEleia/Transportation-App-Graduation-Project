import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/features/profile/domain/entities/challenge_history.dart';
import 'package:transportation_app/features/profile/domain/entities/point_transaction.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_challenge_history_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_point_history_usecase.dart';
import 'package:transportation_app/features/profile/presentation/cubit/loyalty_hub_cubit/loyalty_hub_states.dart';

class LoyaltyHubCubit extends Cubit<LoyaltyHubState> {
  final GetPointHistoryUsecase _pointUsecase;
  final GetChallengeHistoryUsecase _challengeUsecase;

  List<ChallengeHistory> _challenges = [];
  bool _showCompleted = false;
  int _challengePage = 1;
  bool _hasMoreChallenges = true;

  List<PointTransaction> _points = [];
  int _pointsPage = 1;
  bool _hasMorePoints = true;

  bool _isInitialLoad = true;

  LoyaltyHubCubit(this._pointUsecase, this._challengeUsecase)
    : super(LoyaltyHubInitial());

  Future<void> init() async {
    emit(LoyaltyHubLoading());
    await _loadChallengesInternal(reset: true);
    if (state is LoyaltyHubError) {
      _isInitialLoad = false;
      return;
    }
    await _loadPointHistoryInternal(reset: true);
    _isInitialLoad = false;
    if (state is! LoyaltyHubError) {
      _emitLoaded();
    }
  }

  Future<void> loadChallenges({bool reset = false}) async {
    if (_isInitialLoad) return;
    if (!reset && !_hasMoreChallenges) return;

    if (state is LoyaltyHubLoaded) {
      emit((state as LoyaltyHubLoaded).copyWith(isLoadingMoreChallenges: true));
    }
    await _loadChallengesInternal(reset: reset);
    _emitLoaded();
  }

  Future<void> _loadChallengesInternal({required bool reset}) async {
    if (reset) {
      _challengePage = 1;
      _hasMoreChallenges = true;
      _challenges.clear();
    }

    final result = await _challengeUsecase(
      isCompleted: _showCompleted
          ? true
          : null, // If false, you might want to send false. But usually false means active. Let's send false for active.
      pageNumber: _challengePage,
      pageSize: 10,
    );

    result.fold(
      (f) {
        if (_isInitialLoad) emit(LoyaltyHubError(f.message));
        _hasMoreChallenges = false;
      },
      (pagedResult) {
        _challenges.addAll(pagedResult.items);
        _hasMoreChallenges = pagedResult.hasMore;
        if (pagedResult.hasMore) _challengePage++;
      },
    );
  }

  Future<void> loadPointHistory({bool reset = false}) async {
    if (_isInitialLoad) return;
    if (!reset && !_hasMorePoints) return;

    if (state is LoyaltyHubLoaded) {
      emit((state as LoyaltyHubLoaded).copyWith(isLoadingMorePoints: true));
    }
    await _loadPointHistoryInternal(reset: reset);
    _emitLoaded();
  }

  Future<void> _loadPointHistoryInternal({required bool reset}) async {
    if (reset) {
      _pointsPage = 1;
      _hasMorePoints = true;
      _points.clear();
    }

    final result = await _pointUsecase(pageNumber: _pointsPage, pageSize: 10);

    result.fold(
      (f) {
        if (_isInitialLoad) emit(LoyaltyHubError(f.message));
        _hasMorePoints = false;
      },
      (pagedResult) {
        _points.addAll(pagedResult.items);
        _hasMorePoints = pagedResult.hasMore;
        if (pagedResult.hasMore) _pointsPage++;
      },
    );
  }

  void toggleChallengeFilter(bool showCompleted) {
    if (_showCompleted == showCompleted) return;
    _showCompleted = showCompleted;
    if (!_isInitialLoad) {
      loadChallenges(reset: true);
    }
  }

  void _emitLoaded() {
    emit(
      LoyaltyHubLoaded(
        challenges: List.from(_challenges),
        points: List.from(_points),
        hasMoreChallenges: _hasMoreChallenges,
        hasMorePoints: _hasMorePoints,
        showCompleted: _showCompleted,
      ),
    );
  }
}
