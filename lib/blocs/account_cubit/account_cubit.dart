import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:twake/blocs/file_upload_bloc/file_upload_bloc.dart';
import 'package:twake/models/language_option.dart';
import 'package:twake/repositories/account_repository.dart';
import 'package:twake/services/endpoints.dart';
import 'package:twake/utils/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'account_state.dart';

enum AccountFlowStage {
  info,
  edit,
}

class AccountCubit extends Cubit<AccountState> {
  final AccountRepository accountRepository;

  AccountCubit(this.accountRepository)
      : super(AccountInitial(stage: AccountFlowStage.info));

  Future<void> fetch({bool fromNetwork = true}) async {
    emit(AccountLoading());

    if (fromNetwork) await accountRepository.reload();

    final availableLanguages =
        accountRepository.language.options ?? <LanguageOption>[];
    final currentLanguage = accountRepository.selectedLanguage();
    final languageTitle = currentLanguage.title;

    emit(AccountLoaded(
      userName: accountRepository.userName.value,
      firstName: accountRepository.firstName.value,
      lastName: accountRepository.lastName.value,
      picture: accountRepository.picture.value,
      language: languageTitle,
      availableLanguages: availableLanguages,
    ));
  }

  void updateInfo({
    // In the local storage :)
    String firstName,
    String lastName,
    String languageTitle,
    String oldPassword,
    String newPassword,
    bool shouldUpdateCache = false,
  }) async {
    emit(AccountUpdating(
      firstName: firstName,
      lastName: lastName,
      language: languageTitle,
      oldPassword: oldPassword,
      newPassword: newPassword,
    ));
    final languageCode =
        (languageTitle != null && languageTitle.isNotReallyEmpty)
            ? accountRepository.languageCodeFromTitle(languageTitle)
            : '';
    accountRepository.update(
      newFirstName: firstName,
      newLastName: lastName,
      newLanguage: languageCode ?? '',
      oldPassword: oldPassword,
      newPassword: newPassword,
      shouldUpdateCache: shouldUpdateCache,
    );
    emit(AccountUpdated(
      firstName: accountRepository.firstName.value,
      lastName: accountRepository.lastName.value,
      language: accountRepository.selectedLanguage().title,
      oldPassword: oldPassword,
      newPassword: newPassword,
    ));
  }

  Future<void> updateImage(BuildContext context, String path) async {
    emit(AccountSaving(shouldUpdatePicture: true));
    context.read<FileUploadBloc>()
      ..add(
        StartUpload(
          path: path,
          endpoint: Endpoint.accountPicture,
        ),
      )
      ..listen(
        (FileUploadState state) {
          if (state is FileUploaded) {
            fetch();
          }
        },
      );
  }

  void updateAccountFlowStage(AccountFlowStage stage) {
    emit(AccountFlowStageUpdated(stage: stage));
  }
}
