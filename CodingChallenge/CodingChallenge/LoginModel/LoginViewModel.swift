//
//  LoginViewModel.swift
//  CodingChallenge
//
//  Created by Imran Kazi on 06/01/23.
//

import Foundation

enum LoginError {
    case usernameNotEntered
    case passwordNotEntered
    case credentialsNotCorrect
    case countryNotSelected
    case dataNotEnterd
    case incorrectPassword

    func getLoginErrorDescription() -> String {
        switch self {
        case .usernameNotEntered:
            return "Please enter username"
        case .passwordNotEntered:
            return "Please enter password"
        case .credentialsNotCorrect:
            return "Invalid username and password"
        case .countryNotSelected:
            return "Please select country"
        case .dataNotEnterd:
            return "Please enter correct information"
        case .incorrectPassword:
            return "You have entered wrong username or password"
        }
    }
}

struct LoginResult {
    var isLoginSuccessful: Bool = false
    var loginError: LoginError?
}

class LoginViewModel {
    var countryList: [String] = []
    var loginResult = LoginResult()
    private let loginManager = LoginManager.sharedManager
    
    func fetchCountryList(completionHandler: ([String]) -> Void) {
        let regions = Locale.isoRegionCodes
        let languageCode = Locale.isoLanguageCodes
        for (index, region) in regions.enumerated() {
            let locale = Locale(identifier: languageCode[index])
            let name = locale.localizedString(forRegionCode: region)
            countryList.append(name ?? "")
        }
        completionHandler(countryList)
    }
    
    func validateData(username: String,
                      password: String,
                      selectedCountry: String,
                      completionHandler: (LoginResult) -> Void) {
        if username == "", password == "", selectedCountry == "" {
            loginResult = LoginResult(isLoginSuccessful: false, loginError: .dataNotEnterd)
        } else if username == "", password == "" {
            loginResult = LoginResult(isLoginSuccessful: false, loginError: .credentialsNotCorrect)
        } else if username == "" {
            loginResult = LoginResult(isLoginSuccessful: false, loginError: .usernameNotEntered)
        } else if password == "" {
            loginResult = LoginResult(isLoginSuccessful: false, loginError: .passwordNotEntered)
        } else if selectedCountry == "" {
            loginResult = LoginResult(isLoginSuccessful: false, loginError: .countryNotSelected)
        } else {
            let storedPassword = loginManager.getPasswordOfUsername(username: username)
            if password == storedPassword {
                loginResult = LoginResult(isLoginSuccessful: true)
            } else {
                loginResult = LoginResult(isLoginSuccessful: false, loginError: .incorrectPassword)
            }
        }
        completionHandler(loginResult)
    }
}
