//
//  RandomUserRequest.swift
//  RandomMeeting
//
//  Created by 김희진 on 2021/08/10.
//

import Foundation
import Alamofire
import UIKit

class RandomUserRequest {
    
    func getUserData(_ matchingViewController: MatchingViewController, selectedNumber: String, selectedGender:  String, selectedAge: String) {
        
        let url = "https://randomuser.me/api"
        
//        let params: Parameters = [
//            "results" : "1",
//            "gender" : "female",
//            "seed" : "sdfsdf"
//        ]
        
        let params: Parameters = [
            "results" : selectedNumber.trimmingCharacters(in: ["명"]),
            "gender" : selectedGender == "여성" ? "female" : "male"
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: params,
                   headers: nil)
            .responseDecodable(of: RandomUserResponse.self) { response in
                
                switch response.result {
                
                case .success(let response):
//                    print("DEBUG>> USER API GET Response \(response) ")
                    matchingViewController.didSuccess(response)
                    
                case .failure(let error):
                    print("DEBUG>> USER API Get Error : \(error.localizedDescription)")
                    
                }
            }
    }
    
}
