extends Control

signal report_submitted(report: Dictionary)

@export var resident_questions: Array[Dictionary] = []
@export var base_reward: int = 25
@export var correct_answer_bonus: int = 10
@export var ui_click_stream: AudioStream
@export var money_count_stream: AudioStream

var _questions_container: VBoxContainer
var _submit_button: Button
var _result_label: Label
var _question_groups: Array[Dictionary] = []
var _has_submitted: bool = false


func _ready() -> void:
	_build_interface()
	_build_questions()


## Thay danh sách cư dân và tạo lại các nút lựa chọn.
## Mỗi câu hỏi gồm resident_id, resident_name và options.
## Mỗi option gồm id (cột), text (nhãn) và correct (đáp án đúng).
func set_questions(questions: Array[Dictionary]) -> void:
	resident_questions = questions.duplicate(true)
	if is_node_ready():
		_build_questions()


## Đặt lại giao diện để nhập báo cáo cho ngày mới.
func reset_for_new_day() -> void:
	_has_submitted = false
	if not is_node_ready():
		return
	_result_label.text = ""
	_build_questions()


func _build_interface() -> void:
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(640.0, 460.0)
	add_child(panel)

	var layout := VBoxContainer.new()
	panel.add_child(layout)

	var title := Label.new()
	title.text = "Báo cáo cuối ngày"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	layout.add_child(title)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)

	_questions_container = VBoxContainer.new()
	_questions_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_questions_container)

	_result_label = Label.new()
	_result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(_result_label)

	_submit_button = Button.new()
	_submit_button.text = "Nộp báo cáo"
	_submit_button.pressed.connect(_on_submit_pressed)
	layout.add_child(_submit_button)


func _build_questions() -> void:
	_question_groups.clear()
	for child in _questions_container.get_children():
		_questions_container.remove_child(child)
		child.queue_free()

	for question in resident_questions:
		if not _is_valid_question(question):
			push_error("ReportForm: câu hỏi cư dân không hợp lệ: %s" % question)
			continue

		var resident_name: String = question["resident_name"]
		var question_box := VBoxContainer.new()
		question_box.add_theme_constant_override("separation", 4)
		_questions_container.add_child(question_box)

		var name_label := Label.new()
		name_label.text = resident_name
		question_box.add_child(name_label)

		var button_group := ButtonGroup.new()
		for option in question["options"]:
			var radio := CheckButton.new()
			radio.text = option["text"]
			radio.button_group = button_group
			radio.set_meta("report_option", option)
			radio.toggled.connect(_on_option_toggled)
			question_box.add_child(radio)

		_question_groups.append({
			"resident_id": question["resident_id"],
			"options": question["options"],
			"button_group": button_group,
		})

	_refresh_submit_button()


func _is_valid_question(question: Dictionary) -> bool:
	if not question.get("resident_id", null) is String:
		return false
	if not question.get("resident_name", null) is String:
		return false

	var options: Variant = question.get("options", null)
	if not options is Array or options.is_empty():
		return false
	for option in options:
		if not option is Dictionary:
			return false
		if not option.get("id", null) is String:
			return false
		if not option.get("text", null) is String:
			return false
		if not option.get("correct", null) is bool:
			return false
	var correct_option_count := 0
	for option in options:
		if option["correct"]:
			correct_option_count += 1
	if correct_option_count != 1:
		return false
	return true


func _on_option_toggled(is_pressed: bool) -> void:
	if is_pressed:
		_play_ui_click()
	_refresh_submit_button()


func _refresh_submit_button() -> void:
	if not is_instance_valid(_submit_button):
		return

	var all_answered := not _question_groups.is_empty()
	for question in _question_groups:
		var button_group: ButtonGroup = question["button_group"]
		if button_group.get_pressed_button() == null:
			all_answered = false
			break
	_submit_button.disabled = not all_answered or _has_submitted


func _on_submit_pressed() -> void:
	if _has_submitted:
		return

	var entries := _collect_report_entries()
	if entries.size() != _question_groups.size() or entries.is_empty():
		_result_label.text = "Hãy chọn một mức đánh giá cho mỗi cư dân."
		return

	for report in GameState.daily_reports:
		if report.get("day", -1) == GameState.current_day:
			_result_label.text = "Báo cáo hôm nay đã được nộp."
			_submit_button.disabled = true
			_has_submitted = true
			return

	var correct_count := 0
	var first_column: String = entries[0]["column"]
	var all_same_column := true
	for entry in entries:
		if entry["correct"]:
			correct_count += 1
		if entry["column"] != first_column:
			all_same_column = false

	var reward := maxi(0, base_reward) + correct_count * maxi(0, correct_answer_bonus)
	GameState.record_daily_report(entries)
	GameState.add_money(reward)
	_has_submitted = true
	_submit_button.disabled = true

	_result_label.text = "Đã nộp: %d/%d chính xác, %s cùng một cột. Thưởng: $%d." % [
		correct_count,
		entries.size(),
		"tất cả" if all_same_column else "không phải tất cả",
		reward,
	]

	_play_ui_click()
	if money_count_stream != null:
		AudioManager.play_sfx(money_count_stream)

	report_submitted.emit({
		"day": GameState.current_day,
		"entries": entries.duplicate(true),
		"correct_count": correct_count,
		"all_same_column": all_same_column,
		"reward": reward,
	})
	GameState.advance_day()


func _collect_report_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for question in _question_groups:
		var button_group: ButtonGroup = question["button_group"]
		var selected_button := button_group.get_pressed_button() as CheckButton
		if selected_button == null:
			continue

		var selected_option: Dictionary = selected_button.get_meta("report_option")

		entries.append({
			"resident_id": question["resident_id"],
			"column": selected_option["id"],
			"correct": selected_option["correct"],
		})
	return entries


func _play_ui_click() -> void:
	if ui_click_stream != null:
		AudioManager.play_sfx(ui_click_stream)
