extends VehicleBody3D

@export var max_rpm = 1000
@export var max_torque = 500
@export var acceleration = 60
@export var brake_power = 80
@export var steering_speed = 1.0
#@onready var engine_audio = get_node("../engine_audio")

func _ready():
#	engine_audio.play(0)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Handle steering
	var steering_input = Input.get_axis("ui_right", "ui_left")
	if steering_input :
		steering = clamp(lerp(steering, steering_input, steering_speed * delta), -1.0, 1.0)
	else:
		steering = move_toward(steering, 0, steering_speed)
	
	print(steering)
	# Handle acceleration and braking
	var acceleration_input = Input.get_axis("ui_down", "ui_up")
	if acceleration_input:
		# Apply engine force to rear wheels
		var rpm = abs($back_left_wheel.get_rpm())
		$back_left_wheel.engine_force = acceleration_input * acceleration * max_torque * (1 - rpm / max_rpm)
		rpm = abs($back_right_wheel.get_rpm())
		$back_right_wheel.engine_force = acceleration_input * acceleration * max_torque * (1 - rpm / max_rpm)
		print($back_left_wheel.engine_force)
	else:

		# Release engine force
		engine_force = move_toward(engine_force, 0.0, brake_power)

	# Update wheel steering
	$front_left_wheel.steering = steering
	$front_right_wheel.steering = steering
