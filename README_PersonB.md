# Person B: Report and Endings (Godot 4)

# Files
- scripts/report_state.gd : AUTOLOAD `ReportState` ->  Stores ticks, 3-in-a-row rule, true/false score, evidence flag 
- scripts/report_form.gd : The report form UI (built in code, no assets) 
- scripts/endings.gd : Sunday branching `Endings.resolve(delinquent_saved)` + ending texts 
- scripts/ending_screen.gd : Plain text ending screen 
- scripts/test_report.gd : Test scene so you can play all 3 endings alone 
- data/dialogues_thu_sun_DRAFT.csv : Draft dialogues Thu to Sun (needs A's format) 

# Setup in Godot
1. Create a Godot 4 project, copy the `scripts` folder into it.
2. Project > Project Settings > Globals > Autoload: add `scripts/report_state.gd` with the name `ReportState`.
3. New scene: root node `Control`, attach `scripts/test_report.gd`, save it, press F6.

# for the 2 other programmers that want to be able to connect themself to this code
- Person C: `form = ReportForm.new(); form.day = X; form.residents = [...]; form.evidence_available = true/false; add_child(form)`; listen to `form.report_done`.
- Listen to `ReportState.bad_ending_triggered` and show `EndingScreen` with `Endings.SILENCED`.
- On Sunday night: `Endings.resolve(delinquent_saved)` then show `EndingScreen`.
- `delinquent_saved` is a variable owned by Person C.

# Test the 3 endings
- BAD: tick the same column for 3 rows in a row (the test form has 3 rows, so one report is enough).
- GOOD: mix Truthful and Doctored (30% to 70% truthful), tick the evidence box on day 3 or 4, and keep `Endings.resolve(true)`.
- RICH: on every report tick Truthful, Truthful, Omit (Omit rows are ignored in the ratio, so you stay at 100% truthful and never get 3 in a row), and change `Endings.resolve(true)` to `Endings.resolve(false)` in test_report.gd.

# Rules I had to GUESS (to be verify with the creative team)
1. "3 times in a row": I count the same column across consecutive rows, across all days (not reset between reports).
2. Is Omit/Protect a 3rd column? I added it because the GDD says "protect vulnerable residents".
3. "Half true, half false": I use 30% to 70% truthful (Omit rows ignored). Tweak in `report_state.gd`.
4. Rich ending = at least 80% truthful. Tweak `OBEY_MIN_TRUTH`.
5. If the student is saved but evidence is missing or the balance is wrong, the game falls to Rich or Bad.
6. Does the real form have the same rows as the NPCs of the day? Currently `residents` is passed in by the caller.

