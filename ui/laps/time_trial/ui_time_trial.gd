class_name UITimeTrial extends PanelContainer

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
		if l != null:
			laps_signals_connect(l)
	get:
		return laps if !disabled else null

func _process(delta: float) -> void:
	if disabled or laps == null or laps.current == null:
		return
	label_time.text = laps.current._to_string()

func laps_signals_connect(laps: Laps) -> void:
	laps.best_changed.connect(on_best_changed)
	laps.lap_ended.connect(on_lap_ended)
	laps.optimal_changed.connect(on_optimal_changed)

func laps_signals_disconnect(laps: Laps) -> void:
	laps.best_changed.disconnect(on_best_changed)
	laps.lap_ended.disconnect(on_lap_ended)
	laps.optimal_changed.disconnect(on_optimal_changed)

func on_best_changed(best: Lap) -> void:
	label_best_time.text = best._to_string()

func on_lap_ended(lap: Lap, number: int) -> void:
	pass

func on_optimal_changed(optimal: Lap) -> void:
	label_optimal_time.text = optimal._to_string()
