class_name ReportForm
extends Control
## End-of-day report form. Built entirely in code (no scene needed, no assets).
## Usage:
##   var form := ReportForm.new()
##   form.day = 4
##   form.residents = ["Alcoholic Man", "Grocery Lady", "Honor Student"]
##   form.evidence_available = true     # Person C sets this when the player has proof
##   form.report_done.connect(_on_report_done)
##   add_child(form)

signal report_done(day: int)

@export var day: int = 1
@export var residents: Array[String] = ["Resident 1", "Resident 2", "Resident 3"]
@export var evidence_available: bool = false

const COLUMNS := ["Truthful", "Doctored", "Omit / Protect"]

var _groups: Array[ButtonGroup] = []
var _submit: Button
var _evidence_check: CheckBox
var _title: Label


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build()


func _build() -> void:
	var root := VBoxContainer.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 40
	root.offset_top = 30
	root.offset_right = -40
	root.offset_bottom = -30
	root.add_theme_constant_override("separation", 14)
	add_child(root)

	_title = Label.new()
	_title.text = "SHIFT DOSSIER - Day %d" % day
	_title.add_theme_font_size_override("font_size", 28)
	root.add_child(_title)

	var hint := Label.new()
	hint.text = "For each tenant, tick ONE box. The dispatcher reads everything."
	root.add_child(hint)

	var grid := GridContainer.new()
	grid.columns = COLUMNS.size() + 1
	grid.add_theme_constant_override("h_separation", 30)
	grid.add_theme_constant_override("v_separation", 12)
	root.add_child(grid)

	# header row
	grid.add_child(Label.new())
	for c in COLUMNS:
		var l := Label.new()
		l.text = c
		grid.add_child(l)

	# one row per resident, radio behaviour via ButtonGroup
	for r in residents:
		var name_label := Label.new()
		name_label.text = r
		name_label.custom_minimum_size.x = 220
		grid.add_child(name_label)

		var group := ButtonGroup.new()
		group.pressed.connect(_on_choice_changed)
		_groups.append(group)
		for i in COLUMNS.size():
			var cb := CheckBox.new()
			cb.button_group = group
			cb.set_meta("choice", i)   # 0=TRUTH 1=FALSE 2=PROTECT (matches ReportState.Choice)
			grid.add_child(cb)

	if evidence_available:
		_evidence_check = CheckBox.new()
		_evidence_check.text = "Also send my evidence to Child Protective Services"
		root.add_child(_evidence_check)

	_submit = Button.new()
	_submit.text = "File report"
	_submit.disabled = true
	_submit.pressed.connect(_on_submit)
	root.add_child(_submit)


func _on_choice_changed(_btn: BaseButton) -> void:
	for g in _groups:
		if g.get_pressed_button() == null:
			_submit.disabled = true
			return
	_submit.disabled = false


func _on_submit() -> void:
	# 1. record every row in order (the 3-in-a-row rule is checked inside ReportState)
	for i in residents.size():
		var btn := _groups[i].get_pressed_button()
		var choice: int = btn.get_meta("choice")
		ReportState.record_row(day, residents[i], choice)

	# 2. evidence to Child Protective Services (needed for the Good Ending)
	if _evidence_check != null and _evidence_check.button_pressed:
		ReportState.send_evidence()

	_submit.disabled = true
	report_done.emit(day)
