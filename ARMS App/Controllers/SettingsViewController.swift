import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {
    var user: User!
    var iCloudManager = ICloudManager()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var ageText: UITextField!
    @IBOutlet weak var heartText: UITextField!
    @IBOutlet weak var lungText: UITextField!
    @IBOutlet weak var asthmaText: UITextField!
    
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegates()
        loadUserData()
    }
    
    private func setupDelegates() {
        nameText.delegate = self
        ageText.delegate = self
        heartText.delegate = self
        lungText.delegate = self
        asthmaText.delegate = self
    }
    
    private func loadUserData() {
        print("Settings loaded")
        nameLabel.text = "Name: \(user.name)"
        nameText.text = user.name
        ageText.text = "\(user.age)"
        heartText.text = user.heartDisease ? "true" : "false"
        lungText.text = user.lungDisease ? "true" : "false"
        asthmaText.text = user.asthma ? "true" : "false"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateButton.setTitle("Update User", for: .normal)
    }
    
    @IBAction func confirmUpdateTapped(_ sender: UIButton) {
        updateUser()
    }
    
    private func updateUser() {
        guard let newName = nameText.text, !newName.isEmpty,
              let ageTextValue = ageText.text, let newAge = Int(ageTextValue),
              let newHeartStatus = heartText.text?.lowercased(),
              let newLungStatus = lungText.text?.lowercased(),
              let newAsthmaStatus = asthmaText.text?.lowercased() else {
            updateButton.setTitle("Error Updating! Check your inputs", for: .normal)
            return
        }
        
        user.name = newName
        user.age = newAge
        user.heartDisease = newHeartStatus == "true"
        user.lungDisease = newLungStatus == "true"
        user.asthma = newAsthmaStatus == "true"
        
        iCloudManager.updateUserRecord(user: user) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.updateButton.setTitle("User Updated!", for: .normal)
                    paqr.applyWeights()
                } else {
                    self?.updateButton.setTitle("Error Updating!", for: .normal)
                    print("Error: \(String(describing: error))")
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
