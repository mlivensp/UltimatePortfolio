//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Michael Livenspargar on 7/5/24.
//

import XCTest

extension XCUIElement {
    func clear() {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear text in XCUIElement")
            return
        }

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        typeText(deleteString)
    }
}

final class UltimatePortfolioUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppStartsWithNavigationBar() throws {
        XCTAssertTrue(app.navigationBars.element.exists, "There should be a navigation bar when the app launches.")
    }

    func testAppHasBasicButtonsOnLaunch() throws {
        XCTAssertTrue(app.navigationBars.buttons["Filters"].exists, "There should be a filters button on launch.")
        XCTAssertTrue(app.navigationBars.buttons["Filter"].exists, "There should be a filter button on launch.")
        XCTAssertTrue(app.navigationBars.buttons["New Issue"].exists, "There should be a new issue button on launch.")
    }

    func testNoIssuesAtStart() throws {
        XCTAssertEqual(app.cells.count, 0, "There should be 0 list rows initially.")
    }

    func testCreatingAndDeletingIssues() throws {
        for tapCount in 1...5 {
            app.buttons["New Issue"].tap()
            app.buttons["Issues"].tap()

            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }

        for tapCount in (0...4).reversed() {
            app.cells.firstMatch.swipeLeft()
            app.buttons["Delete"].tap()

            XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows in the list.")
        }
    }

    func testEditingIssueTitleUpdatesCorrectly() throws {
        XCTAssertEqual(app.cells.count, 0, "There should be no rows rows initially.")

        app.buttons["New Issue"].tap()

        app.textFields["Enter the issue title here"].tap()
        app.textFields["Enter the issue title here"].clear()
        app.typeText("My New Issue")

        app.buttons["Issues"].tap()
        XCTAssertTrue(app.buttons["My New Issue"].exists, "A My New Issue cell should now exist.")
    }

    func testEditingIssuePriorityShowsIcon() {
        app.buttons["New Issue"].tap()
        app.buttons["Priority, Medium"].tap()
        app.buttons["High"].tap()
        app.buttons["Issues"].tap()

        let identifier = "New issue High Priority"
        XCTAssertTrue(app.images[identifier].exists, "A high-priority issue needs an icon next to it.")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Filters"].tap()
        app.buttons["Show awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            if app.windows.allElementsBoundByIndex[0].frame.contains(award.frame) == false {
                            app.swipeUp()
            }

            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should ba a Locked showing this award.")
            app.buttons["OK"].tap()
        }
    }
}
