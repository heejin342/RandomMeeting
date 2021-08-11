//
//  MyInfoViewController.swift
//  RandomMeeting
//
//  Created by 김희진 on 2021/08/10.
//

import UIKit


class MyInfoViewController: UIViewController{

    
//    weak var delegate: SecondVCDelegate?
    
    @IBOutlet var test: UIImageView!
    
    @IBOutlet var genderLb: UILabel!
    @IBOutlet var emailLb: UILabel!
    @IBOutlet var nameLb: UILabel!
    @IBOutlet var phoneLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("111")
        print("!")
        genderLb.text = ""
        emailLb.text = ""
        nameLb.text = ""
        phoneLb.text = ""
        
        
            
        test.layer.cornerRadius = test.frame.height/2
        test.layer.borderWidth = 1
        test.layer.borderColor = UIColor.clear.cgColor
        test.clipsToBounds = true
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadInputViews()
        
        if UserDefaults.standard.value(forKey: "name") != nil {
            nameLb.text = (UserDefaults.standard.value(forKey: "name") as! String)
            phoneLb.text = (UserDefaults.standard.value(forKey: "mobile") as! String)
            emailLb.text = (UserDefaults.standard.value(forKey: "email") as! String)
            genderLb.text = (UserDefaults.standard.value(forKey: "gender") as! String) == "F" ? "Female" : "Male"

            print(UserDefaults.standard.value(forKey: "profile_image") as! String)
            
            let url = URL(string: (UserDefaults.standard.value(forKey: "profile_image") as! String) ); do {
                    let data = try Data(contentsOf: url!)
                test.image = UIImage(data: data)
            } catch{

            }

        }

    }
    

}

