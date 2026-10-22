extends Control

# ==========================================
# DỮ LIỆU 7 NGÀY (Chuyển trực tiếp từ file HTML sang GDScript)
# ==========================================
const DAYS_DATA = [
	{
		"name": "THỨ HAI (Orientation)",
		"npcs": [
			{ "id": "guard", "icon": "👮", "name": "Ông Bảo Vệ", "text": "Luật ở chung cư này rất nghiêm: Cậu phải giao hàng tận cửa từng căn hộ! Đừng có lảng vảng gần phòng 404 nếu không muốn gặp chuyện ma quỷ." },
			{ "id": "grocery", "icon": "🏪", "name": "Bà Tạp Hóa", "text": "Này cậu shipper mới, cẩn thận cái phòng 404 nhé. Đêm nào tôi cũng nghe tiếng động quái đản phát ra từ đó đấy... Ma ám cả lũ rồi!" },
			{ "id": "rollers", "icon": "🦱", "name": "Bà Cuốn Lô", "text": "Chung cư này xuống cấp thật, may mà có thằng bé Học Sinh Giỏi ở tầng trên ngoan ngoãn, lễ phép hết chỗ chê!" },
			{ "id": "fortune", "icon": "🔮", "name": "Ông Thầy Bói", "text": "Ám khí nặng lắm... Quẻ bói chỉ thẳng vào phòng 404. Nơi đó đang giam giữ một linh hồn đau đớn." },
			{ "id": "couple", "icon": "👫", "name": "Cặp Đôi Trẻ", "text": "Bọn mình mới chuyển đến, thấy cậu Học Sinh Giỏi ở đây nhiệt tình thật sự, ai cũng quý." },
			{ "id": "honor", "icon": "🎓", "name": "Học Sinh Giỏi", "text": "Em cảm ơn anh shipper ạ! Anh vất vả quá. Ở đây có thằng Học Sinh Cá Biệt hơi quậy phá, anh cứ tránh xa nó ra nhé." }
		],
		"questions": [
			"Cư dân có đồn đại về hiện tượng tâm linh ở phòng 404 không?",
			"Thái độ của Học Sinh Giỏi có biểu hiện gì đáng ngờ không?"
		]
	},
	{
		"name": "THỨ BA (Discord)",
		"npcs": [
			{ "id": "pretty", "icon": "💃", "name": "Chị Xinh Đẹp", "text": "Eo ơi, tối qua chị đi ngang phòng 404 nghe tiếng xiềng xích hay va đập gì ghê lắm em ơi..." },
			{ "id": "drunk", "icon": "🍺", "name": "Ông Rượu Bia", "text": "Mẹ kiếp thằng Học Sinh Cá Biệt! Nhìn mặt nó là thấy ghét... *RẦM!* Mày có vừa nghe tiếng động lạ trên hành lang không?!" },
			{ "id": "elderly", "icon": "👵", "name": "Ông Bà Già", "text": "Người ta cứ đổ oan cho thằng bé Học Sinh Cá Biệt, chứ ông bà thấy nó hiền lành, tội nghiệp lắm chú ơi.", "clue": "Lời chứng minh oan cho HSCB" },
			{ "id": "chubby", "icon": "👩‍🍳", "name": "Bà Mũm Mĩm", "text": "Thằng Học Sinh Giỏi ngoan thật! À này, lão Bảo Vệ dưới sảnh nhìn khó tính thế thôi chứ mê đồ ngọt của tôi làm lắm." },
			{ "id": "thug", "icon": "🕶️", "name": "Ông Giang Hồ", "text": "Mày muốn tìm hiểu tầng 4 hả? Tao chỉ cho một lối đi tắt lên hành lang tầng 4 mà không bị để ý này.", "clue": "Lối dẫn lên tầng 4" },
			{ "id": "landlord", "icon": "🔑", "name": "Chủ Nhà", "text": "Giao hàng xong thì về đi, đừng có tò mò chuyện nội bộ của khu nhà này!" }
		],
		"questions": [
			"Ông Rượu Bia có nghe thấy âm thanh bất thường ở hành lang không?",
			"Người chơi có tìm cách tiếp cận thông tin tầng 4 từ Ông Giang Hồ không?"
		]
	},
	{
		"name": "THỨ TƯ (The Parcel)",
		"npcs": [
			{ "id": "delinquent", "icon": "🤕", "name": "Học Sinh Cá Biệt", "text": "(Nhận kiện hàng gửi từ Học Sinh Giỏi, tay run rẩy đầy vết bầm tím)... Làm ơn... đừng nói với nó là anh thấy tôi như thế này...", "clue": "Kiện hàng đe dọa từ HSG" },
			{ "id": "sick", "icon": "😷", "name": "Sinh Viên Nghèo Ốm", "text": "Khụ khụ... Cậu Học Sinh Cá Biệt hay chia thuốc cho tôi lắm. Nó không phải kẻ xấu như lời đồn đâu anh ạ." },
			{ "id": "drunk", "icon": "🍺", "name": "Ông Rượu Bia", "text": "Điên mất thôi! Tiếng đập phá phát ra ngay từ bên trong cái phòng 404 bị khóa kín kia kìa! Tao phải báo lên trên mới được!" },
			{ "id": "landlord", "icon": "🔑", "name": "Chủ Nhà", "text": "Mấy người làm loạn cái gì thế? Phòng 404 bỏ trống lâu rồi, làm gì có ai!" }
		],
		"questions": [
			"Học Sinh Cá Biệt có dấu hiệu hoảng loạn khi nhận hàng từ Học Sinh Giỏi không?",
			"Ông Rượu Bia có phát hiện ra tiếng động từ Phòng 404 không?"
		]
	},
	{
		"name": "THỨ NĂM (Surveillance)",
		"npcs": [
			{ "id": "cctv", "icon": "📹", "name": "Thợ Lắp Camera", "text": "Công ty của cậu thuê tôi gắn camera khắp các tầng. Lạ thật, ông Rượu Bia phòng bên cạnh tự dưng biến mất tiêu từ đêm qua rồi." },
			{ "id": "grocery", "icon": "🏪", "name": "Bà Tạp Hóa", "text": "Đừng nhìn vào phòng 202 nữa! Chỗ đó có ma báo oán đấy, ai hỏi tới là gặp họa như lão Rượu Bia ngay!" },
			{ "id": "honor", "icon": "🎓", "name": "Học Sinh Giỏi", "text": "(Cười lạnh) Anh shipper ơi, hôm qua thằng Học Sinh Cá Biệt nhận được món quà của em chưa ạ? Trông nó có... ngoan hơn không anh?" },
			{ "id": "delinquent", "icon": "🤕", "name": "Học Sinh Cá Biệt", "text": "Họ lắp camera để theo dõi tôi... Tôi không trốn đi đâu được nữa rồi, nó sẽ nhốt tôi vào phòng 404 mất!", "clue": "Dấu hiệu bạo hành & theo dõi" },
			{ "id": "fortune", "icon": "🔮", "name": "Ông Thầy Bói", "text": "Năm xưa ở phòng 202 từng xảy ra một vụ bạo hành trẻ vị thành niên dẫn đến án mạng kinh hoàng. Lịch sử đang lặp lại ở phòng 404!", "clue": "Hồ sơ vụ án phòng 202" },
			{ "id": "pretty", "icon": "💃", "name": "Chị Xinh Đẹp", "text": "(Run rẩy) Vụ án phòng 202... chị sợ quá, chắc chị không dám ở đây nữa đâu!" }
		],
		"questions": [
			"Học Sinh Cá Biệt có đang tìm cách cầu cứu người ngoài không?",
			"Cư dân có đang đào bới lại vụ án mạng ở Phòng 202 năm xưa không?"
		]
	},
	{
		"name": "THỨ SÁU (Escalation)",
		"npcs": [
			{ "id": "rollers", "icon": "🦱", "name": "Bà Cuốn Lô", "text": "Kỳ lạ thật, cứ cách một ngày là tôi lại nghe tiếng lịch kịch, va đập đều đặn ngay trên trần nhà (tầng 4)..." },
			{ "id": "thug", "icon": "🕶️", "name": "Ông Giang Hồ", "text": "Nghe tao nói này: Cái danh 'ma ám' chỉ là vỏ bọc thôi. Thằng Học Sinh Giỏi có tâm lý vặn vẹo, nó đang tra tấn thằng nhỏ Cá Biệt ở phòng 404 mỗi cách ngày đấy!", "clue": "Sự thật về căn phòng 404" },
			{ "id": "mom", "icon": "👩", "name": "Mẹ Học Sinh Giỏi", "text": "Con trai tôi đang bận ôn thi, cậu để hàng ở ngoài đi! Đừng có hỏi vặn vẹo tại sao nó không ra nhận hàng!" },
			{ "id": "landlord", "icon": "🔑", "name": "Chủ Nhà", "text": "Mọi thứ vẫn trong tầm kiểm soát. Cậu chỉ cần điền báo cáo ngoan ngoãn là tiền thưởng về đầy túi." },
			{ "id": "couple", "icon": "👫", "name": "Cặp Đôi Trẻ", "text": "(Đang đóng thùng đồ đạc) Tụi mình dọn đi ngay hôm nay đây! Chỗ này kinh khủng quá rồi!" }
		],
		"questions": [
			"Người chơi có phát hiện ra quy luật tiếng động ở tầng 4 mỗi cách ngày không?",
			"Có ai nghi ngờ hành tung của Học Sinh Giỏi không?"
		]
	},
	{
		"name": "THỨ BẢY (The Heist)",
		"npcs": [
			{ "id": "grocery", "icon": "🏪", "name": "Bà Tạp Hóa", "text": "Cậu muốn lẻn lên phòng 404 cứu người hả? Lão Bảo Vệ canh gác kỹ lắm, chỉ có bánh ngọt của Bà Mũm Mĩm mới dụ lão rời chốt thôi!" },
			{ "id": "elderly", "icon": "👵", "name": "Ông Bà Già", "text": "" },
			{ "id": "chubby", "icon": "👩‍🍳", "name": "Bà Mũm Mĩm", "text": "" },
			{ "id": "guard", "icon": "👮", "name": "Ông Bảo Vệ", "text": "" },
			{ "id": "fortune", "icon": "🔮", "name": "Ông Thầy Bói", "text": "Quẻ đại hung đã ứng! Trước khi màn đêm buông xuống vào ngày mai, sẽ có người phải bỏ mạng nếu không ai can thiệp!" },
			{ "id": "sick", "icon": "😷", "name": "Sinh Viên Nghèo Ốm", "text": "Anh ơi, hãy gửi toàn bộ bằng chứng cho Tổ chức Bảo vệ Trẻ em trước khi quá muộn!" },
			{ "id": "landlord", "icon": "🔑", "name": "Chủ Nhà", "text": "Hôm nay là ca cuối tuần rồi. Làm cho tốt phận sự của mình đi." }
		],
		"questions": [
			"Chốt canh của Bảo vệ tầng 4 có còn nguyên vẹn không?",
			"Mọi hoạt động tại Phòng 404 vẫn diễn ra theo đúng kế hoạch của công ty chứ?"
		]
	}
]

