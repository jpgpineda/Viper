//
//  Presenter.swift
//  VIPER
//
//  Created by Javier Pineda Gonzalez on 19/08/22.
//

import Foundation

protocol AnyPresenter {
    var router: AnyRouter? { get set }
    var view: AnyView? { get set }
    var interactor: AnyInteractor? { get set }
    
    func interactorDidFetchUsers(with result: Result<[User], Error>)
}

class UserPresenter: AnyPresenter {
    var router: AnyRouter?
    
    var view: AnyView?
    
    var interactor: AnyInteractor? {
        didSet {
            interactor?.fetchUsers()
        }
    }
    
    func interactorDidFetchUsers(with result: Result<[User], Error>) {
        switch result {
        case .success(let users):
            view?.updateList(with: users)
        case .failure(let error):
            view?.showError(message: error.localizedDescription)
        }
    }
}
