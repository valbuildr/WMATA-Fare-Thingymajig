//
//  SettingsView.swift
//  WMATA Fare Thingymajig
//
//  Created by Valentine Gacke on 4/12/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("useReducedFare") private var useReducedFare = false
    
    var body: some View {
        List {
            Section {
                Toggle("Use Reduced Fare", isOn: $useReducedFare)
            } header: {
                Text("Fare Settings")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
