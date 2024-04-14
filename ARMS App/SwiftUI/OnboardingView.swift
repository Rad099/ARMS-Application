//
//  Onboarding.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 3/30/24.
//

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var tempUser = User()
    @Published var currentQuestionIndex = 0
    private let icloudManager = ICloudManager()

    // Simplify the questions array
    let questions = [
        "Please enter your name",
        "How old are you?",
        "Do you have any of the listed diseases?",
        "Enter your email"
    ]
    
    // Add diseases list and selected diseases
    let diseases = ["Heart Disease", "Lung Disease", "Asthma", "Other Respiratory Diseases"]
    @Published var selectedDiseases: [String] = []

    var completionHandler: (() -> Void)?
    
    func processAnswer(answer: String) {
        switch currentQuestionIndex {
        case 0: tempUser.name = answer
        case 1: tempUser.age = Int(answer) ?? 0
        case 3: tempUser.email = answer
        default: break
        }
        
        if currentQuestionIndex == 2 {
            // After selecting diseases, directly assign them to the user model
            //tempUser.
        }
        
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            finishOnboarding()
        }
    }
    
    private func finishOnboarding() {
        saveUserToiCloud(user: tempUser)
        completionHandler?()
    }

    private func saveUserToiCloud(user: User) {
        // Your cloudManager saving logic here
    }
}

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var answer: String = ""

    var body: some View {
       
        VStack {
            
            Text("Welcome to the ARMS App!").bold().font(Font.system(size: 25))
            if viewModel.currentQuestionIndex < viewModel.questions.count {
                let isDiseaseQuestion = viewModel.currentQuestionIndex == 2
                
                Text(viewModel.questions[viewModel.currentQuestionIndex])
                    .padding()
                
                if !isDiseaseQuestion {
                    TextField("Your answer here", text: $answer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                } else {
                    // Display diseases as a selectable list
                    List(viewModel.diseases, id: \.self) { disease in
                        HStack {
                            Text(disease)
                            Spacer()
                            if viewModel.selectedDiseases.contains(disease) {
                                Image(systemName: "checkmark").foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if let index = viewModel.selectedDiseases.firstIndex(of: disease) {
                                viewModel.selectedDiseases.remove(at: index)
                            } else {
                                viewModel.selectedDiseases.append(disease)
                            }
                        }
                    }
                }
                
                Button("Next") {
                    viewModel.processAnswer(answer: answer)
                    answer = "" // Reset answer for the next question
                }.disabled(isDiseaseQuestion && viewModel.selectedDiseases.isEmpty)
            }
        }
        .onAppear {
            viewModel.completionHandler = {
                // Handle completion, like dismissing this view or transitioning to another view.
            }
        }
    }
}

#Preview {
    OnboardingView()
}
