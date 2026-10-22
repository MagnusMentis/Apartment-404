extends Control

# Signals gửi thông báo ra ngoài cho MainController biết
signal room_selected(room_id: String)
signal shift_completed()

@onready var guard_room_btn: Button = $VBoxContainer/GuardRoomBtn
@onready var grocery_btn: Button = $VBoxContainer/GroceryBtn
@onready var room_202_btn: Button = $VBoxContainer/Room202Btn
@onready var room_404_btn: Button = $VBoxContainer/Room404Btn
@onready var finish_shift_btn: Button = $VBoxContainer/FinishShiftBtn

func _ready() -> void:
	# Kết nối sự kiện khi bấm vào các nút
	guard_room_btn.pressed.connect(func(): _on_room_clicked("security_guard", guard_room_btn))
	grocery_btn.pressed.connect(func(): _on_room_clicked("grocery_lady", grocery_btn))
	room_202_btn.pressed.connect(func(): _on_room_clicked("room_202", room_202_btn))
	room_404_btn.pressed.connect(func(): _on_room_clicked("room_404", room_404_btn))
	
	finish_shift_btn.pressed.connect(_on_finish_shift_pressed)

func _on_room_clicked(room_id: String, btn: Button) -> void:
	btn.disabled = true # Làm mờ nút sau khi đã gõ cửa
	room_selected.emit(room_id)

func _on_finish_shift_pressed() -> void:
	shift_completed.emit()

# Hàm reset lại trạng thái các nút khi qua ngày mới
func reset_for_new_day() -> void:
	guard_room_btn.disabled = false
	grocery_btn.disabled = false
	room_202_btn.disabled = false
	room_404_btn.disabled = false
