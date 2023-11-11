import wollok.game.*
import objetos.*
import selector.*


class Cliente {
	var property image = null
	var property position = game.origin()
	var property numCliente = 0.randomUpTo(1000).truncsate(0)
	var property pedido = new Pedido(numeroPedido = numCliente)

	
	
	method ordenarPedido (){
		// creo que la voy a eliminar o hacer un game.say para que se muestre el pedido por pantalla
	}
	
	method recibirPedidoTerminado(){
		//recibe el pedido terminado, cambia el estado del pedido	
	}
}

class Cocinero {
	
	var property image = null
	var property position = null
	var property pedidos = []
	var property pedidoProceso = []
	var property siguientePedido = true
	
	method recibirPedidos(pedido){
		pedidos.add(pedido)
	}
	
	// cocinero tiene la mecanica principal del juego
	method hacerPedido(){
		//Generar una comunicacion entre el selector y el cocinero. El cocinero tiene que poder seleccionar las comidas necesarias para completar con un pedido
	}
	
	method hacerPedidos(){
		//tendria que evaluar la posibilidad de usar un tick de 5 minutos aprox para que en ese tiempo el cocinero pueda hacer un pedido y pase con el siguiente. Cuando termine un pedido hay que mostrar un msj por pnatalla
	}
	
	method entregarPedidosJuego(){
		//generar una comunicacion entre cocinero y el juego para que mande todos los pedidos cuando esten terminados
	}
}

class Juego {
	
	const cocinero = new Cocinero ()
	var property clientes = []
	var property dificultad = 1
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
		selector.configs()
		cocinero.hacerPedidos()
		//vuelvo a la escena principal
		// en duda de que cocinero.entregarPedidos() se llame aca o en la clase cocinero directamente
		cocinero.entregarPedidosJuego()
		self.validarPedidos()
		self.entregarPedidosTerminados()
		self.subirDificultad()
		
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
		//aca validaria que onda los pedidos que hizo el cocinero y les daria una puntuacion para cuando termine el juego ver si gana o pierde basandome en esa puntuacion, o algo del estilo
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


