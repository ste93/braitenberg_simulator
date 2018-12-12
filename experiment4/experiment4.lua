-- Put your global variables here
BODY_RADIUS = 0.085036758
RIGHT = 23
LEFT = 2
BASE_SPEED = 2
BASE_SPEED_LEFT = BASE_SPEED
BASE_SPEED_RIGHT = BASE_SPEED 


--[[ This function is executed every time you press the 'execute'
     button ]]
function init()
	--robot.wheels.set_velocity(BASE_SPEED_LEFT, BASE_SPEED_RIGHT)
end

--(E^(-((x-4)^2+(y+3)^2)/20))/2 + (E^(-((x+2)^2+(y-5)^2)/20))/2 
--y = (e ^ x^2 - 1)/2
function proximity_speed(x)
	--return x
	--return (math.exp(math.pow(x,2))-1) / 2
	--(e ^ 5x^5 )/150 
	return (math.exp(math.pow(x,5)* 5) / 150)
--[[	if x < 0.4 then
		return 0.1
	elseif x < 0.8 then
		return 0.5
	else
		return 1
	end]]
--	return x
--[[	if x < 0.2 then
		return 0
	elseif x < 0.8 then
		return x
	else
		return 1
	end]]
end

function gaussian(x)
	return math.exp(-math.pow((4*(x-0.5)), 2))
end

function temperature(position)
	x = position.x
	y = position.y
	return math.abs(math.sin(x *1.5) + math.sin((y + 1) *1.5))/2
end

function sound(position)
	x = position.x
	y = position.y
	return (math.pow(x,3) + 5*math.pow(x,2) + 4*math.pow(y,2))/200 
end

function organic_matter(position) 
	x = position.x
	y = position.y
	return (math.atan(x*y)  * math.cos(x+y))/4 + 0.5
end

function oxigen_concentration(position) 
	x = position.x
	y = position.y
	return (math.exp(-(math.pow(x-4, 2)+math.pow(y+3,2))/20) + math.exp(-(math.pow(x+2, 2)+math.pow(y-5, 2))/20))/2 
end

function calculate_postion() 
	robot_angle = robot.positioning.orientation.angle * robot.positioning.orientation.axis.z 
	sensor_right_deviation_x = math.sin(robot.light[RIGHT].angle + robot_angle) * BODY_RADIUS
	sensor_right_deviation_y = math.cos(robot.light[RIGHT].angle + robot_angle) * BODY_RADIUS
	sensor_left_deviation_x = math.sin(robot.light[LEFT].angle + robot_angle) * BODY_RADIUS
	sensor_left_deviation_y = math.cos(robot.light[LEFT].angle + robot_angle) * BODY_RADIUS
	sensor_right_x = sensor_right_deviation_x + robot.positioning.position.x
	sensor_right_y = sensor_right_deviation_y + robot.positioning.position.y
	sensor_left_x = sensor_left_deviation_x + robot.positioning.position.x
	sensor_left_y = sensor_left_deviation_y + robot.positioning.position.y
	position_left = {}
	position_left['x'] = sensor_left_x
	position_left['y'] = sensor_left_y
	position_right = {}
	position_right['x'] = sensor_right_x
	position_right['y'] = sensor_right_y

	position = {}
	position['left'] = position_left
	position['right'] = position_right
	return position
end

--[[ This function is executed at each time step
     It must contain the logic of your controller ]]
function step()

	--position of simulated sensors
	position = calculate_postion() 

	--speed of the wheels based on sensor's perceptions 
	speed_right = proximity_speed(robot.proximity[21].value)

	speed_left =  proximity_speed(robot.proximity[4].value)
	difference = speed_left - speed_right
--[[	if difference > 0 then
		speed_right = 0 --speed_right / 2
	elseif difference < 0 then
		speed_left = 0 --speed_left / 2
	end]]
--[[
	log("light left " .. robot.light[LEFT].value)
	log("light right " .. robot.light[RIGHT].value)	
	log("temp right " .. gaussian(temperature(position.right)))
	log("temp left " .. gaussian(temperature(position.left)))	]]
	log("prox right " .. speed_right)
	log("prox left " .. speed_left)
--[[	log("org right " .. organic_matter(position.right))
	log("org left " .. organic_matter(position.left))
]]
	robot.wheels.set_velocity((BASE_SPEED_LEFT + speed_left*10) * 5, (BASE_SPEED_RIGHT +speed_right*10) *5)
	log("speed right " .. speed_right)
	log("speed left " .. speed_left)
end

--[[ This function is executed every time you press the 'reset'
     button in the GUI. It is supposed to restore the state
     of the controller to whatever it was right after init() was
     called. The state of sensors and actuators is reset
     automatically by ARGoS. ]]
function reset()
	--robot.wheels.set_velocity(BASE_SPEED_LEFT, BASE_SPEED_RIGHT)
--	robot.positioning.position.x = math.random() * 6 - 3
--	robot.positioning.position.y = math.random() * 6 - 3
end

--[[ This function is executed only once, when the robot is removed
     from the simulation ]]
function destroy()
   -- put your code here
end
