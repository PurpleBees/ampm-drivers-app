import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cfbpvkcpwkckbepklsru.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNmYnB2a2Nwd2tja2JlcGtsc3J1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDg2ODYxMDksImV4cCI6MjAyNDI2MjEwOX0.l_qpxiOUxH_zjxkLwbKNCOxu7ZRdxVIvOVk7iXYa1bk',
  );
  runApp(const MyApp());
}
