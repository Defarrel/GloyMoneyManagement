part of 'profile_screen_bloc.dart';

abstract class ProfileScreenState extends Equatable {
  const ProfileScreenState();

  @override
  List<Object?> get props => [];
}

class ProfileScreenInitial extends ProfileScreenState {}

class ProfileScreenLoading extends ProfileScreenState {}

class ProfileScreenLoaded extends ProfileScreenState {
  final String name;
  final String email;
  final File? profileImage;
  final String? photoUrl;

  const ProfileScreenLoaded({
    required this.name,
    required this.email,
    this.profileImage,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [name, email, profileImage, photoUrl];

  ProfileScreenLoaded copyWith({
    String? name,
    String? email,
    File? profileImage,
    String? photoUrl,
    bool clearProfileImage = false,
    bool clearPhotoUrl = false,
  }) {
    return ProfileScreenLoaded(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: clearProfileImage ? null : profileImage ?? this.profileImage,
      photoUrl: clearPhotoUrl ? null : photoUrl ?? this.photoUrl,
    );
  }
}

class ProfileScreenError extends ProfileScreenState {
  final String message;

  const ProfileScreenError(this.message);

  @override
  List<Object> get props => [message];
}

class LogoutSuccess extends ProfileScreenState {}

class ShowSnackBar extends ProfileScreenState {
  final String message;

  const ShowSnackBar(this.message);

  @override
  List<Object> get props => [message];
}

class ShowLoadingDialog extends ProfileScreenState {}

class HideLoadingDialog extends ProfileScreenState {}