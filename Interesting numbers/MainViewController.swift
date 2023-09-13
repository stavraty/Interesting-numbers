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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        // Встановіть UIScrollView для відстеження клавіатури
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
    }
    
    @IBAction func randomNumberButtonTapped(_ sender: Any) {
    }
    
    @IBAction func numberInARangeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func multipleNumbersButtonTapped(_ sender: Any) {
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

