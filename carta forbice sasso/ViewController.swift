//
//  ViewController.swift
//  carta forbice sasso
//
//  Created by Massimiliano Allegretti on 24/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var computerImageView: UIImageView!
    
    @IBOutlet weak var cartaImageView: UIImageView!
    @IBOutlet weak var forbicemageView: UIImageView!
    @IBOutlet weak var sassoImageView: UIImageView!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelInfo: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = nil
        
        let cartaTap = UITapGestureRecognizer(target: self, action: #selector(cartaTap))
        cartaImageView.addGestureRecognizer(cartaTap)
        cartaImageView.isUserInteractionEnabled = true
        cartaImageView.alpha = 0.5
        
        let forbiceTap = UITapGestureRecognizer(target: self, action: #selector(forbiceTap))
        forbicemageView.addGestureRecognizer(forbiceTap)
        forbicemageView.isUserInteractionEnabled = true
        forbicemageView.alpha = 0.5
        
        
        let sassoTap = UITapGestureRecognizer(target: self, action: #selector(sassoTap))
        sassoImageView.addGestureRecognizer(sassoTap)
        sassoImageView.isUserInteractionEnabled = true
        sassoImageView.alpha = 0.5
        
        showLabelInfo()
    }
    
    @objc func cartaTap() {
        cartaImageView.alpha = 1
        forbicemageView.alpha = 0.5
        sassoImageView.alpha = 0.5
        self.startGame(player: .carta)
    }
    
    @objc func forbiceTap() {
        cartaImageView.alpha = 0.5
        forbicemageView.alpha = 1.0
        sassoImageView.alpha = 0.5
        self.startGame(player: .forbice)
    }
    
    @objc func sassoTap() {
        cartaImageView.alpha = 0.5
        forbicemageView.alpha = 0.5
        sassoImageView.alpha = 1.0
        self.startGame(player: .sasso)
    }
    
    private func startGame(player: Gioco) {
        let randomInt = Int.random(in: 0..<3)
        var computer: Gioco
        if randomInt == 0 {
            computer = .carta
        }else if randomInt == 1 {
            computer = .forbice
        }else {
            computer = .sasso
        }
        
        var haVinto = false
        let pareggio = player == computer
        
        if !pareggio {
            if player == .carta && computer == .sasso {
                haVinto = true
            }else if player == .forbice && computer == .carta {
                haVinto = true
            }else if player == .sasso && computer == .forbice {
                haVinto = true
            }
        }
        
        self.playerImageView.image = Gioco.sasso.getImage()
        self.computerImageView.image = Gioco.sasso.getImage()
        
        let repeatCount = 3.0
        let duration = 2.0 / repeatCount / 10.0
        self.playerImageView.shake(duration: duration, repeatCount: Float(repeatCount))
        self.computerImageView.shake(duration: duration, repeatCount: Float(repeatCount))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.5) {
            
            let totale = self.getTotale() + 1
            var vittorie = self.getVittorie()
            
            if pareggio {
                self.label.text = "AVETE PAREGGIATO!"
            }else if haVinto {
                self.label.text = "HAI VINTO! 😃"
                vittorie += 1
            }else {
                self.label.text = "HAI PERSO! 😔"
            }
            
            self.playerImageView.image = player.getImage()
            self.computerImageView.image = computer.getImage()
            
           

            self.salva(totale: totale, vittorie: vittorie)
            self.showLabelInfo()
        }
        
    }
    
    private func getTotale() -> Int {
        return UserDefaults.standard.integer(forKey: "totale")
    }
    
    private func getVittorie() -> Int {
        return UserDefaults.standard.integer(forKey: "vittorie")
    }
    
    private func salva(totale: Int, vittorie: Int) {
        UserDefaults.standard.set(totale, forKey: "totale")
        UserDefaults.standard.set(vittorie, forKey: "vittorie")
    }
    
    private func showLabelInfo() {
        let totale = getTotale()
        let vittorie = getVittorie()

        labelInfo.text = "Partite giocate: \(totale) - Vittorie: \(vittorie)"
    }
    
}

enum Gioco {
    case carta
    case forbice
    case sasso
    
    func getImage() -> UIImage {
        switch self {
        case .carta:
            return UIImage(named: "carta")!
        case .forbice:
            return UIImage(named: "forbice")!
        case .sasso:
            return UIImage(named: "sasso")!
        }
    }
}

extension UIView {
    func shake(duration: Double, repeatCount: Float) {
        let anim = CABasicAnimation(keyPath: "position")
        anim.duration = duration
        anim.repeatCount = repeatCount
        anim.autoreverses = true
        anim.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        anim.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(anim, forKey: "position")
    }
}


