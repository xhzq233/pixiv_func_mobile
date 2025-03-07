/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:illust_previewer.dart
 * 创建时间:2021/11/20 上午12:53
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/entity/user_preview.dart';
import 'package:pixiv_func_mobile/components/avatar_from_url/avatar_from_url.dart';
import 'package:pixiv_func_mobile/components/follow_switch_button/follow_switch_button.dart';
import 'package:pixiv_func_mobile/components/illust_previewer/illust_previewer.dart';
import 'package:pixiv_func_mobile/pages/user/user.dart';

class UserPreviewer extends StatelessWidget {
  final UserPreview userPreview;

  const UserPreviewer({Key? key, required this.userPreview}) : super(key: key);

  static const double padding = 3;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final itemWidth = constraints.maxWidth / 3 - padding;
              return SizedBox(
                width: constraints.maxWidth,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    for (final illust in userPreview.illusts)
                      Container(
                        padding: const EdgeInsets.all(padding),
                        width: itemWidth,
                        child: IllustPreviewer(illust: illust, square: true),
                      )
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: GestureDetector(
              onTap: () => Get.to(UserPage(id: userPreview.user.id)),
              child: Hero(
                tag: 'UserHero:${userPreview.user.id}',
                child: AvatarFromUrl(userPreview.user.profileImageUrls.medium),
              ),
            ),
            title: Text(
              userPreview.user.name,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: FollowSwitchButton(
              id: userPreview.user.id,
              initValue: userPreview.user.isFollowed!,
            ),
          ),
        ],
      ),
    );
  }
}
