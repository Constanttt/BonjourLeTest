extends KinematicBody2D

const GRAVITY = 10
const SPEED = 40
const FLOOR = Vector2(0, -1)
const MAX_HEALTH = 10

const CHANGESTAGE = preload("res://ChangeStage.tscn")

var velocity = Vector2()
var direction = -1

var health = MAX_HEALTH
var current_speed = SPEED
var is_dead = false

func _ready():
	$NameTag.text = "Hugo"
	$HealthBar.text = str(MAX_HEALTH) + "HP"
	
func dead():
	health -= 1
	$HealthBar.text = str(health) + "HP"
	current_speed += 15
	if health <= 0:
		is_dead = true
		$HealthBar.text = "Dead"
		velocity = Vector2(0, 0)
		$AnimatedSprite.play("dead")
		$CollisionShape2D.disabled = true
		$CollisionShape2D.scale.x = 0
		$CollisionShape2D.scale.y = 0
		var change_stage = CHANGESTAGE.instance()
		get_parent().add_child(change_stage)
		change_stage.position = Vector2(600, 150)
		change_stage.target_stage = "res://TitleScreen.tscn"

func _physics_process(delta):
	if not is_dead:
		velocity.x = current_speed * direction
		
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
			
		$AnimatedSprite.play("walk")
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
	
		if is_on_wall():
			direction *= -1
			$RayCast2D.position.x *= -1
			
		if not $RayCast2D.is_colliding():
			direction *= -1
			$RayCast2D.position.x *= -1
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Player" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.dead()

func _on_Timer_timeout():
	queue_free()