# ==========================================
# BIẾN TRẠNG THÁI (STATE)
# ==========================================
var day_index: int = 0
var money: int = 0
var visited_today: Dictionary = {}
var clues: Dictionary = {}
var heist_step: int = 0
var delinquent_saved: bool = false
var reported_to_cps: bool = false
var report_history: Array = []
var consecutive_same_col_count: int = 0
var last_full_col: String = ""

# Các Node UI được tạo tự động
var day_label: Label
var money_label: Label
var npc_avatar_label: Label
var npc_name_label: Label
var dialogue_label: Label
var room_grid: GridContainer
var special_box: VBoxContainer
var btn_open_report: Button
var report_panel: PanelContainer
var report_vbox: VBoxContainer
var q0_option: OptionButton
var q1_option: OptionButton
var q0_label: Label
var q1_label: Label
var clue_label: Label
var status_label: Label
var floor_label: Label
var elevator_buttons: Array[Button] = []
var room_panel: PanelContainer
var npc_scroll: ScrollContainer
var _panorama: Control
var _current_floor: int = 0
var _dialogue_active: bool = false
var _dialogue_step: int = 0
var _pending_npc: Dictionary = {}
var _pending_npc_button: Button
var _pending_interaction_valid: bool = true
var _skip_dialogue_button: Button
var _elevator_panel: PanelContainer
var _view_mode: String = "intro"
var _intro_overlay: PanelContainer
var _dorm_door_button: Button
var _stage_controls: Node
var _phone_panel: PanelContainer
var _phone_body: Label
var _dialogue_lines: Array[String] = []
var _dialogue_line_index: int = 0
var _json_dialogues: Dictionary = {}
var _dialogue_panel: PanelContainer
var _character_stage_label: Label
var _footer_bar: HBoxContainer

