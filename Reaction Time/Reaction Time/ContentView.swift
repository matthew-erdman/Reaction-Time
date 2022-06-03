//
//  ContentView.swift
//  Reaction Time
//
//  Created by Matthew Erdman on 4/10/22.
//

import SwiftUI
import CoreData
import AVKit
import AudioToolbox

struct ContentView: View {
    // Retreive high scores from CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: HighScore.entity(), sortDescriptors: [])
    private var highScores: FetchedResults<HighScore>
    
    // Set up timer and timer vars
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State private var timerRunning = false
    @State private var startTime =  Date()
    @State private var timerText = "0.00"
    @State private var delayComplete = false
    
    // Set up audio player
    @State var audioPlayer: AVAudioPlayer!
    let kHzTone = Bundle.main.path(forResource: "1kHz", ofType: "mp3")
    
    // Set up vibration
    let vibration = UIImpactFeedbackGenerator(style: .heavy)
    
    // Functionally global game vars, accessable by all tests :(
    @State private var currentHighScore = 0
    @State private var currentHighScorePlayer = "player"
    @State private var scoreUpdateNeeded = false
    @State private var randomX = 0.0
    @State private var randomY = 0.0
    @State private var targetCount = 0
    
    @State private var username = ""
    @State private var screen = "login"
    
    var body: some View {
        VStack {
            // Handle login screen - get username
            if screen == "login" {
                Text("Welcome!")
                TextField(
                    "Please enter a username",
                    text: $username
                )
                .padding()
                // Vaildate username and take user to menu
                .onSubmit {
                    if username == "" {
                        username = "player"
                    }
                    screen = "menu"
                }
                .disableAutocorrection(true)
                .border(.secondary)
            }
            
            // Handle main menu screen - test selection
            else if screen == "menu" {
                NavigationView {
                    List {
                        // Enter regular reaction time test
                        Button(action: {
                            screen = "level1"
                            // Retreive high score to display in test
                            for highScore in highScores {
                                if highScore.test == screen {
                                    currentHighScore = Int(highScore.time)
                                    currentHighScorePlayer = highScore.player ?? "player"
                                }
                            }
                            // Begin timer for test start delay, between 0.5 and 2.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int.random(in: 500..<2500))) {
                                // Timer is complete, begin test
                                delayComplete = true
                                startTime = Date()
                                timerRunning = true
                            }
                        }) {
                            Text("Reaction Time Test")
                        }
                        
                        // Enter precision reaction time test
                        Button(action: {
                            screen = "level2"
                            // Retreive high score to display in test
                            for highScore in highScores {
                                if highScore.test == screen {
                                    currentHighScore = Int(highScore.time)
                                    currentHighScorePlayer = highScore.player ?? "player"
                                }
                                
                            }
                            // Begin timer for test start delay, between 0.5 and 2.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int.random(in: 500..<2500))) {
                                // Timer is complete, generate first target coordinates and begin test
                                randomX = CGFloat(Int.random(in: 50..<Int(UIScreen.main.bounds.width)-50))
                                randomY = CGFloat(Int.random(in: 100..<Int(UIScreen.main.bounds.height)-200))
                                delayComplete = true
                                startTime = Date()
                                timerRunning = true
                            }
                        }) {
                            Text("Precision Reaction Time Test")
                        }
                        
                        // Enter precision reaction time x5 test
                        Button(action: {
                            screen = "level3"
                            // Retreive high score to display in test
                            for highScore in highScores {
                                if highScore.test == screen {
                                    currentHighScore = Int(highScore.time)
                                    currentHighScorePlayer = highScore.player ?? "player"
                                }
                            }
                            // Begin timer for test start delay, between 0.5 and 2.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int.random(in: 500..<2500))) {
                                // Timer is complete, generate first target coordinates and begin test
                                randomX = CGFloat(Int.random(in: 50..<Int(UIScreen.main.bounds.width)-50))
                                randomY = CGFloat(Int.random(in: 100..<Int(UIScreen.main.bounds.height)-200))
                                delayComplete = true
                                startTime = Date()
                                timerRunning = true
                            }
                        }) {
                            Text("Precision Reaction Time x5 Test")
                        }
                        
                        // Enter audio reaction test
                        Button(action: {
                            screen = "level4"
                            // Retreive high score to display in test
                            for highScore in highScores {
                                if highScore.test == screen {
                                    currentHighScore = Int(highScore.time)
                                    currentHighScorePlayer = highScore.player ?? "player"
                                }
                            }
                            
                            // Set up audio player
                            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: kHzTone!))
                            
                            // Begin timer for test start delay, between 0.5 and 2.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int.random(in: 500..<2500))) {
                                // Timer is complete, begin test
                                delayComplete = true
                                startTime = Date()
                                timerRunning = true
                                // Ensure that audio can only play during test
                                if screen == "level4" {
                                    self.audioPlayer.play()
                                }
                            }
                        }) {
                            Text("Audio Reaction Time Test")
                        }
                        
                        // Enter vibration reaction test
                        Button(action: {
                            screen = "level5"
                            // Retreive high score to display in test
                            for highScore in highScores {
                                if highScore.test == screen {
                                    currentHighScore = Int(highScore.time)
                                    currentHighScorePlayer = highScore.player ?? "player"
                                }
                            }
                            
                            // Begin timer for test start delay, between 0.5 and 2.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(Int.random(in: 500..<2500))) {
                                // Timer is complete, begin test
                                delayComplete = true
                                startTime = Date()
                                timerRunning = true
                                // Ensure that vibration can only play during test
                                if screen == "level5" {
                                    vibration.impactOccurred()
                                }
                            }
                        }) {
                            Text("Vibration Reaction Time Test")
                        }
                        
                        // Enter taps per second test
                        Button(action: {
                            screen = "level6"
                            // Retreive high score to display in test
                            for highScore in highScores {
                                if highScore.test == screen {
                                    currentHighScore = Int(highScore.time)
                                    currentHighScorePlayer = highScore.player ?? "player"
                                }
                            }
                        }) {
                            Text("Taps Per Second Test")
                        }
                        
                        // Logout - return to login screen
                        Button(action: {
                            screen = "login"
                        }) {
                            Text("Logout")
                        }
                        
                        // Clear CoreData model of all high scores
