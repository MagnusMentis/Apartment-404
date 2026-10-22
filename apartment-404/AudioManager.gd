extends Node

const MIN_PITCH_SCALE: float = 0.01
const SILENCE_DB: float = -80.0

var _bgm_player: AudioStreamPlayer
var _bgm_tween: Tween


## Chuyển từ BGM hiện tại sang stream mới bằng hiệu ứng crossfade.
func play_bgm(stream: AudioStream, fade_duration: float = 1.0) -> void:
	if stream == null:
		return

	if is_instance_valid(_bgm_player):
		if _bgm_tween != null and _bgm_tween.is_running():
			_bgm_tween.kill()

		if fade_duration <= 0.0:
			_bgm_player.stop()
			_bgm_player.queue_free()
		else:
			_fade_out_player(_bgm_player, fade_duration)

	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.stream = stream
	add_child(_bgm_player)

	if fade_duration <= 0.0:
		_bgm_player.play()
		return

	_bgm_player.volume_db = SILENCE_DB
	_bgm_player.play()
	_bgm_tween = create_tween()
	_bgm_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_bgm_tween.tween_property(_bgm_player, "volume_db", 0.0, fade_duration)


## Giảm âm lượng BGM hiện tại rồi dừng phát.
func stop_bgm(fade_duration: float = 1.0) -> void:
	if not is_instance_valid(_bgm_player):
		_bgm_player = null
		return

	if _bgm_tween != null and _bgm_tween.is_running():
		_bgm_tween.kill()

	var player := _bgm_player
	_bgm_player = null

	if fade_duration <= 0.0:
		player.stop()
		player.queue_free()
	else:
		_fade_out_player(player, fade_duration)


## Phát SFX một lần và giải phóng AudioStreamPlayer khi phát xong.
func play_sfx(stream: AudioStream, pitch_randomness: float = 0.0) -> void:
	if stream == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = stream

	var randomness := absf(pitch_randomness)
	var minimum_pitch := maxf(MIN_PITCH_SCALE, 1.0 - randomness)
	var maximum_pitch := maxf(minimum_pitch, 1.0 + randomness)
	player.pitch_scale = randf_range(minimum_pitch, maximum_pitch)
	player.finished.connect(player.queue_free)

	add_child(player)
	player.play()


func _fade_out_player(player: AudioStreamPlayer, fade_duration: float) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(player, "volume_db", SILENCE_DB, fade_duration)
	tween.finished.connect(player.queue_free)
