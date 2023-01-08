//
//  ViewController.swift
//  CodingChallenge
//
//  Created by Imran Kazi on 06/01/23.
//

import UIKit

class LoginViewController: UIViewController {
    private var loginViewModel = LoginViewModel()
    private var countryPicker: UIPickerView?
    private var countryList: [String]?
    private var selectedCountry = ""

    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var countryPickerView: UIPickerView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var pickerHolderView: UIView!
    @IBOutlet weak var selectCountryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        addNotifications()
        pickerHolderView.isHidden = true
        errorLabel.isHidden = true
        self.title = "Login"
    }

    private func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func animateTextField(up: Bool){
        let movementDistance: CGFloat = 100
        let movementDuration: Double = 0.3
        if up, self.view.frame.origin.y < 0 { return }
        let movement: CGFloat = (up ? -movementDistance : movementDistance)
        UIView.animate(withDuration: movementDuration) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.view.frame = strongSelf.view.frame.offsetBy(dx: 0, dy: movement)
        }
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        animateTextField(up: true)
     }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        animateTextField(up: false)
    }
    
    @IBAction func selectCountryTapped(_ sender: Any) {
        pickerHolderView.isHidden = false
        view.bringSubviewToFront(pickerHolderView)
        if countryList != nil {
            countryPickerView.reloadAllComponents()
        } else {
            loginViewModel.fetchCountryList { [weak self] list in
                guard let strongSelf = self else { return }
                countryList = list
                strongSelf.countryPickerView.reloadAllComponents()
            }
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        pickerHolderView.isHidden = true
        pickerHolderView.sendSubviewToBack(view)
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginViewModel.validateData(username: usernameTextField.text ?? "",
                                    password: passwordTextField.text ?? "",
                                    selectedCountry: selectedCountry) { [weak self] result in
            guard let strongSelf = self else { return }
            errorLabel.isHidden = result.isLoginSuccessful
            if result.isLoginSuccessful {
                guard let userListVC = storyboard?.instantiateViewController(withIdentifier: "UserListScreenID") as? UserListViewController else { return }
                strongSelf.navigationController?.pushViewController(userListVC, animated: true)
            } else {
                errorLabel.text = result.loginError?.getLoginErrorDescription()
            }
        }
    }
}

// MARK :- UITextField Delegate Methods -
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK :- UIPickerViewDelegate Methods -
extension LoginViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCountryButton.setTitle(countryList?[row], for: .normal)
        selectedCountry = countryList?[row] ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        countryList?[row]
    }
}

// MARK :- UIPickerViewDataSource Methods -
extension LoginViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList?.count ?? 0
    }
}
