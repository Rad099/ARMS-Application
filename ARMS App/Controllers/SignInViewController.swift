//
//  SignInViewController.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 2/12/24.
//

import UIKit

class SignInViewController: UIViewController {
    
    //@IBOutlet weak var signLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(dismissViewController), name: NSNotification.Name("UserDidSignInToiCloud"), object: nil)
        self.view.backgroundColor = .black
        let signLabel = UILabel()
        signLabel.text = "Please sign-in to iCloud to continue."
        signLabel.backgroundColor = .white
        signLabel.textAlignment = .center
        signLabel.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 50)
        self.view.addSubview(signLabel)
    }
    
    @objc func dismissViewController() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
            // Remove this object as an observer
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UserDidSignInToiCloud"), object: nil)
        }
}
