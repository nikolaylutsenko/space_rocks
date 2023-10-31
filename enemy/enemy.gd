extends Area2D
@export var bullet_scene : PackedScene
@export var speed = 150
@export var rotation_speed = 120
@export var health = 3
@export var bullet_spread := 0.2
var follow = PathFollow2D.new()
var target = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.frame = randi() % 3 # choose skin of enemy
	var path = $EnemyPaths.get_children()[randi() % $EnemyPaths.get_child_count()]
	path.add_child(follow)
	follow.loop = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	rotation += deg_to_rad(rotation_speed) * delta
	follow.progress += speed * delta
	position = follow.global_position
	if follow.progress_ratio >= 1:
		queue_free()


func shoot() -> void:
	$ShootSound.play()
	var dir = global_position.direction_to(target.global_position)
	dir = dir.rotated(randf_range(-bullet_spread, bullet_spread))
	var b = bullet_scene.instantiate()
	get_tree().root.add_child(b)
	b._start(global_position, dir)

func shoot_pulse(n, delay):
	for i in n:
		shoot()
		await get_tree().create_timer(delay).timeout

func _on_gun_cooldown_timeout():
	if health > 1:
		shoot()
	else:
		shoot_pulse(3, 0.15)
	
func take_damage(amount):
	health -=amount
	$AnimationPlayer.play("flash")
	if health <= 0:
		explode()
		
func explode():
	$ExplosionSound.play()
	speed = 0
	$GunCooldown.stop()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	$Explosion.show()
	$Explosion/AnimationPlayer.play("explosion")
	await  $Explosion/AnimationPlayer.animation_finished
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Rock:
		take_damage(1)
	explode()
	if body is Player:
		take_damage(1)
		body.shield -= 50
