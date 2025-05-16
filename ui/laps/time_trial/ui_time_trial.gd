class_name UITimeTrial extends PanelContainer

@export var color_sector_best: Color
@export var color_sector_default: Color
@export var color_sector_faster: Color
@export var color_sector_slower: Color

@onready var hboxcontainer_best: HBoxContainer = $MarginContainer/VBoxContainer/hboxcontainer_best
@onready var hboxcontainer_optimal: HBoxContainer = $MarginContainer/VBoxContainer/hboxcontainer_optimal
@onready var label_best_time: Label = $MarginContainer/VBoxContainer/hboxcontainer_best/label_best_time
@onready var label_optimal_time: Label = $MarginContainer/VBoxContainer/hboxcontainer_optimal/label_optimal_time
@onready var label_sector_1: Label = $MarginContainer/VBoxContainer/hboxcontainer_sectors/panelcontainer_sector1/label_sector1
@onready var label_sector_2: Label = $MarginContainer/VBoxContainer/hboxcontainer_sectors/panelcontainer_sector2/label_sector2
@onready var label_sector_3: Label = $MarginContainer/VBoxContainer/hboxcontainer_sectors/panelcontainer_sector3/label_sector3
@onready var label_time: Label = $MarginContainer/VBoxContainer/HBoxContainer/label_time
@onready var panelcontainer_sector_1: PanelContainer = $MarginContainer/VBoxContainer/hboxcontainer_sectors/panelcontainer_sector1
@onready var panelcontainer_sector_2: PanelContainer = $MarginContainer/VBoxContainer/hboxcontainer_sectors/panelcontainer_sector2
@onready var panelcontainer_sector_3: PanelContainer = $MarginContainer/VBoxContainer/hboxcontainer_sectors/panelcontainer_sector3
@onready var timer_await_lap: Timer = $timer_await_lap
@onready var timer_await_sector: Timer = $timer_await_sector

var disabled: bool = false:
	set(d):
		if d == disabled:
			return
		disabled = d
		visible = !d
var laps: Laps = null:
	set(l):
		if l == laps:
			return
		if laps != null:
			laps_signals_disconnect(laps)
		laps = l
		reset()
		if l != null:
			laps_signals_connect(l)

func _process(_delta: float) -> void:
	if disabled or laps == null or laps.current == null:
		return
	if timer_await_sector.time_left > 0:
		return
	label_time.text = laps.current._to_string()

func laps_signals_connect(new_laps: Laps) -> void:
	new_laps.best_changed.connect(on_best_changed)
	new_laps.lap_ended.connect(on_lap_ended)
	new_laps.lap_started.connect(on_lap_started)
	new_laps.optimal_changed.connect(on_optimal_changed)
	new_laps.sector_ended.connect(on_sector_ended)
	new_laps.sector_started.connect(on_sector_started)

func laps_signals_disconnect(old_laps: Laps) -> void:
	old_laps.best_changed.disconnect(on_best_changed)
	old_laps.lap_ended.disconnect(on_lap_ended)
	old_laps.lap_started.disconnect(on_lap_started)
	old_laps.optimal_changed.disconnect(on_optimal_changed)
	old_laps.sector_ended.disconnect(on_sector_ended)
	old_laps.sector_started.disconnect(on_sector_started)

func on_best_changed(best: Lap) -> void:
	label_best_time.text = best._to_string()

func on_lap_ended(_lap: Lap, number: int) -> void:
	hboxcontainer_best.show()
	hboxcontainer_optimal.show()
	
	if number == laps.max_laps and timer_await_sector.timeout.is_connected(reset_sectors):
		timer_await_sector.timeout.disconnect(reset_sectors)
	timer_await_lap.start()
	if timer_await_lap.timeout.is_connected(hide_best_and_optimal):
		timer_await_lap.timeout.disconnect(hide_best_and_optimal)

func on_lap_started(_lap: Lap, _number: int) -> void:
	timer_await_lap.timeout.connect(hide_best_and_optimal)

func on_optimal_changed(optimal: Lap) -> void:
	label_optimal_time.text = optimal._to_string()

func on_sector_ended(sector: Sector, number: int) -> void:
	if timer_await_sector.timeout.is_connected(reset_sectors):
		timer_await_sector.timeout.disconnect(reset_sectors)
	
	var panel_style_box: StyleBoxFlat
	if number == 1:
		panel_style_box = panelcontainer_sector_1.get_theme_stylebox('panel')
	if number == 2:
		panel_style_box = panelcontainer_sector_2.get_theme_stylebox('panel')
	if number == 3:
		panel_style_box = panelcontainer_sector_3.get_theme_stylebox('panel')
	
	if panel_style_box != null:
		if laps.optimal == null:
			panel_style_box.bg_color = color_sector_faster
		elif sector.time < laps.optimal.sectors.all[number-1].time:
			panel_style_box.bg_color = color_sector_faster
		else:
			panel_style_box.bg_color = color_sector_slower
	
	timer_await_sector.start()
	label_time.text = sector._to_string()
	
	if number == 3:
		timer_await_sector.timeout.connect(reset_sectors)

func on_sector_started(_sector: Sector, _number: int) -> void:
	pass

func reset() -> void:
	reset_sectors()
	hide_best_and_optimal()
	label_time.text = '0:00.000'
	label_best_time.text = '0:00.000'
	label_optimal_time.text = '0:00.000'

func reset_sectors() -> void:
	for panelcontainer: PanelContainer in [panelcontainer_sector_1, panelcontainer_sector_2, panelcontainer_sector_3]:
		var panel_style_box: StyleBoxFlat = panelcontainer.get_theme_stylebox('panel')
		if panel_style_box:
			panel_style_box.bg_color = color_sector_default

func hide_best_and_optimal() -> void:
	hboxcontainer_best.hide()
	hboxcontainer_optimal.hide()
