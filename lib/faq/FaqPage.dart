import 'package:flutter/material.dart';

class FAQItemData {
  final String question;
  final String answer;
  bool isOpen;

  FAQItemData({
    required this.question,
    required this.answer,
    this.isOpen = false,
  });
}

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  List<FAQItemData> faqList = [
    FAQItemData(
      question: "Apa itu Pakailagi.id?",
      answer:
      "Pakailagi.id adalah aplikasi untuk menjual dan membeli fashion preloved (thrift) yang masih layak pakai untuk mengurangi limbah tekstil.",
    ),
    FAQItemData(
      question: "Pakaian apa saja yang bisa saya buang?",
      answer:
      "Anda bisa membuang pakaian yang sudah tidak bisa dipakai kembali atau tidak layak dijual.",
    ),
    FAQItemData(
      question: "Bagaimana cara menjual pakaian bekas?",
      answer:
      "Hubungi whatsapp admin yang tertera dihalaman profil",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "FAQ",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemBuilder: (context, index) {
          return FAQItem(
            data: faqList[index],
            onToggle: () {
              setState(() {
                faqList[index].isOpen = !faqList[index].isOpen;
              });
            },
          );
        },
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final FAQItemData data;
  final VoidCallback onToggle;

  const FAQItem({
    super.key,
    required this.data,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    data.question,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: data.isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),

        // ANSWER
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              data.answer,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          crossFadeState: data.isOpen
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),

        // LINE SEPARATOR
        Container(
          height: 1,
          color: Colors.grey.shade300,
        )
      ],
    );
  }
}
