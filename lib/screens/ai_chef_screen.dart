import 'package:flutter/material.dart';
import 'package:reseppintar_ai/utils/app_colors.dart'; // Sesuaikan path-nya ya

class AiChefScreen extends StatefulWidget {
  const AiChefScreen({super.key});

  @override
  State<AiChefScreen> createState() => _AiChefScreenState();
}

class _AiChefScreenState extends State<AiChefScreen> {
  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isUser': false,
      'text':
          "Halo Chef! 👨‍🍳\nAda bahan apa aja di kulkas hari ini? Biar aku bantu racikin resep rahasianya!",
    },
  ];

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({'isUser': true, 'text': _chatController.text.trim()});
      _chatController.clear();
    });
  }

  // ==========================================
  // FUNGSI BUAT MUNCULIN POP-UP EDIT PESAN
  // ==========================================
  void _editMessageDialog(int index) {
    // Kita bikin controller baru khusus buat dialog edit, diisi teks yang lama
    TextEditingController editController = TextEditingController(
      text: _messages[index]['text'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFFCF8F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Edit Pesan",
            style: TextStyle(
              color: Color(0xFF4A3728),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: editController,
            maxLines: null, // Biar bisa banyak baris kalau pesannya panjang
            style: const TextStyle(color: Color(0xFF4A3728)),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primaryColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Tutup pop-up kalau batal
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Update teksnya dan tutup pop-up
                setState(() {
                  _messages[index]['text'] = editController.text.trim();
                });
                Navigator.pop(context);
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF8F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF8F3),
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: AppColors.primaryColor, size: 28),
            SizedBox(width: 12),
            Text(
              'AI Chef',
              style: TextStyle(
                color: Color(0xFF4A3728),
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'];

                // ==========================================
                // BUBBLE CHAT DIBUNGKUS GESTURE DETECTOR
                // ==========================================
                return GestureDetector(
                  onLongPress: () {
                    // Cuma pesan user (isUser == true) yang bisa diedit
                    if (isUser) {
                      _editMessageDialog(index);
                    }
                  },
                  child: Align(
                    alignment: isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? AppColors.primaryColor : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 20),
                        ),
                        border: isUser
                            ? null
                            : Border.all(
                                color: AppColors.primaryColor.withOpacity(0.3),
                              ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        msg['text'],
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : const Color(0xFF4A3728),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCF8F3),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _chatController,
                        style: const TextStyle(color: Color(0xFF4A3728)),
                        decoration: const InputDecoration(
                          hintText: 'Misal: Aku punya telur dan bayam...',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                        onSubmitted: (value) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
