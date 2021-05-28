/* import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twake/models/company/company.dart';
import 'package:twake/models/globals/globals.dart';
import 'package:twake/repositories/companies_repository.dart';

import 'companies_state.dart';

class CompaniesCubit extends Cubit<CompaniesState> {
  final CompanyRepository repository;
  List<Company> _companies = [];

  CompaniesCubit(this.repository) : super(CompaniesInitial());

  Future<void> fetch() async {
    emit(CompaniesLoadInProgress());
    final companies = await repository.fetch();
    _companies = companies;
    emit(CompaniesLoadSuccess(
      companies: companies,
    ));
  }

  void selectCompany(String companyId) {
    Globals.instance.companyIdSet = companyId;
    final newState = CompaniesLoadSuccess(
      companies: _companies,
    );
    emit(newState);
  }
}
 */
