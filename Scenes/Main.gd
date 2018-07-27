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
var rampa3 = {}
############################################################################################
const g = 9.8 #Aceleracion hacia abajo

var ar = 0
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

	rampa3.r = 3.0 #Radio
	rampa3.x0 = xf_rampa2
	rampa3.y0 = yf_rampa2
	rampa3.x1 = rampa3.x0 + rampa3.r * 2 - 0.1
	rampa3.y1 = rampa3.y0 - 1

	checkeo_arco(rampa3)
	cuentas_arco(rampa3)

func dist(par):
	return(sqrt(pow(par.x1 - par.x0, 2) + pow(par.y1 - par.y0, 2)))

func checkeo_arco(par):
	var d = dist(par)
	if d > par.r * 2:
		print("ERROR, d > 2 * r", d, par) 

func cuentas_arco(par):
	var b = -(par.x1-par.x0)/(par.y1-par.y0)
	var c = (-pow(par.x0, 2) + pow(par.x1, 2) - pow(par.y0, 2) + pow(par.y1, 2))/(2.0*(par.y1-par.y0))
	printt("B y C:", b, c)

	var aq = pow(b, 2) + 1.0
	var bq = -2.0 * par.x0 + 2.0 * b * c - 2.0 * b * par.y0
	var cq = pow(par.x0, 2) + pow(par.y0, 2) + pow(c, 2) - 2.0 * par.y0 * c - pow(par.r, 2)
	var dq = pow(bq, 2) - 4.0 * aq * cq
	printt("AQ, BQ, CQ, DQ:", aq, bq, cq, dq)

	var xcA = (-bq + sqrt(dq)) / (2.0*aq)
	var xcB = (-bq - sqrt(dq)) / (2.0*aq)
	printt("Raices x:", xcA, xcB)

	var ycA = xcA * b + c
	var ycB = xcB * b + c
	printt("Raices y:", ycA, ycB)
	#Nos calculamos las raices para DOS circulos, panza p'arriba y panza p'abajo.

	par.xc = xcB
	par.yc = ycB
	par.a0 = atan2(par.x0 - par.xc, par.y0 - par.yc)
	par.a1 = -atan2(par.x1 - par.xc, par.y1 - par.yc)

	printt("Par circulo:", par)
	return(par)

func calculo_rampa_recta(dt, alfa):
	ar = g * sin(alfa) #Aceleracion sobre la rampa
	vr += ar * dt #Integramos aceleracion para consegir velocidad
	var dd = vr * dt #cuanto nos movimos en este instante

	$Pelota.position.x += (dd * cos(alfa)) * escala #Transformo la posicion sobre la rampa en coordenadas
	$Pelota.position.y += (dd * sin(alfa)) * escala
	#A: Integre en la posicion el cambio qe produjo la aceleracion de esta rampa
	printt("R1 y R2:", $Pelota.position.x, $Pelota.position.y)

func calculo_rampa_redonda(dt):
	var mix = $Pelota.position.x / escala
	var temp1 = sqrt(pow(rampa3.r, 2) - pow(mix - rampa3.xc, 2))
	var alfa = atan2(1, 2 * temp1) #dy/dx = 1/temp1.,
	#pero con x = r se volveria indefinida, por eso usamos atan2 qe tiene en cuenta ese caso
	ar = -g * sin(alfa)
	vr += ar * dt
	var dd = vr * dt #dd es en la direccion de la tangente del plano

	$Pelota.position.x = (mix + dd * cos(alfa)) * escala
	$Pelota.position.y = (temp1 + rampa3.yc) * escala
	printt("R3:",  mix - rampa3.xc, alfa * 180 / PI, dd, vr, ar)

func _process(delta):
	$Velocimetro.scale.x = vr / 10
	$Acelerometro.scale.x = ar / 20

	if $Pelota.position.x < xf_rampa1 * escala and $Pelota.position.x >= x_rampa1 * escala:
		calculo_rampa_recta(delta, alfa1)

	if $Pelota.position.x < xf_rampa2 * escala and $Pelota.position.x >= x_rampa2 * escala:
		calculo_rampa_recta(delta, alfa2)

	if $Pelota.position.x < rampa3.x1 * escala and $Pelota.position.x >= rampa3.x0 * escala:
		calculo_rampa_redonda(delta)

	xant = $Pelota.position.x
	yant = $Pelota.position.y