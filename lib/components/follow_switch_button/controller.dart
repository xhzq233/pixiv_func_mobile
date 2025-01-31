/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:controller.dart
 * 创建时间:2021/11/23 下午11:33
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/utils/log.dart';

class FollowSwitchButtonController extends GetxController {
  final int id;

  FollowSwitchButtonController(this.id, {required bool initValue}) : _isFollowed = initValue;

  bool _isFollowed;

  bool _requesting = false;

  bool get isFollowed => _isFollowed;

  bool get requesting => _requesting;

  void changeFollowState({bool isChange = false, bool restrict = true}) {
    _requesting = true;
    update();

    if (isChange || !_isFollowed) {
      Get.find<ApiClient>().addFollow(id, restrict: restrict).then((result) {
        _isFollowed = true;
      }).catchError((e) {
        Log.e('关注用户失败', e);
      }).whenComplete(() {
        _requesting = false;
        update();
      });
    } else {
      Get.find<ApiClient>().deleteFollow(id).then((result) {
        _isFollowed = false;
        update();
      }).catchError((e) {
        Log.e('取消关注用户失败', e);
      }).whenComplete(() {
        _requesting = false;
        update();
      });
    }
  }
}