const JSON_DIALOGUE_IDS := {
	"guard": "mon_security", "grocery": "mon_grocery_lady",
	"rollers": "mon_hair_roller_lady", "fortune": "mon_fortune_teller",
	"couple": "mon_couple", "honor": "mon_honor_student"
}

# PLACEHOLDER: sửa câu này theo lời thoại của shipper trong kịch bản cuối.
const COURIER_REPLY_PLACEHOLDER: String = "Anh shipper: Ừm... mình nên nhớ chuyện này để ghi lại trong báo cáo cuối ngày."
func _ready() -> void:
	_load_json_dialogues()
	_build_ui()
	_render_day()
	_show_intro()


func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	if size.x <= 0.0 or size.y <= 0.0:
		return
	# The opening notice acts as a one-click dismiss overlay anywhere on screen.
	if _view_mode == "intro" and _intro_overlay != null and _intro_overlay.visible:
		_intro_overlay.hide()
		get_viewport().set_input_as_handled()
		return
	var point := Vector2(event.position.x / size.x, event.position.y / size.y)
	if _view_mode == "intro" and _point_in_rect(point, Rect2(0.73, 0.2, 0.14, 0.54)):
		_leave_dorm_room()
		get_viewport().set_input_as_handled()
		return
	if _point_in_rect(point, Rect2(0.82, 0.66, 0.16, 0.07)):
		_toggle_phone()
		get_viewport().set_input_as_handled()
		return
	if _view_mode == "corridor" and _point_in_rect(point, Rect2(0.41, 0.42, 0.18, 0.22)):
		_enter_elevator()
		get_viewport().set_input_as_handled()
		return
	if _view_mode == "corridor":
		for room_index in range(4):
			var room_hit_rect: Rect2 = _panorama.call("get_room_hit_rect", room_index)
			if _point_in_rect(point, room_hit_rect):
				_on_room_hotspot_pressed(room_index)
				get_viewport().set_input_as_handled()
				return


func _point_in_rect(point: Vector2, rect: Rect2) -> bool:
	return rect.has_point(point)


func _load_json_dialogues() -> void:
	var file := FileAccess.open("res://dialogues.json", FileAccess.READ)
	if file == null:
		push_warning("Không mở được dialogues.json; sẽ dùng lời thoại dự phòng trong Main.gd.")
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or not parsed.get("dialogues", []) is Array:
		push_warning("dialogues.json không đúng định dạng; sẽ dùng lời thoại dự phòng.")
		return
	for dialogue in parsed["dialogues"]:
		if dialogue is Dictionary and dialogue.has("id"):
			_json_dialogues[str(dialogue["id"])] = dialogue

