import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transportation_app/core/usecases/usecase.dart';
import 'package:transportation_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:transportation_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_picture_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:transportation_app/features/profile/domain/usecases/deposit_wallet_usecase.dart';
import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UploadProfilePictureUseCase uploadPictureUseCase;
  final DepositWalletUseCase depositWalletUseCase;
  final ProfileRepository profileRepository;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadPictureUseCase,
    required this.depositWalletUseCase,
    required this.profileRepository,
  }) : super(ProfileInitial());

  Future<void> loadProfile() async {
    if (isClosed) return;
    emit(ProfileLoading());
    final result = await getProfileUseCase(NoParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String familyName,
    required String email,
    required String phoneNumber,
    int? idType,
    String? idNumber,
  }) async {
    if (isClosed) return;
    emit(ProfileUpdating());
    final result = await updateProfileUseCase(
      UpdateProfileParams(
        firstName: firstName,
        lastName: lastName,
        familyName: familyName,
        email: email,
        phoneNumber: phoneNumber,
        idType: idType,
        idNumber: idNumber,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        ProfileUpdateFailure(message: failure.message, errors: failure.errors),
      ),
      (profile) => emit(ProfileUpdateSuccess(profile)),
    );
  }

  Future<void> uploadProfilePicture(String filePath) async {
    if (isClosed) return;
    emit(ProfilePictureUploading());
    final result = await uploadPictureUseCase(UploadPictureParams(filePath));
    if (isClosed) return;
    result.fold(
      (failure) => emit(ProfilePictureUploadFailure(failure.message)),
      (url) => emit(ProfilePictureUploadSuccess(url)),
    );
  }

  Future<void> depositToWallet({
    required double amount,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    if (isClosed) return;
    emit(WalletDepositLoading());
    final result = await depositWalletUseCase(
      DepositWalletParams(
        amount: amount,
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
      ),
    );
    if (isClosed) return;
    result.fold(
      (failure) {
        final message = failure.errors.isNotEmpty
            ? failure.errors.join('\n')
            : failure.message;
        emit(WalletDepositFailure(message));
      },
      (_) {
        emit(WalletDepositSuccess());
        loadProfile();
      },
    );
  }

  Future<void> loadWalletHistory() async {
    if (isClosed) return;
    emit(WalletHistoryLoading());
    final result = await profileRepository.getWalletHistory();
    if (isClosed) return;
    result.fold(
      (failure) => emit(WalletHistoryError(failure.message)),
      (txns) => emit(WalletHistoryLoaded(txns)),
    );
  }
}
