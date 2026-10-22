extends Control

const ENDINGS: Dictionary = {
	"BAD": {
		"title": "BAD ENDING: Bạn đã chết / Shipper Died",
		"description": "Những báo cáo sai lệch khiến bạn bỏ qua các dấu hiệu nguy hiểm trong khu chung cư. Đêm Chủ Nhật, cánh cửa phòng 404 mở ra. Bạn bước vào mà không ai nhìn thấy mình quay trở lại. Cậu bé vẫn mắc kẹt sau cánh cửa, còn hồ sơ của công ty ghi rằng mọi đơn hàng đều đã được giao.",
	},
	"GOOD": {
		"title": "GOOD ENDING: Giải cứu thành công",
		"description": "Bạn đã dám báo sự việc cho Tổ chức bảo vệ trẻ em và không để những lời đồn lấn át sự thật. Nhờ các báo cáo và bằng chứng bạn thu thập được, cậu bé được tìm thấy và đưa đến nơi an toàn. Bạn sống sót rời khỏi Apartment 404, mang theo cảm giác rằng cuối cùng mình đã làm điều đúng đắn.",
	},
	"RICH": {
		"title": "RICH ENDING: Kẻ đồng lõa tham tiền",
		"description": "Bạn chọn giữ im lặng và tiếp tục nhận tiền thưởng, dù biết cậu bé cần được giúp đỡ. Những khoản tiền tích lũy đủ để đổi lấy một cuộc sống dư dả, nhưng báo cáo đẹp đẽ của bạn đã giúp những người có trách nhiệm che giấu sự thật. Cậu bé vẫn ở lại phía sau cánh cửa phòng 404, còn bạn trở thành kẻ đồng lõa giàu có.",
	},
}

var _title_label: Label
var _description_label: Label
var _restart_button: Button


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_interface()
	hide()


## Hiển thị nội dung tương ứng với kết quả từ GameState.evaluate_ending().
func show_ending(ending: String) -> void:
	if not ENDINGS.has(ending):
		push_error("EndingScreen: ending không hợp lệ '%s'." % ending)
		return

	if not is_node_ready():
		await ready

	var ending_data: Dictionary = ENDINGS[ending]
	_title_label.text = ending_data["title"]
	_description_label.text = ending_data["description"]
	show()


func _build_interface() -> void:
	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color(0.025, 0.02, 0.035, 0.96)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(background)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(680.0, 420.0)
	center.add_child(panel)

	var layout := VBoxContainer.new()
	layout.add_theme_constant_override("separation", 20)
	panel.add_child(layout)

	_title_label = Label.new()
	_title_label.name = "EndingTitle"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	layout.add_child(_title_label)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	layout.add_child(scroll)

	_description_label = Label.new()
	_description_label.name = "EndingDescription"
	_description_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scroll.add_child(_description_label)

	_restart_button = Button.new()
	_restart_button.name = "RestartButton"
	_restart_button.text = "Chơi lại"
	_restart_button.pressed.connect(_on_restart_pressed)
	layout.add_child(_restart_button)


func _on_restart_pressed() -> void:
	GameState.reset_game_state()

	var reload_error := get_tree().reload_current_scene()
	if reload_error != OK:
		push_error("EndingScreen: không thể tải lại cảnh hiện tại (mã lỗi %d)." % reload_error)
