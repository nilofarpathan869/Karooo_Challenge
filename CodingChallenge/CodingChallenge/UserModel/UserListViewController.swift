//
//  UserListViewController.swift
//  CodingChallenge
//
//  Created by Imran Kazi on 07/01/23.
//

import UIKit

protocol UserViewControllerInterface: AnyObject {
    func startAnimate()
    func stopAnimate()
}

class UserListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var userListViewModel: UserListViewModel?
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    private var userList: [UserInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userListViewModel = UserListViewModel(userListInterface: self)
        initializeUI()
        userListViewModel?.getUserList { [weak self] response in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.userList = response
                strongSelf.tableView.isHidden = false
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    private func initializeUI() {
        view.backgroundColor = UIColor.white
        tableView.isHidden = true
    }
}

// MARK :- UITableViewDelegate Methods -
extension UserListViewController: UITableViewDelegate {
    
}

// MARK :- UITableViewDataSourece Methods -
extension UserListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "userListId", for: indexPath)
        cell.textLabel?.text = userList?[indexPath.row].name
        cell.textLabel?.textAlignment = .center
       return cell
    }
}

extension UserListViewController: UserViewControllerInterface {
    func startAnimate() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
    }
    
    func stopAnimate() {
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
