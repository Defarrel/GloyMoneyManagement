part of 'profile_screen_bloc.dart';

abstract class ProfileScreenEvent extends Equatable {
  const ProfileScreenEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserData extends ProfileScreenEvent {}

class UpdateProfileImage extends ProfileScreenEvent {
  final File imageFile;
  
  const UpdateProfileImage(this.imageFile);
  
  @override
  List<Object> get props => [imageFile];
}

class PickImageFromGallery extends ProfileScreenEvent {}

class TakePhoto extends ProfileScreenEvent {}

class DeleteProfileImage extends ProfileScreenEvent {}

class LogoutRequested extends ProfileScreenEvent {}