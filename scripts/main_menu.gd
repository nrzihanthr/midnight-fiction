extends Control
## Menyambungkan tombol menu ke aksinya dan mengatur fokus (mouse + keyboard).
## Animasi dan gerak kursor ditangani skrip lain.

const GAMEPLAY_SCENE: String = "res://scenes/gameplay.tscn"

@onready var btn_mulai: Button = $MenuContainer/BtnMulai
@onready var btn_lanjutkan: Button = $MenuContainer/BtnLanjutkan
@onready var btn_pengaturan: Button = $MenuContainer/BtnPengaturan
@onready var btn_keluar: Button = $MenuContainer/BtnKeluar
@onready var keris_cursor: MenuCursor = $KerisCursor


func _ready() -> void:
	btn_mulai.pressed.connect(_on_mulai_pressed)
	btn_pengaturan.pressed.connect(_on_pengaturan_pressed)
	btn_keluar.pressed.connect(_on_keluar_pressed)

	# LANJUTKAN belum tersedia: nonaktif dan tidak bisa difokus,
	# sehingga navigasi keyboard otomatis melompatinya.
	btn_lanjutkan.disabled = true
	btn_lanjutkan.focus_mode = Control.FOCUS_NONE

	var active: Array[Button] = [btn_mulai, btn_pengaturan, btn_keluar]
	for btn: Button in active:
		btn.focus_entered.connect(keris_cursor.point_at.bind(btn))
		# Hover mouse memindahkan fokus, jadi mouse dan keyboard memakai satu sorotan.
		btn.mouse_entered.connect(btn.grab_focus)

	# Navigasi atas/bawah berputar (KELUAR <-> MULAI).
	btn_mulai.focus_neighbor_top = btn_mulai.get_path_to(btn_keluar)
	btn_keluar.focus_neighbor_bottom = btn_keluar.get_path_to(btn_mulai)

	btn_mulai.grab_focus()
	# Ditunda: VBoxContainer baru mengatur posisi tombol di akhir frame ini.
	keris_cursor.point_at.call_deferred(btn_mulai, true)


func _on_mulai_pressed() -> void:
	get_tree().change_scene_to_file(GAMEPLAY_SCENE)


func _on_pengaturan_pressed() -> void:
	# Sementara: PENGATURAN hanya mengganti mode layar penuh.
	var is_fullscreen: bool = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_WINDOWED if is_fullscreen else DisplayServer.WINDOW_MODE_FULLSCREEN
	)


func _on_keluar_pressed() -> void:
	get_tree().quit()
