extends Control

signal room_selected(room_id: String)
signal shift_completed

@export var rooms_for_day: Array[Dictionary] = [
	{"room_id": "security_guard", "label": "Phòng Bảo vệ", "required": true},
	{"room_id": "grocery_store", "label": "Tiệm Tạp hóa", "required": true},
	{"room_id": "room_202", "label": "Phòng 202", "required": true},
	{"room_id": "room_404", "label": "Phòng 404", "required": true},
]
@export var shift_button_text: String = "Kết thúc ca làm việc / Về bàn nộp báo cáo"

var _rooms_container: VBoxContainer
var _shift_button: Button
var _room_buttons: Dictionary = {}
var _required_rooms: Dictionary = {}
var _completed_rooms: Dictionary = {}
var _shift_was_completed: bool = false


func _ready() -> void:
	_build_interface()
	_set_rooms(rooms_for_day)
	if not GameState.day_changed.is_connected(_on_day_changed):
		GameState.day_changed.connect(_on_day_changed)


## Cập nhật danh sách phòng trong ca. Mỗi phòng gồm room_id, label và required.
func set_rooms_for_day(rooms: Array[Dictionary]) -> void:
	rooms_for_day = rooms.duplicate(true)
	_completed_rooms.clear()
	_shift_was_completed = false
	if is_node_ready():
		_set_rooms(rooms_for_day)


## Đánh dấu phòng đã tương tác xong; gọi sau khi kết thúc hội thoại/giao hàng.
func mark_room_completed(room_id: String) -> void:
	if not _room_buttons.has(room_id):
		push_warning("ApartmentMap: không tìm thấy phòng '%s'." % room_id)
		return
	_completed_rooms[room_id] = true
	_update_room_button(room_id)
	_update_shift_button()


## Đặt lại trạng thái hoàn thành nếu người chơi cần tương tác lại với phòng.
func set_room_completed(room_id: String, completed: bool) -> void:
	if not _room_buttons.has(room_id):
		push_warning("ApartmentMap: không tìm thấy phòng '%s'." % room_id)
		return
	if completed:
		_completed_rooms[room_id] = true
	else:
		_completed_rooms.erase(room_id)
	_update_room_button(room_id)
	_update_shift_button()


func _build_interface() -> void:
	var panel := PanelContainer.new()
	panel.anchor_left = 0.5
	panel.anchor_top = 0.5
	panel.anchor_right = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = -240.0
	panel.offset_top = -260.0
	panel.offset_right = 240.0
	panel.offset_bottom = 260.0
	add_child(panel)

	var layout := VBoxContainer.new()
	panel.add_child(layout)

	var title := Label.new()
	title.text = "Chọn phòng cần giao hàng"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)

	_rooms_container = VBoxContainer.new()
	_rooms_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_rooms_container)

	_shift_button = Button.new()
	_shift_button.text = shift_button_text
	_shift_button.pressed.connect(_on_shift_button_pressed)
	layout.add_child(_shift_button)


func _set_rooms(rooms: Array[Dictionary]) -> void:
	_room_buttons.clear()
	_required_rooms.clear()
	for child in _rooms_container.get_children():
		_rooms_container.remove_child(child)
		child.queue_free()

	var seen_room_ids: Dictionary = {}
	for room in rooms:
		if not _is_valid_room(room):
			push_error("ApartmentMap: dữ liệu phòng không hợp lệ: %s" % room)
			continue

		var room_id: String = room["room_id"]
		if seen_room_ids.has(room_id):
			push_error("ApartmentMap: room_id bị trùng: '%s'." % room_id)
			continue
		seen_room_ids[room_id] = true

		var button := Button.new()
		button.text = room["label"]
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_on_room_button_pressed.bind(room_id))
		_rooms_container.add_child(button)
		_room_buttons[room_id] = {
			"button": button,
			"label": room["label"],
		}
		if room.get("required", true):
			_required_rooms[room_id] = true

	for room_id_to_refresh in _completed_rooms:
		_update_room_button(room_id_to_refresh)

	_update_shift_button()


func _is_valid_room(room: Dictionary) -> bool:
	return (
		room.get("room_id", null) is String
		and not room["room_id"].is_empty()
		and room.get("label", null) is String
		and room.get("required", true) is bool
	)


func _on_room_button_pressed(room_id: String) -> void:
	if _completed_rooms.has(room_id):
		return
	room_selected.emit(room_id)


func _update_room_button(room_id: String) -> void:
	if not _room_buttons.has(room_id):
		return

	var room_data: Dictionary = _room_buttons[room_id]
	var button: Button = room_data["button"]
	var is_completed: bool = _completed_rooms.has(room_id)
	button.disabled = is_completed
	button.text = "%s  -  Đã giao" % room_data["label"] if is_completed else room_data["label"]
	button.modulate = Color(0.65, 0.65, 0.65, 0.8) if is_completed else Color.WHITE


func _update_shift_button() -> void:
	if not is_instance_valid(_shift_button):
		return

	var all_required_completed := true
	for room_id in _required_rooms:
		if not _completed_rooms.has(room_id):
			all_required_completed = false
			break
	_shift_button.visible = all_required_completed and not _shift_was_completed


func _on_shift_button_pressed() -> void:
	if _shift_was_completed:
		return
	for room_id in _required_rooms:
		if not _completed_rooms.has(room_id):
			return

	_shift_was_completed = true
	_shift_button.hide()
	shift_completed.emit()


func _on_day_changed(_new_day: int) -> void:
	_completed_rooms.clear()
	_shift_was_completed = false
	_set_rooms(rooms_for_day)
