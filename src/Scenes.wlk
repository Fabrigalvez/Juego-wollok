import wollok.game.*
import Visuals.*
import objetos.*
import selector.*
//falta sistema de puntuacion, que el juego termine en algun punto y estetica a full, corregir posibles errores

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
		
		keyboard.m().onPressDo{mostrador.iniciar()}
	}
}

//sacar
object mostrador inherits Scene(width = 15, height = 10, ground = "./assets/cafeteria.gif"){
	
	var property cocinero = new Cocinero()
	var property clientes = []
	var property dificultad = 0
	
	method iniciar(){
		game.clear()
		game.width(self.width())
		game.height(self.height())
		game.boardGround(self.ground())
		self.generarClientes()
		game.schedule(5000, {=>game.say(clientes.get(0), 'PEDIDOS REALIZADOS, PRESIONE C PARA COCINAR')})
		
		
		
		keyboard.c().onPressDo{cocina.iniciar()}
	}
	method generarClientes() {
		if(self.pedidosEntregados()){
			new Range (start = 1, end = dificultad).forEach{a =>
				clientes.add(new Cliente ())
				clientes.get(a-1).mostrarCliente(a*2)
								
			}
			self.clientesPiden()
		}
	}
	
	method clientesPiden(){
		
		clientes.forEach{cliente => 
			cocinero.recibirPedido(cliente.pedido())
		}
	}
	
	method pedidosEntregados(){
		
		clientes.forEach{cliente => 
			if (cliente.pedido().estado() == 0){
				return false
			}
		}
		 dificultad +=1
		 clientes.clear()
		 cocinero.reiniciar()	
		return true 
	}
}

object cocina inherits Scene(width = 15, height = 10, ground=""){
	
	//recordar que puede que no se borren las configs de los objetos, hay que verificarlo igual
	//hacer todo manual tipo con binds
	//ir poco a poco, solo enfocarnos en que funcionen las pantallas de cocina y mostrador
	//si a las 4pm aprox no tengo un avance fuerte llamar a mora y romeo
	
	//falta :
		//selector :
		//cocina : mirar el flujo del programa que funque bien
		//cliente :
		//
		//sistema de puntuacion, victoria/derrota
		//vista del juego
		//funciones simples de cocina
		//probarlo y rezar
		const cosas = [cafetera, juguera, heladera]
		const comidas = ['muffin', 'torta', 'galletita']
	method iniciar(){

		game.clear()
		game.width(self.width())
		game.height(self.height())
		game.addVisual(fondoCocina)
		cosas.forEach{cosa => game.addVisual(cosa)}
		//comidas.forEach{comida => game.addVisual(comida)}
		self.plantillaComida()
		game.addVisual(mostrador.cocinero())
		//game.addVisual(selector)
		mostrador.cocinero().configs()
		//selector.configs()
		
		
		//keyboard.e().onPressDo{mostrador.cocinero().pedidoTerminado()}
		keyboard.i().onPressDo{mostrador.cocinero().agregarComida(selector.seleccionado().get(0))}
		keyboard.m().onPressDo{mostrador.iniciar()}
	
	}
	
	method comidaGenerador(){
		//hacer un metodo que me genere una plantilla de comida pero que cada vez que use el selector esa comida no se borre si no que se cree una nueva y se guarde
		//recordar mejorar el selector para que agregue la comida al pedido 
		
	}
	
	method plantillaComida(){
		game.addVisual(new Muffin())
		game.addVisual(new Torta())
		game.addVisual(new Galletita())
	}
	
	method esComida(visual){
		return (comidas.contains(visual.nombre()))
	}
	
	method pedidosTerminados(){
		return mostrador.cocinero().pedidos().size() == mostrador.cocinero().pedidosTerminados().size()
	}
	
}

object fondoCocina{
	const property image = './assets/cocina4.jpg'
	const property position = game.at(0,0)
	var property nombre = 'cocinaFondo'
}



