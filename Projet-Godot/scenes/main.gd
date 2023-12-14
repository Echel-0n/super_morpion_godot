class_name Main
extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	reload_lang()
	
	$c_container/vbox/play_super_morpion.pressed.connect(self._play_super_morpion)
	$c_container/vbox/play_normal_morpion.pressed.connect(self._play_normal_morpion)
	$c_container/vbox/leave_game.pressed.connect(self._leave_game)
	
	$c_container/vbox/language_selection.add_item("English",Language.LANGUAGES.ENGLISH)
	$c_container/vbox/language_selection.add_item("Français",Language.LANGUAGES.FRENCH)
	$c_container/vbox/language_selection.selected = Language.what_lang()
	$c_container/vbox/language_selection.item_selected.connect(self._lang_changed)
	
	connect("resized", Callable(self._on_resized))

func reload_lang() -> void :
	var lang : Language = Language.get_lang()
	$c_container/vbox/play_super_morpion.text = lang.play_super_morpion
	$c_container/vbox/play_normal_morpion.text = lang.play_normal_morpion
	$c_container/vbox/leave_game.text = lang.leave

func _lang_changed(passz) -> void :
	Language.set_lang($c_container/vbox/language_selection.get_selected_id())
	reload_lang()

func _play_super_morpion() -> void :
	get_tree().change_scene_to_file("res://scenes/games/super_morpion.tscn")

func _play_normal_morpion() -> void :
	get_tree().change_scene_to_file("res://scenes/games/normal_morpion.tscn")
	
func _leave_game() -> void :
	get_tree().quit()

func _on_resized() -> void :
	#$echo_games_icon.set_size(Vector2(180, 100))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
