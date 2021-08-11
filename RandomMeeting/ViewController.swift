//
//  ViewController.swift
//  RandomMeeting
//
//  Created by 김희진 on 2021/08/08.
//
import Foundation
import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import Alamofire


class ViewController: UIViewController, NaverThirdPartyLoginConnectionDelegate  {
    
    let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    @IBOutlet var oauthName: UILabel!
    
    @IBOutlet var ouathPlatform: UILabel!
    
       override func viewDidLoad() {
//           loginInstance?.delegate = self
           loginInstance?.requestDeleteToken()
       }
    
    
       // 로그인에 성공한 경우 호출
       func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
           print("Success login")
           getInfo()
       }
       
       // referesh token
       func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
           loginInstance?.accessToken 
       }
       
       // 로그아웃
       func oauth20ConnectionDidFinishDeleteToken() {
           print("log out")
       }
       
       // 모든 error
       func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
           print("error = \(error.localizedDescription)")
       }
       

//       
//       @IBAction func logout(_ sender: Any) {
//           loginInstance?.requestDeleteToken()
//       }
       
       // RESTful API, id가져오기
       func getInfo() {
         guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return }
         
         if !isValidAccessToken {
           return
         }
         
         guard let tokenType = loginInstance?.tokenType else { return }
         guard let accessToken = loginInstance?.accessToken else { return }
           
         let urlStr = "https://openapi.naver.com/v1/nid/me"
         let url = URL(string: urlStr)!
         
         let authorization = "\(tokenType) \(accessToken)"
         
         let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
         
         req.responseJSON { response in
           guard let result = response.value as? [String: Any] else { return }
           guard let object = result["response"] as? [String: Any] else { return }
           guard let name = object["name"] as? String else { return }
           guard let email = object["email"] as? String else { return }
           guard let id = object["id"] as? String else {return}
           guard let mobile = object["mobile"] as? String else {return}
           guard let profile_image = object["profile_image"] as? String else {return}
           guard let gender = object["gender"] as? String else {return}

            print(result)
            
           self.oauthName.text = name
           self.ouathPlatform.text = "login as Naver"
            UserDefaults.standard.set(name, forKey: "name")
            UserDefaults.standard.set(mobile, forKey: "mobile")
            UserDefaults.standard.set(profile_image, forKey: "profile_image")
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(gender, forKey: "gender")

            
           print(id,name,email)
            
//            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: MyInfoViewController
//            let navVB = UINavigationController(rootViewController: vc)
//            let share = UIA
         }
       }

    

    @IBAction func naverLogin(_ sender: Any) {
    
        loginInstance?.delegate = self

        loginInstance?.requestThirdPartyLogin()
    }
    
    
    
    @IBAction func kakaoLogin(_ sender: Any) {
    
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    //do something
                    _ = oauthToken
                }
            }
        
        
        
        UserApi.shared.loginWithKakaoAccount(prompts:[.Login]) {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")

                //do something
                _ = oauthToken

            }
        }
        
        
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                }
            }
        }
        else {
            //로그인 필요
        }

        
        // 사용자 액세스 토큰 정보 조회
        UserApi.shared.accessTokenInfo {(accessTokenInfo, error) in
            if let error = error {
                print(error)
            }
            else {
                print("accessTokenInfo() success.")

                //do something
                _ = accessTokenInfo
            }
        }
        
        
        
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")

                //do something
                
                _ = user
                print(user as Any)
                self.oauthName.text = user?.kakaoAccount?.profile?.nickname
                self.ouathPlatform.text = "login as Kakao"

                
                let img = (user?.properties!["thumbnail_image"]!)!
                
                print(img)
                
                UserDefaults.standard.set(user?.kakaoAccount?.profile?.nickname, forKey: "name")
                UserDefaults.standard.set("010-9986-1675", forKey: "mobile")
                UserDefaults.standard.set(img, forKey: "profile_image")
                UserDefaults.standard.set("tktmzp0526@naver.com", forKey: "email")
                UserDefaults.standard.set("F", forKey: "gender")

                
                
                
                    
                
                
                
//                let url = URL(string : user?.kakaoAccount?.profile?.profileImageUrl); do {
//                        let data = try Data(contentsOf: url!)
//                    vc.test.image = UIImage(data: data)
//                } catch{
//
//                }

                
            }
        }
        
        
        
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                if let user = user {

                    //필요한 scope을 아래의 예제코드를 참고해서 추가한다.
                    //아래 예제는 모든 스콥을 나열한것.
                    var scopes = [String]()

                    if (user.kakaoAccount?.profileNeedsAgreement == true) { scopes.append("profile") }
                    if (user.kakaoAccount?.emailNeedsAgreement == true) { scopes.append("account_email") }
                    if (user.kakaoAccount?.birthdayNeedsAgreement == true) { scopes.append("birthday") }
                    if (user.kakaoAccount?.birthyearNeedsAgreement == true) { scopes.append("birthyear") }
                    if (user.kakaoAccount?.genderNeedsAgreement == true) { scopes.append("gender") }
                    if (user.kakaoAccount?.phoneNumberNeedsAgreement == true) { scopes.append("phone_number") }
                    if (user.kakaoAccount?.ageRangeNeedsAgreement == true) { scopes.append("age_range") }
                    if (user.kakaoAccount?.ciNeedsAgreement == true) { scopes.append("account_ci") }

                    if scopes.count == 0  { return }

                    //필요한 scope으로 토큰갱신을 한다.
                    UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            UserApi.shared.me() { (user, error) in
                                if let error = error {
                                    print(error)
                                }
                                else {
                                    print("me() success.")

                                    //do something
                                    _ = user
                                }

                            } //UserApi.shared.me()
                        }

                    } //UserApi.shared.loginWithKakaoAccount(scopes:)
                }
            }
        }
        
    }
    
}
