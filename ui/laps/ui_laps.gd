class_name UILaps extends VBoxContainer

@export var car: Car
@export var disable_time_trial: bool = false

@onready var ui_race: UIRace = $UIRace
@onready var ui_time_trial: UITimeTrial = $UITimeTrial

func _ready() -> void:
	GM.race_settings.mode_changed.connect(sync_with_mode)
	
	sync_with_mode(GM.race_settings.mode)
	ui_race.laps = car.race_tracker.laps
	ui_time_trial.laps = car.race_tracker.laps

func sync_with_mode(mode: RaceSettings.Mode) -> void:
	match mode:
		RaceSettings.Mode.RACE:
			ui_race.disabled = false
			ui_time_trial.disabled = true
		RaceSettings.Mode.TIME_TRIAL:
			ui_race.disabled = true
			ui_time_trial.disabled = disable_time_trial
