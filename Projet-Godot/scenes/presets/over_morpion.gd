class_name OverMorpion
extends Control

# Interface for games

func before_click(morpion_id:int, id:int) -> bool : return true
func after_click(morpion_id:int, id:int) -> void : pass
func mouse_hover(morpion_id:int, id:int, button_free:bool) -> void : pass
func mouse_out_of(morpion_id:int, id:int, button_free:bool) -> void : pass