//                        Button(action: {
//                            for highScore in highScores {
//                                viewContext.delete(highScore)
//                            }
//                        }) {
//                            Text("ERASE")
//                        }
                        
                        // Show high score data in main menu
//                        ForEach(highScores) { highScore in
//                            NavigationLink {
//                                Text("\(highScore.time) MS on \(highScore.test ?? "test") by \(highScore.player ?? "player")")
//                            } label: {
//                                Text("\(highScore.time) MS")
//                            }
//                        }
                    }
                    .navigationTitle("Welcome, \(username)!")
                }
            }
            
            // Handle normal reaction time test
            else if screen == "level1" {
                VStack {
                    // Back button - reset game vars and return to menu screen
                    HStack {
                        Image(systemName: "chevron.left.circle.fill")
                            .scaleEffect(1.5)
                            .padding()
                            .onTapGesture {
                                screen = "menu"
                                timerRunning = false
                                delayComplete = false
                                timerText = "0.00"
                                currentHighScore = 0
                                currentHighScorePlayer = "player"
                            }
                        Spacer()
                    }
                    Spacer()
                    
                    // Start delay is complete, begin test
                    if delayComplete {
                        Text("Tap!")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                            // Update timer text
                            .onReceive(timer) { _ in
                                if timerRunning {
                                    timerText = String(format: "%.0f MS", (Date().timeIntervalSince(startTime)*1000))
                                }
                            }
                            // Button clicked, stop timer and update highscores
                            .onTapGesture {
                                timerRunning = false
                                scoreUpdateNeeded = true
                                // Check through existing high scores, set flag if new score is high score
                                if highScores.count > 0 {
                                    for highScore in highScores {
                                        if highScore.test == screen && highScore.time > Int(timerText.dropLast(3) as Substring) ?? 0 {
                                            viewContext.delete(highScore)
                                        }
                                        else if highScore.test == screen && highScore.time <= Int(timerText.dropLast(3) as Substring) ?? 0 {
                                            scoreUpdateNeeded = false
                                            break
                                        }
                                    }
                                    // New score is high score, update CoreData model
                                    if scoreUpdateNeeded {
                                        let newHighScore = HighScore(context: viewContext)
                                        newHighScore.player = username
                                        newHighScore.test = screen
                                        newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                        try? viewContext.save()
                                    }
                                }
                                // No exisiting high scores, add new score to CoreData model
                                else {
                                    let newHighScore = HighScore(context: viewContext)
                                    newHighScore.player = username
                                    newHighScore.test = screen
                                    newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                    try? viewContext.save()
                                }
                            }
                        // Display high score and timer at bottom of screen
                        Text(timerText)
                            .font(.largeTitle)
                        Text("High Score: \(currentHighScore) MS by \(currentHighScorePlayer)")
                    }
                    
                    // Game start delay screen
                    else {
                        Text("Tap on green...")
                            .font(.title)
                    }
                }
            }
            
            // Handle precision reaction time test
            else if screen == "level2" {
                VStack {
                    // Back button - reset game vars and return to menu screen
                    HStack {
                        Image(systemName: "chevron.left.circle.fill")
                            .scaleEffect(1.5)
                            .padding()
                            .onTapGesture {
                                screen = "menu"
                                timerRunning = false
                                delayComplete = false
                                timerText = "0.00"
                                currentHighScore = 0
                                currentHighScorePlayer = "player"
                            }
                        Spacer()
                    }
                    Spacer()
                    
                    // Start delay is complete, begin test
                    if delayComplete {
                        // Generate precision target
                        Image(systemName: "plus.circle")
                            .scaleEffect(4.0)
                            .foregroundColor(Color.green)
                            .position(x: randomX, y: randomY)
                            // Update timer text
                            .onReceive(timer) { _ in
                                if timerRunning {
                                    timerText = String(format: "%.0f MS", (Date().timeIntervalSince(startTime)*1000))
                                }
                            }
                            // Target clicked, hide target/stop timer/update high scores
                            .onTapGesture {
                                randomX = -1000.0
                                randomY = -1000.0
                                timerRunning = false
                                scoreUpdateNeeded = true
                                // Check through existing high scores, set flag if new score is high score
                                if highScores.count > 0 {
                                    for highScore in highScores {
                                        if highScore.test == screen && highScore.time > Int(timerText.dropLast(3) as Substring) ?? 0 {
                                            viewContext.delete(highScore)
                                        }
                                        else if highScore.test == screen && highScore.time <= Int(timerText.dropLast(3) as Substring) ?? 0 {
                                            scoreUpdateNeeded = false
                                            break
                                        }
                                    }
                                    // New score is high score, update CoreData model
                                    if scoreUpdateNeeded {
                                        let newHighScore = HighScore(context: viewContext)
                                        newHighScore.player = username
                                        newHighScore.test = screen
                                        newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                        try? viewContext.save()
                                    }
                                }
                                // No exisiting high scores, add new score to CoreData model
                                else {
                                    let newHighScore = HighScore(context: viewContext)
                                    newHighScore.player = username
                                    newHighScore.test = screen
                                    newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                    try? viewContext.save()
                                }
                            }
                        // Display high score and timer at bottom of screen
                        Text(timerText)
                            .font(.largeTitle)
                        Text("High Score: \(currentHighScore) MS by \(currentHighScorePlayer)")
                    }
                    
                    // Game start delay screen
                    else {
                        Text("Tap on target...")
                            .font(.title)
                    }
                }
            }
            
            // Handle precision reaction time x5 test
            else if screen == "level3" {
                VStack {
                    // Back button - reset game vars and return to menu screen
                    HStack {
                        Image(systemName: "chevron.left.circle.fill")
                            .scaleEffect(1.5)
                            .padding()
                            .onTapGesture {
                                screen = "menu"
                                timerRunning = false
                                delayComplete = false
                                timerText = "0.00"
                                targetCount = 0
                                currentHighScore = 0
                                currentHighScorePlayer = "player"
                            }
                        Spacer()
                    }
                    Spacer()
                    
                    // Start delay is complete, begin test
                    if delayComplete {
                        // Generate first precision target
                        Image(systemName: "plus.circle")
                            .scaleEffect(4.0)
                            .foregroundColor(Color.green)
                            .position(x: randomX, y: randomY)
                            // Update timer text
                            .onReceive(timer) { _ in
                                if timerRunning {
                                    timerText = String(format: "%.0f MS", (Date().timeIntervalSince(startTime)*1000))
                                }
                            }
                            // Target clicked
                            .onTapGesture {
                                if targetCount >= 4 {
                                    // Final target, hide target/stop timer/update high scores
                                    randomX = -1000.0
                                    randomY = -1000.0
                                    timerRunning = false
                                    scoreUpdateNeeded = true
                                    // Check through existing high scores, set flag if new score is high score
                                    if highScores.count > 0 {
                                        for highScore in highScores {
                                            if highScore.test == screen && highScore.time > Int(timerText.dropLast(3) as Substring) ?? 0 {
                                                viewContext.delete(highScore)
                                            }
                                            else if highScore.test == screen && highScore.time <= Int(timerText.dropLast(3) as Substring) ?? 0 {
                                                scoreUpdateNeeded = false
                                                break
                                            }
                                        }
                                        // New score is high score, update CoreData model
                                        if scoreUpdateNeeded {
                                            let newHighScore = HighScore(context: viewContext)
                                            newHighScore.player = username
                                            newHighScore.test = screen
                                            newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                            try? viewContext.save()
                                        }
                                    }
                                    // No exisiting high scores, add new score to CoreData model
                                    else {
                                        let newHighScore = HighScore(context: viewContext)
                                        newHighScore.player = username
                                        newHighScore.test = screen
                                        newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                        try? viewContext.save()
                                    }
                                }
                                // Game is not over, increment target counter and generate new target coords
                                else {
                                    targetCount += 1
                                    randomX = CGFloat(Int.random(in: 50..<Int(UIScreen.main.bounds.width)-50))
                                    randomY = CGFloat(Int.random(in: 100..<Int(UIScreen.main.bounds.height)-200))
                                }
                            }
                        // Display high score and timer at bottom of screen
                        Text(timerText)
                            .font(.largeTitle)
                        Text("High Score: \(currentHighScore) MS by \(currentHighScorePlayer)")
                    }
                    
                    // Game start delay screen
                    else {
                        Text("Tap on targets...")
                            .font(.title)
                    }
                }
            }
            
            // Handle audio reaction time test
            else if screen == "level4" {
                VStack {
                    // Back button - reset game vars and return to menu screen
                    HStack {
                        Image(systemName: "chevron.left.circle.fill")
                            .scaleEffect(1.5)
                            .padding()
                            .onTapGesture {
                                screen = "menu"
                                timerRunning = false
                                delayComplete = false
                                timerText = "0.00"
                                currentHighScore = 0
                                currentHighScorePlayer = "player"
                                self.audioPlayer.pause()
                            }
                        Spacer()
                    }
                    Spacer()
                    
                    // Begin test
                    if delayComplete == false || timerRunning == true {
                        Text("Tap on tone...")
                            .font(.title)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                            // Update timer text
                            .onReceive(timer) { _ in
                                if timerRunning {
                                    timerText = String(format: "%.0f MS", (Date().timeIntervalSince(startTime)*1000))
                                }
                            }
                            // Button clicked, check timer
                            .onTapGesture {
                                if delayComplete {
                                    self.audioPlayer.pause()
                                    timerRunning = false
                                    scoreUpdateNeeded = true
                                    // Check through existing high scores, set flag if new score is high score
                                    if highScores.count > 0 {
                                        for highScore in highScores {
                                            if highScore.test == screen && highScore.time > Int(timerText.dropLast(3) as Substring) ?? 0 {
                                                viewContext.delete(highScore)
                                            }
                                            else if highScore.test == screen && highScore.time <= Int(timerText.dropLast(3) as Substring) ?? 0 {
                                                scoreUpdateNeeded = false
                                                break
                                            }
                                        }
                                        // New score is high score, update CoreData model
                                        if scoreUpdateNeeded {
                                            let newHighScore = HighScore(context: viewContext)
                                            newHighScore.player = username
                                            newHighScore.test = screen
                                            newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                            try? viewContext.save()
                                        }
                                    }
                                    // No exisiting high scores, add new score to CoreData model
                                    else {
                                        let newHighScore = HighScore(context: viewContext)
                                        newHighScore.player = username
                                        newHighScore.test = screen
                                        newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                        try? viewContext.save()
                                    }
                                }
                            }
                    }
                    // Show timer after test complete
                    else {
                        Text("Tap on tone...")
                            .font(.title)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                        Text(timerText)
                            .font(.largeTitle)
                        Text("High Score: \(currentHighScore) MS by \(currentHighScorePlayer)")
                    }
                }
            }
            
            // Handle vibration reaction time test
            else if screen == "level5" {
                VStack {
                    // Back button - reset game vars and return to menu screen
                    HStack {
                        Image(systemName: "chevron.left.circle.fill")
                            .scaleEffect(1.5)
                            .padding()
                            .onTapGesture {
                                screen = "menu"
                                timerRunning = false
                                delayComplete = false
                                timerText = "0.00"
                                currentHighScore = 0
                                currentHighScorePlayer = "player"
                            }
                        Spacer()
                    }
                    Spacer()
                    
                    // Begin test
                    if delayComplete == false || timerRunning == true {
                        Text("Tap on vibration...")
                            .font(.title)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                            // Update timer text
                            .onReceive(timer) { _ in
                                if timerRunning {
                                    timerText = String(format: "%.0f MS", (Date().timeIntervalSince(startTime)*1000))
                                }
                            }
                            // Button clicked, check timer
                            .onTapGesture {
                                if delayComplete {
                                    timerRunning = false
                                    scoreUpdateNeeded = true
                                    // Check through existing high scores, set flag if new score is high score
                                    if highScores.count > 0 {
                                        for highScore in highScores {
                                            if highScore.test == screen && highScore.time > Int(timerText.dropLast(3) as Substring) ?? 0 {
                                                viewContext.delete(highScore)
                                            }
                                            else if highScore.test == screen && highScore.time <= Int(timerText.dropLast(3) as Substring) ?? 0 {
                                                scoreUpdateNeeded = false
                                                break
                                            }
                                        }
                                        // New score is high score, update CoreData model
                                        if scoreUpdateNeeded {
                                            let newHighScore = HighScore(context: viewContext)
                                            newHighScore.player = username
                                            newHighScore.test = screen
                                            newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                            try? viewContext.save()
                                        }
                                    }
                                    // No exisiting high scores, add new score to CoreData model
                                    else {
                                        let newHighScore = HighScore(context: viewContext)
                                        newHighScore.player = username
                                        newHighScore.test = screen
                                        newHighScore.time = Int32(timerText.dropLast(3) as Substring) ?? 0
                                        try? viewContext.save()
                                    }
                                }
                            }
                    }
                    // Show timer after test complete
                    else {
                        Text("Tap on vibration...")
                            .font(.title)
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                        Text(timerText)
                            .font(.largeTitle)
                        Text("High Score: \(currentHighScore) MS by \(currentHighScorePlayer)")
                    }
                }
            }
            
            // Handle taps per second test
            else if screen == "level6" {
                VStack {
                    // Back button - reset game vars and return to menu screen
                    HStack {
                        Image(systemName: "chevron.left.circle.fill")
                            .scaleEffect(1.5)
                            .padding()
                            .onTapGesture {
                                screen = "menu"
                                timerRunning = false
                                delayComplete = false
                                timerText = "0.00"
                                currentHighScore = 0
                                currentHighScorePlayer = "player"
                                targetCount = 0
                            }
                        Spacer()
                    }
                    Spacer()
                    
                    // Start delay is complete, begin test
                    if delayComplete && targetCount > 0 {
                        Text("Tap!")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                            // Update timer text
                            .onReceive(timer) { _ in
                                if timerRunning {
                                    timerText = String(format: "%.0f MS / %d taps", (1000-Date().timeIntervalSince(startTime)*1000), targetCount)
                                }
                            }
                            // Button clicked, increment counter
                            .onTapGesture {
                                targetCount += 1
                            }
                        // Display high score and timer at bottom of screen
                        Text(timerText)
                            .font(.largeTitle)
                        Text("High Score: \(currentHighScore) TPS by \(currentHighScorePlayer)")
                    }
                    
                    // Game start delay screen
                    else if !delayComplete && targetCount == 0 {
                        Text("Tap to start...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                            .font(.largeTitle)
                            .onTapGesture(perform: {
                                startTime = Date()
                                timerRunning = true
                                targetCount += 1
                                delayComplete = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(1000)) {
                                    // Timer is complete, stop test
                                    delayComplete = false
                                    timerRunning = false
                                    scoreUpdateNeeded = true
                                    // Check through existing high scores, set flag if new score is high score
                                    if highScores.count > 0 {
                                        for highScore in highScores {
                                            if highScore.test == screen && highScore.time < targetCount {
                                                viewContext.delete(highScore)
                                            }
                                            else if highScore.test == screen && highScore.time >= targetCount {
                                                scoreUpdateNeeded = false
                                                break
                                            }
                                        }
                                        // New score is high score, update CoreData model
                                        if scoreUpdateNeeded {
                                            let newHighScore = HighScore(context: viewContext)
                                            newHighScore.player = username
                                            newHighScore.test = screen
                                            newHighScore.time = Int32(targetCount)
                                            try? viewContext.save()
                                        }
                                    }
                                    // No exisiting high scores, add new score to CoreData model
                                    else {
                                        let newHighScore = HighScore(context: viewContext)
                                        newHighScore.player = username
                                        newHighScore.test = screen
                                        newHighScore.time = Int32(targetCount)
                                        try? viewContext.save()
                                    }
                                }
                            })
                    }
                    
                    // Post test screen
                    else {
                        Text("Tap!")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.green)
                        // Display high score and timer at bottom of screen
                        Text(String(format: "0 MS / %d taps", targetCount))
                            .font(.largeTitle)
                        Text("High Score: \(currentHighScore) TPS by \(currentHighScorePlayer)")
                    }
                }
            }
            
            
            // Fallback in case janky screen var is feeling silly
            else {
                // Back button - reset game vars and return to menu screen
                VStack {
                    HStack {
                        Image(systemName: "chevron.left.circle.fill")
                            .scaleEffect(1.5)
                            .padding()
                            .onTapGesture {
                                screen = "menu"
                                timerRunning = false
                                timerText = "0.00"
                            }
                        Spacer()
                    }
                    Spacer()
                }
                Text("Current screen: \(screen)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
