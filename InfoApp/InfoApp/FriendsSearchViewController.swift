//
//  FriendsSearchViewController.swift
//  InfoApp
//
//  Created by Ramazan Kayalı on 4.07.2021.
//

import UIKit

class FriendsSearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Ekrana tıklayınca klavyeyi kapatma
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    


}
