import 'dart:async';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glider/commands/command.dart';
import 'package:glider/models/item.dart';
import 'package:glider/pages/account_page.dart';
import 'package:glider/pages/reply_page.dart';
import 'package:glider/providers/item_provider.dart';
import 'package:glider/providers/repository_provider.dart';
import 'package:glider/repositories/auth_repository.dart';
import 'package:glider/utils/scaffold_messenger_state_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ReplyCommand implements Command {
  const ReplyCommand(this.context, this.ref, {required this.id, this.rootId});

  final BuildContext context;
  final WidgetRef ref;
  final int id;
  final int? rootId;

  @override
  Future<void> execute() async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    final AuthRepository authRepository = ref.read(authRepositoryProvider);

    if (await authRepository.loggedIn) {
      final Item item =
          await ref.read(itemNotifierProvider(id).notifier).load();
      final Item? root = rootId != null
          ? await ref.read(itemNotifierProvider(rootId!).notifier).load()
          : null;

      final bool success = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) => ReplyPage(parent: item, root: root),
              fullscreenDialog: true,
            ),
          ) ??
          false;

      if (success && rootId != null) {
        ref.refresh(itemTreeStreamProvider(rootId!));
        ScaffoldMessenger.of(context).replaceSnackBar(
          SnackBar(
            content: Text(appLocalizations.processingInfo),
            action: SnackBarAction(
              label: appLocalizations.refresh,
              onPressed: () async {
                await reloadItemTree(ref.read, id: rootId!);
                ref.refresh(itemTreeStreamProvider(rootId!));
              },
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).replaceSnackBar(
        SnackBar(
          content: Text(appLocalizations.replyNotLoggedIn),
          action: SnackBarAction(
            label: appLocalizations.logIn,
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (_) => const AccountPage(),
              ),
            ),
          ),
        ),
      );
    }
  }
}