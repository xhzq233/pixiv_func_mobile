/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:source.dart
 * 创建时间:2021/11/30 下午12:54
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/dto/novels.dart';
import 'package:pixiv_func_mobile/app/api/entity/novel.dart';
import 'package:pixiv_func_mobile/app/data/data_source_base.dart';

class FollowerNewNovelListSource extends DataSourceBase<Novel> {
  final bool? restrict;

  FollowerNewNovelListSource(this.restrict);

  final api = Get.find<ApiClient>();

  @override
  Future<bool> loadData([bool isLoadMoreAction = false]) async {
    try {
      if (!initData) {
        final result = await api.getFollowerNewNovels(
          cancelToken: cancelToken,
          restrict: restrict,
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
