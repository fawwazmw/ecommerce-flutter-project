import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/colors.dart';
import '../../models/news_model.dart';

class NewsInfo extends StatefulWidget {
  final News news;

  const NewsInfo({
    super.key,
    required this.news,
  });

  @override
  State<NewsInfo> createState() => _NewsInfoState();
}

class _NewsInfoState extends State<NewsInfo> {
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 200,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: AppColors.black,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_sharp,
              color: AppColors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Image.network(
                widget.news.urlToImage ?? '', // Provide a fallback empty string or default image
                fit: BoxFit.contain,
                width: size.width,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: size.width,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                  );
                },
                frameBuilder: (BuildContext context, Widget child, int? frame,
                    bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  if (frame == null) {
                    return _buildImageShimmer();
                  }
                  return child;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: 8,
                  right: 8,
                ),
                child: Column(
                  children: [
                    Text(
                      widget.news.title?.toString() ?? 'No Title',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: AppColors.black,
                              size: 20,
                            ),
                            SizedBox(
                              width: size.width / 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.news.author?.toString() ?? 'Unknown Author',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              color: AppColors.black,
                              size: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                              ),
                              child: Text(
                                    () {
                                  try {
                                    return Jiffy.parse(
                                      widget.news.publishedAt.toString(),
                                    ).fromNow().toString();
                                  } catch (e) {
                                    return 'Date unavailable';
                                  }
                                }(),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.news.content?.toString() ?? 'No content available',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  if (widget.news.url != null) {
                    _launchInBrowser(Uri.parse(widget.news.url!));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "View full article",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.black,
                      size: 14,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.facebook,
                      size: 26,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.email_outlined,
                      size: 26,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.wechat_sharp,
                      size: 26,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}