class_name Endings
extends RefCounted
## Sunday branching + ending texts (text only for the prototype).
## Call:  var id := Endings.resolve(delinquent_saved)   then   Endings.get_text(id)

const SILENCED := "SILENCED"
const JUSTICE := "JUSTICE"
const CORRUPTED := "CORRUPTED"

const TEXTS := {
	SILENCED: {
		"title": "BAD ENDING: SILENCED",
		"body": "The agency reads your reports twice. Same answers, again and again.\n\n" \
			+ "\"Careless,\" the dispatcher says, and closes your file.\n" \
			+ "Nobody asks where the new courier went. The building keeps its secrets, " \
			+ "and Apartment 404 receives one more parcel."
	},
	JUSTICE: {
		"title": "GOOD ENDING: JUSTICE SERVED",
		"body": "Your reports were just honest enough to keep you in the building, " \
			+ "and the evidence reached the right desk.\n\n" \
			+ "Child Protection opens the case. The network falls apart, one door at a time. " \
			+ "The student is safe at last, and the courier hands in his badge."
	},
	CORRUPTED: {
		"title": "RICH ENDING: CORRUPTED",
		"body": "You followed every instruction. Every form, every bonus.\n\n" \
			+ "The agency promotes you to senior operative. The pay is excellent. " \
			+ "You no longer wonder what is behind the sealed doors. " \
			+ "That is the real cost."
	},
}


## Decide the ending on Sunday night.
## delinquent_saved: set by Person C / the Sunday dialogue branch.
static func resolve(delinquent_saved: bool) -> String:
	# 1. Repetition trap always wins
	if ReportState.bad_ending:
		return SILENCED

	# 2. Good ending needs ALL three conditions
	if delinquent_saved and ReportState.evidence_sent and ReportState.is_balanced():
		return JUSTICE

	# 3. Otherwise (student not saved, or conditions missing):
	#    obedient = Rich, careless/uncooperative = Silenced
	if ReportState.is_obedient():
		return CORRUPTED
	return SILENCED


static func get_text(id: String) -> Dictionary:
	return TEXTS[id]
