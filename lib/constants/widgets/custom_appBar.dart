import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parking_4/constants/apiKey.dart';
import 'package:parking_4/profile/cubit.dart';
import 'package:parking_4/profile/profileStates.dart';
import 'package:parking_4/profile/unauthprofile.dart';
import 'package:parking_4/profile/profile.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? _cachedImage;

  @override
  void initState() {
    super.initState();
    _fetchAndCacheUserImage();
  }

  Future<void> _fetchAndCacheUserImage() async {
    final cubit = context.read<UserCubit>();
    await cubit.fetchUserData();

    if (cubit.state is UserLoaded) {
      final userImage = (cubit.state as UserLoaded).user.image;
      if (userImage != null && userImage.isNotEmpty) {
        final imageUrl = "$baseUrl/$userImage";
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("profile_image", imageUrl);
        setState(() {
          _cachedImage = imageUrl;
        });
      }
    }
  }

  Future<bool> _isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getString("token") != null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Material(
        color: Colors.white,
        shadowColor: Colors.grey,
        elevation: 7,
        child: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/logo1.png",
                      fit: BoxFit.fill,
                      height: 30,
                      width: 130,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      bool isLoggedIn = await _isUserLoggedIn();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => isLoggedIn
                              ? const ProfilScreen()
                              : const UnAthProfile(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: _cachedImage != null
                            ? NetworkImage(_cachedImage!)
                            : null,
                        child: _cachedImage == null
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
