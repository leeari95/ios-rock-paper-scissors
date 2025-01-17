//
//  RockPaperScissors - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

enum Message: String, CustomStringConvertible {
    case start = "가위(1), 바위(2), 보(3)! <종료: 0> : "
    case gameWin = "이겼습니다!"
    case gameLose = "졌습니다!"
    case gameDraw = "비겼습니다!"
    case gameEnd = "게임 종료"
    case wrongInput = "잘못된 입력입니다. 다시 시도해주세요."
    case startRockScissorsPaper = "묵(1), 찌(2), 빠(3)! <종료 : 0> : "
    
    var description: String {
        return rawValue
    }
}

enum GameMode {
    case scissorsRockPaper
    case rockScissorsPaper
}

enum PlayerOption: CaseIterable {
    case quit
    case scissor
    case rock
    case paper
    
    static var randomHand: PlayerOption {
        let handCount = PlayerOption.allCases.count
        return PlayerOption.allCases[Int.random(in: 1..<handCount)]
    }
}

enum Turn: String, CustomStringConvertible{
    case quit
    case playersTurn = "사용자"
    case computersTurn = "컴퓨터"
    
    var description: String {
        return rawValue
    }
}

struct GameManager {
    func isRestartable(mode: GameMode, _ playerHand: PlayerOption?, _ opponentHand: PlayerOption) -> Bool {
        let isHandSame = playerHand == opponentHand
        switch (mode, isHandSame) {
        case (.scissorsRockPaper, true):
            print(Message.gameDraw)
            return true
        case (.rockScissorsPaper, false):
            return true
        default:
            return false
        }
    }
    
    func decideTurn(_ playerHand: PlayerOption?, _ opponentHand: PlayerOption) -> Turn {
        switch (playerHand, opponentHand) {
        case (.scissor, .paper), (.rock, .scissor), (.paper, .rock):
            return .playersTurn
        default:
            return .computersTurn
        }
    }
    
    func isWrongInput(playerHand: PlayerOption?) -> Bool { playerHand == nil }
}

struct ScissorsRockPaperGame {
    private let gameManager = GameManager()
    
    func playScissorsRockPaper() -> Turn {
        var playerHand: PlayerOption?
        var computerHand: PlayerOption
        
        repeat {
            computerHand = PlayerOption.randomHand
            print(Message.start, terminator: "")
            playerHand = recieveUserInput()
        } while gameManager.isRestartable(mode: .scissorsRockPaper, playerHand, computerHand) || gameManager.isWrongInput(playerHand: playerHand)
        
        guard playerHand != .quit else {
            print(Message.gameEnd)
            return .quit
        }
        let turn = gameManager.decideTurn(playerHand, computerHand)
        printGameResult(turn)
        return turn
    }
    
    private func recieveUserInput(_ userInput: String? = readLine()) -> PlayerOption? {
        switch userInput {
        case "0":
            return .quit
        case "1":
            return .scissor
        case "2":
            return .rock
        case "3":
            return .paper
        default:
            print(Message.wrongInput)
            return nil
        }
    }
    
    private func printGameResult(_ turn: Turn) {
        if turn == .playersTurn {
            print(Message.gameWin)
        } else {
            print(Message.gameLose)
        }
    }
}

struct RockScissorsPaperGame {
    private let gameManager = GameManager()
    private var currentTurnHolder: Turn = ScissorsRockPaperGame().playScissorsRockPaper()
    
    mutating func startGame() {
        guard currentTurnHolder != .quit else { return }
        
        var playerHand: PlayerOption?
        var computerHand: PlayerOption
        var isContinued = false
        
        repeat {
            computerHand = PlayerOption.randomHand
            changeTurn(when: &isContinued, playerHand, computerHand)
            print("[\(currentTurnHolder)의 턴] \(Message.startRockScissorsPaper)", terminator: "")
            playerHand = recieveUserInput()
            if playerHand == .quit { break }
        } while gameManager.isRestartable(mode: .rockScissorsPaper, playerHand, computerHand) || gameManager.isWrongInput(playerHand: playerHand)
        
        guard playerHand != .quit else {
            print(Message.gameEnd)
            return
        }
        
        print("\(currentTurnHolder)의 승리!")
    }
    
    mutating private func changeTurn(when isContinued: inout Bool, _ playerHand: PlayerOption?, _ computerHand: PlayerOption) {
        guard isContinued else {
            isContinued = true
            return
        }
        if gameManager.isWrongInput(playerHand: playerHand) {
            currentTurnHolder = .computersTurn
        } else if isContinued {
            currentTurnHolder = gameManager.decideTurn(playerHand, computerHand)
            print("\(currentTurnHolder)의 턴입니다.")
        }
    }

    private func recieveUserInput(_ userInput: String? = readLine()) -> PlayerOption? {
        switch userInput {
        case "0":
            return .quit
        case "1":
            return .rock
        case "2":
            return .scissor
        case "3":
            return .paper
        default:
            print(Message.wrongInput)
            return nil
        }
    }
}

var rockPaperScissors = RockScissorsPaperGame()
rockPaperScissors.startGame()
