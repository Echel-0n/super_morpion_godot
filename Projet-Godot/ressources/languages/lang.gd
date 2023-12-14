class_name Language
extends Object

enum LANGUAGES {
	ENGLISH,
	FRENCH
}

static var _lang : LANGUAGES = LANGUAGES.ENGLISH

static func set_lang(lang : LANGUAGES) -> void :
	_lang = lang
	
static func what_lang() -> LANGUAGES :
	return _lang

static func get_lang() -> Language :
	match _lang:
		LANGUAGES.ENGLISH:
			return Language_EN.get_lang()
		LANGUAGES.FRENCH:
			return Language_FR.get_lang()
	
	return Language_EN.get_lang()

var leave : String
var play_again : String
var return_menu : String

var play_super_morpion : String
var play_normal_morpion : String
