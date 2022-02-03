/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:source.dart
 * 创建时间:2021/11/25 下午6:13
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_android/app/api/api_client.dart';
import 'package:pixiv_func_android/app/api/dto/novels.dart';
import 'package:pixiv_func_android/app/api/entity/novel.dart';
import 'package:pixiv_func_android/app/data/data_source_base.dart';
import 'package:pixiv_func_android/app/local_data/account_manager.dart';
import 'package:pixiv_func_android/models/bookmarked_filter.dart';

class BookmarkedNovelListSource extends DataSourceBase<Novel> {
  final BookmarkedFilter filter;

  BookmarkedNovelListSource(this.filter);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getUserNovelBookmarks(
          int.parse(Get.find<AccountService>().current!.user.id),
          restrict: filter.restrict,
          cancelToken: cancelToken,
        );
        nextUrl = result.nextUrl;
        addAll(result.novels);
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.next<Novels>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(result.novels);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
