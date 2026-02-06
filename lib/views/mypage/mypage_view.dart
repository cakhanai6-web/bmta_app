import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:bmta_app/core/theme/app_theme.dart';

/// SCR-003: 내 정보 페이지 UI
///
/// - 프로필 영역: 원형 아바타 + 닉네임 + 이메일
/// - 포인트 정보 카드: 보유 포인트 + 충전 버튼
/// - 메뉴 리스트: 쪽지함, 설정, 공지사항, 고객센터
/// - 하단: 로그아웃 버튼 + 버전 정보
class MypageView extends StatelessWidget {
  const MypageView({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final theme = Theme.of(context);

    return ListView(
      padding: EdgeInsets.all(spacing.x3), // 24
      children: [
        // 상단 프로필 영역
        _ProfileSection(spacing: spacing, theme: theme),
        SizedBox(height: spacing.x3), // 24

        // 포인트 정보 카드
        _PointCard(spacing: spacing, theme: theme),
        SizedBox(height: spacing.x3), // 24

        // 메뉴 리스트
        _MenuList(spacing: spacing, theme: theme),

        // 로그아웃 버튼
        _LogoutButton(spacing: spacing, theme: theme),

        // 버전 정보
        _VersionInfo(theme: theme),
      ],
    );
  }
}

/// 상단 프로필 영역
class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.spacing,
    required this.theme,
  });

  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacing.x3), // 24
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40), // rounded-[2.5rem]
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // 원형 아바타 (완전한 원)
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              shape: BoxShape.circle, // rounded-full
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                width: 4,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              LucideIcons.user,
              size: 32,
              color: theme.colorScheme.outline,
            ),
          ),
          SizedBox(width: spacing.x3), // 24
          // 닉네임만 표시 (이메일 제거, 본인인증 라벨 제거)
          Expanded(
            child: Text(
              '익명의 승객',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 포인트 정보 카드
class _PointCard extends StatelessWidget {
  const _PointCard({
    required this.spacing,
    required this.theme,
  });

  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacing.x3), // 24
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(40), // rounded-[2.5rem]
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                LucideIcons.coins,
                size: 20,
                color: theme.colorScheme.secondary, // Mobility Amber
              ),
              SizedBox(width: spacing.x1_5), // 12
              Text(
                '보유 포인트',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Text(
            '1,250 P',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/// 메뉴 리스트
class _MenuList extends StatelessWidget {
  const _MenuList({
    required this.spacing,
    required this.theme,
  });

  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem(
        icon: LucideIcons.mail,
        label: '쪽지함',
        onTap: () {
          // UI 뼈대만 구축 (실제 이동 안 함)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('쪽지함 (준비 중)')),
          );
        },
      ),
      _MenuItem(
        icon: LucideIcons.settings,
        label: '설정',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('설정 (준비 중)')),
          );
        },
      ),
      _MenuItem(
        icon: LucideIcons.megaphone,
        label: '공지사항',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('공지사항 (준비 중)')),
          );
        },
      ),
      _MenuItem(
        icon: LucideIcons.headphones,
        label: '고객센터',
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('고객센터 (준비 중)')),
          );
        },
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(40), // rounded-[2.5rem]
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.outline.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == menuItems.length - 1;

          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item.onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.x3, // 24
                      vertical: spacing.x3, // 24
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          size: 20,
                          color: theme.colorScheme.outline,
                        ),
                        SizedBox(width: spacing.x1_5), // 12
                        Expanded(
                          child: Text(
                            item.label,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                        Icon(
                          LucideIcons.chevronRight,
                          size: 16,
                          color: theme.colorScheme.outline.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  thickness: 1,
                  indent: spacing.x3, // 24
                  endIndent: 0,
                  color: theme.colorScheme.outline.withValues(alpha: 0.05),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// 메뉴 아이템 데이터 클래스
class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

/// 로그아웃 버튼 및 버전 정보
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.spacing,
    required this.theme,
  });

  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: spacing.x2), // 16
      child: Column(
        children: [
          // 로그아웃 텍스트 버튼
          TextButton(
            onPressed: () {
              // 로그아웃 로직은 다음 단계에서 구현
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('로그아웃 (로직 미구현)')),
              );
            },
            child: Text(
              '로그아웃',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.outline.withValues(alpha: 0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 버전 정보
class _VersionInfo extends StatelessWidget {
  const _VersionInfo({
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Version 1.0.2 (Build 2602)',
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
