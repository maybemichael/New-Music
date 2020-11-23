//
//  AuthController.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import Foundation
import StoreKit

class AuthController {

    let skServiceController = SKCloudServiceController()
    var userToken: String?
    var storeFrontID: String?
    
    // Check to see if the user even has Apple Music, and if they do, to find out what they are able to do with their subscription, in order to ask them permission to access their apple music account.
    func checkPlaybackCapabilities(completion: @escaping (Result<Bool, Error>) -> Void) {
        skServiceController.requestCapabilities { capability, error in
            if let error = error {
                print("Error requesting device playback capabilities: \(error)")
                completion(.failure(error))
                return
            }
            
            switch capability {
            case .musicCatalogPlayback:
                print("The user has an Apple Music account and can playback music.")
                self.requestAppleMusicAccess()
                completion(.success(true))
            case .addToCloudMusicLibrary:
                print("The user has an Apple Music account, can playback music, and can add music to Cloud Music Library")
                self.requestAppleMusicAccess()
                completion(.success(true))
            case .musicCatalogSubscriptionEligible:
                print("The user doesn't have an Apple Music subscription.")
                // TODO: - Present sign up for Apple Music
                
                completion(.success(true))
            default:
                print("Hit default in switch statement.")
                completion(.failure(NSError()))
            }
        }
    }
    
    func requestAppleMusicAccess() {
        switch SKCloudServiceController.authorizationStatus() {
        case .authorized:
            print("The user is already authorized.")
            self.authenticateUser { response in
                switch response {
                case .success(let authenticated):
                    print("The user is authenticated: \(authenticated)")
                case .failure(let error):
                    print("Error authenticating user: \(error)")
                }
            }
        case .denied:
            print("The user has denied this app from accessing their Apple Music account.")
            // TODO: - Present Alert to change privacy settings to allow access to apple music.
        case .notDetermined:
            print("The user has not been presented with the prompt or reset their privacy settings.")
            
            SKCloudServiceController.requestAuthorization { status in
                switch status {
                case .authorized:
                    print("The user authorized Neu-Music to access their Apple Music account.")
                case .denied:
                    print("The user denied Neu-Muisc to access their Apple Music account.")
                case .notDetermined:
                    print("The user has not decided or we are unsure of authorization status.")
                case .restricted:
                    print("The user has a restricted device and does not have the ability to grant permission.")
                @unknown default:
                    break
                }
            }
        case .restricted:
            print("The user has a restricted device and does not have the ability to grant permission.")
        @unknown default:
            break
        }
    }
    
    func authenticateUser(completion: @escaping (Result<Bool, Error>) -> Void) {
        switch SKCloudServiceController.authorizationStatus() {
        case .authorized:
            skServiceController.requestUserToken(forDeveloperToken: developerToken) { userToken, error in
                if let error = error {
                    print("Error retrieving user token: \(error)")
                    completion(.failure(error))
                    return
                }
                if let token = userToken {
                    self.userToken = token
                    print("The user token: \(String(describing: self.userToken))")
                    completion(.success(true))
                }
            }
        default:
            requestAppleMusicAccess()
        }
    }
    
    func getUsersStoreFrontID(completion: @escaping (Result<Bool, Error>) -> Void) {
        skServiceController.requestStorefrontIdentifier { storeID, error in
            if let error = error {
                print("Error retrieving users store front ID: \(error)")
                completion(.failure(error))
                return
            }
            guard let id = storeID else {
                print("Bad data returned")
                completion(.failure(NSError()))
                return
            }
            
            self.storeFrontID = id.count != 6 ? String(id.prefix(6)) : id
            print("The users store front ID: \(String(describing: self.storeFrontID))")
            completion(.success(true))
        }
    }
    
    private func presentAppleMusicSignup(viewController: UIViewController, completion: @escaping (Result<Bool, Error>) -> Void) {
        let signUpVC = SKCloudServiceSetupViewController()
        signUpVC.delegate = viewController as? SKCloudServiceSetupViewControllerDelegate
        
        let options: [SKCloudServiceSetupOptionsKey: Any] = [.action: SKCloudServiceSetupAction.subscribe,
                                                             .messageIdentifier: SKCloudServiceSetupMessageIdentifier.playMusic]
        
        signUpVC.load(options: options) { success, error in
            if let error = error {
                print("Error trying to present Apple Music sign up: \(error)")
                completion(.failure(error))
                return
            } else {
                viewController.present(signUpVC, animated: true)
            }
        }
    }
}
