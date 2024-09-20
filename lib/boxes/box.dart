

import 'package:hive/hive.dart';
import 'package:untitled/models/photosModel.dart';

class Boxes{
  static Box<photosModel> getData()=>Hive.box<photosModel>('photoBox');
}