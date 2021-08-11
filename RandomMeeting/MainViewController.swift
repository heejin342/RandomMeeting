//
//  MainViewController.swift
//  RandomMeeting
//
//  Created by 김희진 on 2021/08/09.
//

import UIKit
import PagingKit

class MainViewController: UIViewController, PagingMenuViewControllerDelegate, PagingContentViewControllerDelegate {
    
    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    
    
    static var mainViewController: (UIColor) -> UIViewController = { (color) in
           let vc = UIViewController()
            vc.view.backgroundColor = color
            return vc
        }

    
//    var dataSource = [(menuTitle: "test1", vc: mainViewController(.red)), (menuTitle: "test2", vc: mainViewController(.blue)), (menuTitle: "test3", vc: mainViewController(.yellow))]
    
    var dataSource = [(menu:String, content: UIViewController)]() {
        didSet{
            menuViewController.reloadData()
            contentViewController.reloadData()
        }
    }
    
    lazy var firstLoad: (() -> Void)? = {[weak self, menuViewController, contentViewController] in
        
        menuViewController!.reloadData()
        contentViewController!.reloadData()
        
        self?.firstLoad = nil
        
    }


    fileprivate func makeDataSource() -> [(menu:String, content: UIViewController)]{
        let myMenuArray = ["첫번째", "두번째","세번째"]
        return myMenuArray.map{
            let title = $0
            
            switch title {
            case "첫번째":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as! ViewController
                
                return (menu: title, content: vc)
         
            case "두번째":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MyInfoViewController") as! MyInfoViewController
                return (menu: title, content: vc)
            
            case "세번째":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MatchingViewController") as! MatchingViewController
                return (menu: title, content: vc)
         
            default:
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ViewController") as! ViewController
                return (menu: title, content: vc)
         
            }
        }
    }

    override func viewDidLoad() {
           
        super.viewDidLoad()
        
//        menuViewController.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController.register(type: TitleLabelMenuViewCell.self, forCellWithReuseIdentifier:"identifier")

//        menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        menuViewController.registerFocusView(view: UnderlineFocusView())

        
        menuViewController.cellAlignment = .center
        
//        menuViewController.reloadData()
//        contentViewController.reloadData()
        
        dataSource = makeDataSource()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstLoad?()
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if let vc = segue.destination as? PagingMenuViewController {
              menuViewController = vc
              menuViewController.dataSource = self
              menuViewController.delegate = self
          } else if let vc = segue.destination as? PagingContentViewController {
              contentViewController = vc
              contentViewController.dataSource = self
              contentViewController.delegate = self
          }
    }

}


extension MainViewController: PagingContentViewControllerDataSource, PagingMenuViewControllerDataSource{
    
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].content
    }
    
    
    func numberOfItemsForMenuViewController(viewController mainViewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController mainViewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
//        let cell = mainViewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
        let cell = mainViewController.dequeueReusableCell(withReuseIdentifier: "identifier", for: index) as! TitleLabelMenuViewCell

        cell.titleLabel.text = dataSource[index].menu
        cell.titleLabel.textColor = .black
         
        return cell
    }
    
    func menuViewController(viewController mainViewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
       
        return 100
    }
    
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
            contentViewController.scroll(to: page, animated: true)
        }
    
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
           menuViewController.scroll(index: index, percent: percent, animated: false)
       }
    
}
