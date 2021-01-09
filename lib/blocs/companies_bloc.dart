import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twake/blocs/profile_bloc.dart';
import 'package:twake/events/company_event.dart';
import 'package:twake/models/company.dart';
import 'package:twake/repositories/collection_repository.dart';
import 'package:twake/states/company_state.dart';

export 'package:twake/events/company_event.dart';
export 'package:twake/states/company_state.dart';

class CompaniesBloc extends Bloc<CompaniesEvent, CompaniesState> {
  final CollectionRepository<Company> repository;
  CompaniesBloc(this.repository)
      : super(CompaniesLoaded(
          companies: repository.items,
          selected: repository.selected,
        )) {
    ProfileBloc.selectedCompany = repository.selected.id;
  }

  @override
  Stream<CompaniesState> mapEventToState(CompaniesEvent event) async* {
    if (event is ReloadCompanies) {
      await repository.reload();
      yield CompaniesLoaded(
        companies: repository.items,
        selected: repository.selected,
      );
    } else if (event is ClearCompanies) {
      await repository.clean();
      yield CompaniesEmpty();
    } else if (event is ChangeSelectedCompany) {
      repository.select(event.companyId);
      ProfileBloc.selectedCompany = event.companyId;
      yield CompaniesLoaded(
        companies: repository.items,
        selected: repository.selected,
      );
    } else if (event is LoadSingleCompany) {
      // TODO implement single company loading
      throw 'Not implemented yet';
    } else if (event is RemoveCompany) {
      throw 'Not implemented yet';
      // repository.items.removeWhere((i) => i.id == event.companyId);
      //
      // yield CompaniesLoaded(
      // companies: repository.items,
      // selected: selected,
      // );
    }
  }
}
