import 'package:flutter/material.dart';
import '../../services/audio_service.dart';

class AudioPlayerBar extends StatefulWidget {
  final AudioService audioService;

  const AudioPlayerBar({super.key, required this.audioService});

  @override
  State<AudioPlayerBar> createState() => _AudioPlayerBarState();
}

class _AudioPlayerBarState extends State<AudioPlayerBar> {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.audioService.positionStream.listen((position) {
      if (mounted) setState(() => _position = position);
    });
    widget.audioService.durationStream.listen((duration) {
      if (mounted && duration != null) setState(() => _duration = duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.stop, color: Colors.red),
          onPressed: () => widget.audioService.stop(),
        ),
        Expanded(
          child: Slider(
            value: _position.inSeconds.toDouble(),
            max: _duration.inSeconds.toDouble(),
            onChanged: (value) {
              widget.audioService.seek(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.green,
          ),
        ),
        Text(
          '${_position.inMinutes}:${(_position.inSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}