import wollok.game.*
import Visuals.*
import Scenes.*
import objetos.*

object selector {
	
	var property position = game.at(3,3)
	var property image = "./assets/cursor.JPG"
	var property seleccionado = [];
	
	
	method configs(){
		movimiento.configurarFlechas(self)
		keyboard.enter().onPressDo{self.seleccionar()}
		keyboard.d().onPressDo{game.say(self,seleccionado.get(0).toString())}
	}
	method seleccionar (){
		game.onCollideDo(self,{ visual =>
			if(seleccionado.size() == 0 and cocina.esComida(visual)){
				seleccionado.add(visual)
			}
			if (seleccionado.size()>0){
				game.say(self, 'Ya tenes un elemento seleccionado, confirma seleccion con la letra I o soltar el elemento seleccionando enter nuevamente');
			}	
		})
		if (seleccionado.size() == 1) {
			seleccionado.remove(seleccionado.get(0))
		} 
	}
}
