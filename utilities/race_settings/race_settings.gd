class_name RaceSettings extends Resource

enum Mode {
	RACE,
	TIME_TRIAL,
}

var laps: int = 0:
	set(l):
		if l < 0 or l == laps:
			return
		laps = l
		laps_changed.emit(l)
var mode: Mode = Mode.RACE:
	set(m):
		if !Mode.values().has(m) or m == mode:
			return
		mode = m
		mode_changed.emit(mode)

signal laps_changed(laps: int)
signal mode_changed(mode: Mode)

func set_variables_from_other(other: RaceSettings) -> void:
	laps = other.laps
	mode = other.mode
