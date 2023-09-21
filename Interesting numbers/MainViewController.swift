//
//  ViewController.swift
//  Interesting numbers
//
//  Created by AS on 06.09.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private enum ColorConstants {
        static let selectedButton = UIColor(red: 0.50, green: 0.20, blue: 0.80, alpha: 1.00)
        static let unSelectedButton = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        static let selectedText = UIColor.white
        static let unselectedText = UIColor.black
        static let defaultBorder = UIColor(red: 0.96, green: 0.94, blue: 0.98, alpha: 1.00)
        static let shadow = UIColor.black.cgColor
    }
    
    @IBOutlet weak var userNumberButton: UIButton!
    @IBOutlet weak var randomNumberButton: UIButton!
    @IBOutlet weak var numberInRangeButton: UIButton!
    @IBOutlet weak var multipleNumbersButton: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var displayFactButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let factService = NumberFactService()
    var selectedMode: SelectedMode = .userNumber
    static let showTextFactsSegueIdentifier = "showTextFactsSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberTextField.delegate = self
        
        configureButtons()
        updatePlaceholderText()
        updateButtonStyle(selectedButton: userNumberButton)
        setupKeyboardDismissGesture()
        registerForKeyboardNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MainViewController.showTextFactsSegueIdentifier {
            if let destinationVC = segue.destination as? TextViewController,
               let factText = sender as? String {
                destinationVC.factText = factText
                
                if selectedMode == .randomNumber || selectedMode == .numberInRange {
                    let numberFromFact = extractNumber(from: factText) ?? ""
                    destinationVC.numberText = numberFromFact
                } else {
                    destinationVC.numberText = numberTextField.text
                }
            }
        }
    }
    
    @objc func dismissKeyboardOnTap() {
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
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardOnTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func extractNumber(from text: String) -> String? {
        let regex = try? NSRegularExpression(pattern: "^\\d+", options: .caseInsensitive)
        if let match = regex?.firstMatch(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) {
            return (text as NSString).substring(with: match.range)
        }
        return nil
    }
    
    private func configureButtons() {
        configureDefaultButton(userNumberButton)
        configureDefaultButton(randomNumberButton)
        configureDefaultButton(numberInRangeButton)
        configureDefaultButton(multipleNumbersButton)
        configureDisplayFactButton()
    }
    
    private func configureDisplayFactButton() {
        displayFactButton.backgroundColor = ColorConstants.selectedButton
        displayFactButton.setTitleColor(UIColor.white, for: .normal)
        displayFactButton.layer.cornerRadius = 10
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureDefaultButton(_ button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        button.layer.borderColor = ColorConstants.defaultBorder.cgColor
        button.backgroundColor = ColorConstants.unSelectedButton
        let buttonFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        button.titleLabel?.font = buttonFont
        button.setTitleColor(ColorConstants.unselectedText, for: .normal)
        button.layer.shadowColor = ColorConstants.shadow
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 2.0
    }
    
    private func fetchFactForUserNumber() {
        guard let numberText = numberTextField.text, !numberText.isEmpty else {
            showAlert(type: .emptyNumber)
            return
        }
        fetchFactForNumber(numberText)
    }
    
    private func fetchFactForRandomNumber() {
        fetchFactForNumber("random")
    }
    
    private func fetchFactForNumberInRange() {
        guard let rangeText = numberTextField.text, !rangeText.isEmpty else {
            showAlert(type: .emptyRange)
            return
        }
        
        let numbers = rangeText.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        
        guard numbers.count == 2, let minInt = Int(numbers[0]), let maxInt = Int(numbers[1]) else {
            showAlert(type: .invalidRangeFormat)
            return
        }
        
        if maxInt <= minInt {
            showAlert(type: .invalidRangeValues)
            return
        }
        
        factService.getFactInRange(min: "\(minInt)", max: "\(maxInt)") { [weak self] result in
            switch result {
            case .success(let fact):
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: MainViewController.showTextFactsSegueIdentifier, sender: fact)
                }
            case .failure(_):
                self?.showAlert(type: .networkError)
            }
        }
    }
    
    private func showAlert(type: UIErrorConstants) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func fetchFactForNumber(_ number: String) {
        let type = "trivia"
        factService.getFact(number: number, type: type) { [weak self] result in
            switch result {
            case .success(let fact):
                DispatchQueue.main.async {
                    self?.performSegue(withIdentifier: "showTextFactsSegue", sender: fact)
                }
            case .failure(_):
                self?.showAlert(type: .networkError)
            }
        }
    }
    
    private func updateButtonStyle(selectedButton: UIButton) {
        let buttons = [userNumberButton,
                       randomNumberButton,
                       numberInRangeButton,
                       multipleNumbersButton]
        for button in buttons {
            if button === selectedButton {
                configureButton(button, with: ColorConstants.selectedButton, textColor: ColorConstants.selectedText)
            } else {
                configureButton(button, with: ColorConstants.unSelectedButton, textColor: ColorConstants.unselectedText)
            }
        }
    }
    
    private func configureButton(_ button: UIButton?, with color: UIColor, textColor: UIColor) {
        button?.backgroundColor = color
        button?.tintColor = textColor
    }
    
    private func updatePlaceholderText() {
        numberTextField.placeholder = selectedMode.placeholderText
    }
    
    private func updateSelectedMode(to newMode: SelectedMode, withButton button: UIButton) {
        selectedMode = newMode
        updateButtonStyle(selectedButton: button)
        resetNumberTextField()
        updatePlaceholderText()
        numberTextField.isUserInteractionEnabled = (newMode == .userNumber || newMode == .numberInRange || newMode == .multipleNumbers)
    }
    
    private func resetNumberTextField() {
        numberTextField.text = ""
    }
    
    @IBAction func displayFactButtonTapped(_ sender: UIButton) {
        switch selectedMode {
        case .userNumber, .multipleNumbers:
            fetchFactForUserNumber()
        case .randomNumber:
            fetchFactForRandomNumber()
        case .numberInRange:
            fetchFactForNumberInRange()
        }
    }
    
    @IBAction func userNumberButtonTapped(_ sender: Any) {
        updateSelectedMode(to: .userNumber, withButton: userNumberButton)
    }
    
    @IBAction func randomNumberButtonTapped(_ sender: Any) {
        updateSelectedMode(to: .randomNumber, withButton: randomNumberButton)
    }
    
    @IBAction func numberInARangeButtonTapped(_ sender: Any) {
        updateSelectedMode(to: .numberInRange, withButton: numberInRangeButton)
    }
    
    @IBAction func multipleNumbersButtonTapped(_ sender: Any) {
        updateSelectedMode(to: .multipleNumbers, withButton: multipleNumbersButton)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "0123456789,")
        let characterSet = CharacterSet(charactersIn: string)
        
        guard allowedCharacters.isSuperset(of: characterSet) else {
            return false
        }
        
        if selectedMode == .userNumber {
            return CharacterSet.decimalDigits.isSuperset(of: characterSet)
        }
        
        if selectedMode == .numberInRange {
            let futureText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            let commaCount = futureText.filter { $0 == "," }.count
            return commaCount <= 1 && futureText.count <= 10
        }
        
        return true
    }
}
