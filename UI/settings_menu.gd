extends Control

var old_config: ConfigFile
var config = ConfigFileHandler.config


func _ready() -> void:
	open()
	hide()


func open() -> void:
	%FullscreenCheckBox.button_pressed = config.get_value("video", "fullscreen")
	%MasterVolumeSlider.value = config.get_value("sound", "master_volume")
	%MusicVolumeSlider.value = config.get_value("sound", "music_volume")
	%SFXVolumeSlider.value = config.get_value("sound", "sfx_volume")
	show()


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.update_fullscreen(toggled_on)


func _on_master_volume_slider_value_changed(value: float) -> void:
	ConfigFileHandler.update_volume("Master", value)


func _on_music_volume_slider_value_changed(value: float) -> void:
	ConfigFileHandler.update_volume("Music", value)


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	ConfigFileHandler.update_volume("SFX", value)


func _on_keybindings_button_pressed() -> void:
	pass # Replace with function body.


func _on_apply_button_pressed() -> void:
	ConfigFileHandler.save_settings()
	hide()


func _on_cancel_button_pressed() -> void:
	ConfigFileHandler.restore_settings()
	hide()
