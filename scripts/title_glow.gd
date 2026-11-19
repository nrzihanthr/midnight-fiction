extends TextureRect
## Glow lembut di belakang judul: salinan teks judul dirender ke SubViewport
## (resolusi setengah agar murah), lalu di-blur oleh shader pada TextureRect ini.
## Node ini anak GameTitle dengan show_behind_parent, jadi ikut posisi dan kedipannya.

## Ruang ekstra di sekeliling teks agar blur tidak terpotong (px layar).
@export var padding: float = 48.0
## Skala resolusi SubViewport (0.5 = setengah).
@export_range(0.25, 1.0) var render_scale: float = 0.5

@onready var title: Label = get_parent()
@onready var glow_viewport: SubViewport = $GlowViewport
@onready var glow_text: Label = $GlowViewport/GlowText


func _ready() -> void:
	# Salin teks dan gaya dari judul supaya cukup diubah di satu tempat.
	glow_text.text = title.text
	glow_text.label_settings = title.label_settings
	glow_text.horizontal_alignment = title.horizontal_alignment
	glow_text.vertical_alignment = title.vertical_alignment
	glow_text.size = title.size
	glow_text.position = Vector2(padding, padding)

	var full_size: Vector2 = title.size + Vector2(padding, padding) * 2.0
	glow_viewport.size = Vector2i((full_size * render_scale).ceil())
	glow_viewport.size_2d_override = Vector2i(full_size.ceil())
	glow_viewport.size_2d_override_stretch = true

	position = -Vector2(padding, padding)
	size = full_size
	texture = glow_viewport.get_texture()
