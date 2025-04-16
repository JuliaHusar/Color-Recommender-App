    //
    //  SignUpTwoController.swift
    //  VividListenes
    //
    //  Created by Julia Husar on 4/8/25.
    //

    import UIKit
    import MusicKit

class SignUpTwoController: UIViewController, LastFMModalDelegate {
        /*
         private var recentAlbums: MusicItemCollection<Album> = []
         private var errorMessage: String?
         */
        let apiKey = "8aabfe01bd0862d780e5d4a9aee1b900"
        let sharedSecret = "f9c0dff46a2e4f42c4c60f2e20755b04"


        @IBOutlet weak var nextButton: UIButton!
        let defaults = UserDefaults.standard
        override func viewDidLoad() {
            super.viewDidLoad()
            nextButton.isEnabled = false
      
        }
    
        
        func lastFMModalDidDismiss(with username: String?) {
            if let validUsername = username {
                print("Last.fm username entered: \(validUsername)")
                defaults.set(validUsername, forKey: "lastFMUsername")
            }
            nextButton.isEnabled = true
        }
    
        private var appAuthorization: Bool = false {
            didSet {
                if appAuthorization {
                    //   performSegue(withIdentifier: "signUpThree", sender: self)
                }
            }
        }
        
        //Last FM Logic
        
    @IBAction func nextButton(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let homePage = mainStoryboard.instantiateViewController(withIdentifier: "MainTabController") as? UITabBarController else {
            print("Error: Could not instantiate MainTabController")
            return
        }

        if let window = UIApplication.shared.windows.first {
            window.rootViewController = homePage
            window.makeKeyAndVisible()
        }
    }
    
        
        /*
        @IBAction func musickitButton(_ sender: UIButton) {
            Task{
                do {
                   try await self.requestMusicKitAuth()
                } catch {
                    print (error)
                }
            }
        }
        
        @IBAction func spotifyButton(_ sender: UIButton) {
        }
        
        
        //Spotify Authentication
        
        //Apple Music Authentication
        private func getToken() {
            Task {
                do {
                    let developerToken = "eyJhbGciOiJFUzI1NiIsImtpZCI6IjlZUjZNUEEyTUciLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiI1UTM4ODMyOFk0IiwiaWF0IjoxNzQ0NzQyNzU4LCJleHAiOjE3NDQ3NDYzNTh9.cphn1rLqX0w2EhK3W8jYDLjPiSYDmtog1KIeKHsmfxyDqJs0eMYZamY6CaBXUbfchjjnDb83wws1NuKG3vRMFw"
                        let token = try await MusicKit.MusicDataRequest.tokenProvider.userToken(for: developerToken, options: [])
                        print(token)
                        await fetchRecentAlbums()
                        defaults.set(token, forKey: "token")
                    
                }
            }
        }
        
        func fetchRecentAlbums() async {
                do {
                    let request = MusicLibraryRequest<Album>()
                    let response = try await request.response()
                    recentAlbums = response.items
                    errorMessage = nil
                } catch {
                    print("Error fetching recent albums: \(error)")
                    errorMessage = error.localizedDescription
                }
            }
        
        private func requestMusicKitAuth() async throws{
            let status = await MusicAuthorization.request()
            switch status {
                case .authorized:
                print("authorized")
                appAuthorization = true
            case .denied:
                print("denied")
                appAuthorization = false
            case .notDetermined:
                print("not determined")
                appAuthorization = false
            default:
                print ("not determined")
            }
            
        }
         */
        
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "lastFMSegue",
               let destinationVC = segue.destination as? LastFMModalViewController {
                destinationVC.delegate = self
            }
        }
    
    }
