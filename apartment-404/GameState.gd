extends Node

enum Day {
	MONDAY,
	TUESDAY,
	WEDNESDAY,
	THURSDAY,
	FRIDAY,
	SATURDAY,
	SUNDAY,
}

signal day_changed(new_day: Day)
signal money_changed(new_amount: int)

var current_day: Day = Day.MONDAY
var money: int = 0
var flags: Dictionary = {}
var daily_reports: Array[Dictionary] = []


## Lưu cờ cốt truyện theo khóa.
func set_flag(key: String, value: Variant) -> void:
	flags[key] = value


## Trả về giá trị cờ hoặc giá trị mặc định nếu khóa chưa tồn tại.
func get_flag(key: String, default: Variant = false) -> Variant:
	return flags.get(key, default)


## Kiểm tra khóa cờ đã được lưu hay chưa.
func has_flag(key: String) -> bool:
	return flags.has(key)


## Cập nhật tiền và phát tín hiệu nếu số tiền thực sự thay đổi.
func set_money(new_amount: int) -> void:
	if money == new_amount:
		return

	money = new_amount
	money_changed.emit(money)


## Cộng hoặc trừ tiền qua giao diện có phát tín hiệu.
func add_money(amount: int) -> void:
	set_money(money + amount)


## Xóa dữ liệu lượt chơi và khôi phục trạng thái mặc định của Thứ Hai.
func reset_game_state() -> void:
	var day_was_changed := current_day != Day.MONDAY
	current_day = Day.MONDAY
	flags.clear()
	daily_reports.clear()
	set_money(0)
	if day_was_changed:
		day_changed.emit(current_day)


## Lưu một báo cáo. Mỗi entry cần có "column" (String) và "correct" (bool).
func record_daily_report(entries: Array[Dictionary]) -> void:
	daily_reports.append({
		"day": current_day,
		"entries": entries.duplicate(true),
	})


## Đánh giá kết thúc vào Chủ Nhật; trước đó trả về chuỗi rỗng.
## Ưu tiên: BAD, GOOD, rồi RICH.
## Chuỗi cột liên tiếp được tính theo thứ tự entry trong lịch sử, kể cả qua ngày khác.
func evaluate_ending() -> String:
	if current_day != Day.SUNDAY:
		return ""

	var total_answers := 0
	var correct_answers := 0
	var previous_column := ""
	var consecutive_same_column := 0
	var has_three_same_column := false

	for report in daily_reports:
		var entries: Array = report.get("entries", [])
		for entry in entries:
			if not entry is Dictionary:
				continue

			total_answers += 1
			if entry.get("correct", false) == true:
				correct_answers += 1

			var column := str(entry.get("column", ""))
			if not column.is_empty() and column == previous_column:
				consecutive_same_column += 1
			else:
				previous_column = column
				consecutive_same_column = 1 if not column.is_empty() else 0

			if consecutive_same_column >= 3:
				has_three_same_column = true

	var all_answers_wrong := total_answers > 0 and correct_answers == 0
	if all_answers_wrong or has_three_same_column:
		return "BAD"

	var exactly_half_correct := total_answers > 0 and correct_answers * 2 == total_answers
	if exactly_half_correct and get_flag("reported_to_cps", false) == true:
		return "GOOD"

	if get_flag("delinquent_saved", false) == false:
		return "RICH"

	return ""


## Chuyển sang ngày kế tiếp; Chủ Nhật là ngày cuối nên không quay vòng.
func advance_day() -> void:
	if current_day == Day.SUNDAY:
		return

	current_day = (current_day + 1) as Day
	day_changed.emit(current_day)