# ==========================================
# TỰ ĐỘNG DỰNG GIAO DIỆN TRONG GODOT
# ==========================================
func _build_ui() -> void:
	_panorama = Control.new()
	_panorama.name = "PanoramaView"
	_panorama.set_script(load("res://scenes/ui/PanoramaView.gd"))
	_panorama.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_panorama.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_panorama)
	var shade := ColorRect.new()
	shade.color = Color(0.015, 0.02, 0.035, 0.38)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)
	var main_vbox := VBoxContainer.new()
	main_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	main_vbox.offset_left = 28.0
	main_vbox.offset_top = 18.0
	main_vbox.offset_right = -28.0
	main_vbox.offset_bottom = -18.0
	main_vbox.add_theme_constant_override("separation", 12)
	add_child(main_vbox)

	var hud_bar := HBoxContainer.new()
	hud_bar.add_theme_constant_override("separation", 24)
	main_vbox.add_child(hud_bar)
	day_label = Label.new()
	day_label.add_theme_color_override("font_color", Color("#f0c879"))
	hud_bar.add_child(day_label)
	var title_label := Label.new()
	title_label.text = "APARTMENT 404  /  NIGHT SHIFT"
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_color_override("font_color", Color("#f28a78"))
	hud_bar.add_child(title_label)
	money_label = Label.new()
	money_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	money_label.add_theme_color_override("font_color", Color("#a8d5ad"))
	hud_bar.add_child(money_label)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 16)
	main_vbox.add_child(body)
	_elevator_panel = PanelContainer.new()
	_elevator_panel.custom_minimum_size = Vector2(190.0, 0.0)
	body.add_child(_elevator_panel)
	var elevator_layout := VBoxContainer.new()
	elevator_layout.add_theme_constant_override("separation", 10)
	_elevator_panel.add_child(elevator_layout)
	var elevator_title := Label.new()
	elevator_title.text = "THANG MÁY  •  4 TẦNG"
	elevator_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	elevator_layout.add_child(elevator_title)
	floor_label = Label.new()
	floor_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	floor_label.add_theme_color_override("font_color", Color("#f0c879"))
	elevator_layout.add_child(floor_label)
	for floor_number in range(1, 5):
		var floor_button := Button.new()
		floor_button.text = "TẦNG %d" % floor_number
		floor_button.toggle_mode = true
		floor_button.focus_mode = Control.FOCUS_NONE
		floor_button.custom_minimum_size.y = 46.0
		floor_button.pressed.connect(_choose_elevator_floor.bind(floor_number))
		elevator_layout.add_child(floor_button)
		elevator_buttons.append(floor_button)
	var elevator_hint := Label.new()
	elevator_hint.text = "Rê chuột sang trái / phải để xoay góc nhìn."
	elevator_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	elevator_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	elevator_layout.add_child(elevator_hint)

	room_panel = PanelContainer.new()
	room_panel.custom_minimum_size = Vector2(390.0, 0.0)
	body.add_child(room_panel)
	var room_layout := VBoxContainer.new()
	room_layout.add_theme_constant_override("separation", 10)
	room_panel.add_child(room_layout)
	var room_title := Label.new()
	room_title.text = "CƯ DÂN TRÊN TẦNG"
	room_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	room_layout.add_child(room_title)
	npc_scroll = ScrollContainer.new()
	npc_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	npc_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	room_layout.add_child(npc_scroll)
	room_grid = GridContainer.new()
	room_grid.columns = 2
	room_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	room_grid.add_theme_constant_override("h_separation", 10)
	room_grid.add_theme_constant_override("v_separation", 10)
	npc_scroll.add_child(room_grid)
	special_box = VBoxContainer.new()
	special_box.add_theme_constant_override("separation", 8)
	room_layout.add_child(special_box)
	btn_open_report = Button.new()
	btn_open_report.text = "KẾT THÚC CA  •  GỬI BÁO CÁO"
	btn_open_report.focus_mode = Control.FOCUS_NONE
	btn_open_report.custom_minimum_size.y = 46.0
	btn_open_report.visible = false
	btn_open_report.pressed.connect(_open_report_form)
	room_layout.add_child(btn_open_report)

	report_panel = PanelContainer.new()
	report_panel.custom_minimum_size = Vector2(520.0, 0.0)
	report_panel.visible = false
	body.add_child(report_panel)
	report_vbox = VBoxContainer.new()
	report_vbox.add_theme_constant_override("separation", 10)
	report_panel.add_child(report_vbox)
	var report_title := Label.new()
	report_title.text = "BÁO CÁO CUỐI CA  •  Chọn cùng một cột 3 ngày liên tiếp sẽ dẫn tới BAD ENDING."
	report_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report_title.add_theme_color_override("font_color", Color("#ffaaa0"))
	report_vbox.add_child(report_title)
	q0_label = Label.new()
	q0_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report_vbox.add_child(q0_label)
	q0_option = OptionButton.new()
	q0_option.add_item("A  •  Báo cáo đúng sự thật (+$25)", 0)
	q0_option.add_item("B  •  Báo cáo giả / che giấu ($0)", 1)
	report_vbox.add_child(q0_option)
	q1_label = Label.new()
	q1_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report_vbox.add_child(q1_label)
	q1_option = OptionButton.new()
	q1_option.add_item("A  •  Báo cáo đúng sự thật (+$25)", 0)
	q1_option.add_item("B  •  Báo cáo giả / che giấu ($0)", 1)
	report_vbox.add_child(q1_option)
	var report_actions := HBoxContainer.new()
	report_vbox.add_child(report_actions)
	var cancel_report_button := Button.new()
	cancel_report_button.text = "QUAY LẠI HÀNH LANG"
	cancel_report_button.focus_mode = Control.FOCUS_NONE
	cancel_report_button.pressed.connect(_close_report_form)
	report_actions.add_child(cancel_report_button)
	var submit_report_button := Button.new()
	submit_report_button.text = "GỬI HỒ SƠ & QUA NGÀY TIẾP THEO"
	submit_report_button.focus_mode = Control.FOCUS_NONE
	submit_report_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	submit_report_button.pressed.connect(_submit_report)
	report_actions.add_child(submit_report_button)

	_character_stage_label = Label.new()
	_character_stage_label.anchor_left = 0.34
	_character_stage_label.anchor_top = 0.12
	_character_stage_label.anchor_right = 0.66
	_character_stage_label.anchor_bottom = 0.67
	_character_stage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_character_stage_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_character_stage_label.add_theme_font_size_override("font_size", 128)
	_character_stage_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_character_stage_label.visible = false
	add_child(_character_stage_label)

	_dialogue_panel = PanelContainer.new()
	_dialogue_panel.name = "NovelDialoguePanel"
	_dialogue_panel.anchor_left = 0.18
	_dialogue_panel.anchor_top = 0.7
	_dialogue_panel.anchor_right = 0.82
	_dialogue_panel.anchor_bottom = 0.96
	_dialogue_panel.visible = false
	_dialogue_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var novel_panel_style := StyleBoxFlat.new()
	novel_panel_style.bg_color = Color(0.07, 0.08, 0.11, 0.84)
	novel_panel_style.border_color = Color(0.74, 0.76, 0.8, 0.7)
	novel_panel_style.set_border_width_all(1)
	novel_panel_style.set_corner_radius_all(8)
	_dialogue_panel.add_theme_stylebox_override("panel", novel_panel_style)
	add_child(_dialogue_panel)
	var dialogue_layout := VBoxContainer.new()
	dialogue_layout.add_theme_constant_override("separation", 8)
	_dialogue_panel.add_child(dialogue_layout)
	var speaker_row := HBoxContainer.new()
	speaker_row.add_theme_constant_override("separation", 12)
	dialogue_layout.add_child(speaker_row)
	npc_avatar_label = Label.new()
	npc_avatar_label.text = "📦"
	npc_avatar_label.add_theme_font_size_override("font_size", 48)
	speaker_row.add_child(npc_avatar_label)
	npc_name_label = Label.new()
	npc_name_label.text = "CA LÀM VIỆC BẮT ĐẦU"
	npc_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	npc_name_label.add_theme_color_override("font_color", Color("#f0c879"))
	speaker_row.add_child(npc_name_label)
	_skip_dialogue_button = Button.new()
	_skip_dialogue_button.text = "BỎ QUA  ▸"
	_skip_dialogue_button.focus_mode = Control.FOCUS_NONE
	_skip_dialogue_button.visible = false
	_skip_dialogue_button.pressed.connect(_on_skip_dialogue_pressed)
	speaker_row.add_child(_skip_dialogue_button)
	dialogue_label = Label.new()
	dialogue_label.text = "Nhận đơn, khám phá từng tầng và trò chuyện với cư dân. Hãy dùng thang máy để di chuyển."
	dialogue_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dialogue_layout.add_child(dialogue_label)
	_footer_bar = HBoxContainer.new()
	main_vbox.add_child(_footer_bar)
	clue_label = Label.new()
	clue_label.text = "MANH MỐI (0/5): Chưa có"
	clue_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	clue_label.add_theme_color_override("font_color", Color("#a9dbe0"))
	_footer_bar.add_child(clue_label)
	status_label = Label.new()
	status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_footer_bar.add_child(status_label)
	room_layout.remove_child(btn_open_report)
	_footer_bar.add_child(btn_open_report)

	# Attach stage buttons directly to this full-screen Control. This gives their
	# anchors a well-defined viewport and keeps them in Godot's normal GUI input tree.
	_stage_controls = self
	# Invisible hotspot: the elevator is drawn in the panorama, so no floating text is needed.
	var elevator_hotspot := _make_stage_button("", Vector2(0.41, 0.42), Vector2(0.18, 0.22), _enter_elevator)
	elevator_hotspot.name = "ElevatorHotspot"
	var elevator_overlay := VBoxContainer.new()
	elevator_overlay.name = "ElevatorFloorButtons"
	elevator_overlay.anchor_left = 0.42
	elevator_overlay.anchor_top = 0.3
	elevator_overlay.anchor_right = 0.58
	elevator_overlay.anchor_bottom = 0.67
	elevator_overlay.visible = false
	elevator_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_stage_controls.add_child(elevator_overlay)
	for floor_number in range(1, 5):
		var floor_button := Button.new()
		floor_button.text = "ĐI ĐẾN TẦNG %d" % floor_number
		floor_button.focus_mode = Control.FOCUS_NONE
		floor_button.pressed.connect(_choose_elevator_floor.bind(floor_number))
		elevator_overlay.add_child(floor_button)
	var hall_button := Button.new()
	hall_button.text = "RA HÀNH LANG"
	hall_button.focus_mode = Control.FOCUS_NONE
	hall_button.pressed.connect(_exit_elevator)
	elevator_overlay.add_child(hall_button)
	var phone_button := Button.new()
	phone_button.text = "📱  ĐIỆN THOẠI"
	phone_button.name = "PhoneToggleButton"
	phone_button.anchor_left = 0.82
	phone_button.anchor_top = 0.66
	phone_button.anchor_right = 0.98
	phone_button.anchor_bottom = 0.73
	phone_button.mouse_filter = Control.MOUSE_FILTER_STOP
	phone_button.focus_mode = Control.FOCUS_NONE
	_stage_controls.add_child(phone_button)
	_phone_panel = PanelContainer.new()
	_phone_panel.anchor_left = 0.40
	_phone_panel.anchor_top = 0.10
	_phone_panel.anchor_right = 0.98
	_phone_panel.anchor_bottom = 0.84
	_phone_panel.visible = false
	_phone_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_stage_controls.add_child(_phone_panel)
	_phone_body = Label.new()
	_phone_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var phone_layout := VBoxContainer.new()
	phone_layout.add_theme_constant_override("separation", 10)
	_phone_panel.add_child(phone_layout)
	phone_layout.add_child(_phone_body)
	var close_phone_button := Button.new()
	close_phone_button.text = "ĐÓNG ĐIỆN THOẠI"
	close_phone_button.focus_mode = Control.FOCUS_NONE
	close_phone_button.pressed.connect(_close_report_form)
	phone_layout.add_child(close_phone_button)
	# Put the end-of-shift form inside the phone, alongside the order screen.
	report_panel.reparent(phone_layout)
	report_panel.custom_minimum_size = Vector2.ZERO
	report_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_intro_overlay = PanelContainer.new()
	_intro_overlay.anchor_left = 0.3
	_intro_overlay.anchor_top = 0.24
	_intro_overlay.anchor_right = 0.7
	_intro_overlay.anchor_bottom = 0.72
	_intro_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_stage_controls.add_child(_intro_overlay)
	_dorm_door_button = _make_stage_button("MỞ CỬA", Vector2(0.73, 0.2), Vector2(0.14, 0.54), _leave_dorm_room)
	_dorm_door_button.name = "DormDoorHotspot"
	var intro_content := VBoxContainer.new()
	_intro_overlay.add_child(intro_content)
	var intro_title := Label.new()
	intro_title.text = "PHÒNG TRỌ CỦA SHIPPER"
	intro_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	intro_content.add_child(intro_title)
	var intro_text := Label.new()
	intro_text.text = "Ca giao hàng đầu tiên đang chờ. Điện thoại đã nhận đơn; hãy mở cửa để tới chung cư 404."
	intro_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro_content.add_child(intro_text)
	var leave_room_button := Button.new()
	leave_room_button.text = "MỞ CỬA  •  ĐẾN CHUNG CƯ"
	leave_room_button.focus_mode = Control.FOCUS_NONE
	leave_room_button.pressed.connect(_leave_dorm_room)
	intro_content.add_child(leave_room_button)
	_phone_body.text = _get_phone_order_text()
	_refresh_stage_controls()


