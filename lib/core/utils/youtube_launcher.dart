import 'package:url_launcher/url_launcher.dart';

class YoutubeLauncher {
  static Future<bool> launchVideo(String videoKey) async {
    // YouTube app deep link (opens in app if installed)
    final youtubeAppUrl = Uri.parse('vnd.youtube://$videoKey');
    // YouTube web URL (fallback)
    final youtubeWebUrl = Uri.parse(
      'https://www.youtube.com/watch?v=$videoKey',
    );

    try {
      // Try to open in YouTube app first
      if (await canLaunchUrl(youtubeAppUrl)) {
        return await launchUrl(
          youtubeAppUrl,
          mode: LaunchMode.externalApplication,
        );
      }

      // Fallback to browser
      return await launchUrl(
        youtubeWebUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      // If all fails, try web URL as last resort
      return await launchUrl(
        youtubeWebUrl,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  /// Launch YouTube video with error handling
  static Future<void> launchVideoSafe(
    String videoKey, {
    Function(String)? onError,
  }) async {
    try {
      final success = await launchVideo(videoKey);
      if (!success) {
        onError?.call('Could not open YouTube video');
      }
    } catch (e) {
      onError?.call('Error opening video: $e');
    }
  }
}
