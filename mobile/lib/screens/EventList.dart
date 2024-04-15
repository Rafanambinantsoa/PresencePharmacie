import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/screens/Participants.dart';
import 'package:mobile/services/EventController.dart';

class EventList extends StatefulWidget {
  const EventList({super.key, required this.id});

  @override
  State<EventList> createState() => _EventListState();
  final String id;
}

class _EventListState extends State<EventList> {
  final EventController _controller = Get.put(EventController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getEvents(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste de mes événements"),
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
                      Get.to(() => ParticipantEvent(
                            id: _controller.events.value[index].id.toString(),
                            nomEvent: _controller.events.value[index].titre,
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
                          backgroundImage: NetworkImage(
                              imgUrl + _controller.events.value[index].image),
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
