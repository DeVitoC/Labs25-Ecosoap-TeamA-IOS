//
//  NewPickupView.swift
//  EcoSoapBank
//
//  Created by Jon Bash on 2020-08-10.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import SwiftUI
import Combine


struct NewPickupView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var pickupController: PickupController

    @State private var cartons: [Pickup.CartonContents] = []
    @State private var readyDate: Date = Date()
    @State private var notes: String = ""

    @State private var pickupSubmitInProgress = false
    @State private var successfulSubmit = false
    @State private var shippingLabelURL: URL?
    @State private var cancellables: Set<AnyCancellable> = []

    init(pickupController: PickupController) {
        self.pickupController = pickupController
    }

    // MARK: - Body

    var body: some View {
        Form {
            Section(header: Text("Cartons".uppercased())
                        .font(.caption)
                        .foregroundColor(.black)
            ) {
                ForEach(cartons, content: CartonSummaryView.init)
                    .onDelete(perform: removeCartons(in:))
                Button(action: addAdditionalCarton, label: {
                    HStack {
                        Image.plus()
                        Image.cubeBox()
                        Text("Add carton")
                    }
                })
            }.alert(isPresented: hasError, content: {
                Alert(
                    title: Text("Error!"),
                    message: Text("It seems there's been some sort of error."),
                    dismissButton: .default(Text("Okay?")))
            })

            Section {
                DatePicker(
                    selection: $readyDate,
                    in: PartialRangeFrom(Date()),
                    displayedComponents: .date,
                    label: {
                        Text("Ready Date".uppercased())
                            .font(.caption)
                    }
                )

                VStack(alignment: .leading) {
                    Text("Notes".uppercased())
                        .font(.caption)
                    TextView(text: $notes, textStyle: .body)
                        .frame(maxWidth: .infinity, idealHeight: 120)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                }
            }

            Section {
                Button("Submit For Pickup", action: submitPickup)
                    .frame(alignment: .center)
            }
            .alert(isPresented: $successfulSubmit, content: submitSuccessAlert)
        }
        .disabled(pickupSubmitInProgress)
        .keyboardAvoiding()
    }
}

// MARK: - Helpers

extension NewPickupView {
    private var hasError: Binding<Bool> {
        Binding(get: {
            self.pickupController.error != nil
        }, set: { willHaveError in
            if !willHaveError {
                self.pickupController.error = nil
            }
        })
    }

    private func addAdditionalCarton() {
        cartons.append(.init(product: .bottles, weight: 0))
    }

    private func removeCartons(in indexSet: IndexSet) {
        indexSet.forEach { cartons.remove(at: $0) }
    }

    private func submitPickup() {
        pickupSubmitInProgress = true // disable UI; show loading indicator?

        pickupController.schedulePickup(
            Pickup.ScheduleInput(
                base: Pickup.Base(
                    collectionType: .local, // WILL BE CHANGED
                    status: .submitted,
                    readyDate: readyDate,
                    pickupDate: nil,
                    notes: notes),
                propertyID: UUID(), // WILL BE CHANGED
                cartons: cartons)
        ).sink(receiveCompletion: { _ in
            self.pickupSubmitInProgress = false
        }, receiveValue: { result in
            self.pickupSubmitInProgress = false
            self.shippingLabelURL = result.labelURL
            self.successfulSubmit = true // shows alert
        }).store(in: &cancellables)
    }

    private func submitSuccessAlert() -> Alert {
        let success = Text("Success!")
        let base = "Pickup has been scheduled"
        let dismiss = {
            self.presentationMode.wrappedValue.dismiss()
        }

        if let url = self.shippingLabelURL {
            return Alert(
                title: Text("Success!"),
                message: Text("\(base); your shipping label is ready."),
                primaryButton: .default(
                    Text("Open in Safari"),
                    action: {
                        dismiss()
                        UIApplication.shared.open(url)
                }),
                secondaryButton: .default(Text("Later"), action: {
                    dismiss()
                })
            )
        } else {
            return Alert(
                title: success,
                message: Text("\(base)."),
                dismissButton: .default(Text("Okay"), action: {
                    dismiss()
                }))
        }
    }
}

// MARK: - Preview

struct NewPickupView_Previews: PreviewProvider {
    static var previews: some View {
        NewPickupView(pickupController: PickupController(
            dataProvider: MockPickupProvider()))
    }
}
