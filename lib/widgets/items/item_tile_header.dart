import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:glider/models/item.dart';
import 'package:glider/widgets/items/item_tile.dart';
import 'package:glider/widgets/items/item_tile_thumbnail.dart';
import 'package:glider/widgets/items/item_tile_title.dart';

class ItemTileHeader extends HookWidget {
  const ItemTileHeader(this.item, {Key key, this.dense = false})
      : super(key: key);

  final Item item;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: ItemTile.thumbnailSize),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ItemTileTitle(item, dense: dense),
          ),
          if (item.url != null) ...<Widget>[
            const SizedBox(width: 12),
            ItemTileThumbnail(item),
          ],
        ],
      ),
    );
  }
}