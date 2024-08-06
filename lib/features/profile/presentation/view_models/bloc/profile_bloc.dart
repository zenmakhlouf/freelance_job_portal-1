// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:freelance_job_portal/features/profile/data/models/profile/client_profile.dart';
import 'package:freelance_job_portal/features/profile/data/profile_repo.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepo _profileRepo;
  ProfileBloc(
    this._profileRepo,
  ) : super(ProfileInitial()) {
    on<ShowProfile>(showProfile);
    on<GetProfiles>(getProfiles);
    on<CreateClientProfileEvent>(createClientProfile);
    on<AddPhotoToClientProfileEvent>(addPhotoToClientProfile);
    on<AddSkillToClientProfileEvent>(addSkillToClientProfile);
  }

  FutureOr<void> showProfile(
      ShowProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _profileRepo.getProfile(event.userId, event.profileId);
    result.fold(
        (failure) => emit(ProfileGetError(errorMessage: failure.errMessage)),
        (profile) {
      print('we are in bloc');
      print(profile.toString());
      emit(ProfileGetSuccess(myProfile: profile));
    });
  }

  FutureOr<void> getProfiles(
      GetProfiles event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    final result = await _profileRepo.getUserProfiles(event.userId);
    result.fold(
        (failure) => emit(ProfileGetError(errorMessage: failure.errMessage)),
        (profiles) {
      if (profiles.isEmpty) {
        emit(ProfileNoProfiles());
      } else {
        emit(ProfilesLoaded(profiles));
      }
    });
  }

  FutureOr<void> createClientProfile(
      CreateClientProfileEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileCreateLoading());
    final result = await _profileRepo.createProfile({
      "bio": event.description,
      "jobTitleId": event.jobTitleId,
    });
    result.fold(
      (failure) => emit(ProfileCreateError(errorMessage: failure.errMessage)),
      (clientProfile) {
        print(clientProfile.toString());
        emit(ClientProfileCreatedState(clientProfile: clientProfile));
      },
    );
  }

  FutureOr<void> addPhotoToClientProfile(
      AddPhotoToClientProfileEvent event, Emitter<ProfileState> emit) async {
    emit(AddPhotoToProfileLoading());
    final result = await _profileRepo.addPhoto({
      "clientProfileId": event.clientProfileId,
      "photoId": event.photoId,
    });
    result.fold((failure) => emit(AddPhotoToProfileError(failure.errMessage)),
        (success) {
      print(
          'added photo clientProfileId: ${event.clientProfileId} photoId:  ${event.photoId}');
      emit(AddedPhotoToProfile(success));
    });
  }

  FutureOr<void> addSkillToClientProfile(
      AddSkillToClientProfileEvent event, Emitter<ProfileState> emit) async {
    emit(AddSkillToProfileLoading());
    final result = await _profileRepo.addSkill({
      "clientProfileId": event.clientProfileId,
      "skillId": event.skillId,
    });
    result.fold((failure) => emit(AddPhotoToProfileError(failure.errMessage)),
        (success) {
      print(
          'added skill clientProfileId: ${event.clientProfileId} skillId:  ${event.skillId}');

      emit(AddedPhotoToProfile(success));
    });
  }
}
