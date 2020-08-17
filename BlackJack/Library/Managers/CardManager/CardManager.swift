//
//  CardManager.swift
//  BlackJack
//
//  Created by Prince on 2020-08-16.
//  Copyright © 2020 Prince. All rights reserved.
//

import UIKit

protocol CardManagerDelegate: class {
    func reloadCollection(collectionType: CollectionType)
    func reloadGame()
    func unhideSplit()
    func disableActions(collectionType: CollectionType)
}

class CardManager {
    
    static let shared = CardManager()
    weak var delegate: CardManagerDelegate?

    var deck = [Card]()
    
    var dealerCards = [Card]()
    var playerCards = [Card]()
    var splittedCards = [Card]()
    var firstHandAction: PlayerAction = .none
    var splittedHandAction: PlayerAction = .none

    var showSecondAlert = false

    private init(){
        initializeDeckOfCards()
    }
    
    private func getRandomCard() -> Card? {
        return deck.randomElement()
    }

    private func initializeDeckOfCards() {
        deck.removeAll()
        var cards = [Card]()
        for value in Card.allCases {
            cards.append(value)
        }

        for _ in 0..<8 {        //for 8 standard decks
            deck += cards
        }
        
        deck.shuffle()
    }
    
    // MARK:- Logic Methods for game
    
    func playGame() {
        delegate?.reloadGame()
        //single card for dealer
        getDealerCard()
        //two cards for player
        getPlayerCard()
        getPlayerCard()
        //check rules
        checkRules(againstDealerCards: playerCards, isSplittedPlayer: false)
    }

    private func getDealerCard() {
        if let card = getRandomCard() {
            dealerCards.append(card)
            if let index = deck.firstIndex(of: card) {
                deck.remove(at: index)
            }
            delegate?.reloadCollection(collectionType: .dealer)
        }
    }
    
    func getPlayerCard() {
        if let card = getRandomCard() {
            self.playerCards.append(card)
            if let index = deck.firstIndex(of: card) {
                deck.remove(at: index)
            }
            delegate?.reloadCollection(collectionType: .player)
        }
    }
    
    func getPlayerSplitCard() {
        if let card = getRandomCard() {
            self.splittedCards.append(card)
            if let index = deck.firstIndex(of: card) {
                deck.remove(at: index)
            }
            delegate?.reloadCollection(collectionType: .split)
        }
    }
    
