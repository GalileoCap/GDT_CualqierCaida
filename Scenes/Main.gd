extends Node

#La aceleracion hacia abajo es siempre g
#La aceleracion sobre la rampa es siempre ar = g * sin(alfa1)
#La velocidad sobre la rampa es vr = velocidad_inicial + ar * t
#La posicion sobre la rampa es xr = posicion_inicial + g * sin(alfa1) * 0.5 * t^2

const escala = 100.0 #Un metro = 10 pixeles

#Rampa1
const x_rampa1 = 0.10 #Inicio rampa1
const y_rampa1 = 3.20
const xf_rampa1 = 3.10
const yf_rampa1 = 6.0
var alfa1 #Angulo de la rampa1

#Rampa2
const x_rampa2 = xf_rampa1 #Inicio rampa2
const y_rampa2 = yf_rampa1
const xf_rampa2 = 6.10
const yf_rampa2 = 2.0
var alfa2

const g = 9.8 #Aceleracion hacia abajo
const v0 = 0 #Velocidad inicial

var vr = 0 #Velocidad sobre la rampa1
var t = 0 #Tiempo pasado desde el inicio

func _ready():
	$Pelota.position.x = x_rampa1 * escala
	$Pelota.position.y = y_rampa1 * escala

	var dx1 = xf_rampa1 - x_rampa1
	var dy1 = yf_rampa1 - y_rampa1
	alfa1 = atan2(dy1, dx1)

	var dx2 = xf_rampa2 - x_rampa2
	var dy2 = yf_rampa2 - y_rampa2
	alfa2 =  atan2(dy2, dx2)
#	printt("R2:", dx2, dy2, alfa2)

func calculo_rampa_recta(dt, alfa):
	var ar = g * sin(alfa) #Aceleracion sobre la rampa1
	vr += ar * dt #Integramos aceleracion para consegir velocidad
	var dd = vr * dt #cuanto nos movimos en este instante

	$Pelota.position.x += (dd * cos(alfa)) * escala #Transformo la posicion sobre la rampa1 en coordenadas
	$Pelota.position.y += (dd * sin(alfa)) * escala
	#A: Integre en la posicion el cambio qe produjo la aceleracion de esta rampa
	printt("R:", $Pelota.position.x, $Pelota.position.y, ar, vr, t)

func _process(delta):
	t += delta
#Delta es cuanto tiempo paso entre la ultima llamada a esta funcion y esta llamada

	if $Pelota.position.x < xf_rampa1 * escala and $Pelota.position.x >= x_rampa1 * escala:
		calculo_rampa_recta(delta, alfa1)

	if $Pelota.position.x < xf_rampa2 * escala and $Pelota.position.x >= x_rampa2 * escala:
		calculo_rampa_recta(delta, alfa2)