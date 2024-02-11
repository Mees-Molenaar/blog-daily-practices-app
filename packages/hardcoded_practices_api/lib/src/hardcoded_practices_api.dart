import 'dart:async';
import 'package:practices_api/practices_api.dart';
import 'package:rxdart/subjects.dart';

const hardcoded_practices = <Map<String, dynamic>>[
  {
    'id': "1",
    'practice': 'Sleep eight hours',
  },
  {
    'id': "2",
    'practice': 'Eat two meals instead of three',
  },
  {
    'id': "3",
    'practice': 'No TV (or YouTube)',
  },
  {
    'id': "4",
    'practice': 'No junk food',
  },
  {
    'id': "5",
    'practice': 'No complaining for one whole day',
  },
  {
    'id': "6",
    'practice': 'No gossip',
  },
  {
    'id': "7",
    'practice': 'Return an e-mail from five years ago',
  },
  {
    'id': "8",
    'practice': 'Express thanks to a friend',
  },
  {
    'id': "9",
    'practice': 'Watch a funny movie or a stand-up comic',
  },
  {
    'id': "10",
    'practice': 'Write down a list of ideas. The ideas can be about anything',
  },
  {
    'id': "11",
    'practice':
        'Read a spiritual text. Any one that is inspirational to you. The bible, the Tao te Ching, anything you want',
  },
  {
    'id': "12",
    'practice':
        'Say to yourself when you wake up, "I am going to save a life today. Keep an eye out for that life you can save',
  },
  {
    'id': "13",
    'practice': 'Take up a hobby. Do not say you do not have time',
  },
  {
    'id': "14",
    'practice':
        'Write down your entire schedule. The schedule you do everyday. Cross out one item and do not do that anymore',
  },
  {
    'id': "15",
    'practice': 'Suprise someone',
  },
  {
    'id': "16",
    'practice': 'Think of ten people you are grateful for',
  },
  {
    'id': "17",
    'practice':
        'Forgive someone. You do not have to tell them. Just write it down on a piece of paper and burn the paper (or throw it away)',
  },
  {
    'id': "18",
    'practice': 'Take the stairs instead of the elevator',
  },
  {
    'id': "19",
    'practice':
        'When you find yourself thinking of that special someone who is causing you grief, think very quietly, "No". If you think of him and (or?) her again, think loudly, "No!" Again? Whisper, "No!" Again, say it. Louder. Yell it. Louder. And so on',
  },
  {
    'id': "20",
    'practice': 'Tell someone every day that you love them',
  },
  {
    'id': "21",
    'practice': 'Do not have sex with someone you do not love',
  },
  {
    'id': "22",
    'practice': 'Shower. Scrub. Clean the toxins of your body',
  },
  {
    'id': "23",
    'practice':
        'Read a chapter in a biography about someone who is an inspiration to you',
  },
  {
    'id': "24",
    'practice': 'Make plans to spend time with a friend',
  },
  {
    'id': "25",
    'practice':
        'If you think, "Everything would be better of if I were death" then think. "That is really cool. Now I can do anything I want and I can postpone this thought for a while, maybe even a few months." Because what does it matter now? The planet might not even be around in a few months',
  },
  {
    'id': "26",
    'practice': 'Deep breathing',
  },
];

class HardcodedPracticesApi extends PracticesApi {
  final _practicesSubject = BehaviorSubject<List<Practice>>.seeded(const []);

  @override
  Stream<List<Practice>> getPractices() {
    final practices =
        hardcoded_practices.map((json) => Practice.fromJson(json)).toList();

    _practicesSubject.add(practices);

    return _practicesSubject.asBroadcastStream();
  }

  void dispose() {
    _practicesSubject.close();
  }
}
