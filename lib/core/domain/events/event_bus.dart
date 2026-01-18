import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jozz_events/jozz_events.dart';

@lazySingleton
class EventBus extends JozzBusService {
  EventBus() {
    listen<JozzEvent>(_debugPrintEvent);
  }
  Future<void> _debugPrintEvent(JozzEvent event) async {
    debugPrint("EventBus: ${identityHashCode(this)} Event emitted $event");
  }
}
