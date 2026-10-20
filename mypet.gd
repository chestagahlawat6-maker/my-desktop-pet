extends Node2D

var speed = 200
var direction = Vector2(1,0)
var x_dir = 1
var y_dir = 0
var screen_w = 0
var screen_h = 0
var pet_w = 200
var pet_h = 200
var window_size = Vector2(200,200)
var screen_size = Vector2(0,0)

var idle_timer = 0.0
var is_idling = false

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	var screen = DisplayServer.screen_get_size()
	screen_w = screen.x
	screen_h = screen.y
	screen_size = Vector2(screen_w, screen_h)
	
	var center_x = (screen_w - pet_w) / 2
	var center_y = (screen_h - pet_h) / 2
	DisplayServer.window_set_position(Vector2(center_x, center_y))
	
	animated_sprite.play("Walk_Right")

func _physics_process(delta):
	if is_idling:
		idle_timer -= delta
		if idle_timer <= 0:
			is_idling = false
			speed = 300
			animated_sprite.play("Walk_Right")
		return

	var pos = DisplayServer.window_get_position()
	
	var next_x = pos.x + (x_dir * speed * delta)
	var next_y = pos.y + (y_dir * speed * delta)
	
	var right_edge = screen_w - pet_w
	var bottom_edge = screen_h - pet_h
	
	if next_x <= 0 or next_x >= screen_size.x - window_size.x:
		x_dir = x_dir * -1
		animated_sprite.flip_h = !animated_sprite.flip_h
		maybe_idle()
		
	if next_y <= 0 or next_y >= screen_size.y - window_size.y:
		y_dir = y_dir * -1
		maybe_idle()
		
	if next_x < 0:
		next_x = 0
	if next_x > right_edge:
		next_x = right_edge
		
	if next_y < 0:
		next_y = 0
	if next_y > bottom_edge:
		next_y = bottom_edge
		
	DisplayServer.window_set_position(Vector2(next_x, next_y))

func maybe_idle():
	if randf() < 0.3:
		is_idling = true
		idle_timer = randf_range(2.0, 4.0)
		animated_sprite.play("Idle")
