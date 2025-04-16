//
//  DetailViewController.swift
//  VividListenes
//
//  Created by Julia Husar on 4/16/25.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var colorString: UILabel!
    
    var receivedColorString: String?
    var receivedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorString.text = "Dominant Colors: [0.11111111111111116, .26530612244897955, 0.5764705882352941]"
                if let image = receivedImage {
                    print("Received image: \(image)")
                }

        // Do any additional setup after loading the view.
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
