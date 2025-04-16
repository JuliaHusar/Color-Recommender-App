//
//  LastFMModalViewController.swift
//  VividListenes
//
//  Created by Julia Husar on 4/15/25.
//

import UIKit

class LastFMModalViewController: UIViewController {
    @IBOutlet weak var lastFMUsername: UITextField!
    
    let apiKey = "8aabfe01bd0862d780e5d4a9aee1b900"
    let sharedSecret = "f9c0dff46a2e4f42c4c60f2e20755b04"
    var usernameField: String?
    let defaults = UserDefaults.standard
    weak var delegate: LastFMModalDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let usernameField = usernameField {
            lastFMUsername.text = usernameField
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func enterButton(_ sender: Any) {
        Task { @MainActor in
            if let username = lastFMUsername.text {
                let usernameIsValid = await checkUsername(inputUsername: username)
                delegate?.lastFMModalDidDismiss(with: username)
                dismiss(animated: true) {
                    NotificationCenter.default.post(name: NSNotification.Name("lastFMUsername"), object: username)
                }
            }
        }
    }
    
    //Finish this func if time permits
    private func checkUsername(inputUsername: String) async -> Bool {
        guard let url = URL(string: "https://ws.audioscrobbler.com/2.0/?method=user.getinfo&api_key=\(apiKey)&user=\(inputUsername)&format=json") else { return false }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
        }
        //if true
        defaults.set(inputUsername, forKey: "lastFMUsername")
        return true;
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

protocol LastFMModalDelegate: AnyObject {
    func lastFMModalDidDismiss(with username: String?)
}
