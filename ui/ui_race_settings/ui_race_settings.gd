class_name UIRaceSettings extends Control

@onready var button_back: Button = $MarginContainer/VBoxContainer/HBoxContainer/button_back
@onready var button_save: Button = $MarginContainer/VBoxContainer/HBoxContainer/button_save
@onready var options_button_mode: OptionButton = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/options_button_mode
@onready var spin_box_laps: SpinBox = $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/spin_box_laps

func _ready() -> void:
	button_back.pressed.connect(hide)
	button_save.pressed.connect(save_settings)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('dev_race_settings_toggle'):
		if visible:
			hide()
		else:
			setup_from_gm()
			show()

func save_settings() -> void:
	GM.race_settings.laps = int(spin_box_laps.value)
	GM.race_settings.mode = options_button_mode.selected
	hide()

func setup_from_gm() -> void:
	options_button_mode.selected = GM.race_settings.mode
	spin_box_laps.value = GM.race_settings.laps
