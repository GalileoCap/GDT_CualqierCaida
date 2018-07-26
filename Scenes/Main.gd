extends Node

#La aceleracion hacia abajo es siempre g
#La aceleracion sobre la rampa es siempre ar = g * sin(alfa1)
#La velocidad sobre la rampa es vr = velocidad_inicial + ar * t
#La posicion sobre la rampa es xr = posicion_inicial + g * sin(alfa1) * 0.5 * t^2

const escala = 100.0 #Un metro = 10 pixeles

#Rampa1
const x_rampa1 = 0.10 #Inicio
const y_rampa1 = 3.20
const xf_rampa1 = 3.10 #Fin
const yf_rampa1 = 6.0
var alfa1 #Angulo

#Rampa2
const x_rampa2 = xf_rampa1
const y_rampa2 = yf_rampa1
const xf_rampa2 = x_rampa2 + 3.10
const yf_rampa2 = y_rampa2 - 1.0
var alfa2

#Rampa3
const r_rampa3 = 3.0 #Radio
var circ_rampa3 = 2 * PI * r_rampa3 * 0.25 #Circunferencia del cacho de rampa qe elegi
const x_rampa3 = xf_rampa2
const y_rampa3 = yf_rampa2
const xf_rampa3 = x_rampa3 + r_rampa3
const yf_rampa3 = y_rampa3 - r_rampa3

const g = 9.8 #Aceleracion hacia abajo

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
#	printt(alfa1, alfa2)

func calculo_rampa_recta(dt, alfa):
	var ar = g * sin(alfa) #Aceleracion sobre la rampa
	vr += ar * dt #Integramos aceleracion para consegir velocidad
	var dd = vr * dt #cuanto nos movimos en este instante

	$Pelota.position.x += (dd * cos(alfa)) * escala #Transformo la posicion sobre la rampa en coordenadas
	$Pelota.position.y += (dd * sin(alfa)) * escala
	#A: Integre en la posicion el cambio qe produjo la aceleracion de esta rampa
	printt("R1 y R2:", $Pelota.position.x, $Pelota.position.y, vr, dd)

func calculo_rampa_redonda(dt):
	#Qiero dividir la aceleración de la gravedad, 
	#para calcular la fuerza qe empuja para atras a la pelota.
	#Para eso calculo el angulo al qe se encuentra la pelota respecto del inicio de la rampa
	var dx3 = $Pelota.position.x - x_rampa3
	var dy3 = $Pelota.position.y - y_rampa3
	var alfa = atan2(dy3, dx3)

	var ar = g * sin(alfa)
	vr += ar * dt
	var dd = vr * dt

	#Como estoy integrando los cachos qe se mueve, puedo tratar cada movida sobre el cuarto de circulo
	#como si fueran triángulos. Entonces puedo hacer los calculos desde el centro del circulo
	#con una hipotenusa tamaño r, y el cateto adyacente qe va cambiando (el opuesto siendo dd)
	$Pelota.position.x += dd * escala
	$Pelota.position.y += sqrt(pow(r_rampa3, 2) - pow(dd, 2)) * escala #((C1^2 - R^2 * -1)^0.5) = C2
	#El problema es qe acá estoy sumando todo el C2, cuando sólo qiero sumar la diferencia entre el nuevo y y el anterior
	printt("R3:", $Pelota.position.x, $Pelota.position.y, dy3)

func _process(delta):
	if $Pelota.position.x < xf_rampa1 * escala and $Pelota.position.x >= x_rampa1 * escala:
		calculo_rampa_recta(delta, alfa1)

	if $Pelota.position.x < xf_rampa2 * escala and $Pelota.position.x >= x_rampa2 * escala:
		calculo_rampa_recta(delta, alfa2)

	if $Pelota.position.x < xf_rampa3 * escala and $Pelota.position.x >= x_rampa3 * escala:
		calculo_rampa_redonda(delta)