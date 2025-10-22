import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:es_english/cores/constants/colors.dart';
import 'package:es_english/cores/widgets/base_app_bar.dart';
import 'package:es_english/cores/widgets/base_page.dart';
import 'profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePage(
      isLoading: controller.isLoading,
      appBar: BaseAppBar(title: 'personal_profile'.tr),
      body: Obx(() {
        final u = controller.user.value;
        if (u == null) {
          return Center(child: Text('no_data'.tr));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  // mở chọn ảnh
                },
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: (u.avatarUrl != null &&
                      u.avatarUrl!.isNotEmpty)
                      ? NetworkImage(u.avatarUrl!)
                      : null,
                  backgroundColor: Colors.grey.shade300,
                  child: (u.avatarUrl == null || u.avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 45)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildField('name'.tr, u.fullName ?? "", (v) {
                controller.user.value = u.copyWith(fullName: v);
              }),
              _buildGenderField(u.gender ?? "", (v) {
                controller.user.value = u.copyWith(gender: v);
              }),
              _buildField('age'.tr, u.age?.toString() ?? "", (v) {
                controller.user.value = u.copyWith(age: int.tryParse(v));
              }),
              _buildField('job'.tr, u.occupation ?? "", (v) {
                controller.user.value = u.copyWith(occupation: v);
              }),
              _buildField('avatar_url'.tr, u.avatarUrl ?? "", (v) {
                controller.user.value = u.copyWith(avatarUrl: v);
              }),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton.icon(
                onPressed: controller.isSaving.value
                    ? null
                    : controller.saveProfile,
                icon: controller.isSaving.value
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
                    : const Icon(Icons.save),
                label: Text('save_change'.tr , style: TextStyle(color : TextColors.appBar)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(48),
                ),
              )),
            ],
          ),
        );
      }),
    );
  }

  // TextField cơ bản
  Widget _buildField(String label, String value, Function(String) onChanged) {
    final textCtrl = TextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: textCtrl,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }

  // Dropdown chọn giới tính
  Widget _buildGenderField(String value, Function(String) onChanged) {
    final genders = ["MALE", "FEMALE", "OTHER"];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InputDecorator(
        decoration:  InputDecoration(
          labelText: 'sex'.tr,
          border: OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: genders.contains(value) ? value : "OTHER",
            items: genders
                .map((g) => DropdownMenuItem<String>(
              value: g,
              child: Text(g == "MALE"
                  ? 'male'.tr
                  : g == "FEMALE"
                  ? 'female'.tr
                  : 'other'.tr),
            ))
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ),
    );
  }
}
