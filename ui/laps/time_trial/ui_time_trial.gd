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
var tracker: Tracker = null:
	set(t):
		if t == tracker:
			return
		if tracker != null:
			tracker_signals_disconnect(tracker)
		tracker = t
		reset()
		if t != null:
			tracker_signals_connect(t)

func _process(_delta: float) -> void:
	if disabled or tracker == null or tracker.laps == null or tracker.laps.current == null:
		return
	if timer_await_sector.time_left > 0:
		return
	label_time.text = tracker.laps.current._to_string()

func tracker_signals_connect(t: Tracker) -> void:
	print(t)
	t.laps.best_changed.connect(on_best_changed)
	t.laps.lap_ended.connect(on_lap_ended)
	t.laps.lap_started.connect(on_lap_started)
	t.laps.optimal_changed.connect(on_optimal_changed)
	t.laps.sector_ended.connect(on_sector_ended)
	t.laps.sector_started.connect(on_sector_started)

func tracker_signals_disconnect(t: Tracker) -> void:
	t.laps.best_changed.disconnect(on_best_changed)
	t.laps.lap_ended.disconnect(on_lap_ended)
	t.laps.lap_started.disconnect(on_lap_started)
	t.laps.optimal_changed.disconnect(on_optimal_changed)
	t.laps.sector_ended.disconnect(on_sector_ended)
	t.laps.sector_started.disconnect(on_sector_started)

func on_best_changed(best: Lap) -> void:
	label_best_time.text = best._to_string()

func on_lap_ended(_lap: Lap, number: int) -> void:
	visibility_best_and_optimal(true)
	
	if number == tracker.laps.max_laps and timer_await_sector.timeout.is_connected(reset_sectors):
		timer_await_sector.timeout.disconnect(reset_sectors)
	timer_await_lap.start()
	if timer_await_lap.timeout.is_connected(visibility_best_and_optimal):
		timer_await_lap.timeout.disconnect(visibility_best_and_optimal)

func on_lap_started(_lap: Lap, _number: int) -> void:
	timer_await_lap.timeout.connect(visibility_best_and_optimal)

func on_optimal_changed(optimal: Lap) -> void:
	label_optimal_time.text = optimal._to_string()

func on_sector_ended(sector: Sector, number: int) -> void:
	if timer_await_sector.timeout.is_connected(reset_sectors):
		timer_await_sector.timeout.disconnect(reset_sectors)
	
	var panel_style_box: StyleBoxFlat
	var optimal_sector: Sector = null
	if number == 1:
		panel_style_box = panelcontainer_sector_1.get_theme_stylebox('panel')
		optimal_sector = tracker.laps.optimal.sectors.first if tracker.laps.optimal else null
	if number == 2:
		panel_style_box = panelcontainer_sector_2.get_theme_stylebox('panel')
		optimal_sector = tracker.laps.optimal.sectors.second if tracker.laps.optimal else null
	if number == 3:
		panel_style_box = panelcontainer_sector_3.get_theme_stylebox('panel')
		optimal_sector = tracker.laps.optimal.sectors.third if tracker.laps.optimal else null
	
	if panel_style_box != null:
		if optimal_sector == null:
			panel_style_box.bg_color = color_sector_faster
		elif sector.time < optimal_sector.time:
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
	visibility_best_and_optimal()
	label_time.text = '0:00.000'
	label_best_time.text = '0:00.000'
	label_optimal_time.text = '0:00.000'

func reset_sectors() -> void:
	for panelcontainer: PanelContainer in [panelcontainer_sector_1, panelcontainer_sector_2, panelcontainer_sector_3]:
		var panel_style_box: StyleBoxFlat = panelcontainer.get_theme_stylebox('panel')
		if panel_style_box:
			panel_style_box.bg_color = color_sector_default

func visibility_best_and_optimal(to: bool = false) -> void:
	hboxcontainer_best.visible = to
	hboxcontainer_optimal.visible = to
