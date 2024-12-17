//
//  SettingsView.swift
//  iptv_handler
//
//  Created by Ryan Smith on 12/16/24.
//


import SwiftUI

struct SettingsView: View {
    // Fetch the version number dynamically
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var appBuildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("App Information")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("\(appVersion) (\(appBuildNumber))")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Developed By")
                        Spacer()
                        Text("Ryan Smith")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Support")
                        Spacer()
                        Text("lifewithryans@gmail.com")
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
