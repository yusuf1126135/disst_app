import 'package:flutter/material.dart';

const Color disstPurple = Color(0xFF6C3BFF);
const Color disstBlue = Color(0xFF2D9CFF);
const Color disstBlack = Color(0xFF121212);
const Color disstWhite = Color(0xFFFFFFFF);
const Color disstSecondary = Color(0xFF667085);
const Color disstBorder = Color(0xFFE3E1F5);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: disstWhite,
      appBar: AppBar(
        backgroundColor: disstWhite,
        foregroundColor: disstBlack,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: disstBlack,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _buildWelcomeCard(),
            const SizedBox(height: 22),

            _sectionTitle('Overview'),
            const SizedBox(height: 10),
            _buildOverviewGrid(),

            const SizedBox(height: 24),

            _sectionTitle('Content'),
            const SizedBox(height: 10),
            _buildDashboardItem(
              icon: Icons.article_outlined,
              iconColor: disstPurple,
              title: 'Posts',
              subtitle: 'Manage and review your posts',
            ),
            _buildDashboardItem(
              icon: Icons.movie_outlined,
              iconColor: disstBlue,
              title: 'Reels',
              subtitle: 'View your Reels performance',
            ),
            _buildDashboardItem(
              icon: Icons.live_tv_outlined,
              iconColor: Colors.redAccent,
              title: 'Live',
              subtitle: 'Manage your live content',
            ),

            const SizedBox(height: 24),

            _sectionTitle('Analytics'),
            const SizedBox(height: 10),
            _buildDashboardItem(
              icon: Icons.bar_chart_rounded,
              iconColor: disstPurple,
              title: 'Analytics',
              subtitle: 'Understand your audience and content',
            ),
            _buildDashboardItem(
              icon: Icons.visibility_outlined,
              iconColor: disstBlue,
              title: 'Reach & Views',
              subtitle: 'See how people discover your content',
            ),
            _buildDashboardItem(
              icon: Icons.trending_up_rounded,
              iconColor: Colors.green,
              title: 'Followers Growth',
              subtitle: 'Track your audience growth',
            ),

            const SizedBox(height: 24),

            _sectionTitle('Monetization'),
            const SizedBox(height: 10),
            _buildMonetizationCard(),

            const SizedBox(height: 24),

            _sectionTitle('Account Status'),
            const SizedBox(height: 10),
            _buildAccountStatusCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            disstPurple,
            disstBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage your content, audience and creator tools.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: disstBlack,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.65,
      children: [
        _buildStatCard(
          icon: Icons.people_outline,
          label: 'Followers',
          value: '0',
          color: disstPurple,
        ),
        _buildStatCard(
          icon: Icons.person_add_alt_1_outlined,
          label: 'Following',
          value: '0',
          color: disstBlue,
        ),
        _buildStatCard(
          icon: Icons.favorite_border,
          label: 'Likes',
          value: '0',
          color: Colors.redAccent,
        ),
        _buildStatCard(
          icon: Icons.visibility_outlined,
          label: 'Views',
          value: '0',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: disstBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 25,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: disstBlack,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: disstSecondary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: disstBorder,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 23,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: disstBlack,
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: disstSecondary,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: disstSecondary,
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildMonetizationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F7FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: disstBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      disstPurple,
                      disstBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monetization',
                      style: TextStyle(
                        color: disstBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Grow your account to unlock earning tools.',
                      style: TextStyle(
                        color: disstSecondary,
                        fontSize: 12.5,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: disstSecondary,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0,
              minHeight: 7,
              backgroundColor: Color(0xFFE7E3FF),
              valueColor: AlwaysStoppedAnimation<Color>(
                disstPurple,
              ),
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Not eligible yet',
            style: TextStyle(
              color: disstBlack,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Eligibility requirements will be shown here when monetization is available.',
            style: TextStyle(
              color: disstSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: disstBorder,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: Colors.green,
            size: 27,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Account Standing',
                  style: TextStyle(
                    color: disstBlack,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Your account is currently in good standing.',
                  style: TextStyle(
                    color: disstSecondary,
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: disstSecondary,
          ),
        ],
      ),
    );
  }
}