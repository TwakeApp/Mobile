import 'dart:async';

import 'package:twake/blocs/base_channel_bloc.dart';
import 'package:twake/blocs/companies_bloc.dart';
import 'package:twake/events/channel_event.dart';
import 'package:twake/models/direct.dart';
import 'package:twake/repositories/collection_repository.dart';
import 'package:twake/states/channel_state.dart';

export 'package:twake/events/channel_event.dart';
export 'package:twake/states/channel_state.dart';

class DirectsBloc extends BaseChannelBloc {
  final CompaniesBloc companiesBloc;
  StreamSubscription _subscription;

  DirectsBloc({
    CollectionRepository<Direct> repository,
    this.companiesBloc,
  }) : super(
            repository: repository,
            initState: repository.items.isEmpty
                ? ChannelsEmpty()
                : ChannelsLoaded(channels: repository.items)) {
    _subscription = companiesBloc.listen((CompaniesState state) {
      if (state is CompaniesLoaded) {
        selectedParentId = state.selected.id;
        this.add(ReloadChannels(companyId: selectedParentId));
      }
    });
    selectedParentId = companiesBloc.repository.selected.id;
  }

  @override
  Stream<ChannelState> mapEventToState(ChannelsEvent event) async* {
    if (event is ReloadChannels) {
      yield ChannelsLoading();
      final filter = {
        'company_id': event.companyId,
      };
      await repository.reload(
        queryParams: filter,
        // TODO uncomment once we have correct company ids present
        // for now get all the data from database
        // filters: [
        // ['company_id', '=', selectedCompanyId]
        // ],
        sortFields: {'last_activity': false},
        forceFromApi: event.forceFromApi,
      );
      if (repository.items.isEmpty)
        yield ChannelsEmpty();
      else
        yield ChannelsLoaded(
          channels: repository.items,
        );
    } else if (event is ClearChannels) {
      await repository.clean();
      yield ChannelsEmpty();
    } else if (event is ChangeSelectedChannel) {
      repository.select(event.channelId);

      yield ChannelPicked(
        channels: repository.items,
        selected: repository.selected,
      );
    } else if (event is LoadSingleChannel) {
      // TODO implement single company loading
      throw 'Not implemented yet';
    } else if (event is RemoveChannel) {
      throw 'Not implemented yet';
      // repository.items.removeWhere((i) => i.id == event.channelId);
      // yield ChannelsLoaded(
      // channels: repository.items,
      // selected: selected,
      // );
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
