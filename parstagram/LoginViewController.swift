//
//  LoginViewController.swift
//  parstagram
//
//  Created by Sara Kazemi on 10/23/20.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onSignin(_ sender: Any) {
        PFUser.logInWithUsername(inBackground:usernameField.text!, password:passwordField.text!) {
          (user: PFUser?, error: Error?) -> Void in
          if user != nil {
            // Do stuff after successful login.
            // go to the home screen -- perform a segue
            self.performSegue(withIdentifier: "loginSegue", sender: self)
            
          } else {
            // The login failed. Check error to see why.
            print("Error: " + error!.localizedDescription)
            self.usernameField.text = ""
            self.passwordField.text = ""
          }
        }

        
    }
    
    
    
    @IBAction func onSignup(_ sender: Any) {
        
        var user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
 

        user.signUpInBackground { (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                let errorString = error.localizedDescription
                print("Error: " + errorString)
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
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

}
