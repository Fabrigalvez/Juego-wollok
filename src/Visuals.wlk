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
		pedido.generarComidaRandom(1.randomUpTo(10).truncate(0))
		pedido.generarText()
		game.addVisual(new Text(text = pedido.text(), position = position.up(170), textColor = paleta.verde() ))
	}
	
	method recibirPedidoTerminado(){
		pedido.entregado()
	}
}

class Cocinero {
	
	var property image = "./assets/cocinero1.png"
	var property position = game.at(11,4)
	var property nombre = 'cocinero'
	var property pedidos = []
	var property pedidoProceso = []
	var property pedidosTerminados = []
	var property siguientePedido = true
	var property indicePedido = 0
	
	method recibirPedido(pedido){
		pedidos.add(pedido)
	}
		
	method agregarComida(comida){
		pedidoProceso.get(0).agregarComida(comida)
		pedidoProceso.get(0).generarText2()
		selector.seleccionado().clear()
	}
	
	method existe(comida){
		var control = false
		pedidoProceso.forEach{comida1 =>
			if (comida.nombre() == comida1.nombre()){
				control = true
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
		
	if(siguientePedido){
		pedidoProceso = [new Pedido()]
		siguientePedido = false
		game.addVisual(selector)
		if(indicePedido == 0)selector.configs()
	}}
	
	
	method reiniciar(){
		pedidos.clear()
		pedidoProceso.clear()
		pedidosTerminados.clear()
		siguientePedido = true
		indicePedido = 0
	}
	
	
	method configs(){

		keyboard.e().onPressDo{
			self.hacerPedido()
		}
		keyboard.t().onPressDo{
			self.pedidoTerminado()
		}
		keyboard.p().onPressDo{game.say(self, pedidoProceso.get(0).text())}
	}
	

	method pedidoTerminado(){
		
		if (not(siguientePedido)){
			
			pedidosTerminados.add(pedidoProceso.copy())
			pedidoProceso.clear()
			indicePedido+=1
			siguientePedido = true
			game.removeVisual(selector)
			self.entregarPedidosClientes()
		}
	}
	
	method entregarPedidosClientes(){

		if (cocina.pedidosTerminados()){
			
			self.sistemaPuntaje()
			mostrador.clientes().forEach{cliente =>
				game.schedule(3000,{=>cliente.recibirPedidoTerminado()})
				
			}
			game.say(self, 'PEDIDOS ENTREGADOS, VOLVE AL MOSTRADOR')
		}
	}
	
	method validarPedidos(){
		
		var control = true
		pedidos.forEach{pedido =>
			pedidosTerminados.forEach{pedidoTerminado =>

				if (self.validarContenido(pedido,pedidoTerminado)){
					control = false
				}
			}
		}
		return control
	}
	
	method sistemaPuntaje(){
		if (self.validarPedidos()){
			mostrador.subirPuntaje()
		}else{
			perder.iniciar()
		}
	}
	
	
	method validarContenido (pedido1,pedido2){
		var control = true
		pedido1.forEach{comida1 =>
			pedido2.forEach{comida2 =>
				console.println(comida1)
				console.println(comida2)
				if(self.listaComidasIguales(comida1.comida(),comida2.comida())){
					control = false
				} 
			}
			
		}
		return control
	}
	
	method listaComidasIguales(lista1, lista2){
		
		var control = true
		
		if (lista1.size() == 0 or lista2.size() == 0){
			control = false	
		}
		
		lista1.forEach{comida1=>
			
			if(not lista2.any{comida2 => comida2.nombre() == comida1.nombre() and comida2.cantidad() == comida1.cantidad()}){
				control = false
			}
		}
		
		lista2.forEach{comida2 =>
			if ( not lista1.any{comida1 => comida1.nombre() == comida2.nombre() and comida1.cantidad() == comida2.cantidad()}){
				control = false
			}
		}
		
		return control
	}
}

class Pedido {
	
	
	var property numeroPedido = 0 
	var property comida = []
	var property comidaDisponible = ['muffin','torta','galletita']
	var property estado = 0
	var property text = ""
	
	method generarText(){
		comida.forEach{c =>
			text = text + c.nombre() + " " + c.cantidad().toString() + ", "  
		}
	}
	
	method generarText2(){
		text = ""
		comida.forEach{c =>
			text = text + c.nombre() + " " + c.cantidad().toString() + ", " 
		}
	}
	
	method agregarComida(comida1){
		if (self.verificarComida(comida1.nombre())){
			comida.get(self.indexComida(comida1.nombre())).sumarCantidad()
		}else{
			comida.add(comida1)
		}
	}
		
	method generarComidaRandom(cantidad){
		
		new Range (start = 0, end = cantidad-1).forEach{i=>
			
			if (comidaDisponible.get(0.randomUpTo(comidaDisponible.size()).truncate(0)) == 'muffin'){
				
				if (self.verificarComida('muffin')){
					comida.get(self.indexComida('muffin')).sumarCantidad()
				}else{
					comida.add(new Muffin())	
				}
				
			} 
			
			if (comidaDisponible.get(0.randomUpTo(comidaDisponible.size()).truncate(0)) == 'torta'){
				if (self.verificarComida('torta')){
					comida.get(self.indexComida('torta')).sumarCantidad()
				}else{	
				comida.add(new Torta())
				}
			}
			
			if (comidaDisponible.get(0.randomUpTo(comidaDisponible.size()).truncate(0)) == 'galletita'){
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


