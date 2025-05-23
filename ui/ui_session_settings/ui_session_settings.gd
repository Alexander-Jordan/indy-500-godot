class_name UISessionSettings extends Control

@onready var button_confirm: Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/button_confirm
@onready var options_button_mode: OptionButton = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/options_button_mode
@onready var spin_box_laps: SpinBox = $PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/spin_box_laps

var race_settings_previous: RaceSettings = RaceSettings.new()

func _ready() -> void:
	button_confirm.pressed.connect(confirm_settings)
	GM.state_changed.connect(func(state: GM.State):
		if state == GM.State.FINISHED:
			open_settings()
	)
	options_button_mode.item_selected.connect(func(index: int): GM.race_settings.mode = index)
	spin_box_laps.value_changed.connect(func(value: float): GM.race_settings.laps = int(value))
	
	race_settings_previous.set_variables_from_other(GM.race_settings)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('dev_race_settings_toggle'):
		if visible:
			cancel_settings()
		else:
			open_settings()

func cancel_settings() -> void:
	GM.race_settings.set_variables_from_other(race_settings_previous)
	hide()
	GM.state = GM.State.RACING

func confirm_settings() -> void:
	race_settings_previous.set_variables_from_other(GM.race_settings)
	GM.reset.emit()
	hide()
	GM.count_down.emit()

func open_settings() -> void:
	GM.state = GM.State.NONE
	options_button_mode.selected = GM.race_settings.mode
	spin_box_laps.value = GM.race_settings.laps
	show()
