@tool
class_name GridLayer extends Node2D

@export_range(0, 20) var width: int = 1
@export_range(0, 20) var height: int = 1
@export var tile_prefab: Resource

@onready var tiles: Dictionary = {}

const R_TILE = preload("res://grid/tile.tscn")


func _ready():
	for longitude in range(0, width):
		for latitude in range(0, height):
			var tile = tile_prefab.instantiate()
			tile.latitude = latitude
			tile.longitude = longitude
			tile.elevation = 0
			tiles[str(tile)] = tile
			add_child(tile)
			tile.set_owner(self)
	print("> Ground ready")

func clear_tiles():
	for tile in tiles.values():
		remove_child(tile)
		tile.queue_free()
	tiles = {}
