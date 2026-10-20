class_name EndingScreen
extends Control
## Plain text ending screen. Usage:
##   var s := EndingScreen.new()
##   s.ending_id = Endings.resolve(delinquent_saved)
##   add_child(s)

signal restart_requested

var ending_id: String = Endings.SILENCED


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.05, 0.07)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_FULL_RECT)
	box.offset_left = 80
	box.offset_right = -80
	box.offset_top = 80
	box.offset_bottom = -80
	box.add_theme_constant_override("separation", 24)
	add_child(box)

	var data := Endings.get_text(ending_id)

	var title := Label.new()
	title.text = data["title"]
	title.add_theme_font_size_override("font_size", 36)
	box.add_child(title)

	var body := RichTextLabel.new()
	body.text = data["body"]
	body.fit_content = true
	body.bbcode_enabled = false
	body.add_theme_font_size_override("normal_font_size", 22)
	box.add_child(body)

	var btn := Button.new()
	btn.text = "Back to menu"
	btn.pressed.connect(func(): restart_requested.emit())
	box.add_child(btn)
