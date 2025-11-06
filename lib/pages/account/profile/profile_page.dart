import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        return Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: null,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 45,
                              backgroundImage: (u.avatarUrl != null &&
                                  u.avatarUrl!.isNotEmpty)
                                  ? NetworkImage(u.avatarUrl!)
                                  : null,
                              backgroundColor: Colors.grey.shade300,
                              child: (u.avatarUrl == null ||
                                  u.avatarUrl!.isEmpty)
                                  ? const Icon(Icons.person, size: 45)
                                  : null,
                            ),
                            if (controller.isUploadingAvatar.value)
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() => ElevatedButton.icon(
                        onPressed: controller.isUploadingAvatar.value
                            ? null
                            : controller.pickAndUploadAvatar,
                        icon: const Icon(Icons.photo_camera,
                            color: TextColors.appBar, size: 18),
                        label: Text(
                          controller.isUploadingAvatar.value
                              ? "${'loading'.tr} ..."
                              : 'change_photo'.tr,
                          style: TextStyle(color: TextColors.appBar),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          controller.isUploadingAvatar.value
                              ? Colors.grey
                              : AppColors.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Họ tên với validation
                _buildField(
                  'name'.tr,
                  controller.fullNameController,
                      (v) {
                    controller.user.value = u.copyWith(fullName: v);
                  },
                  validator: controller.validateFullName,
                ),

                // Giới tính
                _buildGenderField(u.gender ?? "", (v) {
                  controller.user.value = u.copyWith(gender: v);
                }),

                // Tuổi với validation
                _buildField(
                  'age'.tr,
                  controller.ageController,
                      (v) {
                    controller.user.value = u.copyWith(age: int.tryParse(v));
                  },
                  validator: controller.validateAge,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                // Nghề nghiệp với validation
                _buildField(
                  'job'.tr,
                  controller.occupationController,
                      (v) {
                    controller.user.value = u.copyWith(occupation: v);
                  },
                  validator: controller.validateOccupation,
                ),

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
                      : Icon(Icons.save, color: TextColors.appBar),
                  label: Text('save_change'.tr,
                      style: TextStyle(color: TextColors.appBar)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(48),
                  ),
                )),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildField(
      String label,
      TextEditingController controller,
      Function(String) onChanged, {
        String? Function(String?)? validator,
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primary),
          ),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        ),
        onChanged: onChanged,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
      ),
    );
  }

  Widget _buildGenderField(String value, Function(String) onChanged) {
    final genders = ["MALE", "FEMALE"];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'sex'.tr,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.primary),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: genders.contains(value) ? value : "MALE",
            items: genders
                .map((g) => DropdownMenuItem<String>(
              value: g,
              child: Text(
                g == "MALE" ? 'male'.tr : 'female'.tr,
              ),
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
