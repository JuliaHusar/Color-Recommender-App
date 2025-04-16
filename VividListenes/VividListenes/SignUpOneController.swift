    //
    //  SignUpOneController.swift
    //  VividListenes
    //
    //  Created by Julia Husar on 4/8/25.
    //

    import UIKit
    import FirebaseCore
    import FirebaseFirestore
    import FirebaseAuth
          

    class SignUpOneController: UIViewController {
        @IBOutlet weak var usernameField: UITextField!
        @IBOutlet weak var passwordField: UITextField!
        @IBOutlet weak var nextButton: UIButton!
        
        var username: String?
        var password: String?
        
        override func viewDidLoad() {
            super.viewDidLoad()

            if let username = username {
                usernameField.text = username
            }
            
            if let password = password {
                passwordField.text = password
            }
            
            let usernameToolbar = UIToolbar()
               usernameToolbar.sizeToFit()
               let usernameDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.usernameDoneClicked))
               usernameToolbar.items = [usernameDoneButton]
               usernameField.inputAccessoryView = usernameToolbar

               let passwordToolbar = UIToolbar()
               passwordToolbar.sizeToFit()
               let passwordDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.passwordDoneClicked))
               passwordToolbar.items = [passwordDoneButton]
               passwordField.inputAccessoryView = passwordToolbar

        }
        
        @objc func usernameDoneClicked() {
            usernameField.resignFirstResponder()
        }

        @objc func passwordDoneClicked() {
            passwordField.resignFirstResponder()
        }
        
        @IBAction func buttonTap(_ sender: Any) {
            Auth.auth().createUser(withEmail: usernameField.text!, password: passwordField.text!) { authResult, error in
                if let error = error {
                    print(error);
                    return;
                } else {
                    self.performSegue(withIdentifier: "toSignUpTwo", sender: nil);
                }
            }
            
        }
        
        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        }
        
      

    }
