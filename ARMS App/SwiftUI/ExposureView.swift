//
//  ExposureView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 2/26/24.
//

import SwiftUI
import CoreData

struct Item: Identifiable {
    var id = UUID()
    var title: String
    var color: Color
}

struct CustomCell: View {
    var item: Item
    var body: some View {
        Text(item.title)
            .bold()
            .padding()
            .frame(maxWidth: .infinity) // Ensure it takes full width available
            .frame(height: 50) // Explicitly set the height of the cell
            .background(item.color)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.vertical, 10) // Adjust vertical padding to create space between cells
    }
}

struct ExposureView: View {
    var managedObjectContext: NSManagedObjectContext

        init(managedObjectContext: NSManagedObjectContext) {
            self.managedObjectContext = managedObjectContext
        }
    
    let items = [Item(title: "PM1", color: Color.red), Item(title: "PM2.5", color: Color.blue), Item(title: "PM10", color: Color.teal), Item(title: "VOC Exposure", color: Color.green), Item(title: "CO Exposure", color: Color.orange), Item(title: "CO2 Exposure", color: Color.yellow )]
    
        @State private var showDetailView = false
        @State private var selectedTab = "Daily" // For the tabs in the detail view
        @State private var selectedPollutantType: PollutantType?
        
    var body: some View {
        NavigationView {
            List(items) { item in
                CustomCell(item: item)
                    .onTapGesture {
                        switch item.title {
                                               case "PM1":
                                                   selectedPollutantType = .pm1
                                               case "PM2.5":
                                                   selectedPollutantType = .pm2_5
                                               case "PM10":
                                                   selectedPollutantType = .pm10
                                               case "VOC Exposure":
                                                   selectedPollutantType = .voc
                                               case "CO Exposure":
                                                   selectedPollutantType = .co
                                               case "CO2 Exposure":
                                                   selectedPollutantType = .co2
                                               default:
                                                   selectedPollutantType = nil
                                               }
                        showDetailView.toggle()
                    }
            }
            .navigationTitle("Exposure")
            
        }
        .sheet(isPresented: $showDetailView) {
            if let pollutantType = selectedPollutantType {
                DetailView(selectedTab: $selectedTab, managedObjectContext: managedObjectContext, type: pollutantType)
            }
        } 
        
     
    }
}

struct DetailView: View {
    @Binding var selectedTab: String
    var managedObjectContext: NSManagedObjectContext
    var type: PollutantType

    var body: some View {
        TabView(selection: $selectedTab) {
            GraphView(pollutantType: type, managedObjectContext: managedObjectContext, timeFrame: selectedTab)
                .tabItem {
                    Label("Daily", systemImage: "calendar")
                }
                .tag(TimeFrame.daily.rawValue)
            
            GraphView(pollutantType: type, managedObjectContext: managedObjectContext, timeFrame: selectedTab)
                .tabItem {
                    Label("Weekly", systemImage: "calendar")
                }
                .tag(TimeFrame.weekly.rawValue)
            
            GraphView(pollutantType: type, managedObjectContext: managedObjectContext, timeFrame: selectedTab)
                .tabItem {
                    Label("Monthly", systemImage: "calendar")
                }
                .tag(TimeFrame.monthly.rawValue)
        }
    }
}


#Preview {
    ExposureView(managedObjectContext: PersistenceController.shared.container.viewContext)
}
