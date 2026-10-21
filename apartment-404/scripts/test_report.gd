extends Control
## TEST SCENE for me. I attach this script to a Control root node, and press F6 to see if it works.
## Permit the player to play 4 fake days of reports and see which ending he gets.
## This file can be delete when the others (A and C) have connected the real game.

var day := 1
var form: ReportForm
var info: Label


func _ready() -> void:
	ReportState.reset()
	ReportState.bad_ending_triggered.connect(_on_bad_ending)

	info = Label.new()
	info.position = Vector2(40, 4)
	add_child(info)
	_new_day()


func _new_day() -> void:
	if form != null:
		form.queue_free()
	form = ReportForm.new()
	form.day = day
	form.residents = ["Alcoholic Man", "Grocery Lady", "Honor Student"]
	form.evidence_available = day >= 3     # fake: proof found from day 3
	form.report_done.connect(_on_report_done)
	add_child(form)
	_update_info()


func _on_report_done(_d: int) -> void:
	_update_info()
	if ReportState.bad_ending:
		return   # handled by _on_bad_ending
	if day >= 4:
		# pretend the delinquent student was saved on Sunday (change to false to test)
		_show_ending(Endings.resolve(true))
	else:
		day += 1
		_new_day()


func _on_bad_ending() -> void:
	_show_ending(Endings.resolve(false))


func _show_ending(id: String) -> void:
	if form != null:
		form.queue_free()
	var s := EndingScreen.new()
	s.ending_id = id
	s.restart_requested.connect(func(): get_tree().reload_current_scene())
	add_child(s)


func _update_info() -> void:
	info.text = "[debug] streak=%dx choice=%d | truth=%d false=%d protect=%d | ratio=%.2f | evidence=%s" % [
		ReportState.streak_count, ReportState.streak_choice,
		ReportState.truth_count, ReportState.false_count, ReportState.protect_count,
		ReportState.truth_ratio(), str(ReportState.evidence_sent)]
