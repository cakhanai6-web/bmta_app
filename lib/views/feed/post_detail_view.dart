import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/auth_guard.dart';

/// 브타 피드 상세페이지
/// 
/// - 제목과 본문 내용 표시
/// - BM UP(좋아요) 버튼 (로그인 체크 필요)
/// - 댓글 입력 필드 (로그인 체크 필요)
/// - 댓글 리스트
class PostDetailView extends ConsumerStatefulWidget {
  const PostDetailView({
    super.key,
    required this.postId,
    this.postTitle,
    this.postContent,
  });

  final String postId;
  final String? postTitle;
  final String? postContent;

  @override
  ConsumerState<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends ConsumerState<PostDetailView> {
  final _commentController = TextEditingController();
  bool _isBoomUpPressed = false;
  bool _isCommentFieldEnabled = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => Navigator.pop(context),
          tooltip: '뒤로가기',
        ),
        title: const Text('브타'),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {
              // 알림 기능 (추후 구현)
            },
            tooltip: '알림',
          ),
          IconButton(
            icon: const Icon(LucideIcons.star),
            onPressed: () {
              // 즐겨찾기 기능 (추후 구현)
            },
            tooltip: '즐겨찾기',
          ),
          IconButton(
            icon: const Icon(LucideIcons.moreVertical),
            onPressed: () {
              // 더보기 기능 (추후 구현)
            },
            tooltip: '더보기',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.x3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  Text(
                    widget.postTitle ?? '게시글 제목',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: spacing.x2),
                  // 본문 내용
                  Text(
                    widget.postContent ??
                        '게시글 본문 내용이 여기에 표시됩니다.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  SizedBox(height: spacing.x3),
                  // BM UP(좋아요) 버튼
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // BM UP 버튼 클릭 시 로그인 체크
                        final isLoggedIn = await checkLoginAndShowDialog(
                          context,
                          ref,
                          returnData: {
                            'postId': widget.postId,
                            'postTitle': widget.postTitle ?? '',
                            'postContent': widget.postContent ?? '',
                          },
                        );
                        if (isLoggedIn) {
                          // 로그인한 경우 → BM UP 처리
                          setState(() {
                            _isBoomUpPressed = !_isBoomUpPressed;
                          });
                          // TODO: 실제 BM UP 로직 구현 (Firestore 업데이트 등)
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _isBoomUpPressed
                                      ? 'BM UP을 눌렀습니다'
                                      : 'BM UP을 취소했습니다',
                                ),
                              ),
                            );
                          }
                        }
                        // 비로그인 상태일 경우 auth_guard에서 Alert 팝업 표시 및 LoginView로 이동
                      },
                      icon: Icon(
                        _isBoomUpPressed
                            ? LucideIcons.thumbsUp
                            : LucideIcons.thumbsUp,
                        color: _isBoomUpPressed
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                      label: Text(
                        'BM UP',
                        style: TextStyle(
                          color: _isBoomUpPressed
                              ? colorScheme.primary
                              : colorScheme.outline,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isBoomUpPressed
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : colorScheme.surface,
                        foregroundColor: _isBoomUpPressed
                            ? colorScheme.primary
                            : colorScheme.outline,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.x4),
                  // 댓글 영역 제목
                  Text(
                    '댓글',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: spacing.x2),
                  // 댓글 리스트 (더미)
                  _buildCommentList(),
                ],
              ),
            ),
          ),
          // 댓글 입력 필드 (하단 고정)
          Container(
            padding: EdgeInsets.all(spacing.x2),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // 댓글 입력 필드 클릭 시 로그인 체크
                        if (!_isCommentFieldEnabled) {
                          final isLoggedIn = await checkLoginAndShowDialog(
                            context,
                            ref,
                            returnData: {
                              'postId': widget.postId,
                              'postTitle': widget.postTitle ?? '',
                              'postContent': widget.postContent ?? '',
                            },
                          );
                          if (isLoggedIn) {
                            // 로그인한 경우 → 댓글 입력 필드 활성화
                            setState(() {
                              _isCommentFieldEnabled = true;
                            });
                            // 포커스 주기
                            FocusScope.of(context).requestFocus(
                              FocusNode(),
                            );
                            // TODO: 실제 댓글 입력 기능 구현
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('댓글 입력 기능은 추후 구현 예정입니다'),
                                ),
                              );
                            }
                          }
                          // 비로그인 상태일 경우 auth_guard에서 Alert 팝업 표시 및 LoginView로 이동
                        }
                      },
                      child: TextField(
                        controller: _commentController,
                        maxLength: 200,
                        enabled: _isCommentFieldEnabled,
                        decoration: InputDecoration(
                          hintText: _isCommentFieldEnabled
                              ? '댓글을 입력하세요'
                              : '댓글을 입력하려면 탭하세요',
                          counterText: '',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: spacing.x1),
                  IconButton(
                    icon: const Icon(LucideIcons.send),
                    onPressed: _isCommentFieldEnabled
                        ? () async {
                            // 댓글 등록 버튼 클릭 시 로그인 체크
                            final isLoggedIn = await checkLoginAndShowDialog(
                              context,
                              ref,
                              returnData: {
                                'postId': widget.postId,
                                'postTitle': widget.postTitle ?? '',
                                'postContent': widget.postContent ?? '',
                              },
                            );
                            if (isLoggedIn) {
                              // 로그인한 경우 → 댓글 등록
                              // TODO: 실제 댓글 등록 로직 구현
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('댓글 등록 기능은 추후 구현 예정입니다'),
                                  ),
                                );
                              }
                            }
                          }
                        : null,
                    tooltip: '댓글 등록',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 댓글 리스트 (더미)
  Widget _buildCommentList() {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Column(
      children: [
        // 더미 댓글
        _buildCommentItem(
          author: '익명의 승객1',
          content: '정말 유용한 정보 감사합니다!',
          createdAt: '5분 전',
        ),
        SizedBox(height: spacing.x2),
        _buildCommentItem(
          author: '익명의 승객2',
          content: '저도 같은 경험 했어요',
          createdAt: '10분 전',
        ),
      ],
    );
  }

  /// 댓글 아이템
  Widget _buildCommentItem({
    required String author,
    required String content,
    required String createdAt,
  }) {
    final theme = Theme.of(context);
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.all(spacing.x2),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                author,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: spacing.x1),
              Text(
                createdAt,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.x1),
          Text(
            content,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
