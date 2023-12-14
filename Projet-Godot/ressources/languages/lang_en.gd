class_name Language_EN
extends Object

static var _lang : Language = null

static func get_lang() -> Language :
	if (_lang == null) :
		_apply_lang()
	return _lang

static func _apply_lang() -> void :
	_lang = Language.new()
	
	_lang.leave = "Leave"
	_lang.play_again = "Play Again"
	_lang.return_menu = "Return to menu"
	_lang.play_super_morpion = "Play Ultimate Tic Tac Toe"
	_lang.play_normal_morpion = "Play Normal Tic Tac Toe"
