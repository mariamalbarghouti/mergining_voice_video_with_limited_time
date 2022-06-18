import 'dart:io';

import 'package:add_voice_over_video_feature/core/print_logger.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class HomeController extends GetxController {
  late File audioFile;
  late File videoFile;
  String? videoUrlName;
  String? audioUrlName;
  String? outputUrlName;
  VideoPlayerController? videoController;
  String? outputUrl;

  @override
  Future<void> onInit() async {
    super.onInit();
    await getDirrPlae();
    // await storagePermissionRequest();
  }

  Future<void> getDirrPlae() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    outputUrl = "${appDocDir.path}/mariam.mp4";
    coloredPrint(msg: "OutputPath $outputUrl");
  }

  Future<void> pickAudio() async {
    FilePickerResult? audioResult = await FilePicker.platform.pickFiles(
      // type: FileType.audio,
      type: FileType.custom,
      allowedExtensions: ['mp3', 'ogg', 'wav'],
    );
    coloredPrint(msg: "audio ${audioResult?.files.single.path}");
    coloredPrint(msg: "audioResult $audioResult");

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
      // type: FileType.video,
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );
    coloredPrint(msg: "Path ${videoResult?.files.single.path}");
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

    String trimOnlyTheFirst30Sec = '-i $videoUrlName -t 5 -c copy $outputUrl';
    // first 30 sec
    //
    // Future.wait([
    await FFmpegKit.execute(commandToExecute);
   await FFmpegKit.execute(trimOnlyTheFirst30Sec);
   
 
    // ]).then((value){
    // coloredPrint(msg: "value: ${await value.getDuration()}");
    outputUrlName = outputUrl;
    // make the music only for image
    videoController = VideoPlayerController.file(File(outputUrlName!))
      ..initialize().then((val) {});
    update();
    coloredPrint(msg: "audioUrlName:$audioUrlName");
  }
}
