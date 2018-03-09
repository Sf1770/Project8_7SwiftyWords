//
//  ViewController.swift
//  7SwiftyWords
//
//  Created by Sabrina Fletcher on 2/15/18.
//  Copyright © 2018 Sabrina Fletcher. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLbl: UILabel!
    @IBOutlet weak var answersLbl: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoresLbl: UILabel!
    @IBOutlet weak var buttonsRW1: UIStackView!
    @IBOutlet weak var buttonsRW2: UIStackView!
    @IBOutlet weak var buttonsRW3: UIStackView!
    @IBOutlet weak var buttonsRW4: UIStackView!
    
    
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet{
            scoresLbl.text = "Score: \(score)"
        }
    }
    var level = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for view in buttonsRW1.subviews{
            let btn = view as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        for view in buttonsRW2.subviews{
            let btn = view as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        for view in buttonsRW3.subviews{
            let btn = view as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        for view in buttonsRW4.subviews{
            let btn = view as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        }
        loadLevel()
        
    }
    
    func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt"){
            
            if let levelContents = try? String(contentsOfFile: levelFilePath){
                
                var lines = levelContents.components(separatedBy: "\n")
                
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
                
                for (index, line) in lines.enumerated() {
                    
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        for i in 0 ..< letterBits.count{
            print(letterBits[i])
        }
        
        cluesLbl.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLbl.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
    }
    
    
    
    @objc func letterTapped(btn: UIButton){
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.isHidden = true
    }

    @IBAction func submitTapped(_ sender: UIButton) {
        if let solutionPosition = solutions.index(of: currentAnswer.text!){
            activatedButtons.removeAll()
            var splitAnswers = answersLbl.text!.components(separatedBy: "\n")
            splitAnswers[solutionPosition] = currentAnswer.text!
            answersLbl.text = splitAnswers.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well Done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
        
    }
    
    func levelUp(action:UIAlertAction){
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in letterButtons{
            btn.isHidden = false
        }
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for btn in activatedButtons{
            btn.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    
}

