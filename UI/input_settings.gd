extends Control


@onready var input_binding_scene = preload("res://UI/input_binding.tscn")


var is_remapping: bool = false
var action_to_remap: InputEvent = null
var remapping_button = null


func _ready() -> void:
	_create_action_list()


func _create_action_list() -> void:
	InputMap.load_from_project_settings()
	for item in %ActionList.get_children():
		item.queue_free()
	
	for action in ConfigFileHandler.INPUT_ACTIONS:
		var button = input_binding_scene.instantiate()
		var action_label = button.find_child("ActionLabel")
		var input_label = button.find_child("InputLabel")
		
		action_label.text = ConfigFileHandler.INPUT_ACTIONS[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		%ActionList.add_child(button)
		button.find_child("InputButton").pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action) -> void:
	if !is_remapping:
		is_remapping = true
		#action_to_remap = action
		#remapping_button = button
		button.find_child("InputLabel").text = "Press key to bind..."
		
