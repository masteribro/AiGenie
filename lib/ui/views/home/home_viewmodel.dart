import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final TextEditingController promptController = TextEditingController();
  bool loading = false;
  final GenerativeModel model;
   ChatSession? chat;
   String? aiOutputText;
  String currentTypingText = '';
  HomeViewModel() : model = GenerativeModel(
    model: 'gemini-1.5-pro',
    apiKey: dotenv.env["GOOGLE_API_KEY"] ?? "",
  ) {
    chat = model.startChat();
  }
  Future runStartupLogic() async {

  }

  Future<void> sendMessage(String message) async {
    chat ??= model.startChat();
    loading = true;
    notifyListeners();

    try {
      final response = await chat?.sendMessage(Content.text(message));
      final responseText = response?.text;
      if (responseText != null) {
        currentTypingText = '';
        await typeTextSlowly(responseText);
      }
    } catch (e) {
      print("error msg: $e");
    } finally {
      loading = false;
      notifyListeners();
      promptController.clear();
    }
  }

  Future<void> typeTextSlowly(String text) async {
    currentTypingText = '';
    for (int i = 0; i < text.length; i++) {
      currentTypingText += text[i];
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 20)); // typing speed
    }
  }


}
