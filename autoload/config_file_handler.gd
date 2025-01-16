extends Node


var config = ConfigFile.new()
const SETTING_FILE_PATH = "user://settings.ini"


const INPUT_ACTIONS = {
	"up": "Move up",
	"right": "Move right",
	"down": "Move down",
	"left": "Move left",
	"jump": "Jump"
}

const DEFAULT_VIDEO_SETTINGS = {
	"fullscreen": true
}

const DEFAULT_SOUND_SETTINGS = {
	"master_volume": 1.0,
	"music_volume": 1.0,
	"sfx_volume": 1.0
}

const SOUND_BUSES = {
	"Master": "master_volume",
	"Music": "music_volume",
	"SFX": "sfx_volume"
}

func _ready() -> void:
	restore_settings()

func _load_default_settings() -> void:
	InputMap.load_from_project_settings()
	for action in INPUT_ACTIONS:
		var events = InputMap.action_get_events(action)
		config.set_value("keybindings", action, events[0].as_text())
	
	for option in DEFAULT_VIDEO_SETTINGS:
		config.set_value("video", option, DEFAULT_VIDEO_SETTINGS[option])
		
	for option in DEFAULT_SOUND_SETTINGS:
		config.set_value("sound", option, DEFAULT_SOUND_SETTINGS[option])
	
	config.save(SETTING_FILE_PATH)

func save_settings() -> void:
	config.save(SETTING_FILE_PATH)
 

func restore_settings() -> void:
	var err = config.load(SETTING_FILE_PATH)
	if err != OK:
		_load_default_settings()
	# TODO: check if config file is valid
	_apply_fullscreen()
	for bus in SOUND_BUSES:
		_apply_volume(bus)


func update_fullscreen(value: bool) -> void:
	config.set_value("video", "fullscreen", value)
	_apply_fullscreen()


func _apply_fullscreen() -> void:
	if config.get_value("video", "fullscreen"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func update_volume(bus: String, value: float) -> void:
	config.set_value("sound", SOUND_BUSES[bus], value)
	_apply_volume(bus)


func _apply_volume(bus: String) -> void:
	var bus_index = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(config.get_value("sound", SOUND_BUSES[bus]))
	)
