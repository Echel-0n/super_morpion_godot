class_name Morpion
extends Control

var _board : Array[TextureButton]

# Called when the node enters the scene tree for the first time.
func _ready():
	_board = [
		$game_container/case1,
		$game_container/case2,
		$game_container/case3,
		$game_container/case4,
		$game_container/case5,
		$game_container/case6,
		$game_container/case7,
		$game_container/case8,
		$game_container/case9
		]
	for case in len(_board) :
		_board[case].pressed.connect(self._on_button_click.bind(case))
		_board[case].mouse_entered.connect(self._on_mouse_hover_button.bind(case))
		_board[case].mouse_exited.connect(self._on_mouse_out_of_button.bind(case))
	connect("resized", Callable(self, "_on_resized"))
	_on_resized()
	reset()
	$result_background.visible = false
	$result_icon.visible = false

# Redimentionnement
func resize()->void:
	_on_resized()

func _on_resized():
	var line_weight = 1
	
	var game_container = $game_container as Container
	if (size.x > size.y) :
		game_container.offset_top = 0
		game_container.offset_left = (size.x - size.y)/2
		game_container.set_size(Vector2(size.y, size.y))
	else :
		game_container.offset_left = 0
		game_container.offset_top = (size.y - size.x)/2
		game_container.set_size(Vector2(size.x, size.x))
	
	$result_icon.set_size(Vector2(game_container.size.x, game_container.size.y))
	
	var hline1 = $game_container/line1 as ColorRect
	var hline2 = $game_container/line2 as ColorRect
	var vline3 = $game_container/line3 as ColorRect
	var vline4 = $game_container/line4 as ColorRect
	
	hline1.offset_top = (game_container.size.y - (2*line_weight))/3
	hline2.offset_top = ((game_container.size.y - (2*line_weight))/3)*2+line_weight
	vline3.offset_left = (game_container.size.x - (2*line_weight))/3
	vline4.offset_left = ((game_container.size.x - (2*line_weight))/3)*2+line_weight
	
	hline1.set_size(Vector2(game_container.size.x, line_weight))
	hline2.set_size(Vector2(game_container.size.x, line_weight))
	vline3.set_size(Vector2(line_weight, game_container.size.y))
	vline4.set_size(Vector2(line_weight, game_container.size.y))
	
	var cases = [
		get_node("game_container/case1") as TextureButton,
		get_node("game_container/case2") as TextureButton,
		get_node("game_container/case3") as TextureButton,
		get_node("game_container/case4") as TextureButton,
		get_node("game_container/case5") as TextureButton,
		get_node("game_container/case6") as TextureButton,
		get_node("game_container/case7") as TextureButton,
		get_node("game_container/case8") as TextureButton,
		get_node("game_container/case9") as TextureButton
	]
	
	for col2 in [2,5,8] :
		cases[col2-1].offset_left = (game_container.size.x-(2*line_weight))/3+line_weight
	for col3 in [3,6,9] :
		cases[col3-1].offset_left = ((game_container.size.x-(2*line_weight))/3+line_weight)*2
		
	for lin2 in [4,5,6] :
		cases[lin2-1].offset_top = (game_container.size.y-(2*line_weight))/3+line_weight
	for lin3 in [7,8,9] :
		cases[lin3-1].offset_top = ((game_container.size.y-(2*line_weight))/3+line_weight)*2
	
	for case in cases :
		case.set_size(Vector2((game_container.size.y - (2*line_weight))/3,(game_container.size.y - (2*line_weight))/3))

# Game
enum STATE_ENUM { PLAYER1, PLAYER2, NONE }
var playable : bool
var is_finished : bool
var winner : STATE_ENUM
var player : STATE_ENUM
var morpion_id : int
var over_morpion : OverMorpion
var _state : Array[STATE_ENUM]

func highlight(b:bool)->void:
	$background.visible = b

func highlight_next_move(b:bool)->void:
	$background2.visible = b

func _on_button_click(id:int)->void:
	if (!over_morpion.before_click(morpion_id,id)) :
		return
	if (id < 0 || id > 8 || is_finished || !playable) :
		return
	if !(_state[id] == STATE_ENUM.NONE) :
		return
	_state[id] = player
	_display()
	_check_board()
	_on_mouse_out_of_button(id)
	over_morpion.after_click(morpion_id,id)

func _on_mouse_hover_button(id:int)->void:
	if (over_morpion != null) : over_morpion.mouse_hover(morpion_id, id, _state[id]==STATE_ENUM.NONE)
	
func _on_mouse_out_of_button(id:int)->void:
	if (over_morpion != null) : over_morpion.mouse_out_of(morpion_id, id, _state[id]==STATE_ENUM.NONE)

func _display()->void:
	for i in 9 :
		match _state[i] :
			STATE_ENUM.NONE :
				_board[i].set_texture_normal(null)
			STATE_ENUM.PLAYER1 :
				_board[i].set_texture_normal(load("res://ressources/morpion/player1_white.svg"))
			STATE_ENUM.PLAYER2 :
				_board[i].set_texture_normal(load("res://ressources/morpion/player2_white.svg"))

func _check_board()->bool :
	var winPatterns = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
		[0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
		[0, 4, 8], [2, 4, 6]             # Diagonals
	]
	for pattern in winPatterns :
		var a = _state[pattern[0]]
		var b = _state[pattern[1]]
		var c = _state[pattern[2]]
		if (a != STATE_ENUM.NONE && b == a && c == a) :
			if (a == STATE_ENUM.PLAYER1) :
				$result_icon.texture = (load("res://ressources/morpion/player1_white.svg"))
				winner = STATE_ENUM.PLAYER1
			else :
				$result_icon.texture = (load("res://ressources/morpion/player2_white.svg"))
				winner = STATE_ENUM.PLAYER2
			$result_icon.visible = true
			$result_background.visible = true
			_finish()
			return true
	if (!_state.has(STATE_ENUM.NONE)) :
		$result_background.visible = true
		_finish()
		return true
	return false

func reset()->void:
	$background.visible = false
	$background2.visible = false
	$result_icon.visible = false
	$result_icon.texture = null
	$result_background.visible = false
	winner = STATE_ENUM.NONE
	playable = true
	is_finished = false
	player = STATE_ENUM.PLAYER1
	_state = [
		STATE_ENUM.NONE, STATE_ENUM.NONE, STATE_ENUM.NONE,
		STATE_ENUM.NONE, STATE_ENUM.NONE, STATE_ENUM.NONE,
		STATE_ENUM.NONE, STATE_ENUM.NONE, STATE_ENUM.NONE
	]
	_display()

func simule_next_move(id:int)->bool:
	var next_state = _state.duplicate(false)
	next_state[id] = player
	var winPatterns = [
		[0, 1, 2], [3, 4, 5], [6, 7, 8], # Rows
		[0, 3, 6], [1, 4, 7], [2, 5, 8], # Columns
		[0, 4, 8], [2, 4, 6]             # Diagonals
		]
	for pattern in winPatterns :
		var a = next_state[pattern[0]]
		var b = next_state[pattern[1]]
		var c = next_state[pattern[2]]
		if (a != STATE_ENUM.NONE &&
			b == a && c == a) : return true
	if (!next_state.has(STATE_ENUM.NONE)) : return true
	return false

func _finish()->void:
	is_finished = true
	playable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
