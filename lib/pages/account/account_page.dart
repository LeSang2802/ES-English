import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../cores/constants/colors.dart';
import '../../cores/constants/dimens.dart';
import '../../cores/constants/text_styles.dart';
import '../../cores/widgets/base_bottom_nav.dart';
import '../../cores/widgets/base_page.dart';
import 'account_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AccountController>();

    return BasePage(
      isLoading: false.obs,
      isNestedScroll: false,
      appBar: _buildAccountAppBar(context, c),
      bottomNavigationBar: BaseBottomNav(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Get.offAllNamed('/home');
              break;
            case 1:
              Get.offAllNamed('/skill');
              break;
            case 2:
              Get.offAllNamed('/progress');
              break;
            case 3:
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.bottom,
        elevation: 3,
        shape: const CircleBorder(),
        onPressed: () => Get.toNamed('/search'),
        child: const Icon(Icons.search, color: AppColors.primary, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: MarginDimens.large,
          right: MarginDimens.large,
          bottom: MarginDimens.large + 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _learnedTodayCard(c),
            const SizedBox(height: 16),
            _settingTileProfile(c),
            const SizedBox(height: 12),
            _settingTileResetPassword(c),
            const SizedBox(height: 12),
            _settingTileLanguage(c),
            // const SizedBox(height: 12),
            // _settingTileDarkMode(c),
            const SizedBox(height: 12),
            _settingTileLogout(c),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAccountAppBar(
      BuildContext context, AccountController c) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(160),
      child: Container(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: BgColors.appBar,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      (c.avatarUrl != null && c.avatarUrl!.isNotEmpty)
                          ? NetworkImage(c.avatarUrl!)
                          : null,
                  child: (c.avatarUrl == null || c.avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 40, color: Colors.blue)
                      : null,
                ),
                const SizedBox(height: 10),
                Text(
                  '${'homepage_greetings'.tr}, ${c.displayName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'welcome_back'.tr,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _learnedTodayCard(AccountController c) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(RadiusDimens.large),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('learned_this_week'.tr,
                      style: TextStyles.small.copyWith(color: Colors.grey[600])),
                  // Text('My courses', style: TextStyles.smallBold.copyWith(color: AppColors.primary)),
                ],
              ),
              SizedBox(height: MarginDimens.reading),
              Row(
                children: [
                  Text('${c.learnedThisWeek.value} ${'min'.tr}',
                      style: TextStyles.largeBold),
                  const SizedBox(width: 6),
                  Text('/ ${c.targetWeek.value} ${'min'.tr}',
                      style:
                          TextStyles.small.copyWith(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: c.progressWeek,
                  minHeight: 6,
                  color: AppColors.primary,
                  backgroundColor: AppColors.primary.withOpacity(0.15),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _settingTileProfile(AccountController c) {
    return _settingCard(
      icon: Icons.person_outline_rounded,
      title: 'edit_profile'.tr,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () => Get.toNamed('/profile'),
    );
  }

  Widget _settingTileResetPassword(AccountController c) {
    return _settingCard(
      icon: Icons.lock_reset_rounded,
      title: 'change_password'.tr,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () => Get.toNamed('/reset_password'),
    );
  }

  Widget _settingTileLanguage(AccountController c) {
    final GlobalKey btnKey = GlobalKey();
    return _settingCard(
      icon: Icons.translate_rounded,
      title: 'language'.tr,
      trailing: Builder(
        builder: (ctx) => InkWell(
          key: btnKey,
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final RenderBox box =
                btnKey.currentContext!.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(ctx).context.findRenderObject() as RenderBox;
            final Offset pos =
                box.localToGlobal(Offset.zero, ancestor: overlay);
            final RelativeRect position = RelativeRect.fromLTRB(
              pos.dx,
              pos.dy + box.size.height + 6,
              overlay.size.width - pos.dx - box.size.width,
              0,
            );

            final selected = await showMenu<String>(
              context: ctx,
              position: position,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              items: [
                PopupMenuItem(
                  value: 'en',
                  child: Row(
                    children: [
                      const Text('E :  ',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      Text('english'.tr),
                      const Spacer(),
                      if (c.currentLangCode == 'en')
                        const Icon(Icons.check, size: 18),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'vi',
                  child: Row(
                    children: [
                      const Text('V :  ',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 6),
                      Text('vietnamese'.tr),
                      const Spacer(),
                      if (c.currentLangCode == 'vi')
                        const Icon(Icons.check, size: 18),
                    ],
                  ),
                ),
              ],
            );

            if (selected != null && selected != c.currentLangCode) {
              c.changeLanguage(selected);
            }
          },
          child: Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      c.currentLangCode.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget _settingTileDarkMode(AccountController c) {
    return Obx(() => _settingCard(
          icon: Icons.dark_mode_outlined,
          title: 'dark_mode'.tr,
          trailing: Switch(
            value: c.isDarkMode.value,
            onChanged: c.toggleDarkMode,
          ),
        ));
  }

  Widget _settingTileLogout(AccountController c) {
    return _settingCard(
      icon: Icons.logout_rounded,
      title: 'logout'.tr,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () async {
        await c.logout();
      },
    );
  }

  Widget _settingCard({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(RadiusDimens.normal),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(RadiusDimens.normal),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MarginDimens.large,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(title, style: TextStyles.mediumBold),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }
}
