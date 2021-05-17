import 'package:json_annotation/json_annotation.dart';
import 'user_bookmarks_body.dart';

part 'user_bookmarks.g.dart';

@JsonSerializable(explicitToJson: true)
class UserBookmarks{
  @JsonKey(name: 'error')
  bool error;
  @JsonKey(name: 'message')
  String message;
  @JsonKey(name: 'body')
  UserBookmarksBody? body;


  UserBookmarks(this.error, this.message, this.body);

  factory UserBookmarks.fromJson(Map<String, dynamic> json) =>
      _$UserBookmarksFromJson(json);

  Map<String, dynamic> toJson() => _$UserBookmarksToJson(this);
}
