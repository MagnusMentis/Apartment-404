extends Control

@export_file("*.json") var dialogue_file: String = "res://dialogues.json"
## Có thể khai báo danh sách phòng riêng theo khóa ngày tiếng Anh (Monday-Sunday).
@export var rooms_by_day: Dictionary = {}
## Ánh xạ khóa ngày tiếng Anh và room_id sang id trong JSON hội thoại.
@export var dialogue_ids_by_day: Dictionary = {
	"Monday": {
		"security_guard": "mon_security",
		"grocery_store": "mon_grocery_lady",
		"room_202": "mon_honor_student",
		"room_404": "mon_fortune_teller",
		"hair_roller_lady": "mon_hair_roller_lady",
		"couple": "mon_couple",
		"honor_student": "mon_honor_student",
		"fortune_teller": "mon_fortune_teller",
	},
}

const DAY_NAMES: Array[String] = [
	"Thứ Hai",
	"Thứ Ba",
	"Thứ Tư",
	"Thứ Năm",
	"Thứ Sáu",
	"Thứ Bảy",
	"Chủ Nhật",
]
const DAY_KEYS: Array[String] = [
	"Monday",
	"Tuesday",
	"Wednesday",
	"Thursday",
	"Friday",
	"Saturday",
	"Sunday",
]

var _apartment_map: Node
var _dialogue_box: Node
var _report_form: Node
var _ending_screen: CanvasItem
var _ending_label: Label
var _day_label: Label
var _dialogues_by_id: Dictionary = {}
var _active_room_id: String = ""
var _pending_next_dialogue_id: String = ""
var _is_ending: bool = false


func _ready() -> void:
	_apartment_map = get_node_or_null("ApartmentMap")
	_dialogue_box = get_node_or_null("DialogueBox")
	_report_form = get_node_or_null("ReportForm")
	_bind_or_create_day_label()
	_bind_or_create_ending_screen()

	if not _validate_references():
		return
	if not _load_dialogues():
		return
	if not _connect_signals():
		return

	_hide_node(_dialogue_box)
	_hide_node(_report_form)
	_hide_node(_ending_screen)
	_start_day()


func _validate_references() -> bool:
	var valid := true
	for entry in [
		{"node": _apartment_map, "path": "ApartmentMap", "signal": "room_selected"},
		{"node": _dialogue_box, "path": "DialogueBox", "signal": "dialogue_ended"},
		{"node": _report_form, "path": "ReportForm", "signal": "report_submitted"},
	]:
		var node: Node = entry["node"]
		if node == null:
			push_error("MainController: thiếu node con '%s'." % entry["path"])
			valid = false
		elif not node.has_signal(entry["signal"]):
			push_error("MainController: '%s' thiếu signal '%s'." % [
				entry["path"],
				entry["signal"],
			])
			valid = false
	if _apartment_map != null and not _apartment_map.has_signal("shift_completed"):
		push_error("MainController: ApartmentMap thiếu signal 'shift_completed'.")
		valid = false
	if _apartment_map != null and not _apartment_map.has_method("mark_room_completed"):
		push_error("MainController: ApartmentMap thiếu hàm 'mark_room_completed'.")
		valid = false
	if _dialogue_box != null and not _dialogue_box.has_signal("choice_picked"):
		push_error("MainController: DialogueBox thiếu signal 'choice_picked'.")
		valid = false
	if _dialogue_box != null and not _dialogue_box.has_method("start_dialogue"):
		push_error("MainController: DialogueBox thiếu hàm 'start_dialogue'.")
		valid = false
	return valid


func _connect_signals() -> bool:
	_apartment_map.connect("room_selected", _on_room_selected)
	_apartment_map.connect("shift_completed", _on_shift_completed)
	_dialogue_box.connect("dialogue_ended", _on_dialogue_ended)
	_dialogue_box.connect("choice_picked", _on_choice_picked)
	_report_form.connect("report_submitted", _on_report_submitted)
	GameState.day_changed.connect(_on_day_changed)
	return true


func _load_dialogues() -> bool:
	if not FileAccess.file_exists(dialogue_file):
		push_error("MainController: không tìm thấy file hội thoại '%s'." % dialogue_file)
		return false

	var file := FileAccess.open(dialogue_file, FileAccess.READ)
	if file == null:
		push_error("MainController: không thể mở file hội thoại '%s'." % dialogue_file)
		return false

	var parser := JSON.new()
	var parse_error := parser.parse(file.get_as_text())
	if parse_error != OK:
		push_error("MainController: JSON lỗi dòng %d: %s" % [
			parser.get_error_line(),
			parser.get_error_message(),
		])
		return false
	if not parser.data is Dictionary:
		push_error("MainController: gốc JSON hội thoại phải là object.")
		return false

	var raw_dialogues: Variant = parser.data.get("dialogues", null)
	if not raw_dialogues is Array:
		push_error("MainController: JSON cần có mảng 'dialogues'.")
		return false

	_dialogues_by_id.clear()
	for dialogue in raw_dialogues:
		if not dialogue is Dictionary:
			push_error("MainController: mỗi mục trong 'dialogues' phải là object.")
			return false
		var dialogue_id: Variant = dialogue.get("id", null)
		if not dialogue_id is String or dialogue_id.is_empty():
			push_error("MainController: mỗi dialogue cần 'id' kiểu String.")
			return false
		if _dialogues_by_id.has(dialogue_id):
			push_error("MainController: id hội thoại bị trùng '%s'." % dialogue_id)
			return false
		_dialogues_by_id[dialogue_id] = dialogue
	return true


