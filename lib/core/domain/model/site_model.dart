import 'package:flutter/foundation.dart';

@immutable
class SiteModel {
  final String? title;
  final String? thumbnail;
  final String? duration;
  final List<LinkModel>? links;

  const SiteModel({
    this.title,
    this.links,
    this.duration,
    this.thumbnail,
  });

  @override
  bool operator ==(covariant SiteModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.thumbnail == thumbnail &&
        other.duration == duration &&
        listEquals(other.links, links);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        thumbnail.hashCode ^
        duration.hashCode ^
        links.hashCode;
  }

  @override
  String toString() {
    return 'SiteModel(title: $title, thumbnail: $thumbnail, duration: $duration, links: $links)';
  }
}

@immutable
class LinkModel {
  final String quality;
  final String? link;
  final String? type;

  const LinkModel({
    required this.quality,
    required this.link,
    required this.type,
  });

  @override
  bool operator ==(covariant LinkModel other) {
    if (identical(this, other)) return true;

    return other.quality == quality && other.link == link && other.type == type;
  }

  @override
  int get hashCode => quality.hashCode ^ link.hashCode ^ type.hashCode;

  @override
  String toString() => 'LinkModel(quality: $quality, link: $link, type: $type)';
}
