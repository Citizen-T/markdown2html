import 'dart:io';

import 'package:markdown/markdown.dart';

main(args) {
    var dir = new Directory(args.first);
    print('args: ${args.first}');
    toHtml(dir);
}

toHtml(dir) async {
    Stream<FileSystemEntity> entities = dir.list(recursive: false, followLinks: false);
    await for (FileSystemEntity entity in entities) {
        print('checking: ${entity.path}');
        var path = entity.path;
        var type = await FileSystemEntity.type(entity.path);
        switch (type) {
            case FileSystemEntityType.DIRECTORY:
                print('is dir: ${entity.path}');
                toHtml(new Directory(entity.path));
                break;
            case FileSystemEntityType.FILE:
                print('is file: ${entity.path}');
                if (!path.endsWith('.md'))
                    break;
                print('is markdown: ${entity.path}');
                var htmlFile = await new File('${path.substring(0, path.length-3)}.html').create();
                var file = new File(entity.path);
                var contents = await file.readAsString();
                var html = markdownToHtml(contents);
                await htmlFile.writeAsString(html);
                file.delete();
                break;
            case FileSystemEntityType.LINK:
                print('this is a symlink');
                break;
            default:
                print("I don't know what this is");
        }
    }
}