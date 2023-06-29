//
//  ContentView.swift
//  BetterRest
//
//  Created by Isaque da Silva on 28/06/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var amountSleepPerDay = 8.0
    @State private var amountCupOfCoffee = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                VStack{
                    Text("When do you want to wake up?")
                        .font(.headline.bold())
                    DatePicker("When do you want to wake up?", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
                .listRowBackground(Color(CGColor(red: 240, green: 240, blue: 246, alpha: 0)))
                
                Section{
                    Stepper("\(amountSleepPerDay.formatted()) Hours", value: $amountSleepPerDay, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep:")
                }
                
                Section {
                    Stepper("\(amountCupOfCoffee) \(amountCupOfCoffee == 1 ? "Cup" : "Cups")", value: $amountCupOfCoffee, in: 1...20)
                } header: {
                    Text("Daily Coffee intake:")
                }
                
                Button("Cauculate", action: {
                    calculateBedTime()
                })
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color(CGColor(red: 240, green: 240, blue: 246, alpha: 0)))
                .frame(maxWidth: 430)
            }.navigationTitle("BetterRest")
        }
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") {}
        } message: {
            Text(alertMessage)
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hours = (components.hour ?? 0) * 3_600
            let minutes = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hours + minutes), estimatedSleep: amountSleepPerDay, coffee: Double(amountCupOfCoffee))
            
            let sleepTime = wakeUp - prediction.actualSleep
            alertTitle = "Ideal bedtime"
            alertMessage = "Your ideal bedtime is \(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, but it looks like there was an error calculating your ideal bedtime!"
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