func _make_stage_button(button_text: String, anchor_position: Vector2, dimensions: Vector2, callback: Callable) -> Button:
	var button := Button.new()
	button.text = button_text
	button.focus_mode = Control.FOCUS_NONE
	button.flat = true
	button.anchor_left = anchor_position.x
	button.anchor_top = anchor_position.y
	button.anchor_right = anchor_position.x + dimensions.x
	button.anchor_bottom = anchor_position.y + dimensions.y
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.pressed.connect(callback)
	_stage_controls.add_child(button)
	return button


func _show_intro() -> void:
	_view_mode = "intro"
	if _panorama.has_method("set_view_mode"):
		_panorama.call("set_view_mode", _view_mode)
	_refresh_stage_controls()


func _leave_dorm_room() -> void:
	get_viewport().gui_release_focus()
	_view_mode = "corridor"
	_intro_overlay.hide()
	if _panorama.has_method("set_view_mode"):
		_panorama.call("set_view_mode", _view_mode)
	dialogue_label.text = "Bạn bước ra khỏi phòng trọ. Đơn hàng hôm nay nằm trong điện thoại; hãy tới đúng cửa phòng."
	_refresh_stage_controls()
	_render_room_buttons()


func _enter_elevator() -> void:
	if _dialogue_active or _view_mode != "corridor":
		return
	_view_mode = "elevator"
	if _panorama.has_method("set_view_mode"):
		_panorama.call("set_view_mode", _view_mode)
	dialogue_label.text = "Chọn tầng cần đến. Thang máy sẽ đưa bạn thẳng tới hành lang tầng đó."
	_refresh_stage_controls()


