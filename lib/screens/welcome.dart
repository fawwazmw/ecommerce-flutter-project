import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../common/colors.dart';
import '../common/common.dart';
import '../common/widgets/no_connectivity.dart';
import 'home/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    if (await getInternetStatus()) {
      Timer(const Duration(seconds: 2), () {
        // Navigate to the home screen after 2 seconds
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
      });
    } else {
      Navigator.of(context, rootNavigator: true)
          .push(
        MaterialPageRoute(
          builder: (context) => const NoConnectivity(),
        ),
      )
          .then(
            (value) => checkConnectivity(),
      );
    }
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: size.height * 0.40,
        ),
        SizedBox(
          width: 130,
          child: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(
          height: size.height * 0.45,
        ),
        Text(
          "Copyright \u00a9 2023",
          style: GoogleFonts.poppins(
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: isLoading
                ? _buildShimmerEffect()
                : _buildContent(size),
          ),
        ),
      ),
    );
  }
}