//
//  UserListManager.swift
//  CodingChallenge
//
//  Created by Imran Kazi on 08/01/23.
//

import Foundation

class UserListManager {
    let urlSession = URLSession(configuration: .default)
    func callServiceToGetUserList(completionHandler: @escaping ([UserInfo]) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
        let dataTask = urlSession.dataTask(with: url) { data, resepnse, error in
            guard let jsonData = data else { return }
            guard let listObject: [UserInfo] = try? JSONDecoder().decode([UserInfo].self, from: jsonData) else
            {
                completionHandler([])
                return
            }
            completionHandler(listObject)
        }
        dataTask.resume()
    }
}
    
