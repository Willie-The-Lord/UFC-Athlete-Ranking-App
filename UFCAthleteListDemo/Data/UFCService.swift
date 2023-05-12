//
//  UFCService.swift
//  UFCAthleteListDemo
//
//  Created by 洪崧傑 on 2023/4/7.
//

import Foundation

//import Foundation
import UIKit

enum AthleteCallingError: Error {
    case problemGeneratingURL
    case problemGettingDataFromAPI
    case problemDecodingData
}

class UFCService {
    private let urlString = "https://run.mocky.io/v3/229eb677-d530-44c0-9070-aef91d57c247"
    
    func getAthletes(completion: @escaping ([Athlete]?, Error?) -> ()) {
        guard let url = URL(string: self.urlString) else {
            DispatchQueue.main.async {
                completion(nil, AthleteCallingError.problemGeneratingURL)
            }
            return
        }
            
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                // Handle no Wi-fi
                let alert = UIAlertController(title: "Error", message: "No data received from server.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                // Extra credit: implement a “retry” button so that, if this happens and then you turn the wifi back on, the data loads!
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.getAthletes(completion: completion)
                }))
                DispatchQueue.main.async {
                    completion(nil, AthleteCallingError.problemGettingDataFromAPI)
                    if let vc = UIApplication.shared.windows.first?.rootViewController {
                        vc.present(alert, animated: true, completion: nil)
                    }
                }
                return
            }
            
            do {
                let athleteResult = try JSONDecoder().decode(AthleteResult.self, from: data)
                // Handle empty list
                if athleteResult.athletes.isEmpty {
                    let alert = UIAlertController(title: "Error", message: "Empty list received from server.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                        self.getAthletes(completion: completion)
                    }))
                    DispatchQueue.main.async {
                        completion(athleteResult.athletes, nil)
                        if let vc = UIApplication.shared.windows.first?.rootViewController {
                            vc.present(alert, animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async { completion(athleteResult.athletes, nil) }
                }
                
            } catch DecodingError.dataCorrupted(let context) {
                // Handle invalid url
                let error = AthleteCallingError.problemDecodingData
                let alert = UIAlertController(title: "Error", message: "Invalid url", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.getAthletes(completion: completion)
                }))
                DispatchQueue.main.async {
                    completion(nil, error)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            } catch (let error) {
                print(error)
                DispatchQueue.main.async { completion(nil, AthleteCallingError.problemDecodingData) }
            }
        }
        task.resume()
    }
}


