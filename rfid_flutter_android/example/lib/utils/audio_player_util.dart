import 'package:audioplayers/audioplayers.dart';

/// Audio player utility class
/// 音频播放器工具类
class AudioPlayerUtil {
  /// Player pool, used to take turns to play audio, can achieve a more rapid sound effect when inventorying
  /// 播放器池，用于轮流播放音频，可实现盘点时声音更急促的效果
  static final List<AudioPlayer> _playerPool = _initPlayerPool();

  /// Mark the player as busy, prevent multiple asynchronous tasks from operating on the same player
  /// 标记播放器是否忙碌，防止多个异步任务同时操作同一个播放器
  static final List<bool> _playerBusy = List.filled(_maxPlayers, false);

  /// The index of the current player
  /// 当前播放器索引
  static int _currentPlayerIndex = 0;

  /// The maximum number of players
  /// 最大播放器数量
  static const int _maxPlayers = 3;

  static final AssetSource _successPath = AssetSource('audio/success.ogg');
  static final AssetSource _failurePath = AssetSource('audio/failure.ogg');

  static List<AudioPlayer> _initPlayerPool() {
    return List.generate(_maxPlayers, (i) => AudioPlayer());
  }

  static Future<void> _playSound(AssetSource sound) async {
    final player = _playerPool[_currentPlayerIndex];
    final playerIndex = _currentPlayerIndex;

    // Check if the player is in use or busy
    // 检查播放器是否正在使用或处于忙碌状态
    if (_playerBusy[playerIndex] || _isPlayerBusy(player)) {
      return;
    }

    // Mark the player as busy
    // 标记播放器为忙碌状态
    _playerBusy[playerIndex] = true;

    try {
      // Ensure the player is in the stopped state
      // 确保播放器处于停止状态
      if (player.state != PlayerState.stopped) {
        await player.stop();
        // Give the MediaPlayer a little time to complete the state transition
        // 给 MediaPlayer 一点时间来完成状态转换
        await Future.delayed(const Duration(milliseconds: 10));
      }

      await player.play(sound);
      _currentPlayerIndex = (_currentPlayerIndex + 1) % _maxPlayers;

      // Listen for the completion event to release the busy state
      // 监听播放完成事件来释放忙碌状态
      player.onPlayerComplete.first.then((_) {
        _playerBusy[playerIndex] = false;
      }).catchError((e) {
        _playerBusy[playerIndex] = false;
      });
    } catch (e) {
      _playerBusy[playerIndex] = false;
    }
  }

  static bool _isPlayerBusy(AudioPlayer player) {
    final state = player.state;
    return state == PlayerState.playing || state == PlayerState.paused || state == PlayerState.disposed;
  }

  static Future<void> playSuccess() => _playSound(_successPath);
  static Future<void> playFailure() => _playSound(_failurePath);

  static Future<void> dispose() async {
    for (final player in _playerPool) {
      await player.dispose();
    }
  }
}
