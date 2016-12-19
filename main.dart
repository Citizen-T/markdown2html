import 'dart:io';

import 'package:markdown/markdown.dart';

main(args) async {
    var dir = new Directory(args.first);
    Stream<FileSystemEntity> entities = dir.list(recursive: false, followLinks: false);
    await for (FileSystemEntity entity in entities) {
        var contents = await new File(entity.path).readAsString();
        print(markdownToHtml(contents));
    }
}