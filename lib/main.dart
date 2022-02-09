import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:youtube_downloader/models.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  runApp(const MyApp());
  doWhenWindowReady(() {
    appWindow.minSize = const Size(1200, 800);
    appWindow.size = const Size(1200, 800);
    appWindow.alignment = Alignment.center;
    appWindow.title = "Youtube Downloader";
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        scaffoldBackgroundColor: const Color.fromARGB(255, 47, 49, 51),
        primarySwatch: Colors.blue,
      ),
      home: const YoutubeDownloader(),
    );
  }
}

class YoutubeDownloader extends StatefulWidget {
  const YoutubeDownloader({Key? key}) : super(key: key);

  @override
  State<YoutubeDownloader> createState() => _YoutubeDownloaderState();
}

class _YoutubeDownloaderState extends State<YoutubeDownloader> {
  final _urlController = TextEditingController();
  bool disabled = true;
  bool clicked = false;
  bool valid = true;
  var _title = "";
  var _author = "";
  var _upload_date = "";
  var _thumbnail =
      "https://upload.wikimedia.org/wikipedia/commons/8/89/HD_transparent_picture.png";

  void search(e) async {
    var yt = YoutubeExplode();
    try {
      var video = await yt.videos.get(e);
      setState(() {
        valid = true;
        _title = video.title;
        _author = video.author;
        _upload_date =
            "${video.uploadDate!.day}/${video.uploadDate!.month}/${video.uploadDate!.year}";
        _thumbnail = video.thumbnails.standardResUrl;
        disabled = false;
      });
    } on ArgumentError {
      setState(() {
        valid = false;
        disabled = true;
        _title = "Invalid URL";
        _author = "Invalid URL";
        _upload_date = "Invalid URL";
        _thumbnail =
            "https://upload.wikimedia.org/wikipedia/commons/8/89/HD_transparent_picture.png";
      });
    } on VideoUnavailableException {
      setState(() {
        valid = false;
        disabled = true;
        _title = "Invalid URL";
        _author = "Invalid URL";
        _upload_date = "Invalid URL";
        _thumbnail =
            "https://upload.wikimedia.org/wikipedia/commons/8/89/HD_transparent_picture.png";
      });
    }
    yt.close();
  }

