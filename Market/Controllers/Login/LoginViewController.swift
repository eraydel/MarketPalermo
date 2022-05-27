//
//  ViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 20/05/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoader()
    }

    @IBAction func btnLogin(_ sender: Any) {
        if validateForm() {
            login()
        } else {
            setMessage("Error", "¡Capture correctamente sus datos!")
        }
    }
    
    // login method
    func login() {
        loader.startAnimating()
        Auth.auth().signIn(withEmail: username.text!, password: password.text! ) { (user , error ) in
            if error != nil {
                DispatchQueue.main.async {
                    self.setMessage("Error de autenticación", "Usuario o password no encontrado")
                }
                self.loader.stopAnimating()
            }
            else {
                DispatchQueue.main.async {
                    //self.setMessage("Autenticación exitosa", "GoHome")
                    self.performSegue(withIdentifier: "goHome", sender: nil)
                }
            }
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        let alert = UIAlertController(title: "Crear cuenta" , message: "Por favor introduce tus datos.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.cancel, handler: nil))
        // agregar text fields a un alert
        alert.addTextField(configurationHandler: { txtEmail in
            txtEmail.placeholder = "Correo electrónico"
            txtEmail.clearButtonMode = .always
        })
        
        alert.addTextField(configurationHandler: { txtPass in
            txtPass.placeholder = "Password"
            txtPass.clearButtonMode = .always
            txtPass.isSecureTextEntry = true
        })
        
        let btnEnviar = UIAlertAction(title: "Enviar" , style: .default , handler: {action in
            
            guard let email = alert.textFields![0].text ,
            let pass  = alert.textFields![1].text
            else { return }
            self.loader.startAnimating()
            Auth.auth().createUser(withEmail: email, password: pass, completion: { auth , error in
                if error != nil {
                    self.setMessage("Error", "\(String(describing: error?.localizedDescription))")
                    print ("ocurrió un error \(String(describing: error))")
                    self.loader.stopAnimating()
                }
            })
            
        })
        alert.addAction(btnEnviar)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setMessage(_ title:String , _ message:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Continuar", style: UIAlertAction.Style.destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateForm() -> Bool {
        if validateEmail() && validatePassword() {
            return true
        } else {
            return false
        }
    }
    
    // validate email
    func validateEmail() -> Bool {
        if username.text != "" {
            if isValidEmailAddress(emailAddressString: username.text!) {
                return true
            }
            else {
                setMessage("Error", "Correo electrónico no válido")
                return false
            }
        } else {
            return false
        }
    }
    
    
    // es un email válido por expresión regular...
    func isValidEmailAddress(emailAddressString: String) -> Bool {
      
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          
          if results.count == 0
          {
              returnValue = false
          }
          
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      
      return  returnValue
    }
    
    // validate password
    func validatePassword() -> Bool {
        if password.text != "" {
            return true
        } else {
            setMessage("Error", "Capture password")
            return false
        }
    }
    
    func setLoader(){
        loader.style = .large
        loader.color = .red
        loader.hidesWhenStopped = true
        loader.center = self.view.center
        self.view.addSubview(loader)
    }
    
}

