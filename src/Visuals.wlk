import wollok.game.*
import objetos.*
import selector.*


class Cliente {
	var property image = null
	var property position = game.origin()
	var property pedido = new Pedido(numeroPedido = numCliente)
	var property numCliente = 0.randomUpTo(1000).truncate(0)
	
	
	method ordenarPedido (){
		
	}
}

class Cocinero {
	
	var property image = null
	var property position = null
	var property pedidos = []
	var property pedidoProceso = []
	
	method recibirPedidos(pedido){
		pedidos.add(pedido)
	}
	
	method hacerPedidos(){
		//el selector tiene que seleccionar las comidas que necesita para un pedidoz
	}
}

class Juego {
	
	const cocinero = new Cocinero ()
	var property clientes = []
	var property dificultad = 1
	var property estado = 0
	
	
	method generarClientes() {
		
		new Range (start = 1, end = dificultad).forEach{
			clientes.push(new Cliente ())				
		}
	}
	
	method main(){
		
		self.generarClientes()
		self.clientesPiden()
		//cambioEscena
		selector.configs()
		cocinero.hacerPedidos()
		//vuelvo a la escena principal
		cocinero.entregarPedidos()
		self.validarPedidos()
		
		
		
	}
	
	method validarPedidos(){
		
	}
	method clientesPiden(){
		
		clientes.forEach{cliente => 
			cocinero.recibirPedido(cliente.pedido())
		}
	}
	
	method clienteRecibe(){
			
	}
	
	
	
	method subirDificultad() {
		
	var control = true
		
		clientes.forEach{cliente =>
			if(cliente.pedido().estado() == 1){
				control = false
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


