import wollok.game.*

class Comida{
	var property image
	var property position
	var property cantidad = 1

	method sumarCantidad () {
		cantidad+=1	
	}
}

class Cafe inherits Comida(image = "./assets/cafetera1.png", position = game.at(12,3)) {
	var property nombre = 'cafe'
}

class Galletita inherits Comida(image = "./assets/galletita1.png", position = game.at(8,3)){//falta la posicion
	var property nombre = 'galletita'
}

class GalletitaPunto inherits Comida(image = "./assets/galletitaPunto.png", position = game.at(5,3)){
	var property nombre = 'galletitaPunto'
}

class Torta inherits Comida(image= "./assets/torta2.png", position = game.at(6,2)){//falta la posicion 	
	var property nombre = 'torta'
}

class Muffin inherits Comida(image= "./assets/muffin2.png", position = game.at(7,3)){//falta la posicion y la imagen
	var property nombre = 'muffin'	
}


class Jugo inherits Comida(image = "./assets/jarraGrande.png",position = game.at(10,1) ){
	var property nombre = 'jugo'
}
