//
//  PickupTests.swift
//  EcoSoapBankTests
//
//  Created by Jon Bash on 2020-08-11.
//  Copyright © 2020 Spencer Curtis. All rights reserved.
//
// swiftlint:disable force_try

import XCTest
import SwiftUI
import Combine
@testable import EcoSoapBank


class PickupTests: XCTestCase {
    private var pickupCoordinator: PickupCoordinator!
    private var pickupController: PickupController!
    private var pickupProvider: MockPickupProvider!

    private var expectationsCount = 0

    private var bag = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()
        bag = []
        let user = User.placeholder()
        pickupProvider = MockPickupProvider(waitTime: 0.05)
        pickupController = PickupController(user: user, dataProvider: pickupProvider)
        pickupCoordinator = PickupCoordinator(user: user, dataProvider: pickupProvider)
    }

    // MARK: - Tests

    func testPickupControllerFetchAllSuccess() throws {
        let exp = newMockExpectation()
        pickupController.fetchPickupsForAllProperties()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Mock pickup provider should have succeeded but failed with error: \(error)")
                }
                exp.fulfill()
            }, receiveValue: { pickups in
                XCTAssertGreaterThan(pickups.count, 0)
                exp.fulfill()
            }).store(in: &bag)
        wait(for: exp)
    }

    func testPickupControllerFetchAllFailure() {
        pickupProvider.shouldFail = true
        let failingController = PickupController(
            user: .placeholder(),
            dataProvider: pickupProvider)

        let exp = newMockExpectation()

        failingController.fetchPickupsForAllProperties()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Mock provider should have failed but succeeded")
                case .failure:
                    exp.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Mock provider should have failed but succeeded")
            }).store(in: &bag)
        wait(for: exp)

        XCTAssert(failingController.pickups.isEmpty)
    }

    func testSchedulePickup() {
        let exp1 = XCTestExpectation(description: "Waiting for mock data 1")

        let input = Pickup.ScheduleInput.random()

        pickupController.schedulePickup(for: input)
            .sink(
                receiveCompletion: handleCompletion(_:),
                receiveValue: { _ in
                    exp1.fulfill()
            }).store(in: &bag)

        wait(for: exp1)
    }

    func testCoordinatorScheduleVMIsResetOnSchedule() throws {
        let exp = newMockExpectation()
        let input = Pickup.ScheduleInput.random()
        
        pickupCoordinator.scheduleNewPickup()

        let firstVM = pickupCoordinator.scheduleVM

        pickupCoordinator.schedulePickup(for: input) { result in
            let pickupResult = try? XCTUnwrap(try? result.get())

            XCTAssertEqual(pickupResult?.pickup?.base, input.base)
            XCTAssert(self.pickupCoordinator.scheduleVM !== firstVM)

            exp.fulfill()
        }

        wait(for: exp)
    }

    func testCoordinatorScheduleVMIsNotResetOnCancel() {
        let firstVM = pickupCoordinator.scheduleVM

        pickupCoordinator.scheduleNewPickup()
        pickupCoordinator.cancelPickup()

        XCTAssert(firstVM === pickupCoordinator.scheduleVM
            || (firstVM == nil && pickupCoordinator.scheduleVM != nil))
    }

    func testUserPropertiesTransferredProperly() {
        pickupCoordinator.scheduleNewPickup()
        XCTAssertEqual(pickupCoordinator.scheduleVM?.properties,
                       pickupController.user.properties)
    }

    func testSchedulePickupAttributes() throws {
        let delegate = MockScheduleVMDelegate()
        let vm = SchedulePickupViewModel(user: .placeholder(), delegate: delegate)

        let in4Days = Date(timeIntervalSinceNow: .days(4))
        let notes = "This is a note"
        let property = vm.properties.last
        XCTAssertNotNil(property)

        vm.readyDate = in4Days
        vm.notes = notes
        vm.addCarton()
        vm.addCarton()
        vm.addCarton()
        vm.cartons[0].carton.percentFull = 100
        vm.cartons[2].carton.percentFull = 50
        vm.cartons[2].carton.product = .paper
        vm.removeCarton(atIndex: 1)
        vm.selectedProperty = try XCTUnwrap(property)

        var pickup: Pickup?
        let exp = newMockExpectation()

        vm.schedulePickup { result in
            if case .failure = result { XCTFail("request should not fail") }
            pickup = try! result.get().pickup

            XCTAssertTrue({
                if case .pickupScheduled = delegate.status {
                    return true
                } else {
                    return false
                }
            }())

            exp.fulfill()
        }

        wait(for: exp)

        XCTAssertEqual(pickup?.cartons.count, 2)
        XCTAssertEqual(pickup?.cartons[0].contents?.percentFull, 100)
        XCTAssertEqual(pickup?.cartons[0].contents?.product, .soap)
        XCTAssertEqual(pickup?.cartons[1].contents?.percentFull, 50)
        XCTAssertEqual(pickup?.cartons[1].contents?.product, .paper)
        XCTAssertEqual(pickup?.notes, notes)
        XCTAssertEqual(pickup?.property.id, property!.id)
        XCTAssert(Calendar.current.isDate(pickup!.readyDate, equalTo: in4Days, toGranularity: .day))
    }

    func testStoryboardInit() throws {
        let pickup = Pickup.random()
        let detailVC = PickupDetailViewController.fromStoryboard { coder in
            PickupDetailViewController(coder: coder, pickup: pickup)
        }
        XCTAssertNotNil(detailVC)
        XCTAssertEqual(detailVC?.pickup, pickup)
    }
}

