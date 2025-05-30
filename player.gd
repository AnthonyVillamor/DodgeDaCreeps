extends Area2D
signal hit

@export var speed = 400
var screen_size
var is_moving = false  # <--- Added this

func _ready():
	screen_size = get_viewport_rect().size
	connect("body_entered", Callable(self, "_on_body_entered")) 

func _process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	is_moving = velocity.length() > 0  # <--- Track if moving

	if is_moving:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

func _on_body_entered(body):
	hide()  
	hit.emit()  
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos  
	show()  
	$CollisionShape2D.disabled = false
