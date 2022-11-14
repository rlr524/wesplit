//
//  ContentView.swift
//  WeSplit
//
//  Created by Rob Ranf on 8/13/22.
//

import SwiftUI

/*
struct ContentView: View {
    @State private var name = ""
    // Doesn't need to be marked with @State as it's a constant and won't change
    let students = ["Harry", "Ron", "Hermione", "Neville", "Cho"]
    // Can change, so needs to be marked as @State. @State property wrappers should be private.
    @State private var selectedStudent = "Harry"

    var body: some View {
        NavigationView {
            Form {
                // We use a $ as two-way binding for the name property. What that does, is bind
                // the text field so it shows the value of the property but also bind it
                // so that any changes to the TextField also update the property; Swift should
                // read the value of the property but also write it back as any changes
                // happen.
                TextField("Enter your name", text: $name)
                // Note we only need to read the value of the property here, we don't need
                // to write it back in any way because the Text view won't change, so no need
                // for two-way binding ($)
                Text("Hello, \(name)")
            }
            Form {
                Picker("Select your student", selection: $selectedStudent) {
                    // The only thing unique about a string is the string itself, so we
                    // use \.self as the id, telling Swift that the id (it's really a
                    // unique key) is the string itself. There are better ways to get
                    // keys using the index, but this works for this case.
                    ForEach(students, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
    }
}
*/

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    let tipPercentages = [10, 15, 20, 25, 30, 0]

    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount

        return amountPerPerson
    }

    var checkTotal: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue

        return grandTotal
    }

    var currencyCode: FloatingPointFormatStyle<Double>.Currency {
        return .currency(code: Locale.current.currencyCode ?? "USD")
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Express the currency either in the user's local currency (baased
                    // on Settings > General > Language and Region, if set) or in USD
                    TextField("Amount",
                              value: $checkAmount,
                              format: currencyCode)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)

                    /*
                     This is declarative user interface design. As with any declarative paradigm,
                     we state what we want without saying how it should be done (which would, in
                     contrast, be imperative userinterface design).
                     */
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<100) {
                            Text("\($0) people")
                        }
                    }
                }

                /*
                 Using multiple trailing closures here; the first one specifies the
                 body of the section, the second one the header.
                 */
                Section {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("How much tip do you want to leave?")
                }

                Section {
                    Text(checkTotal,
                              format: .currency(code: Locale.current.currencyCode ?? "USD"))
                } header: {
                    Text("Total amount of check")
                }

                Section {
                    Text(totalPerPerson,
                         format: currencyCode)
                } header: {
                    Text("Amount per person")
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()

                    Button("Done") {
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
