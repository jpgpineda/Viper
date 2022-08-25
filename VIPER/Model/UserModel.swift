//
//  UserModel.swift
//  VIPER
//
//  Created by Javier Pineda Gonzalez on 24/08/22.
//

import RealmSwift

class UserModel: Object {
    @objc dynamic var name: String = ""
    
    convenience init(user: User) {
        self.init()
        name = user.name
    }
}
