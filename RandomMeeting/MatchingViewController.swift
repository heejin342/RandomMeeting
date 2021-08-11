//
//  MatchingViewController.swift
//  RandomMeeting
//
//  Created by 김희진 on 2021/08/10.
//

import UIKit

class MatchingViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet var dimView: UIView!
    
    var age = ["20세","21세","22세","23세","24세","25세","26세","27세","28세","29세","30세","31세","32세","33세","34세","35세","36세","37세","38세","39세","40세"]
    var number = ["1명", "2명", "3명", "4명", "5명"]
    var gender = ["남성", "여성"]
    
    var selectedAge = ""
    var selectedNumber = ""
    var selectedGender = ""

    @IBOutlet var infoVIew: UIView!
    @IBOutlet var infoImage: UIImageView!
    @IBOutlet var infoName: UILabel!
    @IBOutlet var infoLocation: UILabel!
    @IBOutlet var infoEmail: UILabel!
    
    
    @IBOutlet var numberPicker: UIPickerView!
    
    @IBOutlet var tableView: UITableView!
    
    var UserData : RandomUserResponse? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    

    @IBAction func findRandomUsers(_ sender: Any) {
        RandomUserRequest().getUserData(self, selectedNumber: selectedNumber, selectedGender: selectedGender, selectedAge: selectedAge)
    }

    @IBAction func closeDetail(_ sender: UIButton) {
//        infoVIew.removeFromSuperview()
        
        UIView.animate(withDuration: 0.3, delay:0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options:[] ,animations: {
            self.dimView.alpha = 0
            self.infoVIew.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }){(success) in
            self.infoVIew.removeFromSuperview()
        }
    }
    
}


extension MatchingViewController {
    
    func didSuccess(_ response: RandomUserResponse) {
        
        UserData = response
        
        tableView.reloadData()
                     
    }
}

extension MatchingViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return number.count
        }else if component == 1{
            return age.count
        }
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return number[row]
        }else if component == 1{
            return age[row]
        }
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selectedNumber = number[row]
        }else if component == 1{
            selectedAge = age[row]
        }else if component == 2 {
            selectedGender = gender[row]
        }
    }
    
}


extension MatchingViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (UserData != nil) {
            print(UserData!.results.count)
            return UserData!.results.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! UserTableViewCell
        //        let thisUser = UserData?.results[indexPath.row]

        if (UserData != nil) {
            
            
            tableViewCell.userProfileMessage.text = "hello~ nice to meet you. please click and talk with me !"
            
            let url = URL(string: UserData!.results[indexPath.row].picture.large); do {
                    let data = try Data(contentsOf: url!)
                tableViewCell.userProfileImage.image = UIImage(data: data)
            } catch{

            }
        
        }
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        infoName.text = UserData!.results[indexPath.row].name.first + UserData!.results[indexPath.row].name.last
        infoLocation.text = UserData!.results[indexPath.row].location.country + " , " +  UserData!.results[indexPath.row].location.city
        infoEmail.text = UserData!.results[indexPath.row].email
        
        let url = URL(string: UserData!.results[indexPath.row].picture.large); do {
                let data = try Data(contentsOf: url!)
            infoImage.image = UIImage(data: data)
        } catch{

        }
        
        
        infoVIew.center = dimView.center

        
        infoVIew.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        

        UIView.animate(withDuration: 0.3, delay:0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options:[] ,animations: {
            self.dimView.alpha = 0.8
            self.infoVIew.transform = .identity
        })

        mainView.addSubview(infoVIew)

        

//        let popup = storyboard?.instantiateViewController(withIdentifier: "DetailUserViewController") as! DetailUserViewController
//
//        self.present(popup, animated: true)
    }
    
}
