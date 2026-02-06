import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'feed/feed_view.dart';

/// 메인 스캐폴드: 하단 네비게이션 바를 포함한 앱의 메인 구조
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 2; // 기본: BMTA 피드

  // 각 탭에 해당하는 화면 (현재는 피드만 구현)
  final List<Widget> _pages = [
    const _PlaceholderView(title: '버스타'),
    const _PlaceholderView(title: '지하철타'),
    const FeedView(),
    const _PlaceholderView(title: '내정보'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'BMTA',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _getTitle(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // 알림 기능 (추후 구현)
            },
            icon: const Icon(LucideIcons.bell),
            tooltip: '알림',
          ),
          IconButton(
            onPressed: () {
              setState(() => _currentIndex = 3);
            },
            icon: const Icon(LucideIcons.user),
            tooltip: '마이페이지',
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavButton(
                  context: context,
                  index: 0,
                  icon: LucideIcons.bus,
                  label: '버스타',
                ),
                _buildNavButton(
                  context: context,
                  index: 1,
                  icon: LucideIcons.map,
                  label: '지하철타',
                ),
                _buildNavButton(
                  context: context,
                  index: 2,
                  icon: LucideIcons.messageSquare,
                  label: '브타 피드',
                ),
                _buildNavButton(
                  context: context,
                  index: 3,
                  icon: LucideIcons.user,
                  label: '내정보',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => _currentIndex = index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? colorScheme.primary : colorScheme.outline,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: isSelected ? colorScheme.primary : colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return '버스 실시간';
      case 1:
        return '지하철 실시간';
      case 2:
        return 'BMTA';
      case 3:
        return '내정보';
      default:
        return 'BMTA';
    }
  }
}

/// 아직 구현되지 않은 화면용 플레이스홀더
class _PlaceholderView extends StatelessWidget {
  const _PlaceholderView({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.construction,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            '$title 화면',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '준비 중입니다',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
