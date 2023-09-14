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
        
        configureButton(userNumberButton)
        configureButton(randomNumberButton)
        configureButton(numberInARangeButton)
        configureButton(multipleNumbersButton)
        
        selectedMode = "userNumber"
        updateButtonStyle(selectedButton: userNumberButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

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
    
    func configureButton(_ button: UIButton) {
        // Налаштування бордеру
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00).cgColor
        
        // Налаштування фону кнопки
        button.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        button.tintColor = UIColor.black
        
        // Налаштування тіні
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2.0
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if selectedMode == "multipleNumbers" {
            // Дозвольте тільки цифри і кому в текстовому полі.
            let allowedCharacters = CharacterSet(charactersIn: "0123456789,")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else {
            return true
        }
    }
    
    @IBAction func displayFactButtonTapped(_ sender: UIButton) {
        // Переконайтесь, що поле для введення числа не пусте
        guard let numberText = numberTextField.text, !numberText.isEmpty else {
            // Обробка ситуації, коли поле для введення числа порожнє
            return
        }

        // Отримати тип факту (наприклад, "trivia", "math", тощо) на ваш вибір
        let factType = "trivia" // Замініть це на вибраний вами тип факту
        
        // Викликати NumberFactService для отримання факту
        let factService = NumberFactService()
        factService.getFact(number: numberText, type: factType) { [weak self] result in
            switch result {
            case .success(let fact):
                // Переход до другого контролера після отримання факту
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "showTextFactsSegue", sender: fact)
                }
            case .failure(let error):
                // Обробити помилку
                DispatchQueue.main.async {
                    // Вивести повідомлення про помилку на екран
                    print("Error: \(error)")
                }
            }
        }
    }
    
    func updateButtonStyle(selectedButton: UIButton) {

        userNumberButton.backgroundColor = (selectedButton == userNumberButton) ? selectedColor : unselectedColor
        userNumberButton.tintColor = (selectedButton == userNumberButton) ? selectedTextColor : unselectedTextColor
        
        randomNumberButton.backgroundColor = (selectedButton == randomNumberButton) ? selectedColor : unselectedColor
        randomNumberButton.tintColor = (selectedButton == randomNumberButton) ? selectedTextColor : unselectedTextColor

        numberInARangeButton.backgroundColor = (selectedButton == numberInARangeButton) ? selectedColor : unselectedColor
        numberInARangeButton.tintColor = (selectedButton == numberInARangeButton) ? selectedTextColor : unselectedTextColor
        
        multipleNumbersButton.backgroundColor = (selectedButton == multipleNumbersButton) ? selectedColor : unselectedColor
        multipleNumbersButton.tintColor = (selectedButton == multipleNumbersButton) ? selectedTextColor : unselectedTextColor
    }
    
    @IBAction func userNumberButtonTapped(_ sender: Any) {
        selectedMode = "userNumber"
        updateButtonStyle(selectedButton: userNumberButton)
    }
    
    @IBAction func randomNumberButtonTapped(_ sender: Any) {
        selectedMode = "randomNumber"
        updateButtonStyle(selectedButton: randomNumberButton)
    }
    
    @IBAction func numberInARangeButtonTapped(_ sender: Any) {
        selectedMode = "numberInARange"
        updateButtonStyle(selectedButton: numberInARangeButton)
    }
    
    @IBAction func multipleNumbersButtonTapped(_ sender: Any) {
        selectedMode = "multipleNumbers"
        updateButtonStyle(selectedButton: multipleNumbersButton)
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

