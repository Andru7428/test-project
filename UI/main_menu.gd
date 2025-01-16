extends Control


func _ready() -> void:
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	$SettingsMenu.open()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
