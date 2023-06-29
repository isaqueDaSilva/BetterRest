//
//  ContentView.swift
//  BetterRest
//
//  Created by Isaque da Silva on 28/06/23.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var amountSleepPerDay = 8.0
    @State private var amountCupOfCoffee = 1
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    DatePicker("When do you want to wake up?", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .listRowBackground(Color(CGColor(red: 240, green: 240, blue: 246, alpha: 0)))
                    
                    Section{
                        Stepper("\(amountSleepPerDay.formatted()) hours", value: $amountSleepPerDay, in: 4...12, step: 0.25)
                    } header: {
                        Text("Desired amount of sleep")
                    }
                    
                    Section {
                        Stepper("\(amountCupOfCoffee) Cup(s)", value: $amountCupOfCoffee, in: 1...20)
                    } header: {
                        Text("Daily Coffee intake")
                    }
                    
                    Button("Cauculate", action: {
                        
                    })
                    .buttonStyle(.borderedProminent)
                    .listRowBackground(Color(CGColor(red: 240, green: 240, blue: 246, alpha: 0)))
                    .frame(maxWidth: 430)
                }
            }.navigationTitle("Better Rest")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
