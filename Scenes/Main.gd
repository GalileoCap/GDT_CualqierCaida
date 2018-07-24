extends Node

#La aceleracion hacia abajo es siempre g
#La aceleracion sobre la rampa es siempre ar = g * sin(alfa)
#La velocidad sobre la rampa es vr = velocidad_inicial + ar * t
#La posicion sobre la rampa es xr = posicion_inicial + g * sin(alfa) * 0.5 * t^2

const escala = 100
const x_inicial = 0.10
const y_inicial = 0.20
const largo_rampa = 10
const g = 9.8 #Aceleracion hacia abajo
const v0 = 0 #Velocidad inicial

var vg = 0 #Velocidad hacia abajo

var ar = 0 #Aceleracion sobre la rampa
var vr = 0 #Velocidad sobre la rampa
var d = 0 #Posicion sobre la rampa
var alfa = 5 * PI / 180 #Angulo de la rampa

var t = 0 #Tiempo pasado desde el inicio

func _ready():
	$Pelota.position.x = x_inicial * escala
	$Pelota.position.y = y_inicial * escala

func calculos_sobre_rampa(t): 
	ar = g * sin(alfa) #Aceleracion sobre la rampa
	vr = v0 + ar * t #Velociadd sobre la rampa
	d = ar * 0.5 * pow(t, 2) #Posicion sobre la rampa

func posicion(): #Transformo la posicion sobre la rampa en coordenadas
	$Pelota.position.x = (x_inicial + cos(alfa) * d) * escala #Un metro = diez pixeles
	$Pelota.position.y = (y_inicial + sin(alfa) * d) * escala
#	printt(t, ar, vr, d)

func _process(delta):
	t += delta 
#Delta es cuanto tiempo paso entre la ultima llamada a esta funcion y esta llamada
	calculos_sobre_rampa(t)
	posicion()