// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PendingNotifications extends Equatable {
  /// Constructs an instance of [PendingNotifications].
  const PendingNotifications({
    required this.id,
    this.channelId,
    this.title,
    this.body,
    this.tag,
  });

  /// The notification's id.
  final int id;

  /// The notification channel's id.
  ///
  /// Returned only on Android 8.0 or newer.
  final String? channelId;

  /// The notification's title.
  final String? title;

  /// The notification's content.
  final String? body;

  /// The notification's tag.
  final String? tag;

  @override
  List<Object> get props {
    return [id, channelId ?? '', title ?? '', body ?? '', tag ?? ''];
  }

  PendingNotifications copyWith({
    int? id,
    String? channelId,
    String? title,
    String? body,
    String? tag,
  }) {
    return PendingNotifications(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      title: title ?? this.title,
      body: body ?? this.body,
      tag: tag ?? this.tag,
    );
  }
}
