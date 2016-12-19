import 'dart:io';

import 'package:markdown/markdown.dart';

main(args) {
    toHtml(new Directory(args.first));
}

toHtml(dir) async {
    await for (FileSystemEntity entity in dir.list(recursive: false, followLinks: false)) {
        final p = entity.path;
        switch (await FileSystemEntity.type(p)) {
            case FileSystemEntityType.DIRECTORY:
                toHtml(new Directory(p));
                break;
            case FileSystemEntityType.FILE:
                if (!p.endsWith('.md'))
                    break;
                final html = await new File('${p.substring(0, p.length-3)}.html').create();
                await html.writeAsString(markdownToHtml(await entity.readAsString()));
                entity.delete();
                break;
            case FileSystemEntityType.LINK:
                print('warning: symlinks are not supported (${p})');
                break;
            default:
                print('warning: unrecognized file type (${p})');
        }
    }
}