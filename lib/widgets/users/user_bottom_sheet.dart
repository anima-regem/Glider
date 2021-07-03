import 'package:flutter/material.dart';
import 'package:glider/models/user.dart';
import 'package:glider/repositories/website_repository.dart';
import 'package:glider/utils/formatting_util.dart';
import 'package:glider/widgets/common/options_dialog.dart';

class UserBottomSheet extends StatelessWidget {
  const UserBottomSheet(this.user, {Key? key}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final List<OptionsDialogOption> copyShareOptions = <OptionsDialogOption>[
      if (user.about != null)
        OptionsDialogOption(
          title: 'Text',
          text: FormattingUtil.convertHtmlToHackerNews(user.about!),
        ),
      OptionsDialogOption(
        title: 'User link',
        text: Uri.https(
          WebsiteRepository.authority,
          'user',
          <String, String>{'id': user.id},
        ).toString(),
      ),
    ];

    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            title: const Text('Copy...'),
            onTap: () async {
              await showDialog<void>(
                context: context,
                builder: (_) => OptionsDialog.copy(options: copyShareOptions),
              );
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Share...'),
            onTap: () async {
              await showDialog<void>(
                context: context,
                builder: (_) => OptionsDialog.share(
                  options: copyShareOptions,
                  subject: user.id,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
