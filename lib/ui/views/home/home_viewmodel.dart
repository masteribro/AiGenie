import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../service/ai_service.dart';

class HomeViewModel extends BaseViewModel {
  final _dialogService = locator<DialogService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final TextEditingController promptController = TextEditingController();
  String response = '';
  bool isLoading = false;



  void sendPrompt() async {
    final prompt = promptController.text;
    if (prompt.isEmpty) return;

    isLoading = true;
    notifyListeners();

    final result = await AIService.getResponse(prompt);

    response = result;
    isLoading = false;
    notifyListeners();

  }
// void incrementCounter() {
//   _counter++;
//   rebuildUi();
// }
//
// void showDialog() {
//   _dialogService.showCustomDialog(
//     variant: DialogType.infoAlert,
//     title: 'Stacked Rocks!',
//     description: 'Give stacked $_counter stars on Github',
//   );
// }

// void showBottomSheet() {
//   _bottomSheetService.showCustomSheet(
//     variant: BottomSheetType.notice,
//     title: ksHomeBottomSheetTitle,
//     description: ksHomeBottomSheetDescription,
//   );
// }
}
