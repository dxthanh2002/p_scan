import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'setting_viewmodel.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final SettingViewModel _viewModel = SettingViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChange);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChange);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              children: [
                _buildProBanner(),
                const SizedBox(height: 24),
                _buildMenuItem(
                  title: 'Restore purchases',
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Start app with camera',
                  trailing: CupertinoSwitch(
                    value: _viewModel.startAppWithCamera,
                    onChanged: _viewModel.toggleStartAppWithCamera,
                    activeColor: const Color(0xFF0066FF),
                  ),
                ),
                _buildMenuItem(
                  title: 'Auto-capture',
                  trailing: CupertinoSwitch(
                    value: _viewModel.autoCapture,
                    onChanged: _viewModel.toggleAutoCapture,
                    activeColor: const Color(0xFF0066FF),
                  ),
                ),
                _buildMenuItem(
                  title: 'Default Filter',
                  trailing: const Text(
                    'Document',
                    style: TextStyle(
                      color: Color(0xFF1A87FF),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'High Quality',
                  isPremium: true,
                  trailing: CupertinoSwitch(
                    value: _viewModel.highQuality,
                    onChanged: _viewModel.toggleHighQuality,
                    activeColor: const Color(0xFF0066FF),
                  ),
                ),
                _buildMenuItem(
                  title: 'Contact Us',
                  titleColor: const Color(0xFF1A87FF),
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Terms of Use',
                  titleColor: const Color(0xFF1A87FF),
                  onTap: () {},
                ),
                _buildMenuItem(
                  title: 'Privacy Policy',
                  titleColor: const Color(0xFF1A87FF),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 32),
            child: Text(
              'App version 2.3.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF33A1FF), Color(0xFF0066FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA000),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Get Pro!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Enjoy 10+ benefits',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0066FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 0,
            ),
            child: const Text(
              'Upgrade',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    Widget? trailing,
    Color titleColor = const Color(0xFF2D3748),
    bool isPremium = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isPremium) ...[
              const SizedBox(width: 4),
              Transform.translate(
                offset: const Offset(0, -6),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFFF9800), width: 2),
                  ),
                ),
              ),
            ],
            const Spacer(),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}
