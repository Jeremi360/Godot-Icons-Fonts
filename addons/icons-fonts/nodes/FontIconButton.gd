@tool
@icon("res://addons/icons-fonts/nodes/FontIconButton.svg")
extends ButtonContainer

# todo add descreption and docs links when ready
class_name FontIconButton

@export var icon_settings := FontIconSettings.new():
	set(value):
		icon_settings = value
		if !is_node_ready(): await ready
		_font_icon.icon_settings = value

@export var text := "":
	set(value):
		text = value
		if !is_node_ready(): await ready
		_label.text = text

@export var label_settings := LabelSettings.new():
	set(value):
		label_settings = value
		if !is_node_ready(): await ready
		_label.label_settings = label_settings

@export var button_margin := 5:
	set(value):
		button_margin = value
		if !is_node_ready(): await ready
		_margins.add_theme_constant_override("margin_top", button_margin)
		_margins.add_theme_constant_override("margin_left", button_margin)
		_margins.add_theme_constant_override("margin_bottom", button_margin)
		_margins.add_theme_constant_override("margin_right", button_margin)

var _font_icon: FontIcon
var _label: Label
var _box: BoxContainer
var _margins: MarginContainer

func _ready():
	var empty_style := StyleBoxEmpty.new()
	_box = BoxContainer.new()
	_font_icon = FontIcon.new()
	_font_icon.add_theme_stylebox_override("normal", empty_style)
	_box.add_child(_font_icon)

	_label = Label.new()
	_label.add_theme_stylebox_override("normal", empty_style)
	_box.add_child(_label)

	_margins = MarginContainer.new()
	_margins.add_child(_box)

	add_child(_margins)
