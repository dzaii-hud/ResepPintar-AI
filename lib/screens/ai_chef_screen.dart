import 'package:flutter/material.dart';
import 'package:reseppintar_ai/utils/app_colors.dart'; // Sesuaikan path-nya ya
import 'dart:convert';
import 'package:http/http.dart' as http;

class AiChefScreen extends StatefulWidget {
  const AiChefScreen({super.key});

  @override
  State<AiChefScreen> createState() => _AiChefScreenState();
}

// 1. Tambahin "with AutomaticKeepAliveClientMixin" di sini biar kaga pikun
class _AiChefScreenState extends State<AiChefScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _chatController = TextEditingController();
  bool _isLoading = false;

  // Variabel buat nampung chat
  List<Map<String, dynamic>> _messages = [];

  // 2. Ini wajib di-set "true" biar memori layarnya dipertahankan
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Panggil pesan sambutan pertama kali
    _setInitialMessage();
  }

  void _setInitialMessage() {
    _messages = [
      {
        'isUser': false,
        'text':
            "Halo Chef! 👨‍🍳\nAda bahan apa aja di kulkas hari ini? Biar aku bantu racikin resep rahasianya!",
        'isRecipe': false, // <-- Tambahin ini
      },
    ];
  }

  // ==========================================
  // FUNGSI BUAT TOMBOL SAPU JAGAT (CLEAR CHAT)
  // ==========================================
  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFCF8F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Mulai Sesi Baru?",
          style: TextStyle(
            color: Color(0xFF4A3728),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Semua obrolan resep di atas bakal dibersihkan. Lanjut?",
          style: TextStyle(color: Color(0xFF4A3728)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Tutup pop-up
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
              setState(() {
                _setInitialMessage(); // Balikin ke pesan pertama alias reset
              });
              Navigator.pop(context); // Tutup pop-up
            },
            child: const Text(
              "Bersihkan",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'isUser': true, 'text': text});
      _chatController.clear();
      _isLoading = true;
    });

    // IP Laptop lu yang udah disesuaikan
    final String apiUrl = 'http://192.168.0.232:8000/api/ai-chef';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'message': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // TAMBAHIN 'isRecipe': true DI SINI
          _messages.add({
            'isUser': false,
            'text': data['reply'],
            'isRecipe': true,
          });
        });
      } else {
        setState(() {
          _messages.add({
            'isUser': false,
            'text':
                'Waduh, server Laravel-nya error nih bre. Status: ${response.statusCode}',
            'isRecipe': false, // TAMBAHIN INI JUGA
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'isUser': false,
          'text': 'Gagal nyambung ke dapur. Cek koneksi lu ya!\nError: $e',
          'isRecipe': false, // DAN TAMBAHIN INI JUGA
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveRecipeToDatabase(String fullText) async {
    // 1. Kita belah teksnya. Baris pertama (emoji) dipisah dari isi resepnya
    final lines = fullText.trim().split('\n');
    final String emoji = lines.isNotEmpty ? lines.first.trim() : '🤖';

    // Sisa barisnya digabungin lagi jadi isi resep
    final String recipeContent = lines.length > 1
        ? lines.sublist(1).join('\n').trim()
        : fullText;

    // Pastikan IP ini sesuai sama yang di _sendMessage lu (192.168.0.232)
    final String apiUrl = 'http://192.168.0.232:8000/api/ai-chef/save';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'emoji': emoji, 'content': recipeContent}),
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Berhasil! Resep AI udah masuk Database! ❤️'),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal nyimpen nih. Status: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error jaringan pas nyimpen: $e')));
    }
  }

  void _editMessageDialog(int index) {
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
            maxLines: null,
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
              onPressed: () => Navigator.pop(context),
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
                setState(
                  () => _messages[index]['text'] = editController.text.trim(),
                );
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
    // 3. Wajib panggil ini di dalam build kalau pakai AutomaticKeepAliveClientMixin
    super.build(context);

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
        actions: [
          // 4. Tombol Sapu Jagat (Refresh / Clear)
          IconButton(
            icon: const Icon(
              Icons.cleaning_services_rounded,
              color: AppColors.primaryColor,
            ),
            tooltip: 'Bersihkan Obrolan',
            onPressed: _clearChat,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(4),
                        ),
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Chef AI sedang meracik resep...",
                            style: TextStyle(
                              color: Color(0xFF4A3728),
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final msg = _messages[index];
                final isUser = msg['isUser'];

                return GestureDetector(
                  onLongPress: () {
                    if (isUser) _editMessageDialog(index);
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
                      child: Column(
                        crossAxisAlignment: isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg['text'],
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : const Color(0xFF4A3728),
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                          if (!isUser && msg['isRecipe'] == true) ...[
                            // <-- UBAH BARIS INI DOANG
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                onTap: () {
                                  // Panggil fungsi simpan ke database dan kirim teks resepnya
                                  _saveRecipeToDatabase(msg['text']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        color: AppColors.primaryColor,
                                        size: 18,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "Simpan",
                                        style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
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
                        onSubmitted: (value) {
                          if (!_isLoading) _sendMessage();
                        },
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
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                      onPressed: _isLoading ? null : _sendMessage,
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
