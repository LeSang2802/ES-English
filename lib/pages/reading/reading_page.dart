// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../models/reading/reading.dart';
// import 'reading_controller.dart';
//
// class ReadingPage extends StatelessWidget {
//   const ReadingPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final ReadingController controller = Get.put(ReadingController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Reading"),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.passages.isEmpty) {
//           return const Center(child: Text("No data available"));
//         }
//
//         final currentPassage = controller.passages[controller.currentPassageIndex.value];
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Phần hiển thị đoạn văn
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         currentPassage.title,
//                         style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         currentPassage.content,
//                         style: const TextStyle(fontSize: 18, height: 1.5),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               // Phần câu hỏi
//               const Text(
//                 "Questions:",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               ...currentPassage.questions.asMap().entries.map((entry) {
//                 int qIndex = entry.key;
//                 Question q = entry.value;
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "${qIndex + 1}. ${q.text}",
//                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(height: 12),
//                         ...q.options.asMap().entries.map((optEntry) {
//                           int optIndex = optEntry.key;
//                           Option opt = optEntry.value;
//                           return Obx(() {
//                             bool isSelected = controller.selectedAnswers[qIndex] == optIndex;
//                             bool isCorrect = controller.showResults.value && opt.isCorrect;
//                             bool isWrong = controller.showResults.value && isSelected && !opt.isCorrect;
//                             return RadioListTile<int>(
//                               value: optIndex,
//                               groupValue: controller.selectedAnswers[qIndex],
//                               onChanged: controller.isQuizCompleted.value ? null : (value) => controller.selectAnswer(qIndex, value!),
//                               title: Text(opt.text),
//                               activeColor: isCorrect ? Colors.green : (isWrong ? Colors.red : null),
//                               controlAffinity: ListTileControlAffinity.trailing,
//                             );
//                           });
//                         }).toList(),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//
//               // Nút Submit
//               Obx(() => controller.isQuizCompleted.value
//                   ? ElevatedButton(
//                 onPressed: controller.resetQuiz,
//                 child: const Text("Reset Quiz"),
//               )
//                   : ElevatedButton(
//                 onPressed: controller.submitQuiz,
//                 child: const Text("Submit Answers"),
//               )),
//
//               // Hiển thị kết quả
//               Obx(() => controller.showResults.value
//                   ? Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Card(
//                   color: controller.score.value == currentPassage.questions.length ? Colors.green : Colors.orange,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Text(
//                       "Score: ${controller.score.value}/${currentPassage.questions.length} - ${((controller.score.value / currentPassage.questions.length) * 100).toStringAsFixed(0)}%",
//                       style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                   ),
//                 ),
//               )
//                   : const SizedBox.shrink()),
//
//               const SizedBox(height: 20),
//
//               // Navigation (tương tự flash card)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     onPressed: controller.prevPassage,
//                     icon: const Icon(Icons.arrow_back_ios, size: 32),
//                   ),
//                   Text(
//                     "${controller.currentPassageIndex.value + 1} / ${controller.passages.length}",
//                     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                   ),
//                   IconButton(
//                     onPressed: controller.nextPassage,
//                     icon: const Icon(Icons.arrow_forward_ios, size: 32),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }




