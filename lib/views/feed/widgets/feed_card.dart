import 'package:flutter/material.dart';

import 'package:bmta_app/core/theme/app_theme.dart';

/// 피드 게시글 데이터 모델
class FeedPost {
  final String id;
  final String transportType; // '버스', '지하철', '택시'
  final String routeNumber;
  final String category;
  final String title;
  final String content;
  final String author;
  final int boomUpCount;
  final int commentCount;
  final int viewCount;
  final String createdAt;

  FeedPost({
    required this.id,
    required this.transportType,
    required this.routeNumber,
    required this.category,
    required this.title,
    required this.content,
    required this.author,
    required this.boomUpCount,
    required this.commentCount,
    required this.viewCount,
    required this.createdAt,
  });
}

/// 피드 게시글 카드 위젯
class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.post,
  });

  final FeedPost post;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final radii = context.radii;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radii.md * 2), // 32
      child: InkWell(
        onTap: () {
          // 게시글 상세 페이지로 이동 (현재는 Mock)
        },
        borderRadius: BorderRadius.circular(radii.md * 2),
        child: Container(
          padding: EdgeInsets.all(spacing.x3), // 24
          decoration: BoxDecoration(
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(radii.md * 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더: 이용수단 배지 + 노선 번호 + 제목 + 시간
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이용수단 배지
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _getTransportColor(post.transportType).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _getTransportEmoji(post.transportType),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(width: spacing.x1), // 8
                  // 노선 번호 + 제목
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.routeNumber,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: spacing.x0_5), // 4
                        Text(
                          post.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 시간
                  Text(
                    post.createdAt,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.x1_5), // 12

              // 본문 내용
              Text(
                post.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
              SizedBox(height: spacing.x2), // 16

              // 푸터: 좋아요/댓글 수 + 작성자
              Container(
                padding: EdgeInsets.only(top: spacing.x1_5), // 12
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 좋아요/댓글 수
                    Row(
                      children: [
                        Text(
                          '👍 ${post.boomUpCount}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.outline,
                          ),
                        ),
                        SizedBox(width: spacing.x1_5), // 12
                        Text(
                          '💬 ${post.commentCount}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                    // 작성자
                    Text(
                      post.author,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTransportColor(String type) {
    switch (type) {
      case '버스':
        return const Color(0xFF3B82F6); // blue-500
      case '지하철':
        return const Color(0xFF10B981); // green-500
      case '택시':
        return const Color(0xFFF59E0B); // amber-500
      default:
        return const Color(0xFF64748B); // slate-500
    }
  }

  String _getTransportEmoji(String type) {
    switch (type) {
      case '버스':
        return '🚌';
      case '지하철':
        return '🚇';
      case '택시':
        return '🚕';
      default:
        return '🚗';
    }
  }
}