func _choose_elevator_floor(floor_number: int) -> void:
	_set_current_floor(floor_number)
	_exit_elevator()


func _exit_elevator() -> void:
	_view_mode = "corridor"
	if _panorama.has_method("set_view_mode"):
		_panorama.call("set_view_mode", _view_mode)
	dialogue_label.text = "Bạn đã ra khỏi thang máy ở tầng %d. Bấm một trong bốn cửa phòng để giao hàng." % _current_floor
	_refresh_stage_controls()
	_render_room_buttons()


func _refresh_stage_controls() -> void:
	if _stage_controls == null:
		return
	var elevator_hotspot := _stage_controls.get_node_or_null("ElevatorHotspot") as Button
	if elevator_hotspot != null:
		elevator_hotspot.visible = _view_mode == "corridor"
	if _elevator_panel != null:
		_elevator_panel.visible = false
	if room_panel != null:
		room_panel.visible = false
	var floor_choices := _stage_controls.get_node_or_null("ElevatorFloorButtons")
	if floor_choices != null:
		floor_choices.visible = _view_mode == "elevator"
	var phone_button := _stage_controls.get_node_or_null("PhoneToggleButton") as Button
	if phone_button != null:
		phone_button.visible = not _phone_panel.visible
	if _intro_overlay != null:
		_intro_overlay.visible = _view_mode == "intro"
	if _dorm_door_button != null:
		_dorm_door_button.visible = _view_mode == "intro"


func _toggle_phone() -> void:
	_phone_body.text = _get_phone_order_text()
	_phone_body.show()
	report_panel.hide()
	_phone_panel.visible = not _phone_panel.visible
	_refresh_stage_controls()


func _get_phone_order_text() -> String:
	var day_data: Dictionary = DAYS_DATA[day_index]
	var order_lines: PackedStringArray = ["ĐƠN GIAO HÀNG  •  %s" % day_data["name"], "", "Các địa chỉ cần ghé:"]
	for npc in day_data["npcs"]:
		var room_num := _room_number_for_npc(npc)
		order_lines.append("• Tầng %d  •  Phòng %d0%d  •  %s" % [_npc_floor(npc), _npc_floor(npc), room_num, npc.get("name", "Cư dân")])
	return "\n".join(order_lines)


func _room_number_for_npc(npc: Dictionary) -> int:
	var floor_number := _npc_floor(npc)
	var room_index := 0
	for candidate in DAYS_DATA[day_index]["npcs"]:
		if _npc_floor(candidate) != floor_number:
			continue
		if candidate.get("id", "") == npc.get("id", ""):
			return room_index % 4 + 1
		room_index += 1
	return 1


func _on_room_hotspot_pressed(room_index: int) -> void:
	if _view_mode != "corridor" or _dialogue_active:
		return
	var occupants: Array[Dictionary] = []
	var day_data: Dictionary = DAYS_DATA[day_index]
	for npc in day_data["npcs"]:
		if _npc_floor(npc) == _current_floor:
			occupants.append(npc)
	if room_index >= occupants.size():
		var empty_room_npc: Dictionary = {
			"id": "empty_%d_%d" % [_current_floor, room_index + 1],
			"icon": "👤",
			"name": "Căn hộ %d0%d" % [_current_floor, room_index + 1],
			"text": "Không có ai nhận hàng. Hành lang im lặng sau cánh cửa khép kín.",
			"is_empty": true
		}
		_interact_npc(empty_room_npc, null)
		if _dialogue_active:
			_enter_room_scene(empty_room_npc, room_index + 1)
		return
	var npc: Dictionary = occupants[room_index]
	var npc_button := _find_npc_button(npc.get("id", ""))
	_interact_npc(npc, npc_button)
	if _dialogue_active:
		_enter_room_scene(npc, room_index + 1)


func _enter_room_scene(npc: Dictionary, room_number: int) -> void:
	_view_mode = "room"
	_phone_panel.hide()
	_character_stage_label.text = str(npc.get("icon", "👤"))
	_character_stage_label.visible = true
	_footer_bar.hide()
	if _panorama.has_method("set_room_index"):
		_panorama.call("set_room_index", room_number)
	if _panorama.has_method("set_view_mode"):
		_panorama.call("set_view_mode", "room")
	_refresh_stage_controls()


func _find_npc_button(npc_id: String) -> Button:
	for child in room_grid.get_children():
		if child is Button and child.get_meta("npc_id", "") == npc_id:
			return child
	return null

# ==========================================
# LOGIC VÒNG LẶP GAMEPLAY
# ==========================================
func _render_day() -> void:
	var day_data: Dictionary = DAYS_DATA[day_index]
	day_label.text = day_data["name"]
	money_label.text = "LƯƠNG: $%d" % money
	visited_today.clear()
	_dialogue_active = false
	_skip_dialogue_button.hide()
	_dialogue_panel.hide()
	_character_stage_label.hide()
	_footer_bar.show()
	report_panel.hide()
	room_panel.hide()
	npc_scroll.show()
	_set_current_floor(1)
	_update_special_actions()
	_update_shift_status()
	_render_npcs_for_floor()
	_check_shift_progress()
	npc_avatar_label.text = "📦"
	npc_name_label.text = "BẠN  •  SHIPPER"
	dialogue_label.text = "Ca mới bắt đầu. Rê chuột để nhìn quanh, dùng thang máy để khám phá đủ 4 tầng và chọn cư dân để trò chuyện."


func _on_elevator_button_pressed(floor_number: int) -> void:
	_set_current_floor(floor_number)


func _set_current_floor(floor_number: int) -> void:
	if _dialogue_active:
		return
	_current_floor = clampi(floor_number, 1, 4)
	floor_label.text = "ĐANG Ở  •  TẦNG %d" % _current_floor
	for index in range(elevator_buttons.size()):
		elevator_buttons[index].button_pressed = index + 1 == _current_floor
	if is_instance_valid(_panorama):
		_panorama.call("set_floor", _current_floor)
	if room_panel != null:
		_render_npcs_for_floor()


