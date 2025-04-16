//
//  HomeViewController.swift
//  VividListenes
//
//  Created by Julia Husar on 4/7/25.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    
    @IBOutlet weak var usernameWord: UILabel!
    @IBOutlet weak var todayImage: UIImageView!
    @IBOutlet weak var mainContentStack: UIStackView!
    @IBOutlet weak var takePictureView: UIView!
    @IBOutlet weak var heyWord: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    let defaults = UserDefaults.standard
    var albumData: [Album] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorLabels(heyLabel: heyWord, hexValue: "FF7070")
        getDate()
        loadImageFromUserDefaults()
        updateViewVisibility()
        tabBarController?.delegate = self
    }
    
    func colorLabels(heyLabel: UILabel, hexValue: String){
        heyLabel.textColor = UIColor(hexString: hexValue);
    }
    
    func getDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let currentDateString = formatter.string(from: Date())
        date.text = currentDateString
    }
    
    func getDateValue() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        let currentDateString = formatter.string(from: Date())
        return currentDateString
    }
    
    func loadImageFromUserDefaults() {
        let dateKey = getDateValue()
        if let savedImageData = UserDefaults.standard.data(forKey: dateKey),
           let retrievedImage = UIImage(data: savedImageData) {
            todayImage.image = retrievedImage
            print("Image loaded from UserDefaults for date: \(dateKey)")
            updateViewVisibility()
        } else {
            print("No saved image found for today's date: \(dateKey)")
        }
    }
    
    func updateViewVisibility() {
          takePictureView.isHidden = todayImage.image != nil
          mainContentStack.isHidden = todayImage.image == nil
      }
    
    func uploadImage(image: Data, completion: @escaping (LastFMResponse?) -> Void) async {
        guard let url = URL(string: "https://colormatcherflask.onrender.com/process-image") else { return }
        let boundary = "Boundary-\(UUID().uuidString)"
        let username = defaults.string(forKey: "lastFMUsername")

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var httpBody = Data()

        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"image\"; filename=\"captured_image.jpg\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        httpBody.append(image)
        httpBody.append("\r\n".data(using: .utf8)!)
        
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
           httpBody.append("Content-Disposition: form-data; name=\"username\"\r\n".data(using: .utf8)!)
           httpBody.append("\r\n".data(using: .utf8)!)

           if let unwrappedUsername = username {
               if let usernameData = unwrappedUsername.data(using: .utf8) {
                   httpBody.append(usernameData)
               } else {
                   print("Error: Could not convert username to Data.")
                   return
               }
           } else {
               print("Warning: Username not found in UserDefaults, using default.")
               httpBody.append("Its_Juli".data(using: .utf8)!)
           }

           httpBody.append("\r\n".data(using: .utf8)!)
           httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)

        urlRequest.httpBody = httpBody

        do {
            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: httpBody)

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if (200...299).contains(httpResponse.statusCode) {
                    do{
                        let decoder = JSONDecoder()
                        let lastFMResponse = try decoder.decode(LastFMResponse.self, from: data)
                        print("LastFM Response Object: \(lastFMResponse)")
                        completion(lastFMResponse)
                    } catch {
                        print(error)
                        completion(nil)
                    }
                } else {
                    print("Image upload failed with status code: \(httpResponse.statusCode)")
                    if let errorResponse = String(data: data, encoding: .utf8) {
                        print("Error Response: \(errorResponse)")
                    }
                    completion(nil)
                }
            };
        } catch {
            print(error)
            completion(nil)
        }
    }
    
    @IBAction func didTapPicture(_ sender: Any) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .camera
                picker.allowsEditing = false
                present(picker, animated: true)
            } else {
                print("Camera not available")
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
    
    func saveImage() {
        let date = getDateValue()
        guard let data = UIImage(named: "image")?.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        UserDefaults.standard.set(encoded, forKey: date)
    }

    func loadImage() {
        let date = getDateValue()
        guard let data = UserDefaults.standard.data(forKey: date) else { return }
         let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
         let image = UIImage(data: decoded)
    }

}


extension HomeViewController{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           picker.dismiss(animated: true)

           if let image = info[.originalImage] as? UIImage {
               print("Image selected: \(image)")
               todayImage.image = image
               
               print("todayImage.image after setting: \(String(describing: todayImage.image))")
               updateViewVisibility()
               
               saveImageToUserDefaults(image: image)
               
               if let imageData = image.jpegData(compressionQuality: 0.8) {
                              Task {
                                  await uploadImage(image: imageData) { lastFMResponse in
                                      if let response = lastFMResponse, let albums = response.top_ten_albums?.topalbums?.album {
                                          DispatchQueue.main.async {
                                              self.albumData = albums
                                              self.albumCollectionView.reloadData()
                                          }
                                      } else {
                                          print("Failed to get or process LastFM response for collection view.")
                                      }
                                  }
                              }
                          } else {
                              print("Error: Could not convert image to JPEG data.")
                              let alert = UIAlertController(title: "Error", message: "Failed to convert the image for upload.", preferredStyle: .alert)
                              alert.addAction(UIAlertAction(title: "OK", style: .default))
                              present(alert, animated: true)
                          }
           } else {
               print("Error: Could not retrieve the selected image.")
               let alert = UIAlertController(title: "Error", message: "Failed to load the selected image.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default))
               present(alert, animated: true)
           }
       }
    
    func saveImageToUserDefaults(image: UIImage?) {
        let dateKey = getDateValue()
        if let imageToSave = image, let imageData = imageToSave.jpegData(compressionQuality: 0.5) {
            UserDefaults.standard.set(imageData, forKey: dateKey)
            print("Image saved to UserDefaults for date: \(dateKey)")
        } else {
            print("Error: Could not get image data to save.")
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if viewController != self {
                if let anotherTabVC = viewController as? DetailViewController {
                    anotherTabVC.receivedColorString = "FF7070"
                    anotherTabVC.receivedImage = todayImage.image
                }
            }
        }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumData.count
    }
    

    func numberOfItems(inSection section: Int) -> Int {
        return albumData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCollectionViewCell
        cell.contentView.backgroundColor = .lightGray
        let album = albumData[indexPath.item]
        cell.albumTitleLabel.text = album.name
        cell.albumImageView.image = nil

        if album.image.count >= 3, let imageUrl = URL(string: album.image[2].url) {
            // Attempt to use the third image (index 2)
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let data = data, let loadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let currentCell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell {
                            currentCell.albumImageView.image = loadedImage
                        }
                    }
                } else if let error = error {
                    print("Error loading third image: \(error)")
                }
            }.resume()
        } else if let firstImage = album.image.first, let imageUrl = URL(string: firstImage.url) {
            URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            }.resume()
        }

        return cell
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAlbum = albumData[indexPath.item]
        print("Selected album: \(selectedAlbum.name)")
    }
}