// MARK: - Helpers

extension PickupTests {
    private func newMockExpectation() -> XCTestExpectation {
        expectationsCount += 1
        return XCTestExpectation(
            description: "Waiting for mock data \(expectationsCount)")
    }

    private func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        if case .failure(let error) = completion {
            XCTFail("completed with error: \(error)")
        }
    }
}

protocol HostingController {}

extension UIHostingController: HostingController {}

extension XCTestCase {
    func wait(for expectation: XCTestExpectation, timeout: TimeInterval = 5) {
        wait(for: [expectation], timeout: timeout)
    }
}


protocol KeyPathListable {
    var allKeyPaths: [PartialKeyPath<Self>] { get }
}

extension KeyPathListable {
    var allKeyPaths: [PartialKeyPath<Self>] {
        let mirror = Mirror(reflecting: self)

        return mirror.children
            .reduce(into: [PartialKeyPath<Self>]()) { keyPaths, labelValuePair in
                guard let key = labelValuePair.label else { return }
                keyPaths.append(\Self.[checkedMirrorDescendent: key] as PartialKeyPath)
        }
    }

    private subscript(checkedMirrorDescendent key: String) -> Any {
        Mirror(reflecting: self).descendant(key)!
    }
}

extension Property: KeyPathListable {}

// MARK: - Mock Delegate

class MockScheduleVMDelegate: SchedulePickupViewModelDelegate {
    enum Status {
        case started
        case editingCarton(NewCartonViewModel)
        case schedulingPickup(Pickup.ScheduleInput)
        case pickupScheduled(Result<Pickup.ScheduleResult, Error>)
        case pickupCancelled
    }

    var shouldFail: Bool = false
    var waitTime: Double = 0.1
    private(set) var status: Status = .started

    func reinitialize() {
        self.status = .started
    }

    func editCarton(for viewModel: NewCartonViewModel) {
        NSLog("Editing carton...")
        self.status = .editingCarton(viewModel)
    }

    func cancelPickup() {
        NSLog("Pickup cancelled")
        self.status = .pickupCancelled
    }

    func schedulePickup(
        for input: Pickup.ScheduleInput,
        completion: @escaping ResultHandler<Pickup.ScheduleResult>
    ) {
        self.status = .schedulingPickup(input)
        DispatchQueue.global().asyncAfter(deadline: .now() + waitTime) {
            let result: Result<Pickup.ScheduleResult, Error> = {
                if self.shouldFail {
                    return .failure(MockError.shouldFail)
                } else {
                    return .success(.mock(from: input))
                }
            }()
            self.status = .pickupScheduled(result)
            completion(result)
        }
    }
}
