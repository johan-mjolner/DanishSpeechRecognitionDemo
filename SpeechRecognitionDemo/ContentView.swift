//
//  ContentView.swift
//
//  Created by Johan Rugager Vase on 03/01/2020.
//  Copyright © 2020 mjolner. All rights reserved.
//

import SwiftUI
import Speech
import AVFoundation

struct ContentView: View {
    var speechRecognizer = FileSpeechRecognizer()

    init() {
        recognizeAll()
    }
    
    var body: some View {
        VStack {
            Button(action:{self.recognizeAll()}) { Text("test") }
        }
    }
    
    func recognizeAll() {
        self.speechRecognizer.requestSpeechRecognition(file: "diethylether") {
            print("Expect \"diethylether\", recognized: \($0)")
            self.speechRecognizer.requestSpeechRecognition(file: "gaskromatograf") {
                print("Expect \"gaskromatograf\", recognized: \($0)")
                self.speechRecognizer.requestSpeechRecognition(file: "put-diethylether-i-gaskromatograf"){
                    print("Expect \"put diethylether i gaskromatograf\", recognized: \($0)")
                }
            }
        }
    }
    
}


class FileSpeechRecognizer {
    func requestSpeechRecognition(file: String, completion: @escaping ([String])->()) {
        let url = Bundle.main.url(forResource: file, withExtension: "m4a")!
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "da-DK"))
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.contextualStrings = ["gaskromatograf", "diethylether", "dimetylæter"]

        recognizer?.recognitionTask(with: request) { (result, error) in
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }
            
            if result.isFinal {
                completion( result.transcriptions.map{$0.formattedString} )
            }
        }
    }
}
