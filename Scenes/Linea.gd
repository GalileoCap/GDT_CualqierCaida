extends Node2D

func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()

    for i in range(nb_points+1):
        var angle_point = angle_from + i * (angle_to-angle_from) / nb_points
        points_arc.push_back(center + Vector2(-cos(angle_point), -sin(angle_point)) * radius)

    for index_point in range(nb_points):
        draw_line(points_arc[index_point], points_arc[index_point + 1], color, 5.0)

func _draw():
	var p = get_node("..")
	var x0 = p.x_rampa1
	var y0 = p.y_rampa1

	var x1 = p.xf_rampa1
	var y1 = p.yf_rampa1

	draw_line(Vector2(x0 * p.escala, y0 * p.escala), Vector2(x1 * p.escala, y1 * p.escala), Color(0, 100, 0), 5)
	draw_line(Vector2(p.x_rampa2 * p.escala, p.y_rampa2 * p.escala), Vector2(p.xf_rampa2 * p.escala, p.yf_rampa2 * p.escala), Color(0, 0, 100), 5)
	draw_circle_arc(Vector2(p.rampa3.xc * p.escala, p.rampa3.yc * p.escala), p.rampa3.r * p.escala, p.rampa3.a0, p.rampa3.a1, 100)