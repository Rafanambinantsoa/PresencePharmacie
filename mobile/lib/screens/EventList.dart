import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/screens/Participants.dart';
import 'package:mobile/screens/qrScanner.dart';
import 'package:mobile/services/EventController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.id});

  @override
  State<EventList> createState() => _EventListState();
  final String id;
}

class _EventListState extends State<EventList> {
  final EventController _controller = Get.put(EventController());
  late String scanChoice = "";

  void getScanChoice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("scanChoice", scanChoice);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getEvents();
    });
    super.initState();
    scanChoice = widget.id.toString();
    getScanChoice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choix de l'événements"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Obx(() {
        return _controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _controller.events.value.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => qrScanner(
                            id: _controller.events.value[index].id.toString(),
                          ));
                    },
                    child: Card(
                      color: Colors.blue[100],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 25,
                        ),
                        title: Text(_controller.events.value[index].titre,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        subtitle: Text(_controller.events.value[index].lieu,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                        trailing: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
