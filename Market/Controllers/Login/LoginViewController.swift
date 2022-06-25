//
//  ViewController.swift
//  Market
//
//  Created by Erick Ayala Delgadillo on 20/05/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

import CryptoKit

class LoginViewController: UIViewController {
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?

    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setLoader()
    }

    @IBAction func btnLogin(_ sender: Any) {
        if validateForm() {
            login()
        } else {
            setMessage("Error", "¡Capture correctamente sus datos!")
        }
    }
    
    @IBAction func btnGoogle(_ sender: Any) {
        loginGoogle()
    }
    
    
    // Setup Google
    func loginGoogle(){
        loader.startAnimating()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in

          if let error = error {
              self.loader.stopAnimating()
              print(error.localizedDescription)
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }
            
            let credentials = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credentials) { authResult , error in
                
                if let error = error {
                    self.loader.stopAnimating()
                    print("hubo un error \(error.localizedDescription)")
                }
                self.loader.stopAnimating()
                guard let userPictureProfile = user?.profile?.imageURL(withDimension: 60) , let email = user?.profile?.email
                    else { return }
                
                let defaults = UserDefaults.standard
                defaults.set(userPictureProfile , forKey: "userPictureProfile")
                
                print(email)
                
                self.performSegue(withIdentifier: "goHome", sender: nil)
            }
            
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
    
    @IBAction func btnApple(_ sender: Any) {
        loginApple()
    }
    
    func loginApple(){
        print("login with apple..")
        let request = createAppleIDRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName , .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        return request
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
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
    
    //MARK: - Gradient
    private func setGradientBackground() {
        let colorTop =  UIColor(red: 140/255, green: 143/255, blue: 160/255, alpha: 0.7).cgColor
        let colorBottom = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 0.15]
        gradientLayer.frame = self.view.bounds

        let backgroundView = UIView(frame: self.view.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: .zero)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        loader.startAnimating()
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // retrieve the secure nonce generated
            guard let nonce = self.currentNonce else {
                print("Invalid state: A login callback was received, but not login request was sent")
                return
            }
            
            // Retrieve Apple Identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to decoded identity token")
                return
            }
            
            //convert apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to fetch identity token")
                return
            }
            
            //Initialize a firebase credential
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            
            Auth.auth().signIn(with: firebaseCredential) { authResult, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
            }
            self.performSegue(withIdentifier: "goHome", sender: nil)
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }

}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
}


