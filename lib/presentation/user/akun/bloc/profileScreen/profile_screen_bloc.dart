import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gloymoneymanagement/data/repository/akun_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';
import 'package:gloymoneymanagement/services/storage_helper.dart';

part 'profile_screen_event.dart';
part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AkunRepository _akunRepository = AkunRepository(ServiceHttpClient());

  ProfileScreenBloc() : super(ProfileScreenInitial()) {
    on<LoadUserData>(_onLoadUserData);
    on<UpdateProfileImage>(_onUpdateProfileImage);
    on<PickImageFromGallery>(_onPickImageFromGallery);
    on<TakePhoto>(_onTakePhoto);
    on<DeleteProfileImage>(_onDeleteProfileImage);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadUserData(
    LoadUserData event,
    Emitter<ProfileScreenState> emit,
  ) async {
    emit(ProfileScreenLoading());

    final imagePath = await _storage.read(key: 'userProfilePath');
    debugPrint('Local image path: $imagePath');

    final result = await _akunRepository.getCurrentUser();
    result.fold(
      (error) {
        emit(ProfileScreenLoaded(
          name: 'Gagal memuat',
          email: '-',
          profileImage: imagePath != null ? File(imagePath) : null,
          photoUrl: null,
        ));
      },
      (user) async {
        emit(ProfileScreenLoaded(
          name: user.name,
          email: user.email,
          profileImage: imagePath != null ? File(imagePath) : null,
          photoUrl: user.photoProfile,
        ));

        await _storage.write(key: 'userName', value: user.name);
        await _storage.write(key: 'userEmail', value: user.email);
      },
    );
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileScreenLoaded) return;

    final saved = await StorageHelper.saveImage(event.imageFile, 'profile_');
    await _storage.write(key: 'userProfilePath', value: saved.path);
    
    emit(currentState.copyWith(profileImage: saved));

    try {
      final userId = await _akunRepository.getUserIdFromStorage();
      if (userId == null) {
        emit(const ShowSnackBar("Gagal mendapatkan ID pengguna"));
        return;
      }

      emit(ShowLoadingDialog());

      final response = await _akunRepository.uploadProfilePhoto(
        userId,
        saved.path,
      );
      
      emit(HideLoadingDialog());

      response.fold(
        (error) {
          emit(ShowSnackBar("Upload gagal: $error"));
        },
        (photoUrl) {
          emit(currentState.copyWith(profileImage: saved, photoUrl: photoUrl));
          emit(const ShowSnackBar("Foto profil berhasil diunggah"));
        },
      );
    } catch (e) {
      emit(HideLoadingDialog());
      debugPrint("Upload error: $e");
      emit(const ShowSnackBar("Terjadi kesalahan saat upload foto"));
    }
  }

  Future<void> _onPickImageFromGallery(
    PickImageFromGallery event,
    Emitter<ProfileScreenState> emit,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      add(UpdateProfileImage(File(picked.path)));
    }
  }

  Future<void> _onTakePhoto(
    TakePhoto event,
    Emitter<ProfileScreenState> emit,
  ) async {
    
  }

  Future<void> _onDeleteProfileImage(
    DeleteProfileImage event,
    Emitter<ProfileScreenState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ProfileScreenLoaded) return;

    await _storage.delete(key: 'userProfilePath');
    await _storage.delete(key: 'userPhotoUrl');
    
    emit(currentState.copyWith(
      clearProfileImage: true,
      clearPhotoUrl: true,
    ));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileScreenState> emit,
  ) async {
    await _storage.deleteAll();
    emit(LogoutSuccess());
  }
}
