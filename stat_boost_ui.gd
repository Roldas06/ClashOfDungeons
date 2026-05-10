extends CanvasLayer

signal boost_selected(boost_data: Dictionary)

const BOOST_OPTIONS = [
	{ "id": "health",     "name": "Vitality",        "description": "+10 Max Health",       "stat": "health",     "value": 10 },
	{ "id": "attack",     "name": "Power Up",         "description": "+5 Attack Damage",     "stat": "attack",     "value": 5  },
	{ "id": "projectile", "name": "Sharp Projectile", "description": "+5 Projectile Damage", "stat": "projectile", "value": 5  },
]

const CARDS_TO_SHOW = 3

var panel: Panel
var card_container: HBoxContainer

func _ready() -> void:
	_build_ui()
	hide()


func _build_ui() -> void:
	var viewport_size := get_viewport().get_visible_rect().size

	var root := Control.new()
	root.position = Vector2.ZERO
	root.size = viewport_size
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.position = Vector2.ZERO
	overlay.size = viewport_size
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(overlay)

	panel = Panel.new()
	var panel_size := Vector2(700, 350)
	panel.size = panel_size
	panel.position = (viewport_size - panel_size) / 2.0
	root.add_child(panel)

	var vbox := VBoxContainer.new()
	vbox.position = Vector2(20, 20)
	vbox.size = Vector2(panel_size.x - 40, panel_size.y - 40)
	vbox.add_theme_constant_override("separation", 20)
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "Choose a Stat Boost!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 28)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(title)

	card_container = HBoxContainer.new()
	card_container.alignment = BoxContainer.ALIGNMENT_CENTER
	card_container.add_theme_constant_override("separation", 20)
	card_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	card_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(card_container)


func show_ui() -> void:
	_populate_cards()
	Global.ui_open = true
	show()

func hide_ui() -> void:
	hide()
	Global.ui_open = false


func _populate_cards() -> void:
	for child in card_container.get_children():
		child.queue_free()

	var pool := BOOST_OPTIONS.duplicate()
	pool.shuffle()
	var chosen := pool.slice(0, CARDS_TO_SHOW)

	for boost in chosen:
		card_container.add_child(_build_card(boost))


func _build_card(boost_data: Dictionary) -> Button:
	var card := Button.new()
	card.custom_minimum_size = Vector2(180, 220)
	card.pivot_offset = Vector2(90, 110)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 10)
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(vbox)

	var icon := ColorRect.new()
	icon.color = Color(0.3, 0.6, 1.0)
	icon.custom_minimum_size = Vector2(64, 64)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(icon)

	var name_label := Label.new()
	name_label.text = boost_data["name"]
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(name_label)

	var desc_label := Label.new()
	desc_label.text = boost_data["description"]
	desc_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(desc_label)

	card.mouse_entered.connect(func():
		var t := card.create_tween()
		t.tween_property(card, "scale", Vector2(1.08, 1.08), 0.15).set_ease(Tween.EASE_OUT)
	)
	card.mouse_exited.connect(func():
		var t := card.create_tween()
		t.tween_property(card, "scale", Vector2(1.0, 1.0), 0.15).set_ease(Tween.EASE_OUT)
	)

	card.pressed.connect(func():
		emit_signal("boost_selected", boost_data)
		hide_ui()
	)

	return card
