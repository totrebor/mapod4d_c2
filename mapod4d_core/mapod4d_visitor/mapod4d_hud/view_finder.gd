# tool
@tool

# class_name

# extends
extends Control

## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables

# ----- private variables

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass # Replace with function body.

# ----- public methods

# ----- private methods

func _draw():
	var cen = Vector2(0, 0)
	var side = 480
	var N = 8
	_draw_regular_polygon(cen, side, N, 3.0, Color(0.2, 0.2, 0.2, 0.3))
	side = 40
	_draw_cross(cen, side, 2.0, Color(1, 1, 1, 0.2), Color(0, 0, 0, 0.2))


# draw octagone
func _draw_regular_polygon(cen, side, N, width, color):
	if N >= 3:
		var ang
		var x
		var y
		var points = PackedVector2Array()
		for i in range(N + 1):
			ang = i * (2 * PI / N)
			x = side * cos(ang)
			y = side * sin(ang)
			points.append(cen + Vector2(x, y))
		draw_polyline(points, color, width, true)


# draw central cross
func _draw_cross(cen, side, width, color, second_color):
	var points
	var shift = width / 2
	side = side / 2
	var antialiased = false
	
	# horizontal up
	points = PackedVector2Array()
	points.append(Vector2(cen.x - side, cen.y - shift))
	points.append(Vector2(cen.x + side, cen.y - shift))
	draw_polyline(points, second_color, width, antialiased)
	# horizontal center
	points = PackedVector2Array()
	points.append(Vector2(cen.x - side, cen.y))
	points.append(Vector2(cen.x + side, cen.y))
	draw_polyline(points, color, width, antialiased)
	# horizontal down
	points = PackedVector2Array()
	points.append(Vector2(cen.x - side, cen.y + shift))
	points.append(Vector2(cen.x + side, cen.y + shift))
	draw_polyline(points, second_color, width, antialiased)

	# vertical left
	points = PackedVector2Array()
	points.append(Vector2(cen.x - shift, cen.y - side))
	points.append(Vector2(cen.x - shift, cen.y + side))
	draw_polyline(points, second_color, width, antialiased)
	# vertical center
	points = PackedVector2Array()
	points.append(Vector2(cen.x, cen.y - side))
	points.append(Vector2(cen.x, cen.y + side))
	draw_polyline(points, color, width, antialiased)
	# vertical right
	points = PackedVector2Array()
	points.append(Vector2(cen.x + shift, cen.y - side))
	points.append(Vector2(cen.x + shift, cen.y + side))
	draw_polyline(points, second_color, width, antialiased)
