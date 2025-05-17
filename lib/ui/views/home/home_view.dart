import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Prompt App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: viewModel.promptController,
              decoration: const InputDecoration(
                labelText: 'Enter your prompt...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: viewModel.isLoading ? null : viewModel.sendPrompt,
              child: viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Send'),
            ),
            const SizedBox(height: 24),
            if (viewModel.response.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    viewModel.response,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
