import 'dart:io';

import 'package:markdown/markdown.dart';

main(args) {
    var dir = new Directory(args.first);
    toHtml(dir);
}

toHtml(dir) async {
    Stream<FileSystemEntity> entities = dir.list(recursive: false, followLinks: false);
    await for (FileSystemEntity entity in entities) {
        FileSystemEntityType type = await FileSystemEntity.type(entity.path);
        switch (type) {
            case FileSystemEntityType.DIRECTORY:
                toHtml(new Directory(entity.path));
                break;
            case FileSystemEntityType.FILE:
                if (!entity.path.endsWith('.md'))
                    break;
                var contents = await new File(entity.path).readAsString();       
                print(markdownToHtml(contents));
                break;
            case FileSystemEntityType.LINK:
                print('this is a symlink');
                break;
            default:
                print("I don't know what this is");
        }
    }
}