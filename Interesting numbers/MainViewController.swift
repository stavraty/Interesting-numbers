//
//  ViewController.swift
//  Interesting numbers
//
//  Created by AS on 06.09.2023.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNumberButton: UIButton!
    @IBOutlet weak var randomNumberButton: UIButton!
    @IBOutlet weak var numberInARangeButton: UIButton!
    @IBOutlet weak var multipleNumbersButton: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var displayFactButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let factService = NumberFactService()
    var selectedMode: String?
    let selectedColor = UIColor(red: 0.50, green: 0.20, blue: 0.80, alpha: 1.00)
    let unselectedColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
    let selectedTextColor = UIColor.white
    let unselectedTextColor = UIColor.black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        
        selectedMode = "userNumber"
        configureButtons()
        updatePlaceholderText()
        updateButtonStyle(selectedButton: userNumberButton)
        setupTapGesture()
        registerForKeyboardNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTextFactsSegue" {
            if let destinationVC = segue.destination as? TextViewController,
               let factText = sender as? String {
                destinationVC.factText = factText
                destinationVC.numberText = numberTextField.text
                print(factText)
            }
        }
    }
    
    private func configureButtons() {
        configureButton(userNumberButton)
        configureButton(randomNumberButton)
        configureButton(numberInARangeButton)
        configureButton(multipleNumbersButton)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureButton(_ button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00).cgColor
        button.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        let buttonFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        button.titleLabel?.font = buttonFont
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2.0
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if selectedMode == "numberInARange" {
            let futureText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            return futureText.count <= 10 && (futureText.contains(",") || futureText.allSatisfy { "0123456789".contains($0) })
        } else {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789,")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    }
    
    @IBAction func displayFactButtonTapped(_ sender: UIButton) {
        guard let mode = selectedMode else {
            print("Error: No mode selected.")
            return
        }
        
        switch mode {
        case "userNumber":
            fetchFactForUserNumber()
            
        case "randomNumber":
            fetchFactForRandomNumber()
            
        case "numberInARange":
            fetchFactForNumberInRange()
            
        case "multipleNumbers":
            fetchFactForUserNumber()
            
        default:
            print("Error: Unknown mode.")
        }
    }
    
    func fetchFactForUserNumber() {
        guard let numberText = numberTextField.text, !numberText.isEmpty else {
            print("Error: User number is empty.")
            return
        }
        fetchFactForNumber(numberText, type: "trivia")
    }

    func fetchFactForRandomNumber() {
        fetchFactForNumber("random", type: "trivia")
    }

    func fetchFactForNumberInRange() {
        guard let rangeText = numberTextField.text, !rangeText.isEmpty else {
            print("Error: Range is empty.")
            return
        }

        let numbers = rangeText.split(separator: ",").map { String($0) }

        guard numbers.count == 2 else {
            print("Error: Invalid range format. Expected format: min,max")
            return
        }

        let min = numbers[0]
        let max = numbers[1]

        factService.getFactInRange(min: min, max: max) { [weak self] result in
            switch result {
            case .success(let fact):
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "showTextFactsSegue", sender: fact)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func fetchFactForNumber(_ number: String, type: String) {
        factService.getFact(number: number, type: type) { [weak self] result in
            switch result {
            case .success(let fact):
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "showTextFactsSegue", sender: fact)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func fetchFactUsingURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Error: Invalid URL.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data, let fact = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "showTextFactsSegue", sender: fact)
                }
            } else {
                print("Error: Unable to fetch fact.")
            }
        }.resume()
    }
    
    private func updateButtonStyle(selectedButton: UIButton) {
        
        userNumberButton.backgroundColor = (selectedButton == userNumberButton) ? selectedColor : unselectedColor
        userNumberButton.tintColor = (selectedButton == userNumberButton) ? selectedTextColor : unselectedTextColor
        
        randomNumberButton.backgroundColor = (selectedButton == randomNumberButton) ? selectedColor : unselectedColor
        randomNumberButton.tintColor = (selectedButton == randomNumberButton) ? selectedTextColor : unselectedTextColor
        
        numberInARangeButton.backgroundColor = (selectedButton == numberInARangeButton) ? selectedColor : unselectedColor
        numberInARangeButton.tintColor = (selectedButton == numberInARangeButton) ? selectedTextColor : unselectedTextColor
        
        multipleNumbersButton.backgroundColor = (selectedButton == multipleNumbersButton) ? selectedColor : unselectedColor
        multipleNumbersButton.tintColor = (selectedButton == multipleNumbersButton) ? selectedTextColor : unselectedTextColor
    }
    
    private func updatePlaceholderText() {
        switch selectedMode {
        case "userNumber":
            numberTextField.placeholder = "Just write any number here..."
        case "multipleNumbers":
            numberTextField.placeholder = "Write several numbers separated by a comma"
        case "randomNumber":
            numberTextField.placeholder = "Click the button below"
        case "numberInARange":
            numberTextField.placeholder = "Write the range of min, max values through ,"
        default:
            numberTextField.placeholder = ""
        }
    }
    
    @IBAction func userNumberButtonTapped(_ sender: Any) {
        selectedMode = "userNumber"
        updateButtonStyle(selectedButton: userNumberButton)
        resetNumberTextField()
        updatePlaceholderText()
    }
    
    @IBAction func randomNumberButtonTapped(_ sender: Any) {
        selectedMode = "randomNumber"
        updateButtonStyle(selectedButton: randomNumberButton)
        resetNumberTextField()
        updatePlaceholderText()
    }
    
    @IBAction func numberInARangeButtonTapped(_ sender: Any) {
        selectedMode = "numberInARange"
        updateButtonStyle(selectedButton: numberInARangeButton)
        resetNumberTextField()
        updatePlaceholderText()
    }
    
    @IBAction func multipleNumbersButtonTapped(_ sender: Any) {
        selectedMode = "multipleNumbers"
        updateButtonStyle(selectedButton: multipleNumbersButton)
        resetNumberTextField()
        updatePlaceholderText()
    }
    
    private func resetNumberTextField() {
        numberTextField.text = ""
    }
    
    @objc func handleTap() {
        numberTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
}

