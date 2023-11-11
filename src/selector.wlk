import wollok.game.*
import Visuals.*

object selector {
	
	var property position = null
	var property image = null
	var property seleccionado = [];
	
	
	method configs(){
		movimiento.configurarFlechas(self)
		keyboard.enter().onPressdo{self.seleccionar()}
	}
	method seleccionar (){
		game.whenCollideDo(self,{ visual =>
			if(seleccionado.size() == 0){
				seleccionado.add(visual);
				game.removeVisual(visual);
			}else{
				game.say(self, 'Ya tenes un elemento seleccionado');
			}	
		})
		if (seleccionado.size() == 1) {
			game.addVisual(seleccionado.get(0))
			seleccionado.remove(seleccionado.get(0))
			
		} 
	}
}
