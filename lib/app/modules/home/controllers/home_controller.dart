import 'dart:io';

import 'package:add_voice_over_video_feature/core/print_logger.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  late File audioFile;
  late File videoFile;
  String? videoUrlName;
  String? audioUrlName;
  String? outputUrlName;
  // final String outputUrl =
  final String outputUrl =
      // '/storage/emulated/0/Documents/output.mp4';
      '/data/user/0/com.example.add_voice_over_video_feature/cache/file_picker/dss.mp4';
  VideoPlayerController? videoController;

  // final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> pickAudio() async {
    FilePickerResult? audioResult = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      // type: FileType.custom,
      // allowedExtensions: ['aac','mp3'],
    );
    if (audioResult != null) {
      audioFile = File(audioResult.files.single.path ?? "");

      coloredPrint(msg: "file $audioFile");
      audioUrlName = audioFile.path;
      coloredPrint(msg: "file $audioUrlName");
      update();
    } else {
      // User canceled the picker

    }
  }

  Future<void> pickVideo() async {
    FilePickerResult? videoResult = await FilePicker.platform.pickFiles(
      type: FileType.video,
      // type: FileType.custom,
      // allowedExtensions: ['mp4'],
    );
    if (videoResult != null) {
      videoFile = File(videoResult.files.single.path ?? "");
      videoUrlName = videoFile.path;
      coloredPrint(msg: "file $videoUrlName");
      update();
    } else {
      // User canceled the picker
    }
  }

  void videoClicked() {
    if (videoController != null) {
      videoController!.value.isPlaying
          ? videoController?.pause()
          : videoController?.play();
    }
  }

  Future<void> mergeFiles() async {
    String commandToExecute =
        "-i $videoUrlName -stream_loop -1 -i $audioUrlName -shortest -map 0:v:0 -map 1:a:0 -y $outputUrl";

    String mergeAudioWithVideoCommand =
        '-i $audioUrlName -i $videoUrlName -c copy $outputUrl';

    String trimOnlyTheFirst30Sec = '-i $videoUrlName -t 30 -c copy $outputUrl';

    FFmpegKit.execute(trimOnlyTheFirst30Sec).then((value) async {
      FFmpegKit.execute(commandToExecute).then((value) {});

      outputUrlName = outputUrl;
      // make the music only for image
      videoController = VideoPlayerController.file(File(outputUrlName!))
        ..initialize().then((val) {});
      update();
      coloredPrint(msg: "audioUrlName:$audioUrlName");
      coloredPrint(msg: "value: ${await value.getDuration()}");
    });
  }
}
