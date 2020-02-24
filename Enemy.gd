extends KinematicBody2D

const GRAVITY = 10
const SPEED = 40
const FLOOR = Vector2(0, -1)
const NAMES = ["toto", "tata", "titi", "bob", "jean", "caca", "test", "trou", "chat", "coco", "rat", "fdp", "tom", "bug"]

var velocity = Vector2()
var direction = 1

var is_dead = false

func _ready():
	$NameTag.text = NAMES[floor(rand_range(0, len(NAMES)))]

func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	$AnimatedSprite.play("dead")
	$CollisionShape2D.rotate(PI/2)
	$Timer.start()

func _physics_process(delta):
	if not is_dead:
		velocity.x = SPEED * direction
		
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
