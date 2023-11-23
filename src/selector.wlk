import wollok.game.*
import Visuals.*
import Scenes.*
import objetos.*

object selector {
	
	var property position = game.at(3,3)
	var property image = "./assets/cursor.JPG"
//	var property seleccionado = [];
	var property nombre = 'selector'
	var property num = 1
	
	method configs(){
		movimiento.configurarFlechas(self)
		keyboard.enter().onPressDo{self.seleccionar()}
	}
	
	method seleccionar (){
		
		game.getObjectsIn(position).forEach{visual =>
			if(cocina.esComida(visual)){
			
				mostrador.cocinero().agregarComida(visual)
			}
			if (cocina.esBoton(visual)){
				cocina.cambiarEncendidoApagado(visual)	
			}
			
			if (visual.nombre() == 'cliente'){
				visual.recibirPedidoTerminado(mostrador.cocinero().pedidoProceso().copy())
			}
		}
	}
	
	method configs2(){
		self.configurarFlechas4(self)
		keyboard.enter().onPressDo{self.seleccionar()}
	}
	
	method configurarFlechas3(visual){
		keyboard.left().onPressDo{self.moveraCliente('izquierda',visual)}
		keyboard.right().onPressDo{self.moveraCliente('derecha',visual)}
	}
	
	method configurarFlechas4(visual){
		keyboard.left().onPressDo{ console.println('hola')
			position.left(100)
		}
		keyboard.right().onPressDo{
			
			position = game.at(position.x()+100,position.y())
			console.println('derecha')
			console.println(visual.position())
			console.println(position)
		}
	}
	method moveraCliente(direccion,visual){
		
			var distance = []
			
			game.allVisuals().forEach{obj =>
				if (obj.nombre() == 'cliente' and position != obj.position() ){
					distance.add(position.distance(obj.position()))
				}
			}				
		if (direccion == 'izquierda'){
			game.allVisuals().forEach{obj =>
				if (obj.nombre() == 'cliente' and position != obj.position() and distance.min() < position.distance(obj.position()) ){
					position = obj.position()
				}
			}
		}
		
		if (direccion == 'derecha'){
			game.allVisuals().forEach{obj =>
				if (obj.nombre() == 'cliente' and position != obj.position() and distance.min() > position.distance(obj.position()) ){
					position = obj.position()
				}
				
			}			
		}				
		
	}
}