func _npc_floor(npc: Dictionary) -> int:
	var npc_id: String = npc.get("id", "")
	if npc_id == "guard" and day_index == 5:
		return 4
	match npc_id:
		"guard", "grocery", "drunk", "landlord":
			return 1
		"rollers", "couple", "pretty", "elderly", "chubby":
			return 2
		"honor", "sick", "mom", "cctv":
			return 3
		"fortune", "thug", "delinquent":
			return 4
	return 1


func _render_npcs_for_floor() -> void:
	_render_room_buttons()


func _render_room_buttons() -> void:
	if room_grid == null:
		return
	for child in room_grid.get_children():
		room_grid.remove_child(child)
		child.queue_free()
	var day_data: Dictionary = DAYS_DATA[day_index]
	var occupants: Array[Dictionary] = []
	for npc in day_data["npcs"]:
		if _npc_floor(npc) == _current_floor:
			occupants.append(npc)
	for room_index in range(4):
		var room_number := room_index + 1
		var button := Button.new()
		button.focus_mode = Control.FOCUS_NONE
		button.custom_minimum_size = Vector2(220.0, 64.0)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if room_index >= occupants.size():
			button.text = "PHÒNG %d0%d\nKhông có đơn hôm nay" % [_current_floor, room_number]
			button.disabled = true
		else:
			var npc: Dictionary = occupants[room_index]
			button.text = "PHÒNG %d0%d  %s\n%s" % [_current_floor, room_number, npc.get("icon", "👤"), npc.get("name", "Cư dân")]
			button.set_meta("npc_id", npc["id"])
			button.disabled = visited_today.has(npc["id"])
			button.pressed.connect(_interact_npc.bind(npc, button))
		room_grid.add_child(button)


func _interact_npc(npc: Dictionary, button: Button) -> void:
	if _dialogue_active or _view_mode != "corridor" or visited_today.has(npc["id"]):
		return
	var dialogue: String = npc.get("text", "")
	var can_complete: bool = not bool(npc.get("is_empty", false))

	# Chuỗi nhiệm vụ Thứ Bảy: nguyên liệu -> bánh ngọt -> dụ bảo vệ rời chốt.
	if day_index == 5:
		if npc["id"] == "elderly":
			heist_step = maxi(heist_step, 1)
			dialogue = "Cầm lấy bột mì và trứng sữa đem qua cho Bà Mũm Mĩm làm bánh nhé. Phải dụ lão Bảo Vệ rời chốt mới tới được Phòng 404!"
		elif npc["id"] == "chubby":
			if heist_step >= 1:
				heist_step = maxi(heist_step, 2)
				dialogue = "Đủ nguyên liệu rồi! Bánh vừa ra lò đây. Cậu đem xuống mời lão Bảo Vệ lên phòng tôi nhé!"
			else:
				dialogue = "Tôi hết bột đường rồi. Hình như Ông Bà Già còn nguyên liệu, cậu qua xin giúp tôi nhé!"
				can_complete = false
		elif npc["id"] == "guard":
			if heist_step >= 2:
				heist_step = 3
				delinquent_saved = true
				dialogue = "Bà Mũm Mĩm mời tôi lên ăn bánh à? Tôi đi ngay đây! Bạn tranh thủ mở Phòng 404 và giải cứu cậu bé."
			else:
				dialogue = "Tầng 4 đang hạn chế người qua lại. Trừ khi có bánh của Bà Mũm Mĩm, tôi sẽ không rời chốt đâu!"
				can_complete = false
	_start_npc_dialogue(npc, button, dialogue, can_complete)


func _start_npc_dialogue(npc: Dictionary, button: Button, line: String, can_complete: bool) -> void:
	_pending_npc = npc
	_pending_npc_button = button
	_pending_interaction_valid = can_complete
	_dialogue_active = true
	_dialogue_panel.show()
	_footer_bar.hide()
	_dialogue_step = 0
	_dialogue_line_index = 0
	_dialogue_lines.clear()
	var json_id: String = JSON_DIALOGUE_IDS.get(str(npc.get("id", "")), "") if day_index == 0 else ""
	if not json_id.is_empty() and _json_dialogues.has(json_id):
		var json_data: Dictionary = _json_dialogues[json_id]
		for json_line in json_data.get("lines", []):
			if json_line is String:
				_dialogue_lines.append(json_line)
	if _dialogue_lines.is_empty() or day_index != 0:
		_dialogue_lines.append(line)
	npc_avatar_label.text = npc.get("icon", "👤")
	npc_name_label.text = npc.get("name", "Cư dân")
	dialogue_label.text = _dialogue_lines[0] if not _dialogue_lines[0].is_empty() else "Cư dân im lặng trong giây lát, rồi gật đầu thay cho lời chào."
	_skip_dialogue_button.text = "TIẾP TỤC  ▸"
	_skip_dialogue_button.show()


func _on_skip_dialogue_pressed() -> void:
	if not _dialogue_active:
		return
	if _dialogue_line_index + 1 < _dialogue_lines.size():
		_dialogue_line_index += 1
		dialogue_label.text = _dialogue_lines[_dialogue_line_index]
		return
	if _dialogue_step == 0:
		_dialogue_step = 1
		npc_avatar_label.text = "🧍"
		npc_name_label.text = "ANH SHIPPER  •  PLACEHOLDER"
		dialogue_label.text = COURIER_REPLY_PLACEHOLDER
		_skip_dialogue_button.text = "TIẾP TỤC  ▸"
		return
	_finish_npc_dialogue()


