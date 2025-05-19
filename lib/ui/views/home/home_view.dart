import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('AIGenie',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.chat?.history.length ?? 0,
                      itemBuilder: (context, index) {
                        final contentList = viewModel.chat?.history.toList();
                        final content = contentList?[index];

                        if (content == null) return const SizedBox.shrink();

                        final isUserMessage = content.role == 'user';
                        final textParts = content.parts.whereType<TextPart>().toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: textParts.map((textPart) {
                            final isLastBotResponse = !isUserMessage && index == contentList!.length - 1;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: MarkdownBody(
                                data: isLastBotResponse
                                    ? viewModel.currentTypingText
                                    : textPart.text,
                                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                                  p: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isUserMessage ? FontWeight.bold : FontWeight.normal,
                                    color: isUserMessage ? Colors.blueGrey : null,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),

                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 5, right: 5, top: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: viewModel.promptController,
                      onSubmitted: (String value){
                        viewModel.sendMessage(value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter your prompt...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20,),
                  GestureDetector(
                    onTap: (){
                      viewModel.sendMessage(viewModel.promptController.text);
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      child: const Icon(Icons.send) ,
                    ),
                  ),
                  SizedBox(width: 20,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => SchedulerBinding.instance
      .addPostFrameCallback((timeStamp) => viewModel.runStartupLogic());
}
