extends KinematicBody2D

const SPEED = 60
const GRAVITY = 10
const JUMP_POWER = -220
const FLOOR = Vector2(0, -1)
const MAXJUMP = 2

const FIREBALL = preload("res://FireBall.tscn")

var velocity = Vector2()
var on_ground = false
var is_shooting = false
var current_jump = 0
var is_dead = false

func _physics_process(delta):
	if not is_dead:
		if Input.is_action_pressed("ui_right") and not is_shooting:
			velocity.x = SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = false
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
		elif Input.is_action_pressed("ui_left") and not is_shooting:
			velocity.x = -SPEED
			$AnimatedSprite.play("run")
			$AnimatedSprite.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
		else:
			velocity.x = 0
			if on_ground and not is_shooting:
				$AnimatedSprite.play("idle")
			
		if Input.is_action_just_pressed("ui_up") and not is_shooting:
			if on_ground or current_jump < MAXJUMP - 1:
				velocity.y = JUMP_POWER
				on_ground = false
				current_jump += 1
				
		if Input.is_action_just_pressed("ui_focus_next") and not is_shooting and on_ground:
			is_shooting = true
			$AnimatedSprite.play("shoot")
			yield($AnimatedSprite, "animation_finished")
			var fireball = FIREBALL.instance()
			fireball.set_fireball_direction(sign($Position2D.position.x))
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
		
		velocity.y += GRAVITY
		
		if is_on_floor():
			if not on_ground:
				is_shooting = false
			on_ground = true
			current_jump = 0
		else:
			#if not is_shooting:
			on_ground = false
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("fall")
		
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Enemy" in get_slide_collision(i).collider.name and not get_slide_collision(i).collider.is_dead:
					dead()

func dead():
	is_dead = true
	velocity = 0
	$AnimatedSprite.play("dead")
	$CollisionShape2D.rotate(PI/2)
	$Timer.start()

func _on_AnimatedSprite_animation_finished():
	is_shooting = false


func _on_Timer_timeout():
	get_tree().change_scene("res://TitleScreen.tscn")
