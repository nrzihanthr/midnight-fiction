extends Control
## Animasi melayang di GhostGroup: keris dan guci naik-turun seolah diangkat hantu,
## hantu sendiri mengambang lebih pelan. Posisi awal tiap node dibaca dari scene,
## jadi tata letak tetap diatur di editor.

## Ayunan keris dan guci ke atas dan ke bawah dari posisi awal (px).
@export var bob_height: float = 14.0
## Periode dasar satu ayunan penuh keris dan guci (detik).
@export var bob_period: float = 3.0
## Variasi acak periode per objek (+/- detik), agar tidak serempak.
@export var bob_period_jitter: float = 0.5
## Ayunan hantu (px).
@export var ghost_bob_height: float = 6.0
## Periode ayunan hantu (detik), sengaja lebih lambat dari keris.
@export var ghost_bob_period: float = 5.5
## Rotasi goyang maksimal keris (derajat).
@export var rotation_sway_deg: float = 2.0

@onready var ghost: TextureRect = $Ghost
@onready var keris_list: Array[TextureRect] = [$KerisKiri, $KerisTengah, $KerisKanan]
@onready var guci_list: Array[TextureRect] = [$GuciKiri, $GuciKanan]


func _ready() -> void:
	_start_float(ghost, ghost_bob_height, ghost_bob_period, 0.0, 0.0)
	for keris: TextureRect in keris_list:
		_start_float(keris, bob_height, _random_period(), randf() * TAU, rotation_sway_deg)
	for guci: TextureRect in guci_list:
		_start_float(guci, bob_height, _random_period(), randf() * TAU, 0.0)


func _random_period() -> float:
	return maxf(0.5, bob_period + randf_range(-bob_period_jitter, bob_period_jitter))


## Satu Tween berulang memutar fase 0..TAU secara linear; posisi dihitung sebagai
## base + sin(fase), sehingga geraknya sinus murni (ease in-out alami) dan
## selalu relatif terhadap posisi awal (offset tidak pernah menumpuk).
func _start_float(node: Control, height: float, period: float, phase: float, sway_deg: float) -> void:
	var base_y: float = node.position.y
	var base_rot: float = node.rotation
	var sway: float = deg_to_rad(sway_deg)
	# Pusat rotasi di tengah objek.
	node.pivot_offset = node.size * 0.5

	var apply := func(t: float) -> void:
		var a: float = t + phase
		node.position.y = base_y + sin(a) * height
		# Goyang rotasi tertinggal seperempat siklus dari gerak naik-turun.
		node.rotation = base_rot + cos(a) * sway

	apply.call(0.0)
	var tween: Tween = node.create_tween().set_loops()
	tween.tween_method(apply, 0.0, TAU, period)
