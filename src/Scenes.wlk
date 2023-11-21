import wollok.game.*
import Visuals.*
import objetos.*
import selector.*

class Scene {
	
	const property width = null
	const property height = null
	const property ground = null
		
}

object inicio inherits Scene(width = 15, height = 10, ground ="/assets/entrada-cafeteria.png" ){
	
	method iniciar(){
		
		game.clear()
		game.cellSize(80)
		game.title("Juego-Mostrador")
		game.width(self.width())
		game.height(self.height())
		game.boardGround(fondoMostrador.image())
		game.addVisual(fondoInicio)
		game.addVisual(new Text())
		
		keyboard.m().onPressDo{mostrador.iniciar()}
	}
}

object mostrador inherits Scene(width = 1200, height = 800, ground = "./assets/fondo10.jpg"){
	
	var property cocinero = new Cocinero()
	var property clientes = []
	var property dificultad = 0
	var property puntuacion = 0
	
	method iniciar(){
		
		game.clear()
		game.cellSize(1)
		game.width(self.width())
		game.height(self.height())

		game.boardGround(self.ground())
		self.generarClientes()
		self.generarPuntuacion()
		
		keyboard.c().onPressDo{cocina.iniciar()}
	}
	method generarClientes() {
		if(self.pedidosEntregados()){
			new Range (start = 1, end = dificultad).forEach{a =>
				clientes.add(new Cliente ())
				clientes.get(a-1).mostrarCliente(a*100)					
			}
			self.clientesPiden()
		}
	}
	
	method clientesPiden(){
		clientes.forEach{cliente =>
			game.schedule(2000,{=>cliente.ordenarPedido()})
			cocinero.recibirPedido([cliente.pedido()])
		}
	}
	
	method generarPuntuacion(){
		
		new Range(start = 0, end = puntuacion).forEach{punto =>
			const galletitaPunto = new GalletitaPunto(position = game.at(punto*50,78))
			game.addVisual(galletitaPunto)
			console.println(punto)
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
	
	method subirPuntaje (){
		puntuacion+=1
	}
	
	method reiniciarTodo(){
		cocinero.reiniciar()
		clientes.clear()
		dificultad = 0
		puntuacion = 0
	}
}

object cocina inherits Scene(width = 15, height = 10, ground=""){

		const cosas = [cafetera, juguera, heladera]
		const comidas = ['muffin', 'torta', 'galletita']
	method iniciar(){

		game.clear()
		game.cellSize(80)
		game.width(self.width())
		game.height(self.height())
		game.addVisual(fondoCocina)
		cosas.forEach{cosa => game.addVisual(cosa)}
		self.plantillaComida()
		game.addVisual(mostrador.cocinero())
		mostrador.cocinero().configs()

		
		
		keyboard.i().onPressDo{mostrador.cocinero().agregarComida(selector.seleccionado().copy().get(0))}
		keyboard.m().onPressDo{mostrador.iniciar()}
	
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
	
	method validarContenido (pedido1,pedido2){
		var control = 0
		
		pedido1.forEach{comida1 =>
			pedido2.forEach{comida2 =>
				if(comida1.nombre() != comida2.nombre()){
					control += 1
				} 
			}
			
		}
		return control > 0
	}
	
}

object perder inherits Scene(width = 15, height = 10, ground=""){
		
	method iniciar(){

		game.clear()
		game.cellSize(80)
		game.width(self.width())
		game.height(self.height())
		game.addVisual(fondoPerder)
		
		
		keyboard.e().onPressDo{
			game.stop()
		}
		
		keyboard.r().onPressDo{
			mostrador.reiniciarTodo()
			inicio.iniciar()
		}
	}
	
}

object fondoCocina{
	const property image = './assets/cafeteria3.png'
	const property position = game.at(0,0)
	var property nombre = 'cocinaFondo'
}

object fondoInicio{
	var property image = './assets/inicio.jpg'
	const property position = game.at(0,0)
	var property nombre = 'inicioFondo'
}

object fondoMostrador{
	const property image = './assets/fondo10.jpg'
	const property position = game.at(0,0)
	var property nombre = 'mostradorFondo'
	
	
}

class Text{
	var property text = 'INICIO'
	var property position = game.center()
	var property nombre = 'text'
	var property textColor = paleta.negro()	
}

object fondoPerder{
	const property image = './assets/perder.jpg'
	const property position = game.at(-2,0)
	var property nombre = 'perderFondo'	
}

object paleta {
	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"
	const property negro = '#000000e0'
	const property blanco = '#00000000'
}


