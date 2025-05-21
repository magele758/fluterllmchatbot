import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config/routes.dart';
import '../config/theme.dart';
import '../models/chat_message.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/chat/chat_input.dart';
import '../widgets/chat/chat_list.dart';
import '../widgets/chat/content_type_selector.dart';

/// Main home screen with chat interface
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContentType _selectedContentType = ContentType.text;

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // App logo
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Deep thinking toggle
            Switch.adaptive(
              value: settingsProvider.deepThinkingEnabled,
              onChanged: (value) {
                settingsProvider.setDeepThinking(value);
              },
              activeColor: AppTheme.primaryColor,
            ),
            const SizedBox(width: 4),
            const Text(
              'Deep Thinking',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          // New conversation button
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: '新对话',
            onPressed: () {
              final chatProvider = Provider.of<ChatProvider>(context, listen: false);
              chatProvider.startNewConversation();
            },
          ),
          // Settings button
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.pushNamed(context, Routes.settings);
            },
          ),
        ],
      ),

      // Main chat interface
      body: Column(
        children: [
          // Content type selector
          ContentTypeSelector(
            selectedType: _selectedContentType,
            onTypeSelected: (type) {
              setState(() {
                _selectedContentType = type;
              });
            },
          ),

          // Chat message list
          const Expanded(
            child: ChatList(),
          ),

          // Input area
          ChatInput(
            contentType: _selectedContentType,
            useDeepThinking: settingsProvider.deepThinkingEnabled,
          ),
        ],
      ),

      // User menu
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // User profile header
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? 'User'),
              accountEmail: Text(user?.email ?? 'AI User'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user?.avatarUrl != null
                    ? NetworkImage(user!.avatarUrl!)
                    : null,
                child: user?.avatarUrl == null
                    ? const Icon(Icons.person, size: 40, color: AppTheme.primaryColor)
                    : null,
              ),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
              ),
            ),

            // Menu items
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Conversation History'),
              onTap: () {
                // TODO: Show conversation history
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}