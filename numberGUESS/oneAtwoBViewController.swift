//
//  oneAtwoBViewController.swift
//  numberGUESS
//
//  Created by Howe on 2023/10/22.
//

import UIKit

class oneAtwoBViewController: UIViewController {
    
    var gameNumber: [Int] = []
    
    var userNumbers: [Int] = []
    
    var resultRecord = ""
    
    var newRound: Bool = false
    
    var chancesPointsIndex = 11
    
    var index = -1
    
    @IBOutlet var DisplayedNumbersLabels: [UILabel]!
    @IBOutlet var chancesPointsImageViews: [UIImageView]!
    @IBOutlet weak var DisplayedTypedNumbersTextView: UITextView!
    @IBOutlet weak var announcementsTextView: UITextView!
    
    
    @IBOutlet var numbersButtonsOutlets: [UIButton]!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var confirmButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameStart()
        
        
        
    }
    // MARK: - viewDidLoad Done
    
    
    
    @IBAction func typeNumbers(_ sender: UIButton) {
        
        // 按鈕數字呈現
        if index < 3 {
            index += 1
            DisplayedNumbersLabels[index].text = sender.tag.description
        }
        
        // 將按過的數字按鈕關掉
        if DisplayedNumbersLabels[index].text!.contains(String(sender.tag)){
            sender.isEnabled = false
        }
    }
    
    
    
    @IBAction func confirmNumbers(_ sender: UIButton) {
        
        // 開啟新回合
        if newRound == true {
            newGameStart()
        } else {
            // 繼續猜下一組
            checkNumber()
        }
    }
    
    
    @IBAction func backNumbers(_ sender: UIButton) {
        
        /// 刪除目前號碼並回到上一個階段同時恢復被禁止的按鈕
        if index >= 0 {
            if let currentNumber = Int(DisplayedNumbersLabels[index].text!) {
                for numberButton in numbersButtonsOutlets {
                    if numberButton.tag == currentNumber {
                        numberButton.isEnabled = true
                    }
                }
            }
            DisplayedNumbersLabels[index].text = ""
            index -= 1
        }
        
    }
    
    
    
    // MARK: - Function Section
    
    func newGameStart() {
        
        // 重置索引
        index = -1
        
        // 重置1A2B數字
        gameNumber.removeAll()
        
        
        // 生成4個遊戲數字
        for _ in 0...3 {
            var randomNumber = Int.random(in: 0...9)
            
            // 如果數字已在password中則再隨機選取一次
            while gameNumber.contains(randomNumber) {
                randomNumber = Int.random(in: 0...9)
            }
            gameNumber.append(randomNumber)
        }
        print("THE GAME NUMBER IS : \(gameNumber)")
        
        
        // 淨空顯示數字
        for emptyWord in 0...3 {
            DisplayedNumbersLabels[emptyWord].text = ""
        }
        
        
        // 重新生成機會點數
        chancesPointsIndex = 11
        for points in 0...11 {
            // chancesPointsImageViews[points].image = UIImage(systemName: "circle.fill")
            chancesPointsImageViews[points].setSymbolImage(UIImage(systemName: "circle.fill")!, contentTransition: .replace.upUp, options: .speed(2))
        }
        
        // 重置鍵盤
        for restButton in numbersButtonsOutlets {
            restButton.isEnabled = true
        }
        
        
        // 清空號碼紀錄
        DisplayedTypedNumbersTextView.text = ""
        resultRecord = ""
        userNumbers.removeAll()
        
        // 重置公告
        announcementsTextView.text = "請開始輸入號碼"
        
        // 關閉重新開始按鈕
        newRound = false
        
        // 將按鈕圖案改回確認
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .unspecified, scale: .unspecified)
        if let image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: symbolConfig) {
            confirmButtonOutlet.setImage(image, for: .normal)
        }
        
    }
    
    
    
    func checkNumber() {
        
        // 沒填滿4格就返回
        if DisplayedNumbersLabels[3].text == "" { return }
        
        
        // 將4格內的數字記下
        for numberLabel in DisplayedNumbersLabels {
            userNumbers.append(Int(numberLabel.text!)!)
        }
        print("USER NUMBER IS: \(userNumbers)")
        
        // 計算 1A2B 數字
        var a = 0
        var b = 0
        
        for checkIndex in 0...3 {
            if userNumbers[checkIndex] == gameNumber[checkIndex] {
                a += 1
            } else if userNumbers.contains(gameNumber[checkIndex]) {
                b += 1
            }
        }
        
        // 顯示此回的數字與結果
        var recordString = ""
        for word in userNumbers {
            recordString += String(word)
        }
        resultRecord += "\(recordString)    \(a)A\(b)B\n"
        DisplayedTypedNumbersTextView.text = resultRecord
        
        
        // 機會點數索引減少一次
        chancesPointsIndex -= 1
        
        
        // 顯示機會點數減少
        chancesPointsImageViews[chancesPointsIndex + 1].setSymbolImage(UIImage(systemName: "circle.slash.fill")!, contentTransition: .replace.upUp, options: .speed(2))
        
        
        
        if a == 4 {
            // 顯示通關公告
            announcementsTextView.text = "恭喜！ 在第 \(chancesPointsImageViews.count - chancesPointsIndex - 1) 次解碼完成！"
            
            // 按鈕圖案換成重新開始
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .unspecified, scale: .unspecified)
            if let image = UIImage(systemName: "repeat.circle.fill", withConfiguration: symbolConfig) {
                confirmButtonOutlet.setImage(image, for: .normal)
            }
            
            // 關閉鍵盤
            for restButton in numbersButtonsOutlets {
                restButton.isEnabled = false
            }
            // 開啟新回合
            newRound = true
        } else {
            if chancesPointsIndex >= 0 {
                // 顯示局數通告
                announcementsTextView.text = "還剩下 \(chancesPointsIndex + 1) 次"
                
                // 重置鍵盤
                for restButton in numbersButtonsOutlets {
                    restButton.isEnabled = true
                }
                
                // 淨空顯示數字
                for emptyWord in 0...3 {
                    DisplayedNumbersLabels[emptyWord].text = ""
                }
                
                // 重置索引
                index = -1
                
                // 刪除使用者號碼陣列裡的數字
                userNumbers.removeAll()
                
                print("chancePoint\(chancesPointsIndex)")
            } else {
                // 按鈕圖案換成重新開始
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .unspecified, scale: .unspecified)
                if let image = UIImage(systemName: "repeat.circle.fill", withConfiguration: symbolConfig) {
                    confirmButtonOutlet.setImage(image, for: .normal)
                }
                
                // 宣告遊戲結束
                announcementsTextView.text = "遊戲結束請重新開始"
                
                // 關閉鍵盤
                for restButton in numbersButtonsOutlets {
                    restButton.isEnabled = false
                }
                
                // 開啟新回合
                newRound = true
            }
        }
    }
    

}
