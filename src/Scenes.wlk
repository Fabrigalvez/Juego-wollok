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
		game.boardGround("./assets/fondo10.jpg")
		game.addVisual(new Fondo (
	image = './assets/inicio1.jpg',
	position = game.at(0,0),
	nombre = 'inicioFondo'
))
		self.boton1()
		game.addVisual(selector)
		selector.position(game.at(5,5))
		selector.configs()
		
	}
	
	method boton1(){
		new Range(start = 1,end = 3).forEach{num =>
			game.addVisual(new Boton1(nombre = 'jugar', position = game.at(5+num,4)))
			game.addVisual(new Boton1(nombre = 'jugar', position = game.at(5+num,5)))
		}

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
	

	method generarClientes(){
		self.pasarNivel()
		new Range (start = 0, end = clientes.size()-1).forEach{a =>
			clientes.get(a).mostrarCliente(a*100)					
		}
		game.addVisual(selector)
		selector.configs2()
		selector.position(clientes.get(0).position()) 				
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
		}
	}
	
	method pedidosEntregados(){
		
		var control = 0
		clientes.forEach{cliente => 
			if (cliente.pedido().estado() == 1){
				control+=1
			}
		}	
		return control == clientes.size() or dificultad == 0
	}
	
	method pasarNivel(){
		
		if(self.pedidosEntregados()){
		 	dificultad +=1
		 	clientes.clear()
		 	cocinero.reiniciar()
		 new Range (start = 1, end = dificultad ).forEach{a =>
				clientes.add(new Cliente())					
			}
			self.clientesPiden()			
		}
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
	//var property tiempo = 60
	const comidas = ['muffin', 'torta', 'galletita','cafe','jugo']
	var property encendido = new Boton(nombre = 'encendido', position = game.at(5,5), image = './assets/encendido.png')
	var property apagado = new Boton(nombre = 'apagado', position = game.at(5,5) , image = './assets/apagado.png')
	
	//method text() = tiempo
		
	method iniciar(){

		game.clear()
		game.cellSize(80)
		game.width(self.width())
		game.height(self.height())
		game.addVisual(new Fondo(
 image = './assets/cafeteria3.png',
	 position = game.at(0,0),
nombre = 'cocinaFondo'
))
		game.addVisual(mostrador.cocinero())
		mostrador.cocinero().configs()
		game.addVisual(selector)
		selector.configs()
		selector.position(game.center())
		game.addVisual(apagado)
		//game.onTick(1000, "pasar tiempo", tiempo -= 1)
		
			
		keyboard.m().onPressDo{mostrador.iniciar()}		
	}
	
	method cambiarEncendidoApagado(visual){
		
		if (visual.nombre() == 'encendido'){
			game.removeVisual(encendido)
			game.addVisual(apagado)
			self.plantillaComida(false)
			mostrador.cocinero().pedidoTerminado()
		}
		
		if (visual.nombre() == 'apagado'){
			game.removeVisual(apagado)
			game.addVisual(encendido)
			mostrador.cocinero().hacerPedido()
			self.plantillaComida(true)
		}
	}
	
	
	method plantillaComida(bool){
		
		if (bool){
			game.addVisual(new Muffin())
			game.addVisual(new Torta())
			game.addVisual(new Galletita())
			game.addVisual(new Cafe())
			game.addVisual(new Jugo())			
		}else{
			game.allVisuals().forEach{visual=>	
				if (comidas.contains(visual.nombre())) game.removeVisual(visual)
			}	
		}
		
	}
	
	method esComida(visual){
		return (comidas.contains(visual.nombre()))
	}
	
	method pedidosTerminados(){
		return mostrador.cocinero().pedidos().size() == mostrador.cocinero().pedidosTerminados().size()
	}
	
	method esBoton(visual){
		return ['encendido','apagado','jugar'].contains(visual.nombre())
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

class Fondo{
	var property image
	var property position
	var property nombre
}

/* 
new Fondo(
 image = './assets/cafeteria3.png',
	 position = game.at(0,0),
nombre = 'cocinaFondo'
)

new Fondo (
	image = './assets/inicio1.jpg',
	position = game.at(0,0),
	nombre = 'inicioFondo'
)

new Fondo(
	image = './assets/fondo10.jpg',
	position = game.at(0,0),
	nombre = 'mostradorFondo'
	
	
)
*/
class Text{
	var property text = 'INICIO'
	var property position = 0
	var property nombre = 'text'
	var property textColor = paleta.negro()	
}

object fondoPerder{
	const property image = './assets/perder1.jpg'
	const property position = game.at(-2,0)
	var property nombre = 'perderFondo'	
}

object paleta {
	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"
	const property negro = '#000000e0'
	const property blanco = '#00000000'
}


