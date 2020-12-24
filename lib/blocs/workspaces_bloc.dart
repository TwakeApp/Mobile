import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twake/blocs/companies_bloc.dart';
import 'package:twake/events/workspace_event.dart';
import 'package:twake/models/workspace.dart';
import 'package:twake/repositories/collection_repository.dart';
import 'package:twake/states/company_state.dart';
import 'package:twake/states/workspace_state.dart';

export 'package:twake/events/workspace_event.dart';
export 'package:twake/states/workspace_state.dart';

class WorkspacesBloc extends Bloc<WorkspacesEvent, WorkspaceState> {
  final CollectionRepository repository;
  final CompaniesBloc companiesBloc;
  StreamSubscription subscription;
  String selectedCompanyId;

  WorkspacesBloc({this.repository, this.companiesBloc})
      : super(WorkspacesLoaded(
          workspaces: repository.items
              .where((i) =>
                  (i as Workspace).companyId ==
                  companiesBloc.repository.selected.id)
              .toList(),
          selected: repository.selected,
        )) {
    subscription = companiesBloc.listen((CompaniesState state) {
      if (state is CompaniesLoaded) {
        selectedCompanyId = state.selected.id;
        this.add(ReloadWorkspaces(selectedCompanyId));
      }
    });
    selectedCompanyId = companiesBloc.repository.selected.id;
  }

  List<Workspace> get currentWorkspaces {
    return repository.items
        .where((w) => (w as Workspace).companyId == selectedCompanyId)
        .toList();
  }

  @override
  Stream<WorkspaceState> mapEventToState(WorkspacesEvent event) async* {
    if (event is ReloadWorkspaces) {
      await repository.reload(
        filterMap: {'company_id': event.companyId},
        sortFields: {'name': true},
      );
      yield WorkspacesLoaded(
        workspaces: currentWorkspaces,
        selected: repository.selected,
      );
    } else if (event is ClearWorkspaces) {
      await repository.clean();
      yield WorkspacesEmpty();
    } else if (event is ChangeSelectedWorkspace) {
      Workspace w =
          repository.items.firstWhere((w) => w.id == event.workspaceId);
      repository.selected.isSelected = false;
      w.isSelected = true;
      yield WorkspacesLoaded(
        workspaces: currentWorkspaces,
        selected: w,
      );
    } else if (event is LoadSingleWorkspace) {
      // TODO implement single company loading
      throw 'Not implemented yet';
    } else if (event is RemoveWorkspace) {
      throw 'Not implemented yet';
      // yield WorkspacesLoaded(
      // workspaces: repository.items,
      // selected: selected,
      // );
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}