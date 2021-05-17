/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : followed.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/following/user_preview.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/avatar_view_from_url.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/config.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class FollowedPage extends StatefulWidget {
  @override
  _FollowedPageState createState() => _FollowedPageState();
}

class _FollowedPageState extends State<FollowedPage> {
  List<UserPreview> _users = <UserPreview>[];

  static const int _pageQuantity = 30;

  int _currentPage = 1;

  bool _hasNext = true;
  bool _loading = false;
  bool _initialize = false;

  @override
  void initState() {
    _loadData(reload: false, init: true);
    super.initState();
  }

  Future _loadData({bool reload = true, bool init = false}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _users.clear();
          _currentPage = 1;
          _hasNext = true;
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final followed = await PixivRequest.instance.getFollowing(
      Config.userId,
      (_currentPage - 1) * _pageQuantity,
      _pageQuantity,
      decodeException: (e, response) {
        print(e);
      },
      requestException: (e) {
        print(e);
      },
    );

    if (this.mounted) {
      if (followed != null) {
        if (!followed.error) {
          if (followed.body != null) {
            setState(() {
              _hasNext =
                  followed.body!.total > _currentPage * _pageQuantity;
              _users.addAll(followed.body!.users);
            });
          }
        } else {
          print(followed.message);
        }
      }
    }

    if (this.mounted) {
      setState(() {
        if (init) {
          _initialize = true;
        }
        _loading = false;
      });
    }
  }

  Widget _buildUserCards() {
    return Column(
      children: _users.map((user) {
        return Container(
          child: Card(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Row(
                    children: user.illusts
                        .map((illust) => ImageViewFromUrl(
                              illust.url,
                              width: Util.windowSize.width / 3,
                              imageBuilder: (Widget imageWidget) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Util.gotoPage(
                                          context,
                                          IllustPage(illust.id),
                                        );
                                      },
                                      child: imageWidget,
                                    ),
                                    Positioned(
                                      left: 2,
                                      top: 2,
                                      child: illust.tags.contains('R-18')
                                          ? Card(
                                              color: Colors.pinkAccent,
                                              child: Text('R-18'),
                                            )
                                          : Container(),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: Card(
                                        color: Colors.white12,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          child: Text('${illust.pageCount}'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ))
                        .toList(),
                  ),
                  scrollDirection: Axis.horizontal,
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  leading: AvatarViewFromUrl(
                    user.profileImageUrl,
                    radius: 35,
                  ),
                  title: Text(user.userName),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_users.isNotEmpty) {
      final List<Widget> list = [];
      list.add(_buildUserCards());
      if (_loading) {
        list.add(SizedBox(height: 20));
        list.add(Center(
          child: CircularProgressIndicator(),
        ));
        list.add(SizedBox(height: 20));
      } else {
        if (_hasNext) {
          list.add(Card(
            child: ListTile(
              title: Text('加载更多'),
              onTap: () {
                _currentPage++;
                _loadData(reload: false);
              },
            ),
          ));
        } else {
          list.add(Card(child: ListTile(title: Text('没有更多数据啦'))));
        }
      }

      component = SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: list,
        ),
      );
    } else {
      if (_loading) {
        if (!_initialize) {
          component = Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          component = Container();
        }
      } else {
        component = ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(
                child: Text('没有任何数据'),
              ),
            );
          },
          physics: const AlwaysScrollableScrollPhysics(),
        );
      }
    }

    return Scrollbar(
      radius: Radius.circular(10),
      thickness: 10,
      child: component,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('已关注的用户'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
