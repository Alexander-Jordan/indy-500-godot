class_name UILaps extends VBoxContainer

@export var car: Car
@export var disable_time_trial: bool = false

@onready var ui_race: UIRace = $UIRace
@onready var ui_time_trial: UITimeTrial = $UITimeTrial

func _ready() -> void:
	GM.race_settings.mode_changed.connect(sync_with_mode)
	GM.reset.connect(reset)
	
	set_tracker(car.tracker)
	sync_with_mode(GM.race_settings.mode)

func reset() -> void:
	ui_race.reset()
	ui_time_trial.reset()

func set_tracker(tracker: Tracker) -> void:
	ui_race.tracker = tracker
	ui_time_trial.tracker = tracker

func sync_with_mode(mode: RaceSettings.Mode) -> void:
	match mode:
		RaceSettings.Mode.RACE:
			ui_race.disabled = false
			ui_time_trial.disabled = true
		RaceSettings.Mode.TIME_TRIAL:
			ui_race.disabled = true
			ui_time_trial.disabled = disable_time_trial
