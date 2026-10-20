extends Node
## AUTOLOAD (Project Settings > Globals > Autoload), name it: ReportState
## Person B: keeps everything related to the daily reports and the ending rules.
## Person C's GameState should NOT touch these variables directly; call the functions.

signal bad_ending_triggered   # same column ticked STREAK_LIMIT times in a row
signal evidence_sent_signal   # evidence submitted to Child Protection

# Columns of the report form
enum Choice { TRUTH, FALSE, PROTECT }

# ---- Rules (change them here, nowhere else) --------------------------------
const STREAK_LIMIT := 3        # same column ticked this many times in a row = Bad Ending
const BALANCE_MIN := 0.30      # Good Ending: share of truthful answers must be
const BALANCE_MAX := 0.70      #   between 30% and 70% ("half true, half false")
const OBEY_MIN_TRUTH := 0.80   # Rich Ending: at least 80% truthful (obeys the company)
# -----------------------------------------------------------------------------

var history: Array = []        # [{day, resident, choice}]
var streak_choice: int = -1
var streak_count: int = 0
var bad_ending := false
var evidence_sent := false

var truth_count := 0
var false_count := 0
var protect_count := 0


func reset() -> void:
	history.clear()
	streak_choice = -1
	streak_count = 0
	bad_ending = false
	evidence_sent = false
	truth_count = 0
	false_count = 0
	protect_count = 0


## Record ONE ticked row. Returns true if this row triggered the Bad Ending.
func record_row(day: int, resident: String, choice: int) -> bool:
	history.append({"day": day, "resident": resident, "choice": choice})
	match choice:
		Choice.TRUTH: truth_count += 1
		Choice.FALSE: false_count += 1
		Choice.PROTECT: protect_count += 1

	if choice == streak_choice:
		streak_count += 1
	else:
		streak_choice = choice
		streak_count = 1

	if streak_count >= STREAK_LIMIT and not bad_ending:
		bad_ending = true
		bad_ending_triggered.emit()
	return bad_ending


func send_evidence() -> void:
	if evidence_sent:
		return
	evidence_sent = true
	evidence_sent_signal.emit()


## Share of truthful answers among truthful + doctored answers. -1.0 if none yet.
func truth_ratio() -> float:
	var total := truth_count + false_count
	if total == 0:
		return -1.0
	return float(truth_count) / float(total)


func is_balanced() -> bool:
	var r := truth_ratio()
	return r >= BALANCE_MIN and r <= BALANCE_MAX


func is_obedient() -> bool:
	return truth_ratio() >= OBEY_MIN_TRUTH
