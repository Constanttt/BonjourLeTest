extends Node2D

func _ready():
	$MarginContainer/VBoxContainer/HBoxContainer/StartButton.grab_focus()

func _physics_process(delta):
	if $MarginContainer/VBoxContainer/HBoxContainer/StartButton.is_hovered():
		$MarginContainer/VBoxContainer/HBoxContainer/StartButton.grab_focus()
	if $MarginContainer/VBoxContainer/HBoxContainer/ExitButton.is_hovered():
		$MarginContainer/VBoxContainer/HBoxContainer/ExitButton.grab_focus()


func _on_StartButton_pressed():
	get_tree().change_scene("res://StageOne.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
