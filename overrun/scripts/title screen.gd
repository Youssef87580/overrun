extends Control


func _on_srart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn") #still needs to be edetied 
	
func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn") #still needs to be edetied 

func _on_quit_button_pressed():
	get_tree().quit()
