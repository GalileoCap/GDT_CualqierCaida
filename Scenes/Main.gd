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
var xant #La posicion anterior
var yant

var res

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

	var r = r_rampa3
	var x0 = x_rampa3
	var y0 = y_rampa3
	var x1 = x0 + r
	var y1 = y0 - r
	res = cuentas_arco(x0, y0, x1, y1, r)

func cuentas_arco(x0, y0, x1, y1, r):
	var b = -(x1-x0)/(y1-y0)
	var c = (-pow(x0, 2) + pow(x1, 2) - pow(y0, 2) + pow(y1, 2))/(2.0*(y1-y0))
#	printt("B y C:", b, c)

	var aq = pow(b, 2) + 1.0
	var bq = -2.0 * x0 + 2.0 * b * c - 2.0 * b * y0
	var cq = pow(x0, 2) + pow(y0, 2) + pow(c, 2) - 2.0 * y0 * c - pow(r, 2)
	var dq = pow(bq, 2) - 4.0 * aq * cq
#	printt("AQ, BQ, CQ, DQ:", aq, bq, cq, dq)

	var xcA = (-bq + sqrt(dq)) / (2.0*aq)
	var xcB = (-bq - sqrt(dq)) / (2.0*aq)
#	printt("Raices x:", xcA, xcB)

	var ycA = xcA * b + c
	var ycB = xcB * b + c
#	printt("Raices y:", ycA, ycB)
	#Nos calculamos las raices para DOS circulos, panza p'arriba y panza p'abajo.

	var a0 = atan2(x0 - xcA, y0 - ycA)
	var a1 = -atan2(x1 - xcA, y1 - ycA)
#	printt("Angulos:", a0, a1)
	var res = {"xc":xcB, "yc":ycB, "a0":a0, "a1":a1, "x0":x0, "x1":x1, "y0":y0, "y1":y1, "r":r, }
	return(res)

func calculo_rampa_recta(dt, alfa):
	var ar = g * sin(alfa) #Aceleracion sobre la rampa
	vr += ar * dt #Integramos aceleracion para consegir velocidad
	var dd = vr * dt #cuanto nos movimos en este instante

	$Pelota.position.x += (dd * cos(alfa)) * escala #Transformo la posicion sobre la rampa en coordenadas
	$Pelota.position.y += (dd * sin(alfa)) * escala
	#A: Integre en la posicion el cambio qe produjo la aceleracion de esta rampa
	printt("R1 y R2:", $Pelota.position.x, $Pelota.position.y)

func calculo_rampa_redonda(dt):
	var mix = $Pelota.position.x / escala
	var temp1 = 0.5 * sqrt(pow(res.r, 2) - pow(mix - res.xc, 2))
	var alfa = atan2(1, temp1) #dy/dx = 1/temp1.,
	#pero con x = r se volveria indefinida, por eso usamos atan2 qe tiene en cuenta ese caso
	var ar = -g * sin(alfa)
	vr += ar * dt
	var dd = vr * dt #dd es en la direccion de la tangente del plano

	$Pelota.position.x += dd * cos(alfa) * escala
	$Pelota.position.y -=  dd * sin(alfa) * escala
	printt("R3:", $Pelota.position.x, alfa * 180 / PI, mix - res.xc, dd, vr, ar)

func _process(delta):
	if $Pelota.position.x < xf_rampa1 * escala and $Pelota.position.x >= x_rampa1 * escala:
		calculo_rampa_recta(delta, alfa1)

	if $Pelota.position.x < xf_rampa2 * escala and $Pelota.position.x >= x_rampa2 * escala:
		calculo_rampa_recta(delta, alfa2)

	if $Pelota.position.x < xf_rampa3 * escala and $Pelota.position.x >= x_rampa3 * escala:
		calculo_rampa_redonda(delta)

	xant = $Pelota.position.x
	yant = $Pelota.position.y