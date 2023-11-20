import wollok.game.*

class Electrodomestico {
	var property estaPrendido = false
	var property image
	var property position
}

object cafetera inherits Electrodomestico(image = "./assets/cafetera.png", position = game.at(6,4)) {
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

object heladera inherits Electrodomestico(image = "./assets/heladera.jpg", position = game.at(0.8,5.8)) {
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

class Galletita inherits Comida(image = "./assets/galletita.png", position = game.at(5,5)){//falta la posicion
	var property nombre = 'galletita'

	override method agregarChispas(){
		tieneChispas = true
		image = "./assets/galletitaChispas.png"
	}
}

class GalletitaPunto inherits Comida(image = "./assets/galletitaPunto.png", position = game.at(5,5)){
	var property nombre = 'galletitaPunto'
}

class Torta inherits Comida(image= "./assets/torta.png", position = game.at(4,4)){//falta la posicion 	
	var property nombre = 'torta'
	override method agregarChispas(){
		tieneChispas = true
		image = "./assets/tortaChispas.png"
	}
}

class Muffin inherits Comida(image= "./assets/muffin.jpg", position = game.at(3,3)){//falta la posicion y la imagen
	var property nombre = 'muffin'	
}


object juguera{
	var property image = "./assets/juguera.jpg"
	var property position = game.at(10,4)
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

class Vaso {
	var property image = "./assets/vaso.png"
	var property position = game.at(2,2)
	var property nombre = 'vaso'
	var property jugo = 0
	
	method noTieneJugo(){
		return (jugo == 0)
	}
	method conJugoNaranja(){
		if (self.noTieneJugo()){
			jugo = 1
			image = "./assets/vasoJugoNaranja.png"
		}
	
	}
		method conJugoFrutilla(){
		if (self.noTieneJugo()){
			jugo = 2
			image = "./assets/vasoJugoFrutilla.png"
		}
	}
		method conJugoDuranzo(){
		if (self.noTieneJugo()){
			jugo = 3
			image = "./assets/vasoJugoDurazno.png"
			}
		}
	}




class Taza {
	var property nombre = 'taza'
	var property tieneCafe = false
	var property tieneLeche = false
	var property image = "./assets/taza.jpg"
	var property position = game.at(0,0) //no se donde tiene que estar
	method cafe(){
		tieneCafe = true
		image = "./assets/cafe.png"
	}
	method cafeConLeche(){
		tieneCafe = true
		tieneLeche = true
		image = "./assets/cafeConLeche.png"
	}
}

class Bandeja{
	var property nombre = 'bandeja'
	var property image = "./assets/bandeja.png" //no tenemos el asset
	var property position = game.at(0,0) //no se donde tiene que estar
	var cositas = []
	
	method agregarCosita(cosita){
		cositas.add(cosita)
	}
}

