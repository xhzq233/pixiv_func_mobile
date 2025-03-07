/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:inject.dart
 * 创建时间:2021/11/23 下午6:04
 * 作者:小草
 */

import 'package:get/get.dart';
import 'package:pixiv_func_mobile/app/api/api_client.dart';
import 'package:pixiv_func_mobile/app/api/auth_client.dart';
import 'package:pixiv_func_mobile/app/download/download_manager_controller.dart';
import 'package:pixiv_func_mobile/app/local_data/account_manager.dart';
import 'package:pixiv_func_mobile/app/local_data/browsing_history_manager.dart';
import 'package:pixiv_func_mobile/app/platform/api/platform_api.dart';
import 'package:pixiv_func_mobile/app/settings/app_settings.dart';
import 'package:pixiv_func_mobile/app/version_info/version_info.dart';

class Inject {
  static Future<void> init() async {
    Get.lazyPut(() => PlatformApi());
    Get.lazyPut(() => ApiClient());
    Get.lazyPut(() => AuthClient());
    Get.lazyPut(() => DownloadManagerController());

    await Get.putAsync(() => AccountService().init());
    await Get.putAsync(() => BrowsingHistoryService().init());
    await Get.putAsync(() => AppSettingsService().init());
    await Get.putAsync(() => VersionInfoController().init());
  }
}
