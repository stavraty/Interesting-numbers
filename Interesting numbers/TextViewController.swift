//
//  TextViewController.swift
//  Interesting numbers
//
//  Created by AS on 11.09.2023.
//

import UIKit

class TextViewController: UIViewController {
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var factTextView: UITextView!
    
    var factText: String?
    var numberText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.setTitle("", for: .normal)
        
        numberLabel.text = numberText
        factTextView.text = factText
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        print("closeButtonTapped")
    }
}
