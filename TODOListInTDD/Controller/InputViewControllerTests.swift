//
//  InputViewControllerTests.swift
//  TODOListInTDD
//
//  Created by pp1285 on 2016/9/19.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

import XCTest
import CoreLocation
@testable import TODOListInTDD


class InputViewControllerTests: XCTestCase {
     var sut: InputViewController!
    var placemark: MockPlacemark!
    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController
        _ = sut.view

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }


    func test_HasAllTextField() {
        XCTAssertNotNil(sut.titleTextField)
        XCTAssertNotNil(sut.locationTextField)
        XCTAssertNotNil(sut.addressTextField)
        XCTAssertNotNil(sut.descriptionTextField)
        XCTAssertNotNil(sut.dateTextField)

    }

    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        let mockInputViewController = MockInputViewController()

        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.dateTextField.text = "02/22/2016"
        mockInputViewController.locationTextField.text = "Office"
        mockInputViewController.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockInputViewController.descriptionTextField.text = "Test Description"
        let mockGeocoder = MockGeocoder()
        mockInputViewController.geocoder = mockGeocoder
        mockInputViewController.itemManager = ItemManager()
        let expectation = self.expectation(description: "bla")
        mockInputViewController.completionHandler = {
            expectation.fulfill()
        }
        mockInputViewController.save()


        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        waitForExpectations(timeout: 1, handler: nil)

        let item = mockInputViewController.itemManager?.itemAtIndex(0)


        //書上的timestamp錯了
        let testItem = ToDoItem(title: "Test Title",
                                itemDescription: "Test Description",
                                timestamp: 1456070400,
                                location: Location(name: "Office", coordinate: coordinate))
        XCTAssertEqual(item, testItem)
    }

    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else { XCTFail(); return }
        XCTAssertTrue(actions.contains("save"))
    }

    // chapt5 networking
    func test_GeocoderWorksAsExpected() {
        let expectation = self.expectation(description: "Wait for geocode")
        CLGeocoder().geocodeAddressString("Infinite Loop 1, Cupertino") {
            (placemarks, error) -> Void in
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return }
            guard let longitude = coordinate?.longitude else {
                    XCTFail()
                return }
            //
            XCTAssertEqualWithAccuracy(latitude, 37.3316941,
                                       accuracy: 0.000001)
            XCTAssertEqualWithAccuracy(longitude, -122.030127,
                                       accuracy: 0.000001)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.descriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.save()
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }




}

extension InputViewControllerTests {

    // we call it stub
    class MockGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }

    class MockPlacemark : CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else
            { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude,
                              longitude: coordinate.longitude)
        }
    }

    // partial mock
    class MockInputViewController : InputViewController {
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?
        override func dismiss(animated flag: Bool,
                                                    completion: (() -> Void)?) {
            dismissGotCalled = true
            completionHandler?()
        } }
}
