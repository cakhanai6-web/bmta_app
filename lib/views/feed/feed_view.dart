import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:bmta_app/core/theme/app_theme.dart';
import 'widgets/feed_card.dart';

/// 브타 피드 화면: 2단 필터 바 + 게시글 리스트
class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  String _selectedTransport = '전체';
  String _selectedCategory = '전체';

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // 검색 UI
        Container(
          color: Colors.white,
          padding: EdgeInsets.all(spacing.x2), // 16
          child: _buildSearchBar(context),
        ),
        // 2단 필터 바
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.all(spacing.x2), // 16
          child: Column(
            children: [
              // 1행: 이용수단 필터 (전체/버스/지하철/택시)
              Row(
                children: [
                  _buildTransportFilter('전체'),
                  SizedBox(width: spacing.x1), // 8
                  _buildTransportFilter('버스'),
                  SizedBox(width: spacing.x1),
                  _buildTransportFilter('지하철'),
                  SizedBox(width: spacing.x1),
                  _buildTransportFilter('택시'),
                ],
              ),
              SizedBox(height: spacing.x1_5), // 12
              Container(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.1),
              ),
              SizedBox(height: spacing.x1_5),
              // 2행: 카테고리 필터 (전체/실시간 톡/분실물/사람 찾아요)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('전체'),
                    SizedBox(width: spacing.x1),
                    _buildCategoryChip('실시간 톡'),
                    SizedBox(width: spacing.x1),
                    _buildCategoryChip('분실물'),
                    SizedBox(width: spacing.x1),
                    _buildCategoryChip('사람 찾아요'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 피드 리스트
        Expanded(
          child: Container(
            color: theme.scaffoldBackgroundColor,
            child: ListView(
              padding: EdgeInsets.all(spacing.x2), // 16
              children: [
                // HOT 이슈 카드
                _buildHotIssueCard(),
                SizedBox(height: spacing.x2),

                // 일반 게시글 카드 (더미 데이터)
                ..._dummyPosts.map(
                  (post) => Padding(
                    padding: EdgeInsets.only(bottom: spacing.x2),
                    child: FeedCard(post: post),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 이용수단 필터 버튼
  Widget _buildTransportFilter(String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedTransport == label;

    return Expanded(
      child: Material(
        color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() => _selectedTransport = label);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: isSelected ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 카테고리 필터 칩
  Widget _buildCategoryChip(String label) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _selectedCategory == label;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() => _selectedCategory = label);
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? colorScheme.onSurface : colorScheme.outline,
              width: isSelected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              color: isSelected ? colorScheme.onSurface : colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }

  /// 검색 바
  Widget _buildSearchBar(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: '게시글, 노선, 키워드 검색',
          hintStyle: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.outline,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            LucideIcons.search,
            size: 20,
            color: colorScheme.outline,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacing.x2, // 16
            vertical: spacing.x2, // 16
          ),
          filled: true,
          fillColor: theme.scaffoldBackgroundColor,
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
        ),
        onTap: () {
          // 검색 기능은 추후 구현 (현재는 UI만)
        },
      ),
    );
  }

  /// HOT 이슈 카드
  Widget _buildHotIssueCard() {
    final spacing = context.spacing;
    final radii = context.radii;

    return Container(
      padding: EdgeInsets.all(spacing.x3), // 24
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF3B82F6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(radii.md * 2), // 32
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.2),
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Stack(
        children: [
          // 배경 아이콘
          Positioned(
            right: -16,
            top: -16,
            child: Icon(
              LucideIcons.flame,
              size: 96,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          // 콘텐츠
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'HOT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '지하철 2호선',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.x1), // 8
              const Text(
                '지금 강남역 2번 출구 붕어빵 줄 상황 실시간 제보합니다!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.4,
                ),
              ),
              SizedBox(height: spacing.x2), // 16
              Row(
                children: [
                  Text(
                    '👍 124',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '👀 3,420',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 더미 게시글 데이터
final _dummyPosts = [
  FeedPost(
    id: '1',
    transportType: '버스',
    routeNumber: '143번',
    category: '분실물',
    title: '목도리 주웠습니다!',
    content: '오늘 아침 버스 뒷자리에서 하늘색 목도리 주웠어요. 기사님께 맡겨두었습니다!',
    author: '익명의 승객',
    boomUpCount: 12,
    commentCount: 2,
    viewCount: 89,
    createdAt: '2분 전',
  ),
  FeedPost(
    id: '2',
    transportType: '지하철',
    routeNumber: '2호선',
    category: '실시간 톡',
    title: '지금 강남역 엄청 복잡해요',
    content: '퇴근 시간이라 사람 진짜 많습니다. 다음 열차 타시는 게 나을 듯!',
    author: '출근러',
    boomUpCount: 45,
    commentCount: 8,
    viewCount: 234,
    createdAt: '5분 전',
  ),
  FeedPost(
    id: '3',
    transportType: '택시',
    routeNumber: '3456',
    category: '이용 후기',
    title: '친절한 기사님 감사합니다',
    content: '늦은 밤 집까지 안전하게 데려다주셔서 감사합니다.',
    author: '감사한승객',
    boomUpCount: 67,
    commentCount: 3,
    viewCount: 156,
    createdAt: '10분 전',
  ),
];
