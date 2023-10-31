extends Area2D
@export var speed := 1000
@export var damage := 15


func _start(_pos: Vector2, _dir: Vector2) -> void:
	position = _pos
	rotation = _dir.angle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.shield -= damage
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
