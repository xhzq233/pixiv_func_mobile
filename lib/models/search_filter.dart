/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_mobile
 * 文件名称:search_filter.dart
 * 创建时间:2021/11/29 上午11:50
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_mobile/app/api/enums.dart';

class SearchFilter {
  SearchTarget target;
  SearchSort sort;
  bool enableDateRange;
  DateTimeRange dateTimeRange;
  int? bookmarkTotal;
  int dateTimeRangeType;

  SearchFilter({
    required this.target,
    required this.sort,
    required this.enableDateRange,
    required this.dateTimeRange,
    required this.bookmarkTotal,
    required this.dateTimeRangeType,
  });

  ///因为Dart直接传对线是引用类型 所以需要创建一个副本 用于编辑
  factory SearchFilter.copy(SearchFilter filter) => SearchFilter(
        target: filter.target,
        sort: filter.sort,
        enableDateRange: filter.enableDateRange,
        dateTimeRange: filter.dateTimeRange,
        bookmarkTotal: filter.bookmarkTotal,
        dateTimeRangeType: filter.dateTimeRangeType,
      );

  factory SearchFilter.create({
    SearchTarget target = SearchTarget.partialMatchForTags,
    SearchSort sort = SearchSort.dateDesc,
    bool enableDateLimit = false,
  }) {
    final DateTime _currentDate = DateTime.now();
    return SearchFilter(
      target: target,
      sort: sort,
      enableDateRange: enableDateLimit,
      dateTimeRange: DateTimeRange(
        start: DateTime(_currentDate.year - 1, _currentDate.month, _currentDate.day),
        end: DateTime(_currentDate.year, _currentDate.month, _currentDate.day),
      ),
      bookmarkTotal: null,
      dateTimeRangeType: 0,
    );
  }

  String get formatStartDate => '${dateTimeRange.start.year}-${dateTimeRange.start.month}-${dateTimeRange.start.day}';

  String get formatEndDate => '${dateTimeRange.end.year}-${dateTimeRange.end.month}-${dateTimeRange.end.day}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFilter &&
          runtimeType == other.runtimeType &&
          target == other.target &&
          sort == other.sort &&
          enableDateRange == other.enableDateRange &&
          dateTimeRange == other.dateTimeRange &&
          bookmarkTotal == other.bookmarkTotal &&
          dateTimeRangeType == other.dateTimeRangeType;

  @override
  int get hashCode =>
      target.hashCode ^
      sort.hashCode ^
      enableDateRange.hashCode ^
      dateTimeRange.hashCode ^
      bookmarkTotal.hashCode ^
      dateTimeRangeType.hashCode;
}
