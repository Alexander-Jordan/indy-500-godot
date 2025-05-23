class_name StatsData extends Resource
## All game stats data.

#region VARIABLES
## How many times has the game been booted?
@export var game_booted_count: int = 0
## How many times has a race session been started?
@export var race_count: int = 0
## How many times has a time trial session been started?
@export var time_trial_count: int = 0
## The best lap.
@export var best_lap: Lap = null
#endregion
