@tool
extends Control
## Garis tipis di bawah judul dengan ikon wajik (outline) di tengahnya.

@export var line_color: Color = Color(0.494, 0.431, 0.380):
	set(v):
		line_color = v
		queue_redraw()
@export var diamond_color: Color = Color(0.62, 0.63, 0.59):
	set(v):
		diamond_color = v
		queue_redraw()
@export var line_width: float = 3.0:
	set(v):
		line_width = v
		queue_redraw()
## Setengah diagonal wajik (px).
@export var diamond_half: float = 14.5:
	set(v):
		diamond_half = v
		queue_redraw()
@export var diamond_outline: float = 3.0:
	set(v):
		diamond_outline = v
		queue_redraw()
## Jarak kosong antara ujung garis dan sudut wajik.
@export var gap: float = 7.0:
	set(v):
		gap = v
		queue_redraw()


func _draw() -> void:
	var c := Vector2(size.x * 0.5, size.y * 0.5)
	var cut: float = diamond_half + gap
	draw_line(Vector2(0.0, c.y), Vector2(c.x - cut, c.y), line_color, line_width, true)
	draw_line(Vector2(c.x + cut, c.y), Vector2(size.x, c.y), line_color, line_width, true)
	# Outline wajik: titik pertama diulang di akhir agar tertutup.
	var h: float = diamond_half - diamond_outline * 0.5
	var pts := PackedVector2Array([
		c + Vector2(0.0, -h), c + Vector2(h, 0.0), c + Vector2(0.0, h), c + Vector2(-h, 0.0), c + Vector2(0.0, -h),
	])
	draw_polyline(pts, diamond_color, diamond_outline, true)