    func checkRules(againstDealerCards: [Card], isSplittedPlayer: Bool) {
        let playerHandValue = getHandValue(cards: againstDealerCards)
        let dealerHandValue = getHandValue(cards: dealerCards)
        let playerBlackJack = checkCardsForBlackJack(cards: againstDealerCards)
        let dealerBlackJack = checkCardsForBlackJack(cards: dealerCards)
        var player = ""
        var against = ""
        if isSplittedPlayer {
            player = "Splitted player "
            against = " against Splitted player"
        } else {
            player = "Player "
            against = " against player"
        }
        
        if ((playerHandValue == dealerHandValue) && dealerHandValue >= 17 && playerHandValue <= 21) || (playerBlackJack && dealerBlackJack) {
            showAlert(message: "Push no one wins" + against, isSplittedPlayer: isSplittedPlayer)
        } else if playerBlackJack {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showAlert(message: "BLACKJACK " + player + "wins", isSplittedPlayer: isSplittedPlayer)
            }
        } else if checkIfHandIsMoreThan21(cards: againstDealerCards) {
            showAlert(message: player + "lose", isSplittedPlayer: isSplittedPlayer)
        } else if checkIfHandIsMoreThan21(cards: dealerCards) {
            showAlert(message: "Dealer lose" + against, isSplittedPlayer: isSplittedPlayer)
        } else if playerHandValue > dealerHandValue && dealerHandValue >= 17 {
            showAlert(message: player + "wins", isSplittedPlayer: isSplittedPlayer)
        } else if dealerHandValue > playerHandValue && dealerHandValue >= 17  {
            showAlert(message: "Dealer wins" + against, isSplittedPlayer: isSplittedPlayer)
        }
    }
    
    private func showAlert(message: String, isSplittedPlayer: Bool) {
        if isSplittedPlayer {
            splittedHandAction = .stand
            self.delegate?.disableActions(collectionType: .split)
        } else {
            firstHandAction = .stand
            self.delegate?.disableActions(collectionType: .player)
        }
        UIApplication.shared.windows.first?.rootViewController?.showAlertViewWithMessageAndActionHandler(nil, message: message) {
            if self.showSecondAlert {
                self.showSecondAlert = false
                if isSplittedPlayer {
                    self.doStandFunction(checkSecondHand: false)
                } else {
                    if self.splittedCards.count > 0 {
                        self.doStandFunctionForSplittedCards(checkSecondHand: false)
                    }
                }
            } else {
                self.reloadGame()
            }
        }
    }
    
    func reloadGame() {
        //Needs to complete both hands before reload of the game
        if (firstHandAction == .stand || firstHandAction == .surrender) && ((splittedCards.count > 0 && (splittedHandAction == .stand || splittedHandAction == .surrender)) || (splittedCards.count == 0)) {
            print("Game reloaded")
            initializeDeckOfCards()
            playerCards.removeAll()
            dealerCards.removeAll()
            splittedCards.removeAll()
            delegate?.reloadGame()
            firstHandAction = .none
            splittedHandAction = .none
            showSecondAlert = false
            playGame()
        }
    }
    
    // MARK:- Stand Action
    
    func doStandFunction(checkSecondHand: Bool) {
        firstHandAction = .stand
        if splittedCards.count > 0 && splittedHandAction == .none {
            //don't end game as splitted hand is left
            //and don't open dealer cards until split hand is also done with stand
            UIApplication.shared.windows.first?.rootViewController?.showAlertViewWithMessage(nil, message: "Please make a stand on splitted hand of player")
            return
        }
        
        var dealerHandValue = getHandValue(cards: dealerCards)
        while dealerHandValue <= 17 {
            if let card = getRandomCard() {
                self.dealerCards.append(card)
                dealerHandValue = self.getHandValue(cards: self.dealerCards)
                delegate?.reloadCollection(collectionType: .dealer)
            }
        }
        if splittedCards.count > 0 && splittedHandAction != .surrender {
            showSecondAlert = checkSecondHand
        }
        
        checkRules(againstDealerCards: playerCards, isSplittedPlayer: false)
    }
    
    func doStandFunctionForSplittedCards(checkSecondHand: Bool) {
        splittedHandAction = .stand
        if firstHandAction == .none {
            UIApplication.shared.windows.first?.rootViewController?.showAlertViewWithMessage(nil, message: "Please make a stand on First hand of player")
            return
        }
        var dealerHandValue = getHandValue(cards: dealerCards)
        while dealerHandValue <= 17 {
            if let card = getRandomCard() {
                self.dealerCards.append(card)
                dealerHandValue = self.getHandValue(cards: self.dealerCards)
                delegate?.reloadCollection(collectionType: .dealer)
            }
        }
        
        if firstHandAction != .surrender {
            showSecondAlert = checkSecondHand
        }
        checkRules(againstDealerCards: splittedCards, isSplittedPlayer: true)
    }
    
    // MARK:- Split Action
    
    func doSplitFunction() {
        // no need to check for indexOutOfBound because player always have atleast two cards
        if checkSplit() {
            let card = playerCards.removeLast()
            splittedCards.append(card)
            //adding one card in player and split after split s per rules
            delegate?.unhideSplit()
            getPlayerCard()
            getPlayerSplitCard()
        } else {
            UIApplication.shared.windows.first?.rootViewController?.showAlertViewWithMessage(nil, message: "Split not allowed")
        }
    }
    
    private func checkSplit() -> Bool {
        // no need to check for indexOutOfBound because player always have atleast two cards
        let firstCard = playerCards[0]
        let secondCard = playerCards[1]
        switch firstCard {
        case .aceClub, .aceHeart, .aceSpade, .aceDiamond:
            switch secondCard {
            case .aceClub, .aceHeart, .aceSpade, .aceDiamond:
                return true
            default:
                return false
            }
        case .twoClub, .twoHeart, .twoSpade, .twoDiamond:
            switch secondCard {
            case .twoClub, .twoHeart, .twoSpade, .twoDiamond:
                return true
            default:
                return false
            }
        case .threeClub, .threeHeart, .threeSpade, .threeDiamond:
            switch secondCard {
            case .threeClub, .threeHeart, .threeSpade, .threeDiamond:
                return true
            default:
                return false
            }
        case .fourClub, .fourHeart, .fourSpade, .fourDiamond:
            switch secondCard {
            case .fourClub, .fourHeart, .fourSpade, .fourDiamond:
                return true
            default:
                return false
            }
        case .fiveClub, .fiveHeart, .fiveSpade, .fiveDiamond:
            switch secondCard {
            case .fiveClub, .fiveHeart, .fiveSpade, .fiveDiamond:
                return true
            default:
                return false
            }
        case .sixClub, .sixHeart, .sixSpade, .sixDiamond:
            switch secondCard {
            case .sixClub, .sixHeart, .sixSpade, .sixDiamond:
                return true
            default:
                return false
            }
        case .sevenClub, .sevenHeart, .sevenSpade, .sevenDiamond:
            switch secondCard {
            case .sevenClub, .sevenHeart, .sevenSpade, .sevenDiamond:
                return true
            default:
                return false
            }
        case .eightClub, .eightHeart, .eightSpade, .eightDiamond:
            switch secondCard {
            case .eightClub, .eightHeart, .eightSpade, .eightDiamond:
                return true
            default:
                return false
            }
        case .nineClub, .nineHeart, .nineSpade, .nineDiamond:
            switch secondCard {
            case .nineClub, .nineHeart, .nineSpade, .nineDiamond:
                return true
            default:
                return false
            }
        //Considering casino will not allow for split wih diff 10 value cards
        case .tenClub, .tenHeart, .tenSpade, .tenDiamond:
            switch secondCard {
            case .tenClub, .tenHeart, .tenSpade, .tenDiamond:
                return true
            default:
                return false
            }
        case .jackClub, .jackHeart, .jackSpade, .jackDiamond:
            switch secondCard {
            case .jackClub, .jackHeart, .jackSpade, .jackDiamond:
                return true
            default:
                return false
            }
        case .queenClub, .queenHeart, .queenSpade, .queenDiamond:
            switch secondCard {
            case .queenClub, .queenHeart, .queenSpade, .queenDiamond:
                return true
            default:
                return false
            }
        case .kingClub, .kingHeart, .kingSpade, .kingDiamond:
            switch secondCard {
            case .kingClub, .kingHeart, .kingSpade, .kingDiamond:
                return true
            default:
                return false
            }
        }
    }
    
    // MARK:- BlackJack check Methods
    
    private func checkCardsForBlackJack(cards: [Card]) -> Bool {
        if cards.count > 1 {
            return checkBlackJack(card1: cards[0], card2: cards[1])
        }
        
        return false
    }
    
    private func checkBlackJack(card1: Card, card2: Card) -> Bool {
        if checkIfCardIsAnAce(card: card1) && checkIfCardIsATenValueCard(card: card2) {
            return true
        } else if checkIfCardIsAnAce(card: card2) && checkIfCardIsATenValueCard(card: card1) {
            return true
        }
        
        return false
    }
    
    private func checkIfCardIsAnAce(card: Card) -> Bool {
        return (card == .aceClub || card == .aceHeart || card == .aceSpade || card == .aceDiamond) ? true : false
    }
    
    private func checkIfCardIsATenValueCard(card: Card) -> Bool {
        return (card == .tenClub || card == .jackClub || card == .queenClub || card == .kingClub || card == .tenHeart || card == .jackHeart || card == .queenHeart || card == .kingHeart || card == .tenSpade || card == .jackSpade || card == .queenSpade || card == .kingSpade || card == .tenDiamond || card == .jackDiamond || card == .queenDiamond || card == .kingDiamond) ? true : false
    }
    
    // MARK:- More than 21 check Methods

    func checkIfHandIsMoreThan21(cards: [Card]) -> Bool {
        return getHandValue(cards: cards) > 21 ? true : false
    }
    
    private func getHandValue(cards: [Card]) -> Int {
        var currentValue = 0
        for card in cards {
            let tenValue = checkIfCardIsATenValueCard(card: card) ? 10 : 0
            let cardValue = getValueOfCard(card: card)
            currentValue += tenValue + cardValue
        }
        
        //Add ace value according to currentValue
        currentValue = getValueAfterAceCard(cards: cards, currentValue: currentValue)
        return currentValue
    }
    
    private func getValueOfCard(card: Card) -> Int {
        switch card {
        case .twoClub, .twoHeart, .twoSpade, .twoDiamond:
            return 2
        case .threeClub, .threeHeart, .threeSpade, .threeDiamond:
            return 3
        case .fourClub, .fourHeart, .fourSpade, .fourDiamond:
            return 4
        case .fiveClub, .fiveHeart, .fiveSpade, .fiveDiamond:
            return 5
        case .sixClub, .sixHeart, .sixSpade, .sixDiamond:
            return 6
        case .sevenClub, .sevenHeart, .sevenSpade, .sevenDiamond:
            return 7
        case .eightClub, .eightHeart, .eightSpade, .eightDiamond:
            return 8
        case .nineClub, .nineHeart, .nineSpade, .nineDiamond:
            return 9
        default:
            return 0
        }
    }
    
    private func getValueAfterAceCard(cards: [Card], currentValue: Int) -> Int {
        var currentValue = currentValue
        let filtered = cards.filter { (card) -> Bool in
            if card == .aceClub || card == .aceHeart || card == .aceSpade || card == .aceDiamond {
                return true
            } else {
                return false
            }
        }

        switch filtered.count {
        case 1:
            if currentValue < 11 {
                currentValue += 11
            } else {
                currentValue += 1
            }
        case 2:
            if currentValue < 10 {
                currentValue += 11 + 1
            } else {
                currentValue += 1 + 1
            }
        case 3:
            if currentValue < 9 {
                currentValue += 11 + 1 + 1
            } else {
                currentValue += 1 + 1 + 1
            }
        case 4:
            if currentValue < 8 {
                currentValue += 11 + 1 + 1 + 1
            } else {
                currentValue += 1 + 1 + 1 + 1
            }
        case 5:
            if currentValue < 7 {
                currentValue += 11 + 1 + 1 + 1 + 1
            } else {
                currentValue += 1 + 1 + 1 + 1 + 1
            }
        case 6:
            if currentValue < 6 {
                currentValue += 11 + 1 + 1 + 1 + 1 + 1
            } else {
                currentValue += 1 + 1 + 1 + 1 + 1 + 1
            }
        case 7:
            if currentValue < 5 {
                currentValue += 11 + 1 + 1 + 1 + 1 + 1 + 1
            } else {
                currentValue += 1 + 1 + 1 + 1 + 1 + 1 + 1
            }
        case 8:
            if currentValue < 8 {
                currentValue += 11 + 1 + 1 + 1 + 1 + 1 + 1 + 1
            } else {
                currentValue += 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1
            }
        default:
            break
        }
        
        return currentValue
    }
}
