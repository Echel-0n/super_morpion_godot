class_name Language_FR
extends Object

static var _lang : Language = null

static func get_lang() -> Language :
	if (_lang == null) :
		_apply_lang()
	return _lang

static func _apply_lang() -> void :
	_lang = Language.new()
	
	_lang.leave = "Quitter"
	_lang.play_again = "Rejouer"
	_lang.return_menu = "Retourner au menu"
	_lang.play_super_morpion = "Jouer au Super Morpion"
	_lang.play_normal_morpion = "Jouer au Morpion Normal"
