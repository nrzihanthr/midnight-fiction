class_name MenuCursor
extends TextureRect
## Kursor keris perak yang bergeser halus ke tombol yang sedang disorot.

## Jarak tepi kiri kursor dari tepi kiri teks tombol (negatif = di kiri tombol).
@export var offset_x: float = -209.0
## Geser vertikal tambahan terhadap pusat tombol.
@export var offset_y: float = -1.0
@export var slide_duration: float = 0.15

var _tween: Tween


func point_at(target: Control, instant: bool = false) -> void:
	if _tween != null and _tween.is_valid():
		_tween.kill()
	var center_y: float = target.global_position.y + target.size.y * 0.5
	var goal := Vector2(
		target.global_position.x + offset_x,
		center_y - size.y * 0.5 + offset_y
	)
	if instant:
		global_position = goal
		return
	_tween = create_tween()
	_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "global_position", goal, slide_duration)