func _start_day() -> void:
	if _is_ending:
		return

	var day_name := _get_day_name(GameState.current_day)
	_day_label.text = day_name

	var day_key := _get_day_key(GameState.current_day)
	var rooms: Variant = rooms_by_day.get(day_key, rooms_by_day.get(day_name, []))
	if rooms is Array and not rooms.is_empty() and _apartment_map.has_method("set_rooms_for_day"):
		_apartment_map.call("set_rooms_for_day", rooms)

	if _report_form.has_method("reset_for_new_day"):
		_report_form.call("reset_for_new_day")

	_active_room_id = ""
	_pending_next_dialogue_id = ""
	_hide_node(_dialogue_box)
	_hide_node(_report_form)
	_show_node(_apartment_map)


func _on_day_changed(_new_day: int) -> void:
	_start_day()


func _on_room_selected(room_id: String) -> void:
	if _is_ending:
		return

	var dialogue_id := _get_dialogue_id_for_room(room_id)
	if dialogue_id.is_empty():
		push_warning("MainController: chưa cấu hình hội thoại cho phòng '%s' trong %s." % [
			room_id,
			_get_day_name(GameState.current_day),
		])
		return

	_active_room_id = room_id
	_pending_next_dialogue_id = ""
	_hide_node(_apartment_map)
	_show_node(_dialogue_box)
	if not _start_dialogue_by_id(dialogue_id):
		_active_room_id = ""
		_hide_node(_dialogue_box)
		_show_node(_apartment_map)


func _get_dialogue_id_for_room(room_id: String) -> String:
	var day_key := _get_day_key(GameState.current_day)
	var day_mapping: Variant = dialogue_ids_by_day.get(day_key, {})
	if day_mapping is Dictionary:
		var mapped_id: Variant = day_mapping.get(room_id, "")
		if mapped_id is String:
			return mapped_id
		if mapped_id is Array and not mapped_id.is_empty() and mapped_id[0] is String:
			return mapped_id[0]
	return ""


func _start_dialogue_by_id(dialogue_id: String) -> bool:
	if not _dialogues_by_id.has(dialogue_id):
		push_warning("MainController: không tìm thấy dialogue id '%s' trong %s." % [
			dialogue_id,
			dialogue_file,
		])
		return false
	_dialogue_box.call("start_dialogue", _dialogues_by_id[dialogue_id])
	return true


func _on_choice_picked(_flag_name: String, next_dialogue_id: String) -> void:
	_pending_next_dialogue_id = next_dialogue_id


func _on_dialogue_ended() -> void:
	if not _pending_next_dialogue_id.is_empty():
		var next_id := _pending_next_dialogue_id
		_pending_next_dialogue_id = ""
		if _start_dialogue_by_id(next_id):
			_show_node(_dialogue_box)
			return

	if not _active_room_id.is_empty():
		_apartment_map.call("mark_room_completed", _active_room_id)
	_active_room_id = ""
	_hide_node(_dialogue_box)
	_show_node(_apartment_map)


func _on_shift_completed() -> void:
	if _is_ending:
		return
	_hide_node(_apartment_map)
	_show_node(_report_form)


func _on_report_submitted(report: Dictionary) -> void:
	_hide_node(_report_form)
	var submitted_day: int = report.get("day", GameState.current_day)
	if submitted_day == GameState.Day.SUNDAY:
		_show_ending(GameState.evaluate_ending())


func _show_ending(ending: String) -> void:
	_is_ending = true
	_hide_node(_apartment_map)
	_hide_node(_dialogue_box)
	_hide_node(_report_form)

	if _ending_screen.has_method("show_ending"):
		_ending_screen.call("show_ending", ending)
		return

	var ending_text := "%s ENDING" % ending if not ending.is_empty() else "ENDING"
	if _ending_label != null:
		_ending_label.text = ending_text
	else:
		push_error("MainController: không có EndingScreen.show_ending() hoặc Label kết thúc.")
	_show_node(_ending_screen)


func _get_day_name(day: int) -> String:
	if day >= 0 and day < DAY_NAMES.size():
		return DAY_NAMES[day]
	return "Ngày không xác định"


func _get_day_key(day: int) -> String:
	if day >= 0 and day < DAY_KEYS.size():
		return DAY_KEYS[day]
	return ""


func _bind_or_create_day_label() -> void:
	_day_label = get_node_or_null("DayLabel") as Label
	if _day_label != null:
		return

	_day_label = Label.new()
	_day_label.name = "DayLabel"
	_day_label.position = Vector2(24.0, 16.0)
	add_child(_day_label)


func _bind_or_create_ending_screen() -> void:
	var existing_screen := get_node_or_null("EndingScreen")
	if existing_screen is CanvasItem:
		_ending_screen = existing_screen
		if existing_screen.has_method("show_ending"):
			return
		_ending_label = existing_screen as Label
		if _ending_label == null:
			_ending_label = existing_screen.get_node_or_null("EndingLabel") as Label
		if _ending_label == null:
			_ending_label = existing_screen.get_node_or_null("Label") as Label

	if _ending_screen == null:
		var panel := PanelContainer.new()
		panel.name = "EndingScreen"
		panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(panel)
		_ending_screen = panel

	if _ending_label == null:
		_ending_label = Label.new()
		_ending_label.name = "EndingLabel"
		_ending_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
		_ending_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_ending_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		if _ending_screen is Control:
			_ending_screen.add_child(_ending_label)


func _show_node(node: Node) -> void:
	var canvas_item := node as CanvasItem
	if canvas_item != null:
		canvas_item.show()


func _hide_node(node: Node) -> void:
	var canvas_item := node as CanvasItem
	if canvas_item != null:
		canvas_item.hide()
