import 'dart:convert';

import 'package:get/get.dart';
import 'package:mobile/constant.dart';
import 'package:mobile/models/Event.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/models/ParticipantModel.dart';

class EventController extends GetxController {
  Rx<List<EventModel>> events = Rx<List<EventModel>>([]);
  Rx<List<ParticipantModel>> participants = Rx<List<ParticipantModel>>([]);

  final isLoading = true.obs;

  Future getParticipants(id) async {
    try {
      isLoading.value = true;

      var response = await http.get(
          Uri.parse("$baseURL/ticketAvecAcheteur/$id"),
          headers: {'Accept': 'application/json'});

      if (response.statusCode == 200) {
        //clear the list before adding new items
        participants.value.clear();
        isLoading.value = false;
        final content = json.decode(response.body)['participant'];
        for (var items in content) {
          participants.value.add(ParticipantModel.fromJson(items));
        }
        print(content);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getEvents() async {
    try {
      isLoading.value = true;
      var response =
          await http.get(Uri.parse(baseURL + '/alllEvents'), headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        //clear the list before adding new items
        events.value.clear();
        isLoading.value = false;
        final content = json.decode(response.body);

        for (var items in content) {
          events.value.add(EventModel.fromJson(items));
        }
        print(content);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
