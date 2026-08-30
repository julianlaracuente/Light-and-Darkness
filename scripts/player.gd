extends CharacterBody2D
class_name Player

const BASE_SPEED = 800.0
const JUMP_VELOCITY = 2000
const FALL_SPEED = 5

# with this will be able to control the name of the inputs
var input_name
# if the player can iteract with something
var can_interact : bool

var current_area : Area2D = null

@onready var interactable_collision: CollisionShape2D = $InteractableArea/InteractableCollision
@export var test = "Test"
@onready var sprite: AnimatedSprite2D = get_node("AnimatedSprite2D")
enum Player_State{
	Startup,
	Active,
	Airborne,
	End_Screen
}

var current_state: Player_State = Player_State.Startup

func setup():
	if name == "Player1":
		input_name = "p1_"
	else:
		input_name = "p2_"

func change_state(newState):
	current_state = newState
	match current_state:
		Player_State.Startup:
			pass
		Player_State.Active:
			pass
		Player_State.Airborne:
			pass
		Player_State.End_Screen:
			pass

func _ready() -> void:
	setup()
	change_state(Player_State.Active)


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2.ZERO
	
	# Set movement controls if player is p1 or p2
	direction.x = Input.get_axis(input_name + "left", input_name + "right")
	
	# Flip sprite to match movement direction
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta * FALL_SPEED
		
	# State handling
	match current_state:
		Player_State.Startup:
			pass
		Player_State.Active:
			velocity.x = move_toward(velocity.x,direction.x * BASE_SPEED, 10000 * delta)
			# Animations
			if is_on_floor():
				if !direction:
					sprite.play("idle")
				else:
					sprite.play("run")
			elif not is_on_floor():
				sprite.play("fall")
				change_state(Player_State.Airborne)
			if Input.is_action_just_pressed(input_name + "up") and is_on_floor():
				velocity.y = -JUMP_VELOCITY 
				sprite.play("jump")
				change_state(Player_State.Airborne)
			
			var action_name = input_name + "interact"
			if current_area:
				if Input.is_action_just_pressed(action_name):
					current_area.handle_input(self, "pressed")
				elif Input.is_action_pressed(action_name):
					current_area.handle_input(self, "holding")
				elif Input.is_action_just_released(action_name):
					current_area.handle_input(self, "released")
						
			
			#if Input.is_action_just_pressed(input_name + "interact"):
				#if current_area != null : 
					#current_area.action.emit(self)
			#if Input.is_action_pressed(input_name + "interact"):
				#if current_area != null:
					#if current_area.hold == true:
						#current_area.action.emit(self)
			#if Input.is_action_just_released(input_name + "interact"):
				#if current_area != null:
					#if current_area.hold:
						#if current_area.will_revert_changes:
							#current_area.revert_changes = true
							#current_area.action.emit(self)

		# Airborne state is mostly used so that the jump anim doesn't loop, not much else to it
		Player_State.Airborne:
			velocity.x = move_toward(velocity.x,direction.x * BASE_SPEED, 10000 * delta)
			if is_on_floor():
				change_state(Player_State.Active)
		Player_State.End_Screen:
			pass
	move_and_slide()
