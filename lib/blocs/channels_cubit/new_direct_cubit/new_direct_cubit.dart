import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twake/blocs/account_cubit/account_cubit.dart';
import 'package:twake/blocs/channels_cubit/channels_cubit.dart';
import 'package:twake/blocs/channels_cubit/new_direct_cubit/new_direct_state.dart';
import 'package:twake/blocs/workspaces_cubit/workspaces_cubit.dart';
import 'package:twake/models/account/account.dart';
import 'package:twake/models/globals/globals.dart';
import 'package:twake/repositories/channels_repository.dart';
import 'package:twake/routing/app_router.dart';
import 'package:twake/services/navigator_service.dart';
import 'package:twake/utils/extensions.dart';

class NewDirectCubit extends Cubit<NewDirectState> {
  final WorkspacesCubit workspacesCubit;
  final DirectsCubit directsCubit;
  final AccountCubit accountCubit;
  final ChannelsRepository channelsRepository;

  NewDirectCubit({
    required this.workspacesCubit,
    required this.directsCubit,
    required this.accountCubit,
    required this.channelsRepository,
  }) : super(NewDirectInitial());

  void fetchAllMember() async {
    emit(NewDirectInProgress());

    final result = await Future.wait(
      [workspacesCubit.fetchMembers(local: true), _fetchRecentChats()],
    );

    final workspaceMembers = (result.first as List<Account>)
        ..removeWhere((element) => element.id == Globals.instance.userId);

    final recentChats = result.last as Map<String, Account>;

    emit(NewDirectNormalState(
      members: workspaceMembers,
      recentChats: recentChats,
    ));
  }

  void searchMembers(String memberName) {
    if (memberName.isReallyEmpty) {
      emit(NewDirectNormalState(
          members: state.members, recentChats: state.recentChats));
      return;
    }
    final searchKeyword = memberName.toLowerCase().trim();

    final allMembers = state.members;
    final results = allMembers.where((member) {
      if (member.username.toLowerCase().contains(searchKeyword)) {
        return true;
      }
      if (member.firstname != null &&
          member.firstname!.toLowerCase().contains(searchKeyword)) {
        return true;
      }
      if (member.lastname != null &&
          member.lastname!.toLowerCase().contains(searchKeyword)) {
        return true;
      }
      if (member.email.toLowerCase().contains(searchKeyword)) {
        return true;
      }
      return false;
    }).toList();

    emit(NewDirectFoundMemberState(
        foundMembers: results,
        members: state.members,
        recentChats: state.recentChats));
  }

  Future<Map<String, Account>> _fetchRecentChats() async {
    Map<String, Account> recentChats = {};

    if (directsCubit.state is ChannelsLoadedSuccess) {
      final directs = (directsCubit.state as ChannelsLoadedSuccess).channels;
      for (final direct in directs.where((d) => d.members.length < 2)) {
        final account =
            await accountCubit.fetchStateless(userId: direct.members.first);
        recentChats[direct.id] = account;
      }
    }
    return recentChats;
  }

  void newDirect(String memberId) async {
    final recentKey = state.recentChats.keys.firstWhere(
        (key) => state.recentChats[key]?.id == memberId,
        orElse: () => '');
    if (recentKey.isNotEmpty) {
      NavigatorService.instance.navigate(channelId: recentKey);
    } else {
      final channel = await channelsRepository.createDirect(member: memberId);
      directsCubit.changeSelectedChannelAfterCreateSuccess(channel: channel);
      popBack();
      NavigatorService.instance.navigate(channelId: channel.id);
    }
  }
}
