import SwiftUI
import AppKit

// A simple algebraic puzzle generator
struct Node: Identifiable {
    let id = UUID()
    var value: String
    var isEditable: Bool
    var expected: String
    var type: NodeType
    var row: Int
    var col: Int
}

enum NodeType {
    case number, operatorNode, equals, result, empty
}

struct PuzzleLevel {
    var grid: [[Node]]
    var rows: Int
    var cols: Int
}

class GameState: ObservableObject {
    @Published var currentLevelIndex = 1
    @Published var puzzle: PuzzleLevel = PuzzleLevel(grid: [], rows: 0, cols: 0)
    @Published var showStatus = false
    @Published var isSuccess = false
    
    init() {
        // Carica il livello salvato
        let savedLevel = UserDefaults.standard.integer(forKey: "SavedLevel")
        if savedLevel > 0 {
            currentLevelIndex = savedLevel
        }
        generateLevel()
    }
    
    func generateLevel() {
        // La difficoltà aumenta col livello (livelli infiniti generati proceduralmente)
        let diff = currentLevelIndex
        let rows = 5
        let cols = 5
        var newGrid = Array(repeating: Array(repeating: Node(value: "", isEditable: false, expected: "", type: .empty, row: 0, col: 0), count: cols), count: rows)
        
        let maxVal = diff * 5
        let a = Int.random(in: 1...maxVal)
        let b = Int.random(in: 1...maxVal)
        let c = a + b
        
        let d = Int.random(in: 1...maxVal)
        let e = Int.random(in: 1...maxVal)
        let f = d * e
        
        let g = a + d
        let h = b - e
        
        newGrid[0][0] = Node(value: "", isEditable: true, expected: "\(a)", type: .number, row: 0, col: 0)
        newGrid[0][1] = Node(value: "+", isEditable: false, expected: "+", type: .operatorNode, row: 0, col: 1)
        newGrid[0][2] = Node(value: "\(b)", isEditable: false, expected: "\(b)", type: .number, row: 0, col: 2)
        newGrid[0][3] = Node(value: "=", isEditable: false, expected: "=", type: .equals, row: 0, col: 3)
        newGrid[0][4] = Node(value: "\(c)", isEditable: false, expected: "\(c)", type: .result, row: 0, col: 4)
        
        newGrid[1][0] = Node(value: "+", isEditable: false, expected: "+", type: .operatorNode, row: 1, col: 0)
        newGrid[1][2] = Node(value: "-", isEditable: false, expected: "-", type: .operatorNode, row: 1, col: 2)
        
        newGrid[2][0] = Node(value: "\(d)", isEditable: false, expected: "\(d)", type: .number, row: 2, col: 0)
        newGrid[2][1] = Node(value: "x", isEditable: false, expected: "x", type: .operatorNode, row: 2, col: 1)
        newGrid[2][2] = Node(value: "", isEditable: true, expected: "\(e)", type: .number, row: 2, col: 2)
        newGrid[2][3] = Node(value: "=", isEditable: false, expected: "=", type: .equals, row: 2, col: 3)
        newGrid[2][4] = Node(value: "\(f)", isEditable: false, expected: "\(f)", type: .result, row: 2, col: 4)
        
        newGrid[3][0] = Node(value: "=", isEditable: false, expected: "=", type: .equals, row: 3, col: 0)
        newGrid[3][2] = Node(value: "=", isEditable: false, expected: "=", type: .equals, row: 3, col: 2)
        
        newGrid[4][0] = Node(value: "\(g)", isEditable: false, expected: "\(g)", type: .result, row: 4, col: 0)
        newGrid[4][2] = Node(value: "\(h)", isEditable: false, expected: "\(h)", type: .result, row: 4, col: 2)
        
        puzzle = PuzzleLevel(grid: newGrid, rows: rows, cols: cols)
        showStatus = false
    }
    
    func verify() {
        var correct = true
        for r in 0..<puzzle.rows {
            for c in 0..<puzzle.cols {
                let node = puzzle.grid[r][c]
                if node.isEditable {
                    if node.value.trimmingCharacters(in: .whitespaces) != node.expected {
                        correct = false
                    }
                }
            }
        }
        
        if correct {
            isSuccess = true
            showStatus = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.currentLevelIndex += 1
                UserDefaults.standard.set(self.currentLevelIndex, forKey: "SavedLevel")
                self.generateLevel()
            }
        } else {
            isSuccess = false
            showStatus = true
        }
    }
}

struct NodeView: View {
    @Binding var node: Node
    
    var body: some View {
        Group {
            if node.type == .empty {
                Color.clear.frame(width: 50, height: 50)
            } else if node.isEditable {
                TextField("", text: $node.value)
                    .textFieldStyle(PlainTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Color(white: 0.15))
                    .cornerRadius(25)
                    .overlay(Circle().stroke(Color(white: 0.3), lineWidth: 2))
            } else {
                Text(node.value)
                    .font(.system(size: 24, weight: node.type == .result ? .bold : .regular))
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(node.type == .number || node.type == .result ? Color(white: 0.2) : Color.clear)
                    .cornerRadius(25)
                    .overlay(
                        Group {
                            if node.type == .number || node.type == .result {
                                Circle().stroke(Color(white: 0.35), lineWidth: 2)
                            }
                        }
                    )
            }
        }
    }
}

struct ContentView: View {
    @StateObject var state = GameState()
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Difficoltà: \(state.currentLevelIndex)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 30)
            
            VStack(spacing: 15) {
                ForEach(0..<state.puzzle.rows, id: \.self) { r in
                    HStack(spacing: 15) {
                        ForEach(0..<state.puzzle.cols, id: \.self) { c in
                            NodeView(node: $state.puzzle.grid[r][c])
                        }
                    }
                }
            }
            .padding(30)
            .background(Color(white: 0.12)) // Dark grey inner box
            .cornerRadius(20)
            
            if state.showStatus {
                Text(state.isSuccess ? "Corretto! Passaggio al livello successivo..." : "Ci sono errori. Riprova.")
                    .font(.headline)
                    .foregroundColor(state.isSuccess ? .green : .red)
                    .transition(.opacity)
            } else {
                Text(" ").font(.headline) // Placeholder to maintain height
            }
            
            Button(action: {
                withAnimation {
                    state.verify()
                }
            }) {
                Text("Verifica")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom, 30)
            .disabled(state.showStatus && state.isSuccess)
        }
        .padding(.horizontal, 40)
        .frame(width: 440, height: 580)
        .background(Color(white: 0.18)) // Solid dark grey outer background
    }
}

@main
struct NumGameApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
    }
}

