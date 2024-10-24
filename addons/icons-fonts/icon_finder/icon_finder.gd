@tool
extends Control

@export var icons_renderers: Array[IconsFontsRender]

@export var tooltip := "click on icon to copy its name to clipboard"

@export
@onready var icons_renderers_tabs: TabContainer

@export
@onready var notify_label: Label

@export
@onready var search_line_edit: LineEdit

@export
@onready var size_slider: HSlider

@export
@onready var size_label: Label

@export
@onready var scroll_container: ScrollContainer

@export
@onready var fonts_dropdown: OptionButton

var scroll_bar_v: ScrollBar:
	get: return scroll_container.get_v_scroll_bar()

var scroll_bar_h: ScrollBar:
	get: return scroll_container.get_h_scroll_bar()

var icons_renderer: IconsFontsRender

func _ready():
	notify_label.hide()
	search_line_edit.text_changed.connect(update_table)
	size_slider.value_changed.connect(update_icons_size)
	fonts_dropdown.item_selected.connect(on_font_changed)
	size_slider.value = IconsFonts.preview_size

	for renderer: IconsFontsRender in icons_renderers:
		renderer.tooltip_text = tooltip
		renderer.setup()

func _on_finished():
	scroll_bar_h.max_value = icons_renderer.size.y
	scroll_bar_v.max_value = icons_renderer.size.x

func update_icons_size(value: int):
	size_label.text = str(value)
	if icons_renderer:
		icons_renderer.add_theme_font_size_override("normal", value)
		update_table(search_line_edit.text)
	IconsFonts.preview_size = value

func on_font_changed(font_id: int):
	if icons_renderer:
		icons_renderer.meta_clicked.disconnect(_on_meta)
		icons_renderer.finished.disconnect(_on_finished)

	icons_renderers_tabs.current_tab = font_id
	icons_renderer = icons_renderers[font_id]
	icons_renderer.add_theme_font_size_override(
		"normal", IconsFonts.preview_size)

	icons_renderer.meta_clicked.connect(_on_meta)
	icons_renderer.finished.connect(_on_finished)
	update_table(search_line_edit.text)

func update_table(filter := ""):
	if not icons_renderer: return
	icons_renderer.update_table(filter)

func _on_meta(link: String):
	DisplayServer.clipboard_set(link)
	notify_label.text = "Copied to Clipboard: " + link
	notify_label.show()

	var t := get_tree().create_tween()
	t.tween_property(
		notify_label, "modulate",
		Color.GREEN, 1
	)
	t.chain().tween_property(
		notify_label, "modulate",
		Color.TRANSPARENT, 1
	)
	await t.finished
	notify_label.hide()
