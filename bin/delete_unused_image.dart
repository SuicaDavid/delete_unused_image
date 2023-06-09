import 'dart:io';

import 'package:args/args.dart';
import 'package:delete_unused_image/file_reader.dart';
import 'package:delete_unused_image/image_modal.dart';

void main(List<String> arguments) async {
  ArgParser argParser = ArgParser();
  argParser.addOption(
    'root-path',
    defaultsTo: '/',
  );
  argParser.addOption('assets-path', defaultsTo: '/assets');
  argParser.addOption('lib-path', defaultsTo: '/lib');
  argParser.addFlag('ignore-dynamic', abbr: 'i', defaultsTo: false);
  var results = argParser.parse(arguments);
  final bool ignoreDynamicAssets = results['ignore-dynamic'];
  String rootPath = results['root-path'];
  String assetsPath = results['assets-path'];
  String libPath = results['lib-path'];

  FileReader fileReader = FileReader(
    rootPath: rootPath,
    assetsPath: assetsPath,
    libPath: libPath,
  );
  final List<ImageEntityStatistics> imageEntities =
      await fileReader.readAssetsEntities();

  final List<FileSystemEntity> configureEntities =
      await fileReader.readRootFileEntity();
  final List<FileSystemEntity> libEntites =
      await fileReader.readLibFileEntity();

  fileReader.analyzeImages(
    ignoreDynamicAssets: ignoreDynamicAssets,
    imageEntities: imageEntities,
    configureEntities: configureEntities,
    libEntites: libEntites,
  );

  fileReader.deleteImage(imageEntities);
}
