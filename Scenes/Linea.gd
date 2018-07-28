extends Node2D

#Dibuja un arco. Como Godot tiene invertidas las Y,
#(Godot dibuja en sentido a reloj, nosotros en sentido anti-reloj)
#cambiamos el "sin" por un "-sin" invirtiendo las Y.
func draw_circle_arc(centro, radio, angulo_ini, angulo_fin, color):
	var cuantas_veces = 32
	printt("Params", centro, radio, angulo_ini, angulo_fin)

#Repite esto la cantidad de veces qe le dijimos
	for i in range(1, cuantas_veces + 1):
		var angulo_desde = angulo_ini + (i - 1) * (angulo_fin-angulo_ini) / cuantas_veces
		var angulo_hasta = angulo_ini + i * (angulo_fin-angulo_ini) / cuantas_veces
		var desde = centro + Vector2(cos(angulo_desde), -sin(angulo_desde)) * radio
		var hasta = centro + Vector2(cos(angulo_hasta), -sin(angulo_hasta)) * radio
#DBG		printt("Angulos:", i, desde, hasta, angulo_desde, angulo_hasta)

		draw_line(desde, hasta, color, 5.0)

#Esta funcion se llama despues del _ready de Main
func _draw():
	var p = get_node("..")

	for parte in p.Pista:
		if parte.T == "C":
			draw_circle_arc(Vector2(parte.xc * p.escala, parte.yc * p.escala), parte.r * p.escala, parte.a0, parte.a1, parte.col)
		else:
			draw_line(Vector2(parte.x0 * p.escala, parte.y0 * p.escala), Vector2(parte.x1 * p.escala, parte.y1 * p.escala), parte.col, 5)