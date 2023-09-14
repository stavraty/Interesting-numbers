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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        
        let factService = NumberFactService()
        
        configureButton(userNumberButton)
        configureButton(randomNumberButton)
        configureButton(numberInARangeButton)
        configureButton(multipleNumbersButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFactSegue" {
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
        button.layer.borderColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00).cgColor // Колір бордеру
        
        // Налаштування фону кнопки
        button.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00) // Ваш колір фону
        button.tintColor = UIColor.black // Колір тексту та іконок на кнопці (зазвичай чорний або інший контрастний колір)
        
        // Налаштування тіні
        button.layer.shadowColor = UIColor.black.cgColor // Колір тіні
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2.0
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Визначте набір дозволених символів (в цьому випадку, це цифри).
        let allowedCharacters = CharacterSet.decimalDigits
        
        // Перевірте, чи всі символи в рядку заміни є дозволеними.
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
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
    
    
    @IBAction func userNumberButtonTapped(_ sender: Any) {
        userNumberButton.backgroundColor = UIColor(red: 0.50, green: 0.20, blue: 0.80, alpha: 1.00)
        userNumberButton.tintColor = UIColor.white
        randomNumberButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        numberInARangeButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        multipleNumbersButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
    }
    
    @IBAction func randomNumberButtonTapped(_ sender: Any) {
        userNumberButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        randomNumberButton.backgroundColor = UIColor(red: 0.50, green: 0.20, blue: 0.80, alpha: 1.00)
        numberInARangeButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        multipleNumbersButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
    }
    
    @IBAction func numberInARangeButtonTapped(_ sender: Any) {
        userNumberButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        randomNumberButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        numberInARangeButton.backgroundColor = UIColor(red: 0.50, green: 0.20, blue: 0.80, alpha: 1.00)
        multipleNumbersButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
    }
    
    @IBAction func multipleNumbersButtonTapped(_ sender: Any) {
        userNumberButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        randomNumberButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        numberInARangeButton.backgroundColor = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        multipleNumbersButton.backgroundColor = UIColor(red: 0.50, green: 0.20, blue: 0.80, alpha: 1.00)
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

