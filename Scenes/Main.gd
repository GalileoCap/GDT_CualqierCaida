extends Node

#La aceleracion hacia abajo es siempre g
#La aceleracion sobre la rampa es siempre ar = g * sin(alfa1)
#La velocidad sobre la rampa es vr = velocidad_inicial + ar * t
#La posicion sobre la rampa es xr = posicion_inicial + g * sin(alfa1) * 0.5 * t^2

const escala = 100.0 #Un metro = 10 pixeles

############################################################################################

const posIn_x = 0.10 #Posicion inicial de la pelota
const posIn_y = 3.20

const g = 9.8 #Aceleracion de la gravedad

var ar = 0
var vr = 0 #Velocidad sobre la rampa1
var t = 0 #Tiempo pasado desde el inicio
var Pista = Array()

func pista_LbLsCh():
	#El orden de las rampas
	Pista.push_back(rampa_L_baja())
	Pista.push_back(rampa_L_sube())
	Pista.push_back(rampa_C_horizontal())

#Definimos los valores de las rampas
func rampa_L_baja():
	var rampa1 = {}
	rampa1.T = "L" #Qe estilo de rampa es ("L" = Lineal)
	rampa1.Dx = 3.0 #Cuanto cambia la rampa en x
	rampa1.Dy = + 2.40 #Y el Y
	rampa1.alfa = atan2(rampa1.Dy, rampa1.Dx) #El angulo de la pendiente
	rampa1.col = Color(0, 100, 0) #El color de la rampa en Red Green Blue
	return(rampa1)

func rampa_L_sube():
	var rampa2 = {}
	rampa2.T = "L"
	rampa2.Dx = 3.10
	rampa2.Dy = - 1.0
	rampa2.alfa = atan2(rampa2.Dy, rampa2.Dx)
	rampa2.col = Color(0, 0, 100)
	return(rampa2)

func rampa_C_horizontal():
	var rampa3 = {}
	rampa3.T = "C" #"C" = circular
	rampa3.r = 3.0 #Radio
	rampa3.Dx = rampa3.r * 1.9 #1.9 asi siempre es mas chico qe el radio
	rampa3.Dy = 0.000001 #Restamos esto para qe y1 e y0 no sean iguales
	rampa3.col = Color(100, 0, 0)
	return(rampa3)

func dist(par):
	return(sqrt(pow(par.x1 - par.x0, 2) + pow(par.y1 - par.y0, 2)))

func arreglar_pista(pista):
	var x0ant = posIn_x #El inicio de la rampa 
	var y0ant = posIn_y #(si no lo especificamos el programa continua la rampa anterior)

	for parte in pista:
		#Si no especificamos inicio, qe la continue de la anterior
		if not parte.has("x0"): parte.x0 = x0ant
		if not parte.has("y0"): parte.y0 = y0ant
		#Si no espeficicamos final, qe lo calcule de la pendiente qe le dimos
		if not parte.has("x1"): parte.x1 = parte.x0 + parte.Dx
		if not parte.has("y1"): parte.y1 = parte.y0 + parte.Dy

		#Si es un circulo hace los calculos especificos para el circulo
		if parte.T == "C":
			checkeo_arco(parte)
			cuentas_arco(parte)

		#Define el final de esa pendiente como el inicio de la sigiente (a menos qe especifiqemos)
		x0ant = parte.x1
		y0ant = parte.y1

func salir_error(mensaje, d):
	printt("ERROR:", mensaje, d)
	get_tree().quit()

#Revisamos qe el arco de las pendientes circulares tenga sentido
func checkeo_arco(par):
	var d = dist(par)
	if d > par.r * 2:
		salir_error("d > 2 * r", {"d":d, "par":par})

