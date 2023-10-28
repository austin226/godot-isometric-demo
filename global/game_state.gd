class_name GameState extends Node

signal focus_layer_changed(layer_delta: int)


func _ready():
	print("> GameState ready")

func change_focus_layer(layer_delta: int):
	print(layer_delta)
	focus_layer_changed.emit(layer_delta)