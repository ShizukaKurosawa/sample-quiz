//
//  QuizViewController.swift
//  SampleQuiz
//
//  Created by SHIZUKA KUROSAWA on 2022/01/21.
//

import UIKit
import GoogleMobileAds

class QuizViewController: UIViewController {
    @IBOutlet weak var quizNumberLabel: UILabel!
    @IBOutlet weak var quizTextView: UITextView!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var judgeImageView: UIImageView!
    
    var bannerView: GADBannerView!
    var csvArray: [String] = []
    var quizArray: [String] = []
    var quizCount = 0
    var correctCount = 0
    var selectLevel = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        addBannerViewToView(bannerView)
        
        print("選択肢たのは、レベル\(selectLevel)")
        
        csvArray = loadCSV(fileName: "quiz\(selectLevel)")
        
//        print("🟥シャッフル前: \(csvArray)\n")
//        問題をシャッフルする
        csvArray.shuffle()
//        print("🟩シャッフル後: \(csvArray)")
        
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        quizNumberLabel.text = "第\(quizCount + 1)問"
//        quizArray([問題文, 正解, 選択肢1, 選択肢2, 選択肢3, 選択肢4])
//        問題文を取得
        quizTextView.text = quizArray[0]
//        選択肢の1番目を取得
        answerButton1.setTitle(quizArray[2], for: .normal)
//        選択肢の2番目を取得
        answerButton2.setTitle(quizArray[3], for: .normal)
//        選択肢の3番目を取得
        answerButton3.setTitle(quizArray[4], for: .normal)
//        選択肢の4番目を取得
        answerButton4.setTitle(quizArray[5], for: .normal)
        
        answerButton1.layer.borderWidth = 2
        answerButton1.layer.borderColor = UIColor.black.cgColor
        answerButton2.layer.borderWidth = 2
        answerButton2.layer.borderColor = UIColor.black.cgColor
        answerButton3.layer.borderWidth = 2
        answerButton3.layer.borderColor = UIColor.black.cgColor
        answerButton4.layer.borderWidth = 2
        answerButton4.layer.borderColor = UIColor.black.cgColor

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        let scoreVC = segue.destination as! ScoreViewController
        scoreVC.correct = correctCount
    }
    
//    ボタンを押したときに呼ばれる
    @IBAction func btnAction(sender: UIButton) {
        if sender.tag == Int(quizArray[1]) {
            correctCount += 1
            print("正解")
            judgeImageView.image = UIImage(named: "correct")
        } else {
            print("不正解")
            judgeImageView.image = UIImage(named: "incorrect")
        }
        print("スコア: \(correctCount)")
//        2問目以降も○×を表示するようにする
        judgeImageView.isHidden = false
//        ○×ボタンが非表示になるまでボタンを押せなくする
        answerButton1.isEnabled = false
        answerButton2.isEnabled = false
        answerButton3.isEnabled = false
        answerButton4.isEnabled = false
//        0.5秒後に不表示にする
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.judgeImageView.isHidden = true
            self.answerButton1.isEnabled = true
            self.answerButton2.isEnabled = true
            self.answerButton3.isEnabled = true
            self.answerButton4.isEnabled = true
//            ○×が非表示になってから次の問題をセットする
            self.nextQuiz()
        }
    }
    
    func nextQuiz() {
        quizCount += 1
        if quizCount < csvArray.count {
        quizArray = csvArray[quizCount].components(separatedBy: ",")
        quizNumberLabel.text = "第\(quizCount + 1)門"
        quizTextView.text = quizArray[0]
        answerButton1.setTitle(quizArray[2], for: .normal)
        answerButton2.setTitle(quizArray[3], for: .normal)
        answerButton3.setTitle(quizArray[4], for: .normal)
        answerButton4.setTitle(quizArray[5], for: .normal)
        } else {
            performSegue(withIdentifier: "toScoreVC", sender: nil)
        }
    }
    
    func loadCSV(fileName: String) -> [String] {
        let csvBundle = Bundle.main.path(forResource: fileName, ofType: "csv")!
        do {
            let csvData = try String(contentsOfFile: csvBundle, encoding: String.Encoding.utf8)
            let lineChange = csvData.replacingOccurrences(of: "\r", with: "\n")
            csvArray = lineChange.components(separatedBy: "\n")
            csvArray.removeLast()
        } catch {
            print("error")
        }
        return csvArray
    }
    
//    広告を表示させる
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
