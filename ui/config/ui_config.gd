class_name UIConfig extends Control

@onready var check_button_music: CheckButton = $HBoxContainer/check_button_music
@onready var check_button_sfx: CheckButton = $HBoxContainer/check_button_sfx

var sfx_bus_index:int
var music_bus_index:int

func _ready() -> void:
	music_bus_index = AudioServer.get_bus_index('music')
	sfx_bus_index = AudioServer.get_bus_index('sfx')
	AudioServer.set_bus_mute(music_bus_index, !SS.config.audio.music)
	AudioServer.set_bus_mute(sfx_bus_index, !SS.config.audio.sfx)
	
	check_button_music.toggled.connect(on_music_toggled)
	check_button_sfx.toggled.connect(on_sfx_toggled)
	
	check_button_music.set_pressed_no_signal(SS.config.audio.music)
	check_button_sfx.set_pressed_no_signal(SS.config.audio.sfx)

func on_music_toggled(toggled_on: bool) -> void:
	SS.config.audio.music = toggled_on
	AudioServer.set_bus_mute(music_bus_index, !toggled_on)
	SS.save_config()

func on_sfx_toggled(toggled_on: bool) -> void:
	SS.config.audio.sfx = toggled_on
	AudioServer.set_bus_mute(sfx_bus_index, !toggled_on)
	SS.save_config()
