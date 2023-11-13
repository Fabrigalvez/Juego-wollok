import wollok.game.*
import objetos.*
import selector.*
import Scenes.*


class Cliente {
	var property image = './assets/juanCliente.jpg'
	var property nombre = 'cliente'
	var property position = game.at(2,3)
	var property numCliente = 0.randomUpTo(1000).truncate(0)
	var property pedido = new Pedido(numeroPedido = numCliente)

	
	method mostrarCliente(num){
		position = game.at(position.x() + num,position.y()) 
		game.addVisual(self)
	}
	method ordenarPedido (){
		// creo que la voy a eliminar o hacer un game.say para que se muestre el pedido por pantalla
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
		pedidoProceso.add(comida)
		selector.seleccionado().clear()
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
			mostrador.clientes().forEach{cliente =>
				//creo que aca tengo que poner lo de validar para los puntos
				game.schedule(3000,{=>cliente.recibirPedidoTerminado()})
		
			}
			game.say(self, 'PEDIDOS ENTREGADOS, VOLVE AL MOSTRADOR')
		}
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
	//estado = 0 = en proceso            1 = entregado
	var property estado = 0
	
	//puede que lo borre
	method generarComida(cantidades , comidas){
		
		cantidades.forEach{cantidad =>
			if (comidas.get(cantidad) == 'muffin'){
				comida.push(new Muffin())
			} 
			
			if (comidas.get(cantidad) == 'torta'){
				comida.push(new Torta())
			}
			
			if (comidas.get(cantidad) == 'galletita'){
				comida.push(new Galletita())
			}
				
		}
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


