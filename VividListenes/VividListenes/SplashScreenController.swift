//
//  SplashScreenController.swift
//  VividListenes
//
//  Created by Julia Husar on 4/8/25.
//

import UIKit

class SplashScreenController: UIViewController {

    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonStroke(selectedButton: signUp)
        

        // Do any additional setup after loading the view.
    }
    
    func configureButtonStroke(selectedButton: UIButton) {
            // Set the border width (thickness of the stroke)
        selectedButton.layer.borderWidth = 2.0 // Adjust the value as needed

            selectedButton.layer.borderColor = UIColor.black.cgColor

            selectedButton.layer.masksToBounds = true
            selectedButton.layer.cornerRadius = 8.0 // If you have a corner radius
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
