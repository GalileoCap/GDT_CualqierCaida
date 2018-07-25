extends Node

#La aceleracion hacia abajo es siempre g
#La aceleracion sobre la rampa es siempre ar = g * sin(alfa1)
#La velocidad sobre la rampa es vr = velocidad_inicial + ar * t
#La posicion sobre la rampa es xr = posicion_inicial + g * sin(alfa1) * 0.5 * t^2

const escala = 100 #Un metro = 10 pixeles

#Rampa1
const x_rampa1 = 0.10 #Inicio rampa1
const y_rampa1 = 3.20
const xf_rampa1 = 3.10
const yf_rampa1 = 6.0
var largo_rampa1
var alfa1 #Angulo de la rampa1

#Rampa2
const x_rampa2 = xf_rampa1 #Inicio rampa2
const y_rampa2 = yf_rampa1
const xf_rampa2 = 6.10
const yf_rampa2 = 0.5
var largo_rampa2
var alfa2

const g = 9.8 #Aceleracion hacia abajo
const v0 = 0 #Velocidad inicial

var ar = 0 #Aceleracion sobre la rampa1
var vr = 0 #Velocidad sobre la rampa1
var d = 0 #Posicion sobre la rampa1
var finrampa_x
var finrampa_y
var t = 0 #Tiempo pasado desde el inicio

var estado

func _ready():
	$Pelota.position.x = x_rampa1 * escala
	$Pelota.position.y = y_rampa1 * escala

	var dx1 = xf_rampa1 - x_rampa1
	var dy1 = yf_rampa1 - y_rampa1
	largo_rampa1 = sqrt(pow(dx1, 2) + pow(dy1, 2))
	alfa1 = atan2(dy1, dx1)

	var dx2 = xf_rampa2 - x_rampa2
	var dy2 = yf_rampa2 - y_rampa2
	largo_rampa2 = sqrt(pow(dx2, 2) + pow(dy2, 2))
	alfa2 =  atan2(dy2, dx2)
	printt("R2:", dx2, dy2, alfa2)

func calculo_rampa1(t): 
	ar = g * sin(alfa1) #Aceleracion sobre la rampa1
	vr = v0 + ar * t #Velociadd sobre la rampa1
	d = v0 * t + ar * 0.5 * pow(t, 2) #Posicion sobre la rampa1

	$Pelota.position.x = (x_rampa1 + cos(alfa1) * d) * escala #Transformo la posicion sobre la rampa1 en coordenadas
	$Pelota.position.y = (y_rampa1 + sin(alfa1) * d) * escala
#	printt("R1:", $Pelota.position.x, $Pelota.position.y, ar, vr, t)

func calculo_rampa2(t):
	var alfaok = alfa2

	ar = g * sin(alfa2) #Aceleracion sobre la rampa2
	vr = v0 + ar * t #Velociadd sobre la rampa2
	d = v0 * t + ar * 0.5 * pow(t, 2) #Posicion sobre la rampa2

	$Pelota.position.x = (x_rampa2 + cos(alfa2) * d) * escala #Transformo la posicion sobre la rampa2 en coordenadas
	$Pelota.position.y = (y_rampa2 + sin(alfa2) * d) * escala
	printt("R2:", $Pelota.position.x, $Pelota.position.y, ar, vr, t)

func _process(delta):
	t += delta
#Delta es cuanto tiempo paso entre la ultima llamada a esta funcion y esta llamada

	if $Pelota.position.x < xf_rampa1 * escala and $Pelota.position.x >= x_rampa1 * escala:
		calculo_rampa1(t)
		if $Pelota.position.x >= xf_rampa1 * escala or $Pelota.position.x < x_rampa1 * escala:
			t = 0
			v0 = vr
			printt("Fin rampa1:", t, vr)

	if $Pelota.position.x < xf_rampa2 * escala and $Pelota.position.x >= x_rampa2 * escala:
		calculo_rampa2(t)
		if $Pelota.position.x >= xf_rampa2 * escala or $Pelota.position.x < x_rampa2 * escala:
			t = 0
			v0 = -vr
			printt("Fin rampa2:", t, vr)