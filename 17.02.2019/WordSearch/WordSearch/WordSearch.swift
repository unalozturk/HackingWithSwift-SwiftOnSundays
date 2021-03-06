//
//  WordSearch.swift
//  WordSearch
//
//  Created by Ünal Öztürk on 18.02.2019.
//  Copyright © 2019 Ünal Öztürk. All rights reserved.
//

import UIKit


enum PlacementType : CaseIterable {
    case leftRight
    case rightLeft
    case upDown
    case downUp
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft
    
    var movement: (x: Int , y: Int ) {
        switch self {
        case .leftRight:
            return(1,0)
        case .rightLeft:
            return(-1,0)
        case .upDown:
            return(0,1)
        case .downUp:
            return(0,-1)
        case .topLeftBottomRight:
            return(1,1)
        case .topRightBottomLeft:
            return(-1,1)
        case .bottomLeftTopRight:
            return(1,-1)
        case .bottomRightTopLeft:
            return(-1,-1)
        }
    }
}

enum Difficulty {
    case easy
    case medium
    case hard
    
    var placementType : [PlacementType] {
        switch self {
        case .easy:
            return [.leftRight , .rightLeft].shuffled()
        case .medium:
            return [.leftRight , .rightLeft, .upDown, .downUp].shuffled()
        case .hard:
            return PlacementType.allCases.shuffled()
            
        }
    }
}

struct Word: Decodable {
    var text : String
    var clue : String
}

class Label {
    var letter : Character = " "
}

class WordSearch {
    var words =  [Word]()
    var gridSize = 10
    var labels = [[Label]]()
    var difficulty = Difficulty.hard
    var numberOfPages = 10
    
    // Unicode a is 65 , z is 90 so it creates all characters to allLetters
    let allLetters = (65...90).map { Character(Unicode.Scalar($0)) }
    
    func makeGrid() {
        labels = (0 ..< gridSize).map { _ in
            (0 ..< gridSize ).map { _ in
                Label()
            }
        }
        
        placeWords()
        fillGaps()
        printGrid()
        
    }
    
    private func fillGaps() {
        for column in labels {
            for label in column {
                if label.letter == " " {
                    label.letter = allLetters.randomElement()!
                }
            }
        }
    }
    
    private func printGrid() {
        for column in labels {
            for row in column {
                print(row.letter, terminator: "")
            }
            print("")
        }
    }
    
    private func labels(fromX x: Int , y: Int ,words : String , movement: (x: Int , y: Int)) -> [Label]? {
        var returnValue = [Label]()
        var xPosition = x
        var yPosition = y
        
        for letter in words {
            let label = labels[xPosition][yPosition]
            if label.letter == " " || label.letter == letter {
                returnValue.append(label)
                xPosition += movement.x
                yPosition += movement.y
            } else {
                return nil
            }
        }
        return returnValue
    }
    
    private func tryPlacing(_ word : String , movement: (x: Int , y: Int)) -> Bool {
        let xLength = (movement.x * (word.count - 1))
        let yLength = (movement.y * (word.count - 1))
        
        let rows = (0 ..< gridSize ).shuffled()
        let cols = (0 ..< gridSize ).shuffled()
        
        for row in rows {
            for col in cols {
                let finalX = col + xLength
                let finalY = row + yLength
                
                if finalX >= 0 && finalX < gridSize && finalY >= 0 && finalY < gridSize {
                    if let returnValue = labels(fromX: col, y: row, words: word, movement: movement) {
                        for(index , letter ) in word.enumerated() {
                            returnValue[index].letter = letter
                        }
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func place(_ word: Word ) -> Bool {
        let formattedWord = word.text.replacingOccurrences(of: " ", with: "").uppercased()
        
       /* for type in difficulty.placementType {
            if tryPlacing(formattedWord, movement: type.movement) {
                return true
            }
        }*/
        
        return difficulty.placementType.contains {
            tryPlacing(formattedWord, movement: $0.movement)
        }
    }
    
    private func placeWords() -> [Word] {
       /* words.shuffled()
        var usedWords = [Word]()
        for word in words {
            if place(word) {
                usedWords.append(word)
            }
        }
         return usedWords
    }*/
    return words.shuffled().filter(place)
    }
    
    func render() -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let margin = pageRect.width / 10
        
        let availableSpace = pageRect.width - (margin * 2 )
        let gridCellSize = availableSpace / CGFloat(gridSize)
        
        let gridLetterFont = UIFont.systemFont(ofSize: 16)
        let gridLetterStyle = NSMutableParagraphStyle()
        gridLetterStyle.alignment = .center
        
        let gridLetterAttributes: [NSAttributedString.Key : Any] = [
            .font: gridLetterFont,
            .paragraphStyle: gridLetterStyle
        ]
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        return renderer.pdfData { ctx in
            for _ in 0 ..< numberOfPages {
                ctx.beginPage()
                
                _ = makeGrid()
                
                
                
                //WRITE GRID
                for i in 0 ... gridSize {
                    let linePosition = CGFloat(i) * gridCellSize
                    
                    ctx.cgContext.move(to: CGPoint(x: margin, y: margin + linePosition))
                    ctx.cgContext.addLine(to: CGPoint(x: margin + (CGFloat(gridSize) * gridCellSize ), y: margin + linePosition ))
                    
                    ctx.cgContext.move(to: CGPoint(x: margin + linePosition , y: margin))
                    ctx.cgContext.addLine(to: CGPoint(x: margin + linePosition, y : margin + (CGFloat(gridSize) * gridCellSize )))
                }
                
                ctx.cgContext.setLineCap(.square)
                ctx.cgContext.strokePath()
                
                //DRAW LETTERS
                var xOffSet =  margin
                var yOffSet =  margin
                
                for column in labels {
                    for label in column {
                        let size = String(label.letter).size(withAttributes: gridLetterAttributes)
                        let yPosition = (gridCellSize - size.height) / 2
                        let cellRect = CGRect(x: xOffSet, y: yOffSet + yPosition , width: gridCellSize, height: gridCellSize)
                        String(label.letter).draw(in: cellRect , withAttributes: gridLetterAttributes)
                        xOffSet += gridCellSize
                    }
                    
                    xOffSet = margin
                    yOffSet += gridCellSize
                }
            }
        }
        
    }
}




