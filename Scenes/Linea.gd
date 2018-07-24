extends Node2D

func _draw():
	var p = get_node("..")
	var x0 = p.x_inicial
	var y0 = p.y_inicial

	var x1 = x0 + p.largo_rampa * cos(p.alfa)
	var y1 = y0 + p.largo_rampa * sin(p.alfa)

	draw_line(Vector2(x0 * p.escala, y0 * p.escala), Vector2(x1 * p.escala, y1 * p.escala), Color(0, 100, 0), 5)