extends Node2D

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	#U: Dibuja un arco sentido antihorario (el sentido real no godoteano)
	var nb_points = 32
	printt("Params", center, radius, angle_from, angle_to)

	for i in range(1, nb_points+1):
		var angle_desde = angle_from + (i - 1) * (angle_to-angle_from) / nb_points
		var angle_hasta = angle_from + i * (angle_to-angle_from) / nb_points
		var desde = center + Vector2(cos(angle_desde), -sin(angle_desde)) * radius
		var hasta = center + Vector2(cos(angle_hasta), -sin(angle_hasta)) * radius
		printt("Angulos:", i, desde, hasta, angle_desde, angle_hasta)

		draw_line(desde, hasta, color, 5.0)

func _draw():
	var p = get_node("..")

	for parte in p.Pista:
		if parte.T == "C":
			draw_circle_arc(Vector2(parte.xc * p.escala, parte.yc * p.escala), parte.r * p.escala, parte.a0, parte.a1, parte.col)
		else:
			draw_line(Vector2(parte.x0 * p.escala, parte.y0 * p.escala), Vector2(parte.x1 * p.escala, parte.y1 * p.escala), parte.col, 5)

#	draw_line(Vector2(p.x_rampa2 * p.escala, p.y_rampa2 * p.escala), Vector2(p.xf_rampa2 * p.escala, p.yf_rampa2 * p.escala), Color(0, 0, 100), 5)
#	draw_circle_arc(Vector2(p.rampa3.xc * p.escala, p.rampa3.yc * p.escala), p.rampa3.r * p.escala, p.rampa3.a0, p.rampa3.a1, 100)