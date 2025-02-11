import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/provider/auth_provider.dart';

class StutasPage extends StatefulWidget {
  const StutasPage({super.key});

  @override
  State<StutasPage> createState() => _StutasPageState();
}

class _StutasPageState extends State<StutasPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProviderIn>(context, listen: false).getProfileData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderIn>(
      builder: (context, authProvider, child) {
        return Scaffold(
          body: authProvider.isLoding
              ? const Center(child: CircularProgressIndicator())
              : authProvider.profileData.isEmpty
                  ? const Center(child: Text('No numbers found.'))
                  : ListView.builder(
                      itemCount: authProvider.profileData.length,
                      itemBuilder: (context, index) {
                        final data = authProvider.profileData[index];
                        return ListTile(
                          title: Text('${data.userPhone}'),
                        );
                      },
                    ),
        );
      },
    );
  }
}
