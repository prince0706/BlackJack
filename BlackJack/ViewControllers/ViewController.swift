//
//  ViewController.swift
//  BlackJack
//
//  Created by Prince on 2020-08-16.
//  Copyright © 2020 Prince. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dealerHandCollectionView: UICollectionView!
    @IBOutlet weak var playerHandCollectionView: UICollectionView!
    @IBOutlet weak var playerSplittedHandLabel: UILabel!
    @IBOutlet weak var playerSplitHandCollectionView: UICollectionView!
    
    @IBOutlet weak var standButton: UIButton!
    @IBOutlet weak var splitButton: UIButton!
    
    @IBOutlet weak var splittedPlayerSplitButton: UIButton!
    @IBOutlet weak var splittedPlayerActions: UIStackView!
    @IBOutlet weak var PlayerActions: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CardManager.shared.delegate = self
        CardManager.shared.playGame()
    }
    
    // MARK:- Action Delegate Methods
    
    @IBAction func hitButtonTapped(_ sender: Any) {
        CardManager.shared.getPlayerCard()
        if CardManager.shared.checkIfHandIsMoreThan21(cards: CardManager.shared.playerCards) {
            CardManager.shared.firstHandAction = .stand
            showAlertViewWithMessageAndActionHandler(nil, message: "Player lose") {
                if CardManager.shared.splittedCards.count == 0 {
                    CardManager.shared.reloadGame()
                }
            }
        }
 
        splitButton.isEnabled = false
    }
    
    @IBAction func standButtonTapped(_ sender: Any) {
        standButton.isEnabled = false
        PlayerActions.isUserInteractionEnabled = false
        CardManager.shared.doStandFunction(checkSecondHand: true)
    }
    
    @IBAction func splitButtonTapped(_ sender: Any) {
        CardManager.shared.doSplitFunction()
    }
    
    @IBAction func surrenderButtonTapped(_ sender: Any) {
        showAlertViewWithMessageAndActionHandler(nil, message: "Game surrendered for first hand") {
            CardManager.shared.firstHandAction = .surrender
            self.PlayerActions.isUserInteractionEnabled = false
            if (CardManager.shared.splittedCards.count > 0 && CardManager.shared.splittedHandAction == .stand) {
                CardManager.shared.doStandFunctionForSplittedCards(checkSecondHand: false)
                } else if CardManager.shared.splittedCards.count == 0 {
                CardManager.shared.reloadGame()
            }
        }
    }
    
    // MARK:- Splitted Player Actions
    
    @IBAction func spliitedPlayerHitButtonTapped(_ sender: Any) {
        CardManager.shared.getPlayerSplitCard()
        if CardManager.shared.checkIfHandIsMoreThan21(cards: CardManager.shared.splittedCards) {
            CardManager.shared.splittedHandAction = .stand
            showAlertViewWithMessageAndActionHandler(nil, message: "Splitted player lose") {
                if CardManager.shared.firstHandAction == .stand {
                    CardManager.shared.reloadGame()
                }
            }
        }

        splittedPlayerSplitButton.isEnabled = false
    }
    
    @IBAction func spliitedPlayerStandButtonTapped(_ sender: Any) {
        splittedPlayerActions.isUserInteractionEnabled = false
        CardManager.shared.doStandFunctionForSplittedCards(checkSecondHand: true)
    }
    
    @IBAction func spliitedPlayerSplitButtonTapped(_ sender: Any) {
        //not allowed in splitted hand
    }
    
    @IBAction func spliitedPlayerSurrenderButtonTapped(_ sender: Any) {
        showAlertViewWithMessageAndActionHandler(nil, message: "Game surrendered for splitted player") {
            CardManager.shared.splittedHandAction = .surrender
            self.splittedPlayerActions.isUserInteractionEnabled = false
            switch CardManager.shared.firstHandAction {
            case .surrender, .none, .hit, .split:
                CardManager.shared.reloadGame()
            case .stand:
                CardManager.shared.doStandFunction(checkSecondHand: false)
            }
        }
    }
    
}

