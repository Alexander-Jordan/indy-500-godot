class_name GameManager extends Node

enum State {
	NONE,
	RACING,
	FINISHED,
}

var race_settings: RaceSettings = RaceSettings.new()
var state: State = State.NONE:
	set(s):
		if !State.values().has(s) or s == state:
			return
		state = s
		state_changed.emit(s)
var players: int = 2:
	set(p):
		if p < 0 or p > 2 or p == players:
			return
		players = p
		players_changed.emit(p)

signal count_down
signal reset
signal state_changed(state: State)
signal players_changed(players: int)

func _ready() -> void:
	race_settings.mode_changed.connect(func(mode: RaceSettings.Mode):
		match mode:
			RaceSettings.Mode.RACE:
				players = 2
			RaceSettings.Mode.TIME_TRIAL:
				players = 1
	)
