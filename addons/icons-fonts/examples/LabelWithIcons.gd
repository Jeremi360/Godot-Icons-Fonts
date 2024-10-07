@tool
extends RichTextLabel

@export_multiline
var text_with_icons: String:
	set(value):
		text_with_icons = value
		bbcode_enabled = true
		text = IconsFonts.parse_icons(value)

	get: return text_with_icons

func _ready():
	bbcode_enabled = true
	text = IconsFontse_icons(text_with_icons)