//
//  GuessViewController.swift
//  numberGUESS
//
//  Created by Howe on 2023/10/24.
//

import UIKit

class GuessViewController: UIViewController {
    
    var gameNumber = Int()
    
    var newRound = false
    
    var chancePointsIndex = 5
    
    var maxNumber = 99
    var minNumber = 1
    
    var userNumber: Int?
    
    var recordNumber: [Int] = [0]
    
    
    @IBOutlet weak var inputNumberTextField: UITextField!
    
    @IBOutlet var chancePointsImageViews: [UIImageView]!
    
    @IBOutlet weak var announcementsLabel: UILabel!
    
    @IBOutlet weak var compareButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGame()
        
        
    }
    // MARK: - viewDidLoad Done
    
    
    
    @IBAction func compareGO(_ sender: UIButton) {
        
        if newRound == true {
            newGame()
        } else {
            compareNumber()
        }
        
        
    }
    
    
    // MARK: - Function Section
    
    // 新局開始
    func newGame() {
        
        gameNumber = Int.random(in: 1...99)
        print("gameNumber is : \(gameNumber)")
        
        newRound = false
        
        chancePointsIndex = 5
        for restore in 0...5 {
            chancePointsImageViews[restore].setSymbolImage(UIImage(systemName: "circle.fill")!, contentTransition: .replace.upUp, options: .speed(2))
        }
        
        announcementsLabel.text = "請輸入 1 ~ 99 之間的數字"
        
        inputNumberTextField.text = ""
        
        maxNumber = 99
        minNumber = 1
        
        compareButtonOutlet.setTitle("GO", for: .normal)
        
        inputNumberTextField.isEnabled = true
        
        recordNumber = [0]
        
    }
    
    
    // 比較數字
    func compareNumber(){
        
        if let inputNumber = inputNumberTextField.text {
            userNumber = Int(inputNumber)
            
            if userNumber == nil { return }
            
            if recordNumber.contains(userNumber!) {
                announcementsLabel.text = "不要輸入一樣的數字 \n \(minNumber) ~ \(maxNumber)"
                return
            }
            
            if userNumber! > 0 && userNumber! <= 99 {
                
                recordNumber.append(userNumber!)
                
                chancePointsIndex -= 1
                chancePointsImageViews[chancePointsIndex + 1].setSymbolImage(UIImage(systemName: "circle.slash.fill")!, contentTransition: .replace.upUp, options: .speed(2))
                
                if userNumber! > gameNumber {
                    maxNumber = userNumber!
                    announcementsLabel.text = "你這個數字偏大 \n \(minNumber) ~ \(maxNumber)"
                    inputNumberTextField.text = ""
                }
                
                if userNumber! < gameNumber {
                    minNumber = userNumber!
                    announcementsLabel.text = "你這個數字偏小 \n \(minNumber) ~ \(maxNumber)"
                    inputNumberTextField.text = ""
                }
                
                if userNumber! == gameNumber {
                    announcementsLabel.text = "恭喜你！在第\(chancePointsImageViews.count - chancePointsIndex - 1)次答對"
                    compareButtonOutlet.setTitle("重來", for: .normal)
                    inputNumberTextField.isEnabled = false
                    newRound = true
                }
                print("chancePoint: \(chancePointsIndex)")
                if chancePointsIndex == -1 {
                    announcementsLabel.text = "你沒了，重來吧"
                    compareButtonOutlet.setTitle("重來", for: .normal)
                    inputNumberTextField.isEnabled = false
                    newRound = true
                }
            }
        }
        
        
        
        
    }
    
    
    
}
