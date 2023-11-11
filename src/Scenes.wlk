import wollok.game.*
import Visuals.*
import objetos.*


class Scene {
	
	const property width = null
	const property height = null
	const property ground = null
		
}

object inicio inherits Scene(width = 20, height = 20, ground ="" ){
	
	//Pantalla de inicio con comando de tecla para empezar a jugar
	method iniciar(){
		
		game.clear()
		game.title("Juego-Mostrador")
		game.width(self.width())
		game.height(self.height())
		game.ground(self.ground())
		//agregar visuales de la ventana principal
		
		
		keyboard.p().onPressDo{mostrador.iniciar()}
	}
							
}

//sacar
object mostrador inherits Scene(width = 0, height = 0, ground = "./assets/cafeteria.gif"){
	
	method iniciar(){
		
		
		game.width(self.width())
		game.height(self.height())
		game.ground(self.ground())
		
		keyboard.b().onPressDo{cocina.iniciar()}
		
		
	}
}

object cocina inherits Scene(width = 15, height = 10, ground="./assets/cocina.jpg"){
	
	method iniciar(){
		const cosas = [cafetera, juguera, heladera]
		game.width(self.width())
		game.height(self.height())
		game.boardGround(self.ground())
		cosas.forEach{cosa => game.addVisual(cosa)}
		
		
	}
}



