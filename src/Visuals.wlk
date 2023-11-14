import wollok.game.*
import objetos.*
import selector.*
import Scenes.*


class Cliente {
	var property image = './assets/ash_2.png'
	var property nombre = 'cliente'
	var property position = game.at(2,54)
	var property numCliente = 0.randomUpTo(1000).truncate(0)
	var property pedido = new Pedido(numeroPedido = numCliente)
	
	method mostrarCliente(num){
		
		position = game.at(position.x() + num,position.y()) 
		game.addVisual(self)
		
	}
	method ordenarPedido (){
		//hacer esto
		//hacer un game.say para que se muestre el pedido por pantalla
		pedido.generarComidaRandom(0.randomUpTo(10).truncate(0))
		pedido.generarText()
		game.say(self, pedido.text())
	}
	
	method recibirPedidoTerminado(){
		//recibe el pedido terminado, cambia el estado del pedido
		pedido.entregado()
	}
}

class Cocinero {
	
	var property image = "./assets/cocinero.jpg"
	var property position = game.at(3,5)
	var property nombre = 'cocinero'
	var property pedidos = []
	var property pedidoProceso = []
	var property pedidosTerminados = []
	var property siguientePedido = true
	var property indicePedido = 0
	
	method recibirPedido(pedido){
		pedidos.add(pedido)
	}
	
	// cocinero tiene la mecanica principal del juego
	method agregarComida(comida){
		//Generar una comunicacion entre el selector y el cocinero. El cocinero tiene que poder seleccionar las comidas necesarias para completar con un pedido
		
		if (self.existe(comida)){
			pedidoProceso.get(self.indiceComida(comida)).sumarCantidad()
		}else{
			pedidoProceso.add(comida)
		}
		
		
		selector.seleccionado().clear()
	}
	
	method existe(comida){
		var control = false
		pedidoProceso.forEach{comida1 =>
			if (comida.nombre() == comida1.nombre()){
				var control = true
			}
		}
		return control
	}
	
	method indiceComida(comida){
		
		var index = 0
		
		new Range (start = 0, end = pedidoProceso.size()-1).forEach{num =>
			if (comida.nombre() == pedidoProceso.get(num).nombre()){
						index = num
			}
		}
		return index
	}
	method hacerPedido(){
		siguientePedido = false
		game.addVisual(selector)
		if(indicePedido == 0)selector.configs()
		//pedidoProceso.add(pedidos.get(indicePedido))
	}
	
	
	method reiniciar(){
		pedidos.clear()
		pedidoProceso.clear()
		pedidosTerminados.clear()
		siguientePedido = true
		indicePedido = 0
	}
	
	
	method configs(){
		//Cuando termine un pedido hay que mostrar un msj por pnatalla
		keyboard.e().onPressDo{
			self.hacerPedido()
		}
		keyboard.t().onPressDo{
			self.pedidoTerminado()
		}
		keyboard.p().onPressDo{game.say(self, pedidoProceso.toString())}
	}
	
	
	method pedidoTerminado(){
		
		if (not(siguientePedido)){
			pedidosTerminados.add(pedidoProceso)
			pedidoProceso.clear()
			indicePedido+=1
			siguientePedido = true
			game.removeVisual(selector)
			self.entregarPedidosClientes()
			// aca usar entregarPedidosClientes
		}
	}
	
	method entregarPedidosClientes(){
		//generar una comunicacion entre cocinero y el juego para que mande todos los pedidos cuando esten terminados
		//aca usar pedidosTerminados
		//cuando los pedidos esten terminados qeu se entreguen y pasar al siguiente nivel
		if (cocina.pedidosTerminados()){
			
			self.sistemaPuntaje()
			mostrador.clientes().forEach{cliente =>
				//creo que aca tengo que poner lo de validar para los puntos
				game.schedule(3000,{=>cliente.recibirPedidoTerminado()})
				
			}
			game.say(self, 'PEDIDOS ENTREGADOS, VOLVE AL MOSTRADOR')
		}
	}
	
	method validarPedidos(){
		
		var control = true
		pedidos.forEach{pedido =>
			pedidosTerminados.forEach{pedidoTerminado =>
				if (not self.validarContenido(pedido,pedidoTerminado)){
					control = false
				}
			}
		}
		return control
	}
	
	method sistemaPuntaje(){
		if (self.validarPedidos()){
			mostrador.subirPuntaje()
			console.println(mostrador.puntuacion())
		}else{
			console.println('false')
			game.stop()
		}
	}
	
	
	method validarContenido (pedido1,pedido2){
		var control = true
		
		pedido1.comida().forEach{comida1 =>
			pedido2.forEach{comida2 =>
				if(comida1.nombre() != comida2.nombre() or comida1.cantidad() != comida2.cantidad()){
					control = false
				} 
			}
			
		}
		return control
	}
}

//creo que lo voy a sacar y pongo una bind y listo
class Boton {
	var property activo = false
	const property image = null
	var property position = null
	
	
	
}

class Juego {
	
