//
//  ViewController.swift
//  SampleQuiz
//
//  Created by SHIZUKA KUROSAWA on 2022/01/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        枠線の太さ
        startButton.layer.borderWidth = 2
//        枠線の色を指定
        startButton.layer.borderColor = UIColor.black.cgColor
    }


}

