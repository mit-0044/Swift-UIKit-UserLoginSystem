//
//  SignUpViewController.swift
//  UserLoginSystem
//
//  Created by Mit Patel on 02/07/24.
//

import UIKit
      
class SignUpViewController: UIViewController, URLSessionTaskDelegate {
    
    struct DataResponse: Codable {
        let message: String
    }
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(nil, forKey: "isUserLoggedIn")
        errorLabel.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let contact = contactTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let error = validateFields()
        let emailError = Utilities.isValidEmail(email)
        let contactError = Utilities.isValidContact(contact)
        let passwordError = Utilities.isValidPassword(password)
        
        if error != nil {
            showError(error!)
        }else if emailError != true{
            showError("Invalid email address.")
        }else if contactError != true{
            showError("Contact no. must be 10 digits only.")
        }else if passwordError != true{
            showError("Password contains must be 8 Characters.")
        }else{
            self.errorLabel.alpha = 0
            guard let url = URL(string: "http://127.0.0.1:8000/api/sign_up") else {
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            let postString = "name=\(name)&email=\(email)&contact=\(contact)&password=\(password)"
            urlRequest.httpBody = postString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    print("error = \(error!)")
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString!)
                
                if responseString == "emailExist" {
                    DispatchQueue.main.async {                    
                        self.showError("Email already exist.")
                    }
                }else if responseString != "success" {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.set(email, forKey: "userEmail")
                        UserDefaults.standard.synchronize()
                        
                        let vc = UIStoryboard(name: "Main", bundle: nil)
                        let HomeVC = vc.instantiateViewController(identifier: "HomeVC")
                        HomeVC.modalPresentationStyle = .fullScreen
                        self.present(HomeVC, animated: false, completion: nil)
                    }
                }else {
                    DispatchQueue.main.async {
                        self.showError("Something went wrong.")
                    }
                }
            }
            task.resume()
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
    }
    
    func validateFields() -> String? {
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "All fields are required."
        }
        return nil
    }
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}

