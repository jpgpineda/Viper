//
//  Interactor.swift
//  VIPER
//
//  Created by Javier Pineda Gonzalez on 19/08/22.
//

import Foundation
import RealmSwift

protocol AnyInteractor {
    var presenter: AnyPresenter? { get set }
    
    func fetchUsers()
}

class UserInteractor: AnyInteractor {
    var presenter: AnyPresenter?
    
    let realm = try! Realm()
    
    func fetchUsers() {
        let usersModels = realm.objects(UserModel.self)
        guard !usersModels.isEmpty else {
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data,
                      error == nil else {
                          self?.presenter?.interactorDidFetchUsers(with: .failure(FetchError.failed))
                    return
                }
                do {
                    let entities = try JSONDecoder().decode([User].self, from: data)
                    self?.saveUserData(users: entities)
                    self?.presenter?.interactorDidFetchUsers(with: .success(entities))
                } catch {
                    self?.presenter?.interactorDidFetchUsers(with: .failure(error))
                }
            }
            task.resume()
            return
        }
        let users: [User] = usersModels.compactMap { userModel in
            User(name: userModel.name)
        }
        presenter?.interactorDidFetchUsers(with: .success(users))
    }
    
    func saveUserData(users: [User]) {
        let userModels = users.compactMap { user in
            UserModel(user: user)
        }
        DispatchQueue.main.async { [weak self] in
            self?.realm.beginWrite()
            self?.realm.add(userModels)
            try! self?.realm.commitWrite()
        }
    }
}
