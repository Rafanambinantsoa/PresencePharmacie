import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:mobile/services/EventController.dart';

class ParticipantEvent extends StatefulWidget {
  const ParticipantEvent({super.key, required this.id, required this.nomEvent});

  @override
  State<ParticipantEvent> createState() => _ParticipantEventState();
  final String id;
  final String nomEvent;
}

class _ParticipantEventState extends State<ParticipantEvent> {
  final EventController _controller = Get.put(EventController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getParticipants(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Evénement : ${widget.nomEvent}"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: Obx(() {
        return _controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _controller.participants.value.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Card(
                        color: Colors.blue[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                            title: Text(
                                _controller.participants.value[index].nom,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            subtitle: Text(
                                _controller.participants.value[index].email,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            trailing: Obx(
                              () {
                                return _controller.participants.value[index]
                                            .isScanned ==
                                        1
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      );
                              },
                            ))),
                  );
                },
              );
      }),
    );
  }
}
