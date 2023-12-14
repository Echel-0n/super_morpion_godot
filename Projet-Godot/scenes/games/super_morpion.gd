class_name SuperMorpion
extends OverMorpion

var _morpions : Array[Morpion]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$buttons/play_again.text = Language.get_lang().play_again
	$buttons/return_menu.text = Language.get_lang().return_menu
	
	_morpions = [
		get_node("game_container/morpion1") as Morpion,
		get_node("game_container/morpion2") as Morpion,
		get_node("game_container/morpion3") as Morpion,
		get_node("game_container/morpion4") as Morpion,
		get_node("game_container/morpion5") as Morpion,
		get_node("game_container/morpion6") as Morpion,
		get_node("game_container/morpion7") as Morpion,
		get_node("game_container/morpion8") as Morpion,
		get_node("game_container/morpion9") as Morpion
	]
	for i in len(_morpions) :
		_morpions[i].over_morpion = self
		_morpions[i].morpion_id = i
	
	$buttons/play_again.pressed.connect(self._reset)
	$buttons/return_menu.pressed.connect(self._go_to_menu)
	connect("resized", Callable(self, "_on_resized"))
	
	_on_resized()
	_reset()

func _on_resized():
	var line_weight = 3
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
	
	$game_container/result_icon.set_size(Vector2(game_container.size.x, game_container.size.y))
	$game_container/result_icon.set_size(Vector2(game_container.size.x, game_container.size.y)) # Le faire 2 fois permet de résoudre un bug
	$game_container/result_background.set_size(Vector2(game_container.size.x, game_container.size.y))
	
	for col2 in [2,5,8] :
		_morpions[col2-1].offset_left = (game_container.size.x-(2*line_weight))/3+line_weight
	for col3 in [3,6,9] :
		_morpions[col3-1].offset_left = ((game_container.size.x-(2*line_weight))/3+line_weight)*2
	for lin2 in [4,5,6] :
		_morpions[lin2-1].offset_top = (game_container.size.y-(2*line_weight))/3+line_weight
	for lin3 in [7,8,9] :
		_morpions[lin3-1].offset_top = ((game_container.size.y-(2*line_weight))/3+line_weight)*2
	for morpion in _morpions :
		morpion.set_size(Vector2((game_container.size.y - (2*line_weight))/3,(game_container.size.y - (2*line_weight))/3))
		morpion.resize()
	
	# Separators
	var hline1 = get_node("game_container/line1") as ColorRect
	var hline2 = get_node("game_container/line2") as ColorRect
	var vline3 = get_node("game_container/line3") as ColorRect
	var vline4 = get_node("game_container/line4") as ColorRect
	
	hline1.offset_top = (game_container.size.y - (2*line_weight))/3
	hline2.offset_top = ((game_container.size.y - (2*line_weight))/3)*2+line_weight
	vline3.offset_left = (game_container.size.x - (2*line_weight))/3
	vline4.offset_left = ((game_container.size.x - (2*line_weight))/3)*2+line_weight
	
	hline1.set_size(Vector2(game_container.size.x, line_weight))
	hline2.set_size(Vector2(game_container.size.x, line_weight))
	vline3.set_size(Vector2(line_weight, game_container.size.y))
	vline4.set_size(Vector2(line_weight, game_container.size.y))

func _go_to_menu() -> void :
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# Game
var _player : Morpion.STATE_ENUM = Morpion.STATE_ENUM.PLAYER1
var _can_play : Array[int]

func _reset() -> void :
	$game_container/result_icon.visible = false
	$game_container/result_icon.texture = null
	$game_container/result_background.visible = false
	
	_player = Morpion.STATE_ENUM.PLAYER1
	_can_play = [0,1,2,3,4,5,6,7,8]
	for morpion in _morpions :
		morpion.reset()
		morpion.player = Morpion.STATE_ENUM.PLAYER1
		morpion.highlight(true)

func before_click(morpion_id:int, id:int) -> bool :
	if !(morpion_id in _can_play) :
		return false
	return true

func after_click(morpion_id:int, id:int) -> void :
	if (!_morpions[id].is_finished) :
		_can_play = [id]
	else :
		_can_play.clear()
		for j in len(_morpions) :
			if !(_morpions[j].is_finished) :
				_can_play.append(j)
	if(_check_board()) :
		_can_play.clear()
	for i in 9:
		var m : Morpion = _morpions[i]
		if (m.is_finished) : m.playable = false
		else : m.playable = true
		
		if(i in _can_play) : m.highlight(true)
		else : m.highlight(false)
		switch_player()

func mouse_hover(morpion_id:int, id:int, button_free:bool) -> void :
	if (morpion_id in _can_play && button_free) :
		if (morpion_id == id) :
			if (_morpions[id].simule_next_move(id)) :
				for j in len(_morpions) :
					if j != id && !(_morpions[j].is_finished) :
						_morpions[j].highlight_next_move(true)
				return
		if !(_morpions[id].is_finished) :
			_morpions[id].highlight_next_move(true)
			return
		for j in len(_morpions) :
			if !(_morpions[j].is_finished) :
				_morpions[j].highlight_next_move(true)

func mouse_out_of(morpion_id:int, id:int, button_free:bool) -> void :
	for morpion in _morpions :
		morpion.highlight_next_move(false)

func switch_player() -> void : 
	if (_player == Morpion.STATE_ENUM.PLAYER1) : _player = Morpion.STATE_ENUM.PLAYER2
	else : _player = Morpion.STATE_ENUM.PLAYER1
	
	for m in _morpions :
		m.player = _player

func _check_board() -> bool :
	var winPatterns = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
		[0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
		[0, 4, 8], [2, 4, 6]             # Diagonals
	]
	for pattern in winPatterns :
		var a = _morpions[pattern[0]]
		var b = _morpions[pattern[1]]
		var c = _morpions[pattern[2]]
		if (a.is_finished && a.winner != Morpion.STATE_ENUM.NONE
			&& b.winner == a.winner && c.winner == a.winner) :
			if (a.winner == Morpion.STATE_ENUM.PLAYER1) :
				$game_container/result_icon.texture = (load("res://ressources/morpion/player1_white.svg"))
			else :
				$game_container/result_icon.texture = (load("res://ressources/morpion/player2_white.svg"))
			$game_container/result_icon.visible = true
			$game_container/result_background.visible = true
			_finish()
			return true
	if (_is_match_over()) :
		$game_container/result_background.visible = true
		_finish()
		return true
	return false

func _is_match_over() -> bool :
	for morpion in _morpions :
		if !morpion.is_finished : return false
	return true

func _finish() -> void :
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
