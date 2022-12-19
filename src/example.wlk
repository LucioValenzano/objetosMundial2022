
object fifa {
	var sedesPosibles = []
	var selecciones = []
	
	method agregarSeleccion(sele){
		selecciones.add(sele)
	}
	method agregarSede(sede){
		sedesPosibles.add(sede)
	}
	method sedeMundial() = sedesPosibles.max({sede => sede.dineroPagado()})
	
	method posiblesCampeones() = self.sedeMundial().posiblesCampeones(selecciones)
	
	method elegirCampeon(){
		const campeon = self.posiblesCampeones().max({sele => sele.golesMetidos()})
		campeon.ganarMundial()
		return campeon
	}
}

class Sede {
	const caracProhibidas = []
	const pbi
	var property criterio = neutro
	var guerras = []
	
	method dineroPagado() = (pbi * 0.65).min(pbi/2)
	
	method posiblesCampeones(selecciones) = criterio.posiblesCampeones(selecciones,self)
	
	method contieneAlgunaCarac(seleccion) = seleccion.caracteristicas().any({carac => caracProhibidas.contains(carac)})
	
	method hayConflicto(pais) = self.huboGuerraEntre(self,pais)
	
	method huboGuerraEntre(pais,otroPais) = guerras.any({guerra => guerra.bandosDiferentes(pais,otroPais)})
}


object noEstaPermitido {
	method posiblesCampeones(selecciones,sede) = selecciones.filter({sele =>not sede.contieneAlgunaCarac(sele)})
}

class GanoMundiales {
	const cantMundiales
	
	method posiblesCampeones(selecciones,sede) = selecciones.filter({sele => self.cumpleConLosMundiales(sele)})
	
	method cumpleConLosMundiales(seleccion) = seleccion.mundialesGanados() > cantMundiales
}

object politico {
	method posiblesCampeones(selecciones,sede) = selecciones.filter({sele => sede.hayConflicto(sele.paisQueRepresenta())})
}

object neutro {
	method posiblesCampeones(selecciones,sede) = selecciones.take(5)
}

class Guerra {
	var bando1 = []
	var bando2 = []
	
	method bandosDiferentes(pais,otroPais) = 
		(bando1.contains(pais) && bando2.contains(otroPais)) || (bando1.contains(otroPais) && bando2.contains(pais))
}

class Seleccion {
	const property paisQueRepresenta
	const property caracteristicas = []
	var property mundialesGanados
	var property golesMetidos = 0
	
	method sumarGolesDePartido(cant){
		golesMetidos += cant
	}
	method ganarMundial(){
		mundialesGanados += 1
	}
}