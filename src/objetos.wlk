import wollok.game.*

class Electrodomestico {
	var property estaPrendido = false
	var property image
	var property position
}

object cafetera inherits Electrodomestico(image = "./assets/cafetera1.png", position = game.at(12,3)) {
	var property nombre = 'cafetera'
	method hacerCafe(taza){
		
		if (not estaPrendido or not taza.tieneCafe()){
		estaPrendido = true
		game.schedule(5000, taza.cafe())
		estaPrendido = false
		
		}
	}		
		
	method hacerCafeConLeche(taza){
		
		if (not estaPrendido or not taza.tieneCafe()){
		estaPrendido = true
		game.schedule(5000, taza.cafeConLeche())
		estaPrendido = false
	   }		
	}
}

object heladera inherits Electrodomestico(image = "./assets/heladera.jpg", position = game.at(0.8,4.8)) {
	var property nombre = 'heladera'
}
class Comida{
	var property image
	var property position
	var tieneChispas = false
	var property cantidad = 1
	
	method agregarChispas (){
		tieneChispas = true
	}
	method sumarCantidad () {
		cantidad+=1	
	}
}

class Galletita inherits Comida(image = "./assets/galletita1.png", position = game.at(8,3)){//falta la posicion
	var property nombre = 'galletita'

	override method agregarChispas(){
		tieneChispas = true
		image = "./assets/galletitaChispas.png"
	}
}

class GalletitaPunto inherits Comida(image = "./assets/galletitaPunto.png", position = game.at(5,3)){
	var property nombre = 'galletitaPunto'
}

class Torta inherits Comida(image= "./assets/torta2.png", position = game.at(6,2)){//falta la posicion 	
	var property nombre = 'torta'
	override method agregarChispas(){
		tieneChispas = true
		image = "./assets/tortaChispas.png"
	}
}

class Muffin inherits Comida(image= "./assets/muffin2.png", position = game.at(7,3)){//falta la posicion y la imagen
	var property nombre = 'muffin'	
}


object juguera{
	var property image = "./assets/jarraGrande.png"
	var property position = game.at(10,1)
	var property nombre = 'juguera'
	
	method servirJugoNaranja(vaso){
		vaso.conJugoNaranja()
	}
		method servirJugoFrutilla(vaso){
		vaso.conJugoFrutilla()
	}
		method servirJugoDurazno(vaso){
		vaso.conJugoDurazno()
	}
}
