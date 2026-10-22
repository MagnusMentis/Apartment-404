extends Control

var current_floor: int = 1
var current_room_index: int = 1
var _pan_offset: float = 0.0
var view_mode: String = "corridor"


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(true)


func set_floor(floor_number: int) -> void:
	current_floor = clampi(floor_number, 1, 4)
	queue_redraw()


func set_view_mode(mode: String) -> void:
	view_mode = mode
	queue_redraw()


func set_room_index(room_index: int) -> void:
	current_room_index = clampi(room_index, 1, 4)
	queue_redraw()


func get_room_hit_rect(room_index: int) -> Rect2:
	var centers: Array[float] = [0.06, 0.24, 0.76, 0.94]
	if room_index < 0 or room_index >= centers.size() or size.x <= 0.0:
		return Rect2()
	var center_x := centers[room_index] + _pan_offset / size.x
	return Rect2(center_x - 0.08, 0.49, 0.16, 0.42)


func _process(_delta: float) -> void:
	var viewport_width := get_viewport_rect().size.x
	if viewport_width <= 0.0:
		return
	var mouse_x := get_viewport().get_mouse_position().x
	var target_offset := clampf((0.5 - mouse_x / viewport_width) * 120.0, -60.0, 60.0)
	var next_offset := lerpf(_pan_offset, target_offset, 0.12)
	if absf(next_offset - _pan_offset) > 0.2:
		_pan_offset = next_offset
		queue_redraw()


func _draw() -> void:
	var w := size.x
	var h := size.y
	if w <= 0.0 or h <= 0.0:
		return
	if view_mode == "intro":
		_draw_dorm_room(w, h)
		return
	if view_mode == "elevator":
		_draw_elevator(w, h)
		return
	if view_mode == "room":
		_draw_apartment_room(w, h)
		return

	var accent := Color("#a94742") if current_floor == 4 else Color("#b68955")
	var wall_color := Color("#25242b") if current_floor != 4 else Color("#241d25")
	var center_x := w * 0.5 + _pan_offset
	var horizon_y := h * 0.43
	var bottom_y := h * 0.76

	draw_rect(Rect2(Vector2.ZERO, Vector2(w, h)), Color("#11141b"))
	draw_rect(Rect2(0.0, 0.0, w, horizon_y), Color("#171a22"))
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, horizon_y), Vector2(w, horizon_y),
		Vector2(w, bottom_y), Vector2(0.0, bottom_y),
	]), wall_color)
	draw_colored_polygon(PackedVector2Array([
		Vector2(0.0, bottom_y), Vector2(w, bottom_y),
		Vector2(w, h), Vector2(0.0, h),
	]), Color("#17171c"))

	# Perspective edges and floor tiles emphasize the first-person hallway.
	draw_line(Vector2(0.0, horizon_y), Vector2(center_x, horizon_y), Color("#55505a", 0.8), 2.0)
	draw_line(Vector2(w, horizon_y), Vector2(center_x, horizon_y), Color("#55505a", 0.8), 2.0)
	for tile_index in range(1, 9):
		var t := float(tile_index) / 8.0
		var y := lerpf(bottom_y, h, t * t)
		draw_line(Vector2(0.0, y), Vector2(w, y), Color(0.48, 0.45, 0.48, 0.18), 1.0)
	for edge in range(-3, 4):
		var start_x := center_x + edge * w * 0.16
		draw_line(Vector2(center_x, bottom_y), Vector2(start_x, h), Color(0.48, 0.45, 0.48, 0.16), 1.0)

	# Repeated apartment doors drift with the mouse, like panning a wide panorama.
	var room_centers: Array[float] = [0.06, 0.24, 0.76, 0.94]
	for room_index in range(4):
		var side := -1 if room_index < 2 else 1
		var door_width := w * 0.14
		var door_height := h * 0.38
		var door_x := w * room_centers[room_index] + _pan_offset - door_width * 0.5
		var door_y := horizon_y + h * 0.08
		_draw_door(door_x, door_y, door_width, door_height, accent, room_index, side)

	# The elevator stays at the vanishing point and changes its floor display.
	var elevator_width := w * 0.13
	var elevator_height := h * 0.32
	var elevator_rect := Rect2(center_x - elevator_width * 0.5, horizon_y - h * 0.015, elevator_width, elevator_height)
	draw_rect(elevator_rect.grow(5.0), Color("#111116"))
	draw_rect(elevator_rect, Color("#38343a"))
	draw_rect(Rect2(elevator_rect.position.x + 7.0, elevator_rect.position.y + 8.0, elevator_width - 14.0, elevator_height - 16.0), Color("#252329"))
	draw_line(Vector2(center_x, elevator_rect.position.y + 10.0), Vector2(center_x, elevator_rect.end.y - 8.0), Color("#625b61"), 2.0)
	draw_rect(Rect2(center_x - 5.0, elevator_rect.position.y - 22.0, 10.0, 10.0), accent)
	draw_string(ThemeDB.fallback_font, Vector2(center_x - 14.0, elevator_rect.position.y - 29.0), "%02d" % current_floor, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 14, Color("#f2c679"))

	# Ceiling lamps and a distinct red emergency glow on the haunted top floor.
	for lamp_index in range(4):
		var lamp_x := center_x + (float(lamp_index) - 1.5) * w * 0.18
		var lamp_y := h * (0.08 + float(lamp_index) * 0.055)
		draw_rect(Rect2(lamp_x - 19.0, lamp_y, 38.0, 5.0), Color(0.82, 0.72, 0.55, 0.32))
	if current_floor == 4:
		draw_circle(Vector2(center_x, h * 0.22), w * 0.17, Color(0.55, 0.05, 0.08, 0.12))

	draw_string(ThemeDB.fallback_font, Vector2(28.0, h - 24.0), "HÀNH LANG  •  TẦNG %d" % current_floor, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, Color(0.83, 0.79, 0.75, 0.8))


