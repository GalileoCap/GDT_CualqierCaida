extends Node2D

func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points+1):
        var angle_point = angle_from + i * (angle_to-angle_from) / nb_points
        points_arc.push_back(center + Vector2(-cos(angle_point), -sin(angle_point)) * radius)

    for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color, 5.0)

func dibujar_arco_ppr(x0, y0, x1, y1, r):
	var p = get_node("..")
	var b = -(x1-x0)/(y1-y0)
	var c = (-pow(x0, 2) + pow(x1, 2) - pow(y0, 2) + pow(y1, 2))/(2.0*(y1-y0))
	printt("B y C:", b, c)

	var aq = pow(b, 2) + 1.0
	var bq = -2.0 * x0 + 2.0 * b * c - 2.0 * b * y0
	var cq = pow(x0, 2) + pow(y0, 2) + pow(c, 2) - 2.0 * y0 * c - pow(r, 2)
	var dq = pow(bq, 2) - 4.0 * aq * cq
	printt("AQ, BQ, CQ, DQ:", aq, bq, cq, dq)

	var xcA = (-bq + sqrt(dq)) / (2.0*aq)
	var xcB = (-bq - sqrt(dq)) / (2.0*aq)
	printt("Raices x:", xcA, xcB)

	var ycA = xcA * b + c
	var ycB = xcB * b + c
	printt("Raices y:", ycA, ycB)
	#Nos calculamos las raices para DOS circulos, panza p'arriba y panza p'abajo.

	var a0 = atan2(x0 - xcA, y0 - ycA)
	var a1 = -atan2(x1 - xcA, y1 - ycA)
	printt("Angulos:", a0, a1)
	draw_circle_arc(Vector2(xcB * p.escala, ycB * p.escala), r * p.escala, a0, a1, 100)

func _draw():
	var p = get_node("..")
	var x0 = p.x_rampa1
	var y0 = p.y_rampa1

	var x1 = p.xf_rampa1
	var y1 = p.yf_rampa1

	draw_line(Vector2(x0 * p.escala, y0 * p.escala), Vector2(x1 * p.escala, y1 * p.escala), Color(0, 100, 0), 5)
	draw_line(Vector2(p.x_rampa2 * p.escala, p.y_rampa2 * p.escala), Vector2(p.xf_rampa2 * p.escala, p.yf_rampa2 * p.escala), Color(0, 0, 100), 5)

	var r = 3.0
	x0 = p.x_rampa3
	y0 = p.y_rampa3
	x1 = x0 + r
	y1 = y0 - r
	var mic = y0-x0-r
	var mibq = -4.0 * x0 - 2.0 * r
	var micq = 2 * pow(x0, 2) + 2 * r * x0
	printt("MIC:", mic, "MIBQ:", mibq, "MICQ:", micq)
	dibujar_arco_ppr(x0, y0, x1, y1, r)