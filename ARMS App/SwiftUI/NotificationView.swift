//
//  NotificationView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 2/11/24.
//

import SwiftUI

struct NotificationView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            // Adjust the position, size, and styling as needed
    }
}

#Preview {
    NotificationView(message: "Warning, the PAQS is too Low")
}
