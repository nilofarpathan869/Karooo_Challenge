//
//  UserListViewModel.swift
//  CodingChallenge
//
//  Created by Imran Kazi on 08/01/23.
//

import UIKit

class UserListViewModel {
    private let userlistManager = UserListManager()
    weak var userListInterface: UserViewControllerInterface?
    
    init(userListInterface: UserViewControllerInterface) {
        self.userListInterface = userListInterface
    }
    func getUserList(completionHandler: @escaping ([UserInfo]) -> Void) {
        userListInterface?.startAnimate()
        userlistManager.callServiceToGetUserList { [weak self] userInfoList in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.userListInterface?.stopAnimate()
                completionHandler(userInfoList)
            }
        }
    }
    
    func showLoadingIndicator() {
        userListInterface?.startAnimate()
    }
    
    func hideLoadingIndicator() {
        userListInterface?.stopAnimate()
    }
}
