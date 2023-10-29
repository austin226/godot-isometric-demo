class_name LayerChangeButton extends Button

## Positive if button moves up, negative if button moves down.
@export var layer_delta: int = 0

@onready var _game_state: GameState = $"/root/G_GameState"


func _ready():
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	_game_state.change_focus_layer(layer_delta)
