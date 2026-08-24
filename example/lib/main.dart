import 'package:flutter/material.dart';

import 'pages/add_objects.dart';
import 'pages/all_map_modern_widgets.dart';
import 'pages/all_map_widgets.dart';
import 'pages/benchmark.dart';
import 'pages/benchmark_with_isolates.dart';
import 'pages/calc_position.dart';
import 'pages/camera_moves.dart';
import 'pages/clustering.dart';
import 'pages/common.dart';
import 'pages/copyright.dart';
import 'pages/custom_style_load.dart';
import 'pages/fps_page.dart';
import 'pages/indoor_widget.dart';
import 'pages/map_gestures.dart';
import 'pages/map_objects_identification.dart';
import 'pages/map_snapshot.dart';
import 'pages/search_page.dart';
import 'pages/stateless_screen_with_map.dart';
import 'pages/traffic_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SDK test app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter SDK test app Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Map'),
              Tab(text: 'Directory'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _mapPages(),
            _directoryPages(),
          ],
        ),
      ),
    );
  }

  Widget _mapPages() {
    return ListView(
      children: [
        ListTile(
          title: buildPageTitle('Add objects'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AddObjectsPage(title: 'Add objects'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('All Map Controls'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const AllMapWidgetsPage(title: 'All Map Controls'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('All Map Modern Controls'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AllMapModernWidgetsPage(
                    title: 'All Map Modern Controls'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Benchmark'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BenchmarkPage(title: 'Benchmark'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Benchmark with Isolates'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BenchmarkWithIsolatesPage(
                    title: 'Benchmark with Isolates'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Calc position'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CalcPositionPage(title: 'Calc position'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Camera moves'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CameraMovesPage(title: 'Camera moves'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Clustering'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClusteringPage(title: 'Clustering'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Copyright'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CopyrightPage(title: 'Copyright'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Custom style load'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const CustomStyleLoadPage(title: 'Custom style load'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Fps'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FpsPage(title: 'Fps'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Indoor Control'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const IndoorWidgetPage(title: 'Indoor Control'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Map gestures'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MapGesturesPage(title: 'Map gestures'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Map objects identification'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MapObjectsIdentificationPage(
                    title: 'Map objects identification'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Map snapshot'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const MapSnapshotPage(title: 'Map snapshot'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Simple map screen (stateless widget)'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SimpleMapScreen(
                    title: 'Simple map screen (stateless widget)'),
              ),
            );
          },
        ),
        ListTile(
          title: buildPageTitle('Traffic Control'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const TrafficWidgetPage(title: 'Traffic Control'),
              ),
            );
          },
        )
      ],
    );
  }

  Widget _directoryPages() {
    return ListView(
      children: [
        ListTile(
          title: buildPageTitle('Search'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchPage(title: 'Search'),
              ),
            );
          },
        )
      ],
    );
  }
}
