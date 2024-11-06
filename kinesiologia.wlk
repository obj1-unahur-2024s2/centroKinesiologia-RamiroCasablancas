class Paciente{
 var edad
 var fortaleza
 var dolor 
 const rutina = []

   method edad() = edad
   method fortaleza() = fortaleza
   method dolor() = dolor
   method cumplirAnios() { edad += 1}
   method cargarRutina(unaLista) {
     rutina.clear()
     rutina.addAll(unaLista)
   } 
   method disminuirDolor(unValor) {
    dolor -= unValor
   }
   method aumentarFortaleza(unValor) {
     fortaleza += unValor
   }
   method puedeUsar(unAparato) = unAparato.puedeSerUsadoPor(self) 
   method usar(unAparato) {
     if (self.puedeUsar(unAparato))
        unAparato.consecuenciasDeUso(self)
   }
   method puedeHacerRutina() = 
        rutina.all{a=>self.puedeUsar(a)}
   
   method realizarRutina() {
     rutina.forEach({a=>self.usar(a)})
   }
   
}
class Resistente inherits Paciente{
    override method realizarRutina(){
        const cantidad = rutina.count{a=>self.puedeUsar(a)}
        super()
        self.aumentarFortaleza(cantidad)
    }
}
class Caprichoso inherits Paciente{
    override method puedeHacerRutina(){
        return self.hayAlgunAparatoRojo()
            and super()
    }
    method hayAlgunAparatoRojo(){
        return rutina.any({a=>a.color() == "Rojo"})
    }
    override method realizarRutina(){
        super()
        super()
    }
}

class RapidaRecuperacion inherits Paciente{
    override method realizarRutina() {
        super()
        self.disminuirDolor(disminucionDolor.valor())
    }
}
object disminucionDolor {
  var property valor = 3 
}

class Aparato{
    var property color = "Blanco" 
    method consecuenciasDeUso(unPaciente)
    method puedeSerUsadoPor(unPaciente)
    method recibirMantenimiento(){}
    method necesitaMantenimiento() = false
}

class Magneto inherits Aparato{
    var imantacion = 800
    override method consecuenciasDeUso(unPaciente){
        unPaciente.disminuirDolor(unPaciente.dolor() * 0.1)
        imantacion -=1
    }
    override method puedeSerUsadoPor(unPaciente){
        return true
    }
    override method recibirMantenimiento(){
        imantacion = (imantacion+500).min(800)
    }
    override method necesitaMantenimiento() = imantacion < 100
}

class Bicicleta inherits Aparato{
    var tornillos = 0
    var aceite = 0
    override method consecuenciasDeUso(unPaciente){
        if(unPaciente.dolor()>= 30){//ponerlo en un metodo
            tornillos += 1
            if(unPaciente.edad().between(30, 50))
                aceite += 1
        }
        unPaciente.disminuirDolor(4)
        unPaciente.aumentarFortaleza(3)
    }
    override method puedeSerUsadoPor(unPaciente){
        return unPaciente.edad()>8
    }
    override method recibirMantenimiento(){}
    override method necesitaMantenimiento() = 
    tornillos >= 10 or aceite >= 5

}

class Minitramp inherits Aparato{
    override method consecuenciasDeUso(unPaciente){
        unPaciente.aumentarFortaleza(unPaciente.edad() * 0.1)
    }
    override method puedeSerUsadoPor(unPaciente){
        return unPaciente.dolor()<20
    }
    override method recibirMantenimiento(){

    }
}

object centroKinesiologia {
  const aparatos =[]
  const pacientes =[]
    method cargarAparatos(unaLista) {
     aparatos.addAll(unaLista)
   } 
   method cargarPacientes(unaLista) {
     pacientes.addAll(unaLista)
   } 
  method coloresAparatos() =
     aparatos.map({a=>a.color()}).asSet()
  
  method pacientesMenoresA(unValor) =
     pacientes.filter({a=>a.edad()>unValor})
  method pacientesIncumpliendo() =
     pacientes.count({p=> not p.puedeHacerRutina()})
  
  method estaEnCondicionesOptimas() = aparatos.all{a=>not a.necesitaMantenimiento()}
  method estaComplicado() = 
    self.cantNecesitaMantenimiento() >= aparatos.size().div(2)

  method cantNecesitaMantenimiento() {
    return aparatos.count{a=>a.necesitaMantenimiento()}
  }


}
