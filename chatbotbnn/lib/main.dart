import 'package:chatbotbnn/page/slaps_page.dart';
import 'package:chatbotbnn/provider/chat_provider.dart';
import 'package:chatbotbnn/provider/chatbot_provider.dart';
import 'package:chatbotbnn/provider/chatbotcolors_provider.dart';
import 'package:chatbotbnn/provider/config_chat_provider.dart';
import 'package:chatbotbnn/provider/historyid_provider.dart';
import 'package:chatbotbnn/provider/navigation_provider.dart';
import 'package:chatbotbnn/provider/provider_color.dart';
import 'package:chatbotbnn/provider/selected_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Providercolor()),
      ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ChangeNotifierProvider(create: (_) => ChatbotProvider()),
      ChangeNotifierProvider(create: (_) => ChatbotcolorsProvider()),
      ChangeNotifierProvider(create: (_) => HistoryidProvider()),
      ChangeNotifierProvider(create: (_) => ChatbotProvider()),
      ChangeNotifierProvider(create: (_) => ChatProvider()),
      ChangeNotifierProvider(create: (_) => SelectedHistoryProvider()),
      ChangeNotifierProvider(create: (_) => ConfigChatProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat Bot',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const SlapsPage());
  }
}
