//
//  MockPaymentProvider.swift
//  EcoSoapBank
//
//  Created by Christopher Devito on 9/1/20.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//

import Foundation


/// For placeholder and testing purposes.
class MockPaymentProvider {
    /// Set to `true` for testing networking failures
    var shouldFail: Bool

    init(shouldFail: Bool = false) {
        self.shouldFail = shouldFail
    }
}


extension MockPaymentProvider: PaymentDataProvider {
    /// Simply returns mock Pickups through closure
    /// (or `MockPickupProvider.Error.shouldFail` if `shouldFail` instance property is set to `true`).
    func fetchPayments(forPropertyID propertyID: String, _ completion: @escaping ResultHandler<[Payment]>) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            guard !self.shouldFail else {
                completion(.mockFailure())
                return
            }
            completion(.success(.random()))
        }
    }

    func makePayment(
        _ paymentInput: Payment,
        completion: @escaping ResultHandler<Payment>) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            guard !self.shouldFail else {
                completion(.mockFailure())
                return
            }
            completion(.success(.mock(from: paymentInput)))
        }
    }
}

// MARK: - Convenience Extensions

extension Array where Element == Payment {
    static func random() -> [Payment] {
        (3...20).map { _ in Payment.random() }
    }
}

extension Payment {
    /// Uses input `base` to construct data from mock "server."
    static func mock(from input: Payment) -> Self {
        Payment(id: mockConfirmationCode(),
                invoiceCode: mockInvoiceCode(),
                invoice: mockInvoice(),
                amountPaid: 225,
                amountDue: 225,
                date: randomDate(dateType: .date),
                invoicePeriodStartDate: randomDate(dateType: .invoiceStart),
                invoicePeriodEndDate: randomDate(dateType: .invoiceEnd),
                dueDate: randomDate(dateType: .dueDate),
                paymentMethod: randomPaymentMethod())
    }

    static func random() -> Self {
        Payment(id: mockConfirmationCode(),
                invoiceCode: mockInvoiceCode(),
                invoice: mockInvoice(),
                amountPaid: 225,
                amountDue: 225,
                date: randomDate(dateType: .date),
                invoicePeriodStartDate: randomDate(dateType: .invoiceStart),
                invoicePeriodEndDate: randomDate(dateType: .invoiceEnd),
                dueDate: randomDate(dateType: .dueDate),
                paymentMethod: randomPaymentMethod()
        )
    }
}

//extension Payment.ScheduleResult {
//    static func mock(from input: Pickup.ScheduleInput) -> Self {
//        Pickup.ScheduleResult(
//            pickup: .mock(from: input),
//            labelURL: URL(string: "http://www.google.com")!)
//    }
//}

// swiftlint:disable private_over_fileprivate
fileprivate func mockConfirmationCode() -> String {
    let longCode = UUID().uuidString
    return String(longCode.dropLast(longCode.count - 7))
}

fileprivate func mockInvoiceCode() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var string = String((0..<3).map { _ in letters.randomElement()! })
    string.append(" ")
    string.append(String((0..<3).map { _ in letters.randomElement()! }))
    return string
}

fileprivate func mockInvoice() -> String {
    "https://test.com/invoice\(Int.random(in: 0...20))"
}

enum DateType {
    case date
    case invoiceStart
    case invoiceEnd
    case dueDate
}

fileprivate func randomDate(dateType: DateType) -> Date {
    var startRange: Double
    var endRange: Double

    switch dateType {
    case .date:
        startRange = 1577917936
        endRange = 1598999536
    case .invoiceStart:
        startRange = 1577917936
        endRange = 1588458736
    case .invoiceEnd:
        startRange = 1588458736
        endRange = 1598999536
    case .dueDate:
        startRange = 1588458736
        endRange = 1598999536
    }

    let timeSince1970: TimeInterval = Double.random(in: startRange...endRange)
    return Date(timeIntervalSince1970: timeSince1970)
}

fileprivate func randomPaymentMethod() -> PaymentMethod {
    PaymentMethod.allCases.randomElement() ?? PaymentMethod.ach
}