func _finish_npc_dialogue() -> void:
	_dialogue_active = false
	_skip_dialogue_button.hide()
	if _pending_interaction_valid:
		var npc_id: String = _pending_npc["id"]
		visited_today[npc_id] = true
		if _pending_npc.has("clue"):
			clues[_pending_npc["clue"]] = true
			clue_label.text = "MANH MỐI (%d/5): %s" % [clues.size(), ", ".join(clues.keys())]
	_update_special_actions()
	_update_shift_status()
	_render_npcs_for_floor()
	_check_shift_progress()
	_pending_npc = {}
	_pending_npc_button = null
	_dialogue_panel.hide()
	_footer_bar.show()
	_character_stage_label.hide()
	_view_mode = "corridor"
	if _panorama.has_method("set_view_mode"):
		_panorama.call("set_view_mode", _view_mode)
	_refresh_stage_controls()
	npc_avatar_label.text = "📦"
	npc_name_label.text = "BẠN  •  SHIPPER"
	dialogue_label.text = "Cuộc trò chuyện đã kết thúc. Tiếp tục khám phá tầng này hoặc gọi thang máy."


func _update_shift_status() -> void:
	status_label.text = "CPS: %s  |  Phòng 404: %s" % [
		"Đã báo" if reported_to_cps else "Chưa báo",
		"Đã cứu" if delinquent_saved else "Chưa cứu"
	]


func _update_special_actions() -> void:
	for child in special_box.get_children():
		child.queue_free()

	if clues.size() >= 3 and not reported_to_cps:
		var cps_btn = Button.new()
		cps_btn.text = "📞 GỬI BẰNG CHỨNG MẬT CHO TỔ CHỨC BẢO VỆ TRẺ EM (CPS)"
		cps_btn.custom_minimum_size = Vector2(450, 40)
		cps_btn.pressed.connect(func():
			reported_to_cps = true
			_update_special_actions()
		)
		special_box.add_child(cps_btn)

	status_label.text = "Hồ sơ CPS: %s | Giải cứu Phòng 404: %s" % [
		"Đã gửi" if reported_to_cps else "Chưa báo",
		"Thành công" if delinquent_saved else "Chưa"
	]

func _check_shift_progress() -> void:
	var day_data = DAYS_DATA[day_index]
	btn_open_report.visible = visited_today.size() >= min(3, day_data["npcs"].size())

func _open_report_form() -> void:
	if _dialogue_active:
		return
	_view_mode = "intro"
	if _panorama.has_method("set_view_mode"):
		_panorama.call("set_view_mode", _view_mode)
	var day_data: Dictionary = DAYS_DATA[day_index]
	q0_label.text = "1. " + day_data["questions"][0]
	q1_label.text = "2. " + day_data["questions"][1]
	q0_option.select(0)
	q1_option.select(0)
	room_panel.hide()
	_phone_body.hide()
	_phone_panel.show()
	report_panel.show()
	if _intro_overlay != null:
		_intro_overlay.hide()
	_refresh_stage_controls()


func _close_report_form() -> void:
	report_panel.hide()
	_phone_panel.hide()
	_phone_body.show()
	room_panel.hide()
	_check_shift_progress()
	_refresh_stage_controls()


func _submit_report() -> void:
	var c0 = "A" if q0_option.selected == 0 else "B"
	var c1 = "A" if q1_option.selected == 0 else "B"
	report_history.append([c0, c1])

	if c0 == "A": money += 25
	if c1 == "A": money += 25

	if c0 == c1:
		if last_full_col == c0:
			consecutive_same_col_count += 1
		else:
			last_full_col = c0
			consecutive_same_col_count = 1
	else:
		last_full_col = ""
		consecutive_same_col_count = 0

	if day_index < DAYS_DATA.size() - 1:
		day_index += 1
		_phone_panel.hide()
		report_panel.hide()
		_phone_body.show()
		_view_mode = "intro"
		if _panorama.has_method("set_view_mode"):
			_panorama.call("set_view_mode", _view_mode)
		_refresh_stage_controls()
		_phone_body.text = _get_phone_order_text()
		npc_avatar_label.text = "🌙"
		npc_name_label.text = "QUA ĐÊM AN TOÀN..."
		dialogue_label.text = "Báo cáo đã gửi. Một ngày mới bắt đầu; hãy xem đơn hàng trên điện thoại rồi ra hành lang."
		_render_day()
	else:
		_trigger_sunday_ending()

func _trigger_sunday_ending() -> void:
	day_label.text = "CHỦ NHẬT (PHÁN QUYẾT)"
	report_panel.hide()
	room_panel.hide()
	npc_scroll.hide()
	room_grid.visible = false
	btn_open_report.hide()

	var count_a = 0
	var count_b = 0
	for pair in report_history:
		for v in pair:
			if v == "A": count_a += 1
			else: count_b += 1

	if consecutive_same_col_count >= 3 or count_a == 0:
		npc_avatar_label.text = "💀"
		npc_name_label.text = "BAD ENDING: SILENCED (BỊ THỦ TIÊU)"
		dialogue_label.text = "Hệ thống phát hiện bạn điền báo cáo rập khuôn (tick 1 cột 3 lần liên tiếp hoặc khai giả toàn bộ). Công ty kết luận bạn là mối nguy hại và thủ tiêu bạn tại Phòng 404."
	elif delinquent_saved and reported_to_cps and count_a > 0 and count_b > 0:
		npc_avatar_label.text = "🌅"
		npc_name_label.text = "GOOD ENDING: JUSTICE SERVED (CÔNG LÝ ĐƯỢC THỰC THI)"
		dialogue_label.text = "Nhờ báo cáo nửa thật nửa giả đánh lạc hướng công ty, kết hợp giải cứu Học Sinh Cá Biệt ở Phòng 404 và gửi bằng chứng cho Tổ chức Bảo vệ Trẻ em (CPS), đường dây bạo hành đã bị triệt phá!"
	else:
		npc_avatar_label.text = "💼"
		npc_name_label.text = "RICH ENDING: CORRUPTED (KẺ ĐỒNG LÕA THAM TIỀN)"
		dialogue_label.text = "Bạn bỏ mặc cậu bé Học Sinh Cá Biệt để đổi lấy $%d tiền thưởng. Công ty thăng chức cho bạn thành Quản lý Giám sát cấp cao, xóa bỏ mọi ranh giới đạo đức." % money

	var restart_btn = Button.new()
	restart_btn.text = "🔄 CHƠI LẠI TỪ THỨ HAI"
	restart_btn.custom_minimum_size = Vector2(300, 44)
	restart_btn.pressed.connect(func(): get_tree().reload_current_scene())
	special_box.add_child(restart_btn)