func _draw_door(x: float, y: float, door_width: float, door_height: float, accent: Color, door_index: int, _side: int) -> void:
	var rect := Rect2(x, y, door_width, door_height)
	draw_rect(rect.grow(4.0), Color("#141419"))
	draw_rect(rect, Color("#40383a"))
	draw_rect(Rect2(x + door_width * 0.08, y + door_height * 0.05, door_width * 0.84, door_height * 0.92), Color("#29272d"))
	draw_rect(Rect2(x + door_width * 0.72, y + door_height * 0.52, 4.0, 4.0), accent)
	var room_number := "404" if current_floor == 4 and door_index == 3 else "%d0%d" % [current_floor, door_index + 1]
	draw_string(ThemeDB.fallback_font, Vector2(x + door_width * 0.12, y + door_height * 0.23), room_number, HORIZONTAL_ALIGNMENT_LEFT, door_width * 0.76, 18, Color("#e0d2c2"))


func _draw_dorm_room(w: float, h: float) -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(w, h)), Color("#12131a"))
	draw_rect(Rect2(0.0, 0.0, w, h * 0.72), Color("#292831"))
	draw_rect(Rect2(0.0, h * 0.72, w, h * 0.28), Color("#17151a"))
	draw_rect(Rect2(w * 0.12, h * 0.31, w * 0.3, h * 0.37), Color("#3a3438"))
	draw_rect(Rect2(w * 0.14, h * 0.34, w * 0.26, h * 0.18), Color("#373b46"))
	draw_rect(Rect2(w * 0.13, h * 0.58, w * 0.29, h * 0.1), Color("#514444"))
	draw_rect(Rect2(w * 0.72, h * 0.18, w * 0.16, h * 0.54), Color("#18191f"))
	draw_rect(Rect2(w * 0.74, h * 0.2, w * 0.12, h * 0.5), Color("#40383a"))
	draw_circle(Vector2(w * 0.84, h * 0.47), 4.0, Color("#d6a138"))
	draw_string(ThemeDB.fallback_font, Vector2(w * 0.08, h * 0.9), "PHÒNG TRỌ  •  ĐÊM ĐẦU TIÊN", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color("#d8dee9"))


func _draw_elevator(w: float, h: float) -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(w, h)), Color("#11141b"))
	draw_rect(Rect2(w * 0.12, 0.0, w * 0.76, h), Color("#25242b"))
	draw_rect(Rect2(w * 0.3, h * 0.08, w * 0.4, h * 0.72), Color("#38343a"))
	draw_rect(Rect2(w * 0.32, h * 0.1, w * 0.18, h * 0.68), Color("#252329"))
	draw_rect(Rect2(w * 0.5, h * 0.1, w * 0.18, h * 0.68), Color("#252329"))
	draw_rect(Rect2(w * 0.47, h * 0.05, w * 0.06, h * 0.03), Color("#d6a138"))


func _draw_apartment_room(w: float, h: float) -> void:
	var wall_tone := Color("#29252a") if current_floor == 4 else Color("#363238")
	var floor_tone := Color("#17161b") if current_floor == 4 else Color("#29252a")
	draw_rect(Rect2(Vector2.ZERO, Vector2(w, h)), Color("#101117"))
	draw_rect(Rect2(0.0, 0.0, w, h * 0.72), wall_tone)
	draw_rect(Rect2(0.0, h * 0.72, w, h * 0.28), floor_tone)
	draw_line(Vector2(0.0, h * 0.72), Vector2(w, h * 0.72), Color("#625653"), 3.0)
	draw_rect(Rect2(w * 0.07, h * 0.13, w * 0.19, h * 0.31), Color("#121923"))
	draw_rect(Rect2(w * 0.085, h * 0.15, w * 0.16, h * 0.27), Color("#35414d"))
	draw_line(Vector2(w * 0.165, h * 0.15), Vector2(w * 0.165, h * 0.42), Color("#6c737a"), 2.0)
	draw_rect(Rect2(w * 0.72, h * 0.35, w * 0.2, h * 0.1), Color("#4a3c38"))
	draw_rect(Rect2(w * 0.75, h * 0.45, w * 0.04, h * 0.24), Color("#332b2d"))
	draw_rect(Rect2(w * 0.86, h * 0.45, w * 0.04, h * 0.24), Color("#332b2d"))
	draw_rect(Rect2(w * 0.68, h * 0.31, w * 0.28, h * 0.045), Color("#65534a"))
	draw_rect(Rect2(w * 0.08, h * 0.64, w * 0.28, h * 0.08), Color("#443a3d"))
	draw_rect(Rect2(w * 0.11, h * 0.6, w * 0.22, h * 0.05), Color("#71615e"))
	draw_rect(Rect2(w * 0.43, h * 0.08, w * 0.14, h * 0.012), Color(0.82, 0.72, 0.55, 0.45))
	draw_string(ThemeDB.fallback_font, Vector2(28.0, 44.0), "CĂN HỘ %d0%d  •  TẦNG %d" % [current_floor, current_room_index, current_floor], HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color("#ded2c6"))