	//const cocinero = new Cocinero ()
	//var property clientes = []
	//var property dificultad = 1
	var property estado = 0
	var property pedidosTerminados = []
	var property puntuacion = 0
	const puntuacionGanadora = 100
	
	
	method generarClientes() {
		
		new Range (start = 1, end = dificultad).forEach{
			clientes.push(new Cliente ())				
		}
	}
	//diria que el main se ejecute 5 veces, una vez por nivel. Recordar manejar todo con ticks para que no se ejecute todo de una, tipo cuando aparecen los clientes, hacen los pedidos,etc
	method main(){
		
		self.generarClientes()
		self.clientesPiden()
		//cambioEscena
		cocina.iniciar()
		cocinero.hacerPedidos()
		//vuelvo a la escena principal
		// en duda de que cocinero.entregarPedidos() se llame aca o en la clase cocinero directamente
		cocinero.entregarPedidosJuego()
		self.validarPedidos()
		self.entregarPedidosTerminados()
		//self.subirDificultad()
		
	}
	
	

	method clientesPiden(){
		
		clientes.forEach{cliente => 
			cocinero.recibirPedido(cliente.pedido())
		}
	}
	
	method recibirPedidoTerminado(pedidoTerminado){
		pedidosTerminados.add(pedidoTerminado)
	}
	
	method validarPedidos(){
		//aca validaria que onda los pedidos que hizo el cocinero  y les daria una puntuacion para cuando termine el juego ver si gana o pierde basandome en esa puntuacion, o algo del estilo
	}
	
	method entregarPedidosTerminados(){
		// Les daria a los clientes el pedido y los eliminaria con ticks de por medio para que no sea tan irreal
	}
	
	method clienteRecibe(){
		//creo que voy a borrar esto		
	}
	
	
	method subirDificultad() {
		
	var control = true
		
		clientes.forEach{cliente =>
			if(cliente.pedido().estado() == 1){
				control = false
				//creo que aca borro el pedido si se entregan todos al mismo tiempo practicamente
			}
			
		}
		if (control) dificultad++
	}
	
	
	
}

class Pedido {
	
	
	var property numeroPedido = 0 //random
	var property comida = []
	var property comidaDisponible = ['muffin','torta','galletita']
	//estado = 0 = en proceso            1 = entregado
	var property estado = 0
	var property text = ""
	
	method generarText(){
		comida.forEach{c =>
			text = text + c.nombre() + " " + c.cantidad().toString() + ", "  
		}
	}
		
	method generarComidaRandom(cantidad){
		
		new Range (start = 0, end = cantidad-1).forEach{i=>
			
			if (comidaDisponible.get(0.randomUpTo(comidaDisponible.size()-1).truncate(0)) == 'muffin'){
				
				if (self.verificarComida('muffin')){
					comida.get(self.indexComida('muffin')).sumarCantidad()
				}else{
					comida.add(new Muffin())	
				}
				
			} 
			
			if (comidaDisponible.get(0.randomUpTo(comidaDisponible.size()-1).truncate(0)) == 'torta'){
				if (self.verificarComida('torta')){
					comida.get(self.indexComida('torta')).sumarCantidad()
				}else{	
				comida.add(new Torta())
				}
			}
			
			if (comidaDisponible.get(0.randomUpTo(comidaDisponible.size()-1).truncate(0)) == 'galletita'){
				if (self.verificarComida('galletita')){
					comida.get(self.indexComida('galletita')).sumarCantidad()
				}else{
				comida.add(new Galletita())
				}
			}
		}
	}
	method verificarComida(comidaNombre) {
		
		var control = false
		
		comida.forEach{c =>
			if (c.nombre() == comidaNombre){
				control = true	
			}
		}
		return control
	}
	
	method indexComida(comidaNombre){
		 var index = 0
		 
		 new Range(start = 0, end = comida.size()-1).forEach{i =>
		 	if (comida.get(i).nombre() == comidaNombre){
		 		index = i
		 	}
		 }
		 return index
	}
	
	method entregado() {
		estado = 1
	}
}


object movimiento {
	
	method configurarFlechas(visual){
		keyboard.up().onPressDo{ self.mover(arriba,visual)}
		keyboard.down().onPressDo{ self.mover(abajo,visual)}
		keyboard.left().onPressDo{ self.mover(izquierda,visual)}
		keyboard.right().onPressDo{ self.mover(derecha,visual)}
   }
	
	method mover(direccion,personaje){
		personaje.position(direccion.siguiente(personaje.position()))
	}	
	
	method moverClienteMostrador(positionFinal, personaje){
		
		new Range( start = 0, end = personaje.distance(positionFinal).x()).forEach{value =>
			self.mover(izquierda , personaje)
		}	
	}
	
	
}
object izquierda { 
	method siguiente(position) = position.left(1) 
	method opuesto() = derecha
}

object derecha { 
	method siguiente(position) = position.right(1) 
	method opuesto() = izquierda
}

object abajo { 
	method siguiente(position) = position.down(1) 
	method opuesto() = arriba
}

object arriba { 
	method siguiente(position) = position.up(1) 
	method opuesto() = abajo
}