//-----------------------------------------

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../models/reading/reading.dart';
// import 'reading_controller.dart';
//
// class ReadingPage extends StatelessWidget {
//   const ReadingPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final ReadingController controller = Get.put(ReadingController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Reading"),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         if (controller.passages.isEmpty) {
//           return const Center(child: Text("Không có dữ liệu"));
//         }
//
//         final currentPassage = controller.passages[controller.currentPassageIndex.value];
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Phần hiển thị đoạn văn
//               Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         currentPassage.title,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueAccent,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         currentPassage.content,
//                         style: const TextStyle(fontSize: 18, height: 1.5),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),
//
//               // Tiêu đề câu hỏi
//               const Text(
//                 "Câu hỏi:",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//
//               // Danh sách câu hỏi trong ListView
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: currentPassage.questions.length + 2, // +2 cho Submit/Reset và Navigation
//                 itemBuilder: (context, index) {
//                   if (index < currentPassage.questions.length) {
//                     final qIndex = index;
//                     final Question q = currentPassage.questions[qIndex];
//                     return Card(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       elevation: 2,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "${qIndex + 1}. ${q.text}",
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 12),
//                             Wrap(
//                               spacing: 16,
//                               runSpacing: 12,
//                               children: q.options.asMap().entries.map((optEntry) {
//                                 final int optIndex = optEntry.key;
//                                 final Option opt = optEntry.value;
//                                 return Obx(() {
//                                   bool isSelected = controller.selectedAnswers[qIndex] == optIndex;
//                                   bool isCorrect = controller.showResults.value && opt.isCorrect;
//                                   bool isWrong = controller.showResults.value && isSelected && !opt.isCorrect;
//                                   return SizedBox(
//                                     width: (MediaQuery.of(context).size.width - 64) / 2, // Chia đôi chiều rộng
//                                     child: RadioListTile<int>(
//                                       value: optIndex,
//                                       groupValue: controller.selectedAnswers[qIndex],
//                                       onChanged: controller.isQuizCompleted.value
//                                           ? null
//                                           : (value) => controller.selectAnswer(qIndex, value!),
//                                       title: Text(
//                                         "${String.fromCharCode(65 + optIndex)}: ${opt.text}", // A, B, C, D
//                                         style: TextStyle(
//                                           fontSize: 16,
//                                           color: isCorrect
//                                               ? Colors.green
//                                               : isWrong
//                                               ? Colors.red
//                                               : null,
//                                         ),
//                                       ),
//                                       contentPadding: EdgeInsets.zero,
//                                       dense: true,
//                                       visualDensity: VisualDensity.compact,
//                                     ),
//                                   );
//                                 });
//                               }).toList(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   } else if (index == currentPassage.questions.length) {
//                     // Nút Submit/Reset
//                     return Obx(() => controller.isQuizCompleted.value
//                         ? ElevatedButton(
//                       onPressed: controller.resetQuiz,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                       ),
//                       child: const Text("Làm lại"),
//                     )
//                         : ElevatedButton(
//                       onPressed: controller.submitQuiz,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                       ),
//                       child: const Text("Nộp bài"),
//                     ));
//                   } else {
//                     // Navigation
//                     return Column(
//                       children: [
//                         const SizedBox(height: 20),
//                         Obx(() => controller.showResults.value
//                             ? Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Card(
//                             color: controller.score.value == currentPassage.questions.length
//                                 ? Colors.green
//                                 : Colors.orange,
//                             child: Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: Text(
//                                 "Điểm: ${controller.score.value}/${currentPassage.questions.length} - ${((controller.score.value / currentPassage.questions.length) * 100).toStringAsFixed(0)}%",
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                             : const SizedBox.shrink()),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             IconButton(
//                               onPressed: controller.prevPassage,
//                               icon: const Icon(Icons.arrow_back_ios, size: 32),
//                             ),
//                             Text(
//                               "${controller.currentPassageIndex.value + 1} / ${controller.passages.length}",
//                               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                             ),
//                             IconButton(
//                               onPressed: controller.nextPassage,
//                               icon: const Icon(Icons.arrow_forward_ios, size: 32),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                       ],
//                     );
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reading/reading.dart';
import 'reading_controller.dart';

class ReadingPage extends StatelessWidget {
  const ReadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ReadingController controller = Get.put(ReadingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.passages.isEmpty) {
          return const Center(child: Text("Không có dữ liệu"));
        }

        final currentPassage = controller.passages[controller.currentPassageIndex.value];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần hiển thị đoạn văn
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentPassage.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        currentPassage.content,
                        style: const TextStyle(fontSize: 18, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Câu hỏi:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Phần câu hỏi trong ListView
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: currentPassage.questions.length + 2, // +2 cho Submit/Reset và Navigation
                itemBuilder: (context, index) {
                  if (index < currentPassage.questions.length) {
                    final qIndex = index;
                    final Question q = currentPassage.questions[qIndex];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${qIndex + 1}. ${q.text}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 16,
                              runSpacing: 12,
                              children: q.options.asMap().entries.map((optEntry) {
                                final int optIndex = optEntry.key;
                                final Option opt = optEntry.value;
                                return Obx(() {
                                  bool isSelected = controller.selectedAnswers[qIndex] == optIndex;
                                  bool isCorrect = controller.showResults.value && opt.isCorrect;
                                  bool isWrong = controller.showResults.value && isSelected && !opt.isCorrect;
                                  return SizedBox(
                                    width: (MediaQuery.of(context).size.width - 64) / 2, // Chia đôi chiều rộng
                                    child: RadioListTile<int>(
                                      value: optIndex,
                                      groupValue: controller.selectedAnswers[qIndex],
                                      onChanged: controller.isQuizCompleted.value
                                          ? null
                                          : (value) => controller.selectAnswer(qIndex, value!),
                                      title: Text(
                                        "${String.fromCharCode(65 + optIndex)}: ${opt.text}", // A, B, C, D
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isCorrect
                                              ? Colors.green
                                              : isWrong
                                              ? Colors.red
                                              : null,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      dense: true,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (index == currentPassage.questions.length) {
                    // Nút Submit/Reset
                    return Obx(() => controller.isQuizCompleted.value
                        ? ElevatedButton(
                      onPressed: controller.resetQuiz,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: const Text("Làm lại"),
                    )
                        : ElevatedButton(
                      onPressed: controller.submitQuiz,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: const Text("Nộp bài"),
                    ));
                  } else {
                    // Navigation và điểm số
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Obx(() => controller.showResults.value
                            ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: Card(
                            color: controller.score.value == currentPassage.questions.length
                                ? Colors.green
                                : Colors.orange,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "Điểm: ${controller.score.value}/${currentPassage.questions.length} - ${((controller.score.value / currentPassage.questions.length) * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                            : const SizedBox.shrink()),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: controller.prevPassage,
                              icon: const Icon(Icons.arrow_back_ios, size: 32),
                            ),
                            Text(
                              "${controller.currentPassageIndex.value + 1} / ${controller.passages.length}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                              onPressed: controller.nextPassage,
                              icon: const Icon(Icons.arrow_forward_ios, size: 32),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}


//  luồng xử lý chọn áp án:
//
// API trả về content, questions, mỗi câu hỏi có options, correctIndex.
//
// Model ánh xạ dữ liệu đó vào app.
//
// UI hiển thị câu hỏi + danh sách đáp án để chọn.
//
// Controller giữ state (câu hiện tại, đáp án người dùng chọn).
//
// Logic so sánh selectedIndex == correctIndex để check đúng/sai, lưu kết quả.
//
//  cần thay dữ liệu mock bằng API thật là chạy được.