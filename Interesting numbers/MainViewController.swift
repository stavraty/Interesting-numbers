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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        
        // Додати жест тапу для ховання клавіатури
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Визначте набір дозволених символів (в цьому випадку, це цифри).
        let allowedCharacters = CharacterSet.decimalDigits
        
        // Перевірте, чи всі символи в рядку заміни є дозволеними.
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    @objc func handleTap() {
        // Викликати метод приховання клавіатури для numberTextField
        numberTextField.resignFirstResponder()
    }

}

