import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skrispsi_app/app/simple_map_controller.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SimpleMapController>(
      init: Get.put(SimpleMapController()),
      initState: ((state) {
        tabController = TabController(length: 3, vsync: this);
      }),
      builder: (ctrl) {
        if (ctrl.isLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Simple Map')),
            drawer: drawerCustom(ctrl),
            body: Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  markers: Set<Marker>.of(ctrl.markers),
                  polylines: ctrl.polylines,
                  initialCameraPosition: ctrl.initialGoogleMap,
                  onMapCreated: (GoogleMapController controller) {
                    ctrl.controllerGoogleMap.complete(controller);
                  },
                  onTap: (argument) {
                    ctrl.addLocationMarker(lat: argument.latitude, lng: argument.longitude);
                  },
                ),
              ],
            ),
            floatingActionButton: actionButton(ctrl),
          );
        }
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget drawerCustom(SimpleMapController ctrl) {
    return Drawer(child: tabBar(ctrl));
  }

  Widget tabBar(SimpleMapController ctrl) {
    return SafeArea(
      child: Container(
        width: Get.width,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                // color: Colors.green,
                child: TabBar(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  controller: tabController,
                  labelColor: Colors.blue,
                  tabs: const [
                    Tab(text: 'Position'),
                    Tab(text: 'Distance'),
                    Tab(text: 'Rute'),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Container(
                // color: Colors.yellow,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    positionInformation(ctrl),
                    distanceInformation(ctrl),
                    routeInformation(ctrl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget positionInformation(SimpleMapController ctrl) {
    return ListView.builder(
      itemCount: ctrl.markers.length,
      itemBuilder: (context, index) {
        Marker data = ctrl.markers[index];
        return ListTile(
          title: Text('Position ${data.markerId.value}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lat: ${data.position.latitude}'),
              Text('Lng: ${data.position.longitude}'),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ctrl.deleteMarker(data.markerId);
            },
          ),
        );
      },
    );
  }

  Widget distanceInformation(SimpleMapController ctrl) {
    return ListView.builder(
      itemCount: ctrl.distanceLines.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> origin = ctrl.distanceLines[index];
        Map<String, dynamic> destination = ctrl.distanceLines[index == ctrl.distanceLines.length - 1 ? 0 : index + 1];
        return ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Line id ${origin['id']}'),
              const SizedBox(width: 10),
              Container(
                width: 80,
                height: 3,
                color: origin['color'] as Color,
              ),
              const SizedBox(width: 10),
              Text('${destination['id']}'),
            ],
          ),
          subtitle: Text('Distance: ${origin['distance']}'),
          trailing: IconButton(
            icon: const Icon(Icons.remove_red_eye_sharp),
            onPressed: () {
              ctrl.disableLine(ctrl.distanceLines[index]['id']);
              // ctrl.showLine(ctrl.distanceLines[index]['id'] as String);
              // ctrl.polylines[index].visible = !ctrl.polylines[index].visible;
              // ctrl.polylines[index] = ctrl.polylines[index];
              // ctrl.deleteMarker(ctrl.markers[index].markerId);
            },
          ),
        );
      },
    );
  }

  Widget routeInformation(SimpleMapController ctrl) {
    return ListView.builder(
      itemCount: ctrl.markers.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Position ${index + 1}'),
          // subtitle: Text('Distance: ${ctrl.distance[index]}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              ctrl.deleteMarker(ctrl.markers[index].markerId);
            },
          ),
        );
      },
    );
  }

  Widget actionButton(SimpleMapController ctrl) {
    return Wrap(
      direction: Axis.horizontal,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: FloatingActionButton(
            child: const Icon(Icons.location_searching),
            onPressed: () async {
              await ctrl.gotoCurrentLocation();
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: FloatingActionButton(
            backgroundColor: Colors.deepPurpleAccent,
            child: const Icon(Icons.directions),
            onPressed: () {
              ctrl.generateLines().then((value) {
                setState(() {});
                // ctrl.matrixDistance();
              });
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: FloatingActionButton(
            onPressed: () {
              ctrl.deleteAllMarker();
              setState(() {});
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.delete_rounded),
          ),
        ),
      ],
    );
  }

  popupLoading() {
    return Get.defaultDialog(
      title: 'Generate Route',
      content: const CircularProgressIndicator(),
    );
  }
}
