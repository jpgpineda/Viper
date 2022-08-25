//
//  View.swift
//  VIPER
//
//  Created by Javier Pineda Gonzalez on 19/08/22.
//

import UIKit

protocol AnyView {
    var presenter: AnyPresenter? { get set }
    
    func updateList(with users: [User])
    func showError(message: String)
}

class UserViewController: UIViewController, AnyView {
    var presenter: AnyPresenter?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    var users: [User] = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemOrange
        view.addSubview(tableView)
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func updateList(with users: [User]) {
        DispatchQueue.main.async { [weak self] in
            self?.users = users
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.users = []
            self?.tableView.isHidden = true
            self?.showErrorAlert(with: message)
        }
    }
    
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "Precaucion!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension UserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var listConfiguration = UIListContentConfiguration.cell()
        listConfiguration.text = users[indexPath.row].name
        cell.contentConfiguration = listConfiguration
        return cell
    }
}
