class_name NormalMorpion
extends OverMorpion

var _morpion : Morpion

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$buttons/play_again.text = Language.get_lang().play_again
	$buttons/return_menu.text = Language.get_lang().return_menu
	
	_morpion = $game_container/morpion
	_morpion.over_morpion = self
	_morpion.morpion_id = 0
	
	$buttons/play_again.pressed.connect(self._reset)
	$buttons/return_menu.pressed.connect(self._go_to_menu)
	connect("resized", Callable(self, "_on_resized"))
	
	_on_resized()
	_reset()

func _on_resized():
	var button_height : int = 50
	
	var game_container = $game_container as Container
	var buttons = $buttons as HBoxContainer
	
	if (size.x > size.y-button_height) :
		game_container.offset_top = 0
		game_container.offset_left = (size.x - size.y)/2 + button_height/2
		game_container.set_size(Vector2(size.y-button_height, size.y-button_height))
	else :
		game_container.offset_left = 0
		game_container.offset_top = (size.y-button_height - size.x)/2
		game_container.set_size(Vector2(size.x, size.x))
	
	buttons.offset_left = game_container.offset_left
	buttons.offset_top = game_container.offset_top + game_container.size.y
	buttons.set_size(Vector2(game_container.size.x, button_height))
	
	_morpion.set_size(Vector2(game_container.size.x, game_container.size.y))
	_morpion.resize()

func _go_to_menu() -> void :
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# Game
var _player : Morpion.STATE_ENUM = Morpion.STATE_ENUM.PLAYER1

func _reset() :
	_player = Morpion.STATE_ENUM.PLAYER1
	_morpion.reset()

func before_click(morpion_id:int, id:int) -> bool :
	return true

func after_click(morpion_id:int, id:int) -> void :
	if (!_morpion.is_finished) :
		switch_player()

func mouse_hover(morpion_id:int, id:int, button_free:bool) -> void :
	pass

func mouse_out_of(morpion_id:int, id:int, button_free:bool) -> void :
	pass

func switch_player() -> void : 
	if (_player == Morpion.STATE_ENUM.PLAYER1) : _player = Morpion.STATE_ENUM.PLAYER2
	else : _player = Morpion.STATE_ENUM.PLAYER1
	_morpion.player = _player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
