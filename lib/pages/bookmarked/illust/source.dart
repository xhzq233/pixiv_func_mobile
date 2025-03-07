/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:source.dart
 * 创建时间:2021/11/25 下午12:09
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/dto/illusts.dart';
import 'package:pixiv_func_mobile/app/api/entity/illust.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';
import 'package:pixiv_func_mobile/app/local_data/account_manager.dart';
import 'package:pixiv_func_mobile/models/bookmarked_filter.dart';

class BookmarkedIllustListSource extends DataSourceBase<Illust> {
  final BookmarkedFilter filter;

  BookmarkedIllustListSource(this.filter);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getUserIllustBookmarks(
          Get.find<AccountService>().currentUserId,
          restrict: filter.restrict,
          cancelToken: cancelToken,
        );
        nextUrl = result.nextUrl;
        addAll(result.illusts);
        initData = true;
      } else {
        if (hasMore) {
          final result = await api.next<Illusts>(nextUrl!, cancelToken: cancelToken);
          nextUrl = result.nextUrl;
          addAll(result.illusts);
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