  void download(String e, bool video) async {
    setState(() {
      clicked = true;
    });
    late BuildContext dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const Center(child: CircularProgressIndicator());
      },
    );
    var yt = YoutubeExplode();
    try {
      var manifest = await yt.videos.streamsClient.getManifest(e);
      var vid = await yt.videos.get(e);
      var directory = await getDownloadsDirectory();
      if (video) {
        var info = manifest.muxed.sortByVideoQuality().first;
        var stream = yt.videos.streams.get(info);
        var file = await File(directory!.path +
                "/" +
                vid.title
                    .replaceAll(RegExp(r"[^0-9a-zA-Z ]+"), "")
                    .replaceAll(" ", "_") +
                ".mp4")
            .create(recursive: true);
        var fileStream = file.openWrite();
        await stream.pipe(fileStream);
        await fileStream.flush();
        await fileStream.close();
        Navigator.pop(dialogContext);
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ButtonBarTheme(
                data: const ButtonBarThemeData(
                    alignment: MainAxisAlignment.center),
                child: AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  titleTextStyle:
                      const TextStyle(fontFamily: "Youtube", fontSize: 20),
                  title: const Icon(
                    Icons.check_circle,
                    color: Color.fromARGB(255, 146, 253, 119),
                    size: 70,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Download Complete',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Downloaded in ${file.path}",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      minWidth: 300,
                      padding: EdgeInsets.all(20),
                      color: Colors.orange.shade300,
                      child: const Text(
                        'OK',
                        style: TextStyle(fontFamily: "Youtube"),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            });
        setState(() {
          clicked = false;
        });
      } else {
        var info = manifest.audioOnly.sortByBitrate().last;
        var stream = yt.videos.streams.get(info);
        var file = await File(directory!.path +
                "/" +
                vid.title
                    .replaceAll(RegExp(r"[^0-9a-zA-Z ]+"), "")
                    .replaceAll(" ", "_") +
                ".mp3")
            .create(recursive: true);
        var fileStream = file.openWrite();
        await stream.pipe(fileStream);
        await fileStream.flush();
        await fileStream.close();
        Navigator.pop(dialogContext);
        print("sed");
        await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ButtonBarTheme(
                data: const ButtonBarThemeData(
                    alignment: MainAxisAlignment.center),
                child: AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  titleTextStyle:
                      const TextStyle(fontFamily: "Youtube", fontSize: 20),
                  title: const Icon(
                    Icons.check_circle,
                    color: Color.fromARGB(255, 146, 253, 119),
                    size: 70,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Download Complete',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 30),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Downloaded in ${file.path}",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  actions: <Widget>[
                    MaterialButton(
                      minWidth: 300,
                      padding: EdgeInsets.all(20),
                      color: Colors.orange.shade300,
                      child: const Text(
                        'OK',
                        style: TextStyle(fontFamily: "Youtube"),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            });
        setState(() {
          clicked = false;
        });
      }
    } on ArgumentError {
    } on VideoUnavailableException {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(50),
                child: Column(
                  children: [
                    RichText(
                        text: const TextSpan(
                            text: "YouTube",
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: "Youtube",
                                color: Colors.amber),
                            children: [
                          TextSpan(
                              text: "Downloader",
                              style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: "Youtube",
                                  color: Colors.white))
                        ])),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        LeftRow([
                          TextField(
                            onSubmitted: (e) => search(e),
                            maxLength: 43,
                            controller: _urlController,
                            decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.3, color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0.6, color: Colors.blue)),
                                floatingLabelStyle:
                                    TextStyle(color: Colors.white70),
                                labelStyle: TextStyle(color: Colors.grey),
                                hintStyle: TextStyle(color: Colors.white30),
                                hintText: "https://www.youtube.com/watch?v=",
                                labelText: "Enter Video ID",
                                counterText: "",
                                fillColor: Color(0xff121212),
                                filled: true),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          MaterialButton(
                            minWidth: 100,
                            height: 40,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: Colors.red,
                            child: const Icon(Icons.search),
                            onPressed: () => search(_urlController.value.text),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          disabled
                              ? Container()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                        minWidth: 100,
                                        height: 50,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        color: Colors.teal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.download),
                                            Text(" Download Audio ")
                                          ],
                                        ),
                                        onPressed: clicked
                                            ? null
                                            : () => download(
                                                _urlController.value.text,
                                                false)),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    MaterialButton(
                                        minWidth: 100,
                                        height: 50,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        color: Colors.teal,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            Icon(Icons.download),
                                            Text(" Download Video ")
                                          ],
                                        ),
                                        onPressed: clicked
                                            ? null
                                            : () => download(
                                                _urlController.value.text,
                                                true)),
                                  ],
                                ),
                        ]),
                        const SizedBox(
                          width: 50,
                        ),
                        RightRow([
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: valid
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                          const Text(
                                            "Video Details",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 23,
                                                fontFamily: "Youtube",
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  text: "Title: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: "Youtube",
                                                      color:
                                                          Colors.pink.shade300),
                                                  children: [
                                                TextSpan(
                                                    text: _title.characters
                                                        .take(80)
                                                        .string,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style
                                                                .fontFamily,
                                                        color: Colors.white))
                                              ])),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  text: "Author: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: "Youtube",
                                                      color:
                                                          Colors.pink.shade300),
                                                  children: [
                                                TextSpan(
                                                    text: _author.characters
                                                        .take(50)
                                                        .string,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style
                                                                .fontFamily,
                                                        color: Colors.white))
                                              ])),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          RichText(
                                              text: TextSpan(
                                                  text: "Upload Date: ",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: "Youtube",
                                                      color:
                                                          Colors.pink.shade300),
                                                  children: [
                                                TextSpan(
                                                    text: _upload_date,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontFamily:
                                                            DefaultTextStyle.of(
                                                                    context)
                                                                .style
                                                                .fontFamily,
                                                        color: Colors.white))
                                              ])),
                                          const SizedBox(
                                            height: 50,
                                          ),
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(40)),
                                            child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: _thumbnail,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.35,
                                            ),
                                          ),
                                        ])
                                  : const Text(
                                      "Invalid URL",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontFamily: "Youtube",
                                          color: Colors.white),
                                    ),
                            ),
                          )
                        ])
                      ],
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
