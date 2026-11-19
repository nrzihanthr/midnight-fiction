extends Label
## Judul berkedip halus sesekali, seperti cahaya lilin yang goyah.
## Memakai modulate, jadi glow (anak node ini) ikut meredup.

@export var min_interval: float = 4.0
@export var max_interval: float = 9.0
## Kecerahan terendah saat berkedip (1.0 = tidak berubah).
@export_range(0.0, 1.0) var dim_alpha: float = 0.55

var _timer: Timer


func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.timeout.connect(_flicker)
	_schedule_next()


func _schedule_next() -> void:
	_timer.start(randf_range(min_interval, max_interval))


func _flicker() -> void:
	# 1-2 kedipan cepat yang tidak sama dalam, lalu kembali normal.
	var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	var blinks: int = randi_range(1, 2)
	for i: int in blinks:
		var low: float = lerpf(dim_alpha, 0.85, randf())
		tween.tween_property(self, "modulate:a", low, randf_range(0.05, 0.09))
		tween.tween_property(self, "modulate:a", 1.0, randf_range(0.08, 0.16))
	tween.tween_callback(_schedule_next)