#Hace las cuentas para el arco de nuestras pendientes circulares
func cuentas_arco(par):
	var b = -(par.x1-par.x0)/(par.y1-par.y0)
	var c = (-pow(par.x0, 2) + pow(par.x1, 2) - pow(par.y0, 2) + pow(par.y1, 2))/(2.0*(par.y1-par.y0))
	printt("B y C:", b, c)

	var aq = pow(b, 2) + 1.0
	var bq = -2.0 * par.x0 + 2.0 * b * c - 2.0 * b * par.y0
	var cq = pow(par.x0, 2) + pow(par.y0, 2) + pow(c, 2) - 2.0 * par.y0 * c - pow(par.r, 2)
	var dq = pow(bq, 2) - 4.0 * aq * cq
	printt("AQ, BQ, CQ, DQ:", aq, bq, cq, dq)

	#Nos calculamos las raices para DOS circulos, uno panza p'arriba y uno panza p'abajo.
	var xcA = (-bq + sqrt(dq)) / (2.0*aq)
	var xcB = (-bq - sqrt(dq)) / (2.0*aq)
	printt("Raices x:", xcA, xcB)

	var ycA = xcA * b + c
	var ycB = xcB * b + c
	printt("Raices y:", ycA, ycB)

	#Aca elegimos qe circulo usar y calcula los angulos inicial y final (respecto del centro)
	#XXXXARREGLARXXXX Veamos si hay alguna forma de qe lo eliga por su cuenta el programa
	par.xc = xcB
	par.yc = ycB
	par.a0 = atan2(par.y0 - par.yc, par.x0 - par.xc)
	par.a1 = atan2(par.y1 - par.yc, par.x1 - par.xc)

	printt("Par circulo:", par)
	return(par)

#Mueve a la pelota sobre
func calculo_rampa_recta(dt, alfa):
	ar = g * sin(alfa) #Aceleracion sobre la rampa
	vr += ar * dt #Integramos aceleracion para consegir velocidad
	var dd = vr * dt #cuanto nos movimos en este instante

	$Pelota.position.x += dd * cos(alfa) * escala #Transformo la posicion sobre la rampa en coordenadas
	$Pelota.position.y += dd * sin(alfa) * escala
	#A: Integre en la posicion el cambio qe produjo la aceleracion de esta rampa
	printt("RL:", $Pelota.position.x, $Pelota.position.y)

#Calcula la posicion sobre la rampa redonda, el chiste es qe la imaginamos como muchos
#mini planos, por lo qe podemos hacer el calculo del plano una y otra vez para
#calcular la velocidad.
func calculo_rampa_redonda(dt, rampa3):
	var mix = $Pelota.position.x / escala #Averigua donde esta la pelota
	var temp1 = sqrt(pow(rampa3.r, 2) - pow(mix - rampa3.xc, 2)) #dy
	var alfa = atan2(1, 2 * temp1) #dy/dx = 1/temp1.,
	#pero con x = r se volveria indefinida, por eso usamos atan2 qe tiene en cuenta ese caso
	ar = -g * sin(alfa)
	vr += ar * dt
	var dd = vr * dt #dd es en la direccion de la tangente del plano

	$Pelota.position.x = (mix + dd * cos(alfa)) * escala
	$Pelota.position.y = (temp1 + rampa3.yc) * escala

	var proxima_rampa = 0 #Por defecto segimos en esta
	if rampa3.x0 * escala > $Pelota.position.x:
		proxima_rampa = -1 #Nos fuimos para la anterior
	elif rampa3.x1 * escala < $Pelota.position.x:
		proxima_rampa = 1 #Nos fuimos para la sigiente

	printt("RC:",  {"prox":proxima_rampa, "dc":mix - rampa3.xc, "angulo":alfa * 180 / PI, "dd":dd})
	return(proxima_rampa)

func _ready():
	#Pongo a la pelota en su posicion inicial
	$Pelota.position.x = posIn_x * escala
	$Pelota.position.y = posIn_y * escala

	Pista.push_back(rampa_C_horizontal())
	arreglar_pista(Pista)

#A cada instante
func _process(delta):
	#Pusimos dos flechas en la pantalla qe al crecer y achicarse marcan el cambio en:
	$Velocimetro.scale.x = vr / 10 #La velocidad
	$Acelerometro.scale.x = ar / 20 #La aceleracion
	$Posicion.text = str($Pelota.position.x / escala)

	for parte in Pista:
		if parte.x0 * escala <= $Pelota.position.x and $Pelota.position.x < parte.x1 * escala:
			if parte.T == "C":
				calculo_rampa_redonda(delta, parte)
			else:
				calculo_rampa_recta(delta, parte.alfa)