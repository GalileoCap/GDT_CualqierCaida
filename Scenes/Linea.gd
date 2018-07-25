extends Node2D

func _draw():
	var p = get_node("..")
	var x0 = p.x_rampa1
	var y0 = p.y_rampa1

	var x1 = p.xf_rampa1
	var y1 = p.yf_rampa1

	draw_line(Vector2(x0 * p.escala, y0 * p.escala), Vector2(x1 * p.escala, y1 * p.escala), Color(0, 100, 0), 5)
	draw_line(Vector2(p.x_rampa2 * p.escala, p.y_rampa2 * p.escala), Vector2(p.xf_rampa2 * p.escala, p.yf_rampa2 * p.escala), Color(0, 0, 100), 5)