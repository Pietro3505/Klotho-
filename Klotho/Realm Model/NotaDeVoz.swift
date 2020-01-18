import RealmSwift
import Realm
import Foundation

class NotasDeVoz: Object {
    @objc dynamic var nombre : String?
    @objc dynamic var camino : Int = 0
}
