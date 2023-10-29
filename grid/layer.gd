@tool
class_name GridLayer extends Node2D

@export_range(0, 20) var width: int = 1
@export_range(0, 20) var height: int = 1
@export var tile_prefab: Resource
@export var fill_tiles: bool = false
@export var layer_number: int = 0

@onready var tiles: Dictionary = {}

const R_TILE = preload("res://grid/tile.tscn")


func _ready():
	clear_tiles()
	if fill_tiles:
		_fill_tiles()
	print("> Ground ready")

func _fill_tiles() -> void:
	for longitude in range(0, width):
		for latitude in range(0, height):
			var tile = tile_prefab.instantiate()
			tile.latitude = latitude
			tile.longitude = longitude
			tile.elevation = 0
			tiles[str(tile)] = tile
			tile.name = "(%d,%d,%d)" % [latitude, longitude, layer_number]
			%Tiles.add_child(tile)
			tile.set_owner(%Tiles)

func clear_tiles() -> void:
	if %Tiles == null:
		return
	for child in %Tiles.get_children():
		if child is Tile:
			%Tiles.remove_child(child)
			child.queue_free()
	tiles = {}
