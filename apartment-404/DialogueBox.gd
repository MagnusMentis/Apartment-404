extends CanvasLayer

signal choice_picked(flag_name: String, next_dialogue_id: String)
signal dialogue_ended

const CHARACTER_DELAY: float = 0.035

var _root_control: Control
var _name_label: Label
var _content_label: RichTextLabel
var _choices_container: VBoxContainer

var _lines: Array[String] = []
var _line_index: int = 0
var _choices: Array[Dictionary] = []
var _typewriter_tween: Tween
var _is_typing: bool = false


func _ready() -> void:
	_create_nodes()
	_root_control.hide()


## Tạo giao diện DialogueBox bằng code để không cần scene riêng.
func _create_nodes() -> void:
	_root_control = Control.new()
	_root_control.name = "DialogueRoot"
	_root_control.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root_control.mouse_filter = Control.MOUSE_FILTER_PASS
	add_child(_root_control)

	var panel := PanelContainer.new()
	panel.name = "DialoguePanel"
	panel.anchor_left = 0.05
	panel.anchor_top = 1.0
	panel.anchor_right = 0.95
	panel.anchor_bottom = 1.0
	panel.offset_top = -260.0
	panel.offset_bottom = -24.0
	_root_control.add_child(panel)

	var layout := VBoxContainer.new()
	panel.add_child(layout)

	_name_label = Label.new()
	_name_label.name = "NameLabel"
	_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layout.add_child(_name_label)

	_content_label = RichTextLabel.new()
	_content_label.name = "ContentLabel"
	_content_label.custom_minimum_size = Vector2(0.0, 120.0)
	_content_label.fit_content = false
	_content_label.scroll_active = false
	_content_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	layout.add_child(_content_label)

	_choices_container = VBoxContainer.new()
	_choices_container.name = "ChoicesContainer"
	layout.add_child(_choices_container)


## Nhận một dialogue object hoặc toàn bộ JSON có mảng "dialogues".
## Với JSON gốc, dialogue đầu tiên sẽ được phát.
func start_dialogue(dialogue_data: Dictionary) -> void:
	var dialogue: Dictionary = dialogue_data
	if dialogue_data.has("dialogues"):
		var dialogue_list: Variant = dialogue_data["dialogues"]
		if not dialogue_list is Array or dialogue_list.is_empty():
			push_error("DialogueBox: 'dialogues' phải là mảng không rỗng.")
			return
		if not dialogue_list[0] is Dictionary:
			push_error("DialogueBox: phần tử dialogue đầu tiên phải là Dictionary.")
			return
		dialogue = dialogue_list[0]

	if not dialogue.has("speaker") or not dialogue["speaker"] is String:
		push_error("DialogueBox: dialogue cần trường 'speaker' kiểu String.")
		return
	if not dialogue.has("lines") or not dialogue["lines"] is Array:
		push_error("DialogueBox: dialogue cần trường 'lines' kiểu Array.")
		return

	_cancel_typewriter()
	_clear_choices()
	_lines.clear()
	_choices.clear()
	_line_index = 0
	_name_label.text = dialogue["speaker"]

	for line in dialogue["lines"]:
		if not line is String:
			push_error("DialogueBox: mỗi câu trong 'lines' phải là String.")
			return
		_lines.append(line)

	var raw_choices: Variant = dialogue.get("choices", [])
	if not raw_choices is Array:
		push_error("DialogueBox: 'choices' phải là Array.")
		return
	for choice in raw_choices:
		if not choice is Dictionary:
			push_error("DialogueBox: mỗi lựa chọn phải là Dictionary.")
			continue
		_choices.append(choice)

	_root_control.show()
	_show_line()


func _input(event: InputEvent) -> void:
	var advance := false
	if event is InputEventMouseButton:
		advance = event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	elif event is InputEventKey:
		advance = event.keycode == KEY_SPACE and event.pressed and not event.echo

	if not advance or not _root_control.visible:
		return

	if event is InputEventMouseButton:
		var hovered_control := get_viewport().gui_get_hovered_control()
		if hovered_control != null and (
			hovered_control == _choices_container
			or _choices_container.is_ancestor_of(hovered_control)
		):
			return

	_advance_dialogue()
	get_viewport().set_input_as_handled()


func _advance_dialogue() -> void:
	if _is_typing:
		_finish_typewriter()
		return

	if _line_index + 1 < _lines.size():
		_line_index += 1
		_show_line()
		return

	if _choices.is_empty():
		_end_dialogue()


func _show_line() -> void:
	if _line_index >= _lines.size():
		_show_choices()
		return

	_content_label.text = _lines[_line_index]
	_content_label.visible_characters = 0
	var character_count := _content_label.get_total_character_count()
	if character_count <= 0:
		_finish_typewriter()
		return

	_is_typing = true
	_typewriter_tween = create_tween()
	_typewriter_tween.tween_property(
		_content_label,
		"visible_characters",
		character_count,
		maxf(CHARACTER_DELAY * character_count, 0.01)
	)
	_typewriter_tween.finished.connect(_on_typewriter_finished)


func _on_typewriter_finished() -> void:
	_is_typing = false
	if _line_index == _lines.size() - 1 and not _choices.is_empty():
		_show_choices()


func _finish_typewriter() -> void:
	_cancel_typewriter()
	_content_label.visible_characters = -1
	_is_typing = false
	if _line_index == _lines.size() - 1 and not _choices.is_empty():
		_show_choices()


func _show_choices() -> void:
	_clear_choices()
	for choice in _choices:
		var text: Variant = choice.get("text", null)
		var flag_data: Variant = choice.get("set_flag", null)
		var next_id: Variant = choice.get("next_id", null)
		if not text is String or not flag_data is Dictionary:
			push_error("DialogueBox: lựa chọn cần 'text' và 'set_flag' hợp lệ.")
			continue
		if not flag_data.get("key", null) is String:
			push_error("DialogueBox: set_flag cần có 'key' kiểu String.")
			continue
		if next_id != null and not next_id is String:
			push_error("DialogueBox: 'next_id' phải là String hoặc null.")
			continue

		var button := Button.new()
		button.text = text
		button.focus_mode = Control.FOCUS_NONE
		button.pressed.connect(_on_choice_pressed.bind(choice))
		_choices_container.add_child(button)

	if _choices_container.get_child_count() == 0:
		_end_dialogue()


func _on_choice_pressed(choice: Dictionary) -> void:
	var flag_data: Dictionary = choice["set_flag"]
	var flag_name: String = flag_data["key"]
	var next_id: Variant = choice.get("next_id", null)
	var next_dialogue_id := "" if next_id == null else str(next_id)

	if not is_instance_valid(GameState):
		push_error("DialogueBox: Autoload 'GameState' không tồn tại.")
		return

	GameState.set_flag(flag_name, flag_data.get("value", true))
	choice_picked.emit(flag_name, next_dialogue_id)
	_end_dialogue()


func _clear_choices() -> void:
	for child in _choices_container.get_children():
		_choices_container.remove_child(child)
		child.queue_free()


func _cancel_typewriter() -> void:
	if _typewriter_tween != null and _typewriter_tween.is_running():
		_typewriter_tween.kill()
	_typewriter_tween = null
	_is_typing = false


func _end_dialogue() -> void:
	_cancel_typewriter()
	_root_control.hide()
	dialogue_ended.emit()
