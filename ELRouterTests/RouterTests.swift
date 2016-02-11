//
//  RouterTests.swift
//  ELRouter
//
//  Created by Angelo Di Paolo on 12/1/15.
//  Copyright © 2015 theholygrail.io. All rights reserved.
//

import XCTest
@testable import ELRouter
import ELFoundation

// MARK: - translate Tests

class RouterTests: XCTestCase {
    func test_updateNavigator_setsTabBarViewControllersBasedOnStaticRoutes() {
        let router = Router()
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        router.navigator = tabBarController
                
        router.register(Route("tabOne", type: .Static) { (variable) in
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.register(Route("tabTwo", type: .Static) { (variable) in
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.register(Route("tabThree", type: .Static) { (variable) in
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.updateNavigator()
        
        XCTAssertNotNil(tabBarController.viewControllers)
        XCTAssertEqual(tabBarController.viewControllers?.count, 3)
    }
    
    func test_updateNavigator_doesNotSetTabBarViewControllersWithNilActionReturns() {
        let router = Router()
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        router.navigator = tabBarController
        
        router.register(Route("tabOne", type: .Static) { (variable) in
            return nil
        })
        
        router.register(Route("tabTwo", type: .Static) { (variable) in
            return nil
        })
        
        router.register(Route("tabThree", type: .Static) { (variable) in
            return nil
        })
        
        router.updateNavigator()
        
        XCTAssertNil(tabBarController.viewControllers)
    }
    
    func test_updateNavigator_doesNotSetTabBarViewControllersWithNilActions() {
        let router = Router()
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        router.navigator = tabBarController
        
        router.register(Route("tabOne", type: .Static))
        router.register(Route("tabTwo", type: .Static))
        router.register(Route("tabThree", type: .Static))
        
        router.updateNavigator()
        
        XCTAssertNil(tabBarController.viewControllers)
    }
    
    func test_updateNavigator_executesStaticRoutes() {
        let router = Router()
        let tabBarController = UITabBarController(nibName: nil, bundle: nil)
        router.navigator = tabBarController
        
        let tabOneExpectation = expectationWithDescription("tabOne static route executes")
        let tabTwoExpectation = expectationWithDescription("tabTwo static route executes")
        let tabThreeExpectation = expectationWithDescription("tabThree static route executes")

        router.register(Route("tabOne", type: .Static) { (variable) in
            tabOneExpectation.fulfill()
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.register(Route("tabTwo", type: .Static) { (variable) in
            tabTwoExpectation.fulfill()
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.register(Route("tabThree", type: .Static) { (variable) in
            tabThreeExpectation.fulfill()
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.updateNavigator()
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func test_updateNavigator_doesNotExecuteStaticRoutesWithNilNavigator() {
        let router = Router()
        
        router.register(Route("tabOne", type: .Static) { (variable) in
            XCTAssertTrue(false)
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.register(Route("tabTwo", type: .Static) { (variable) in
            XCTAssertTrue(false)
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.register(Route("tabThree", type: .Static) { (variable) in
            XCTAssertTrue(false)
            let vc = UIViewController(nibName: nil, bundle: nil)
            return UINavigationController(rootViewController: vc)
        })
        
        router.updateNavigator()
    }
}

// MARK: - translate Tests

extension RouterTests {
    // TODO: implement tests
    func test_translate_shouldNotThrowExceptionForNewTranslation() {
        let router = Router()
        
        // nothing to assert because test will fail if exception is thrown
        router.translate("foo", to: "bar")
    }
    
    func test_translate_throwsExceptionForExistingTranslation() {
        let router = Router()
        router.translate("foo", to: "bar")
        
        // TODO: this test always fails, no way to catch an obj-c exception from Swift
        router.translate("foo", to: "bar")

    }
}

// MARK: - routesForComponents Tests

extension RouterTests {
    func test_routesForComponents_returnsEmptyResultsForBogusComponents() {
        let router = Router()
        let results = router.routesForComponents(["walmart.com", "foo"])
        
        XCTAssertTrue(results.isEmpty)
    }
    
    func test_routesForComponents_returnsEmptyResultsForEmptyComponents() {
        let router = Router()
        let results = router.routesForComponents([])
        
        XCTAssertTrue(results.isEmpty)
    }
    
    func test_routesForComponents_returnsNamedRoutesForValidComponents() {
        let router = Router()
        let route = Route("walmart.com", type: .Other).route("foo", type: .Other)
        router.register(route)
        
        let results = router.routesForComponents(["walmart.com", "foo"])
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].name, "walmart.com")
        XCTAssertEqual(results[1].name, "foo")
    }
}

extension RouterTests {
    func test_routesForURL__returnsNamedRoutesForValidURL() {
        let router = Router()
        let route = Route("walmart.com", type: .Other).route("foo", type: .Other)
        router.register(route)
        let url = NSURL(string: "scheme://walmart.com/foo")!
        
        let results = router.routesForURL(url)
        
        XCTAssertFalse(results.isEmpty)
        XCTAssertEqual(results.count, 2)
        XCTAssertEqual(results[0].name, "walmart.com")
        XCTAssertEqual(results[1].name, "foo")
    }
    
    func test_routesForURL__returnsEmptyResultsForBadURL() {
        let router = Router()
        let url = NSURL(string: "::")!
        
        let results = router.routesForURL(url)
        
        XCTAssertTrue(results.isEmpty)
    }
}

// MARK: - routesByName Tests

extension RouterTests {
    func test_routesByName_returnsRegisteredRoutesForValidName() {
        let router = Router()
        let name = "testRouteName"
        router.register(Route(name, type: .Other))
        router.register(Route(name, type: .Other))
        
        let namedRoutes = router.routesByName(name)
        XCTAssertEqual(namedRoutes.count, 2)
        
        for route in namedRoutes {
            XCTAssertNotNil(route.name)
            XCTAssertEqual(route.name, name)
        }
    }
    
    func test_routesByName_returnsEmptyArrayForBogusRouteName() {
        let router = Router()
        let fakeRoutes = router.routesByName("definitelyNotARealRouteNameYo")
        
        XCTAssertTrue(fakeRoutes.isEmpty)
    }
}

// MARK: - routesByType Tests

extension RouterTests {
    func test_routesByType_returnsRegisteredRoutesForValidType() {
        let router = Router()
        let routeName = "testRoutesByType"
        router.register(Route(routeName, type: .Other))
        router.register(Route(routeName, type: .Other))
        
        let namedRoutes = router.routesByType(.Other)
        XCTAssertEqual(namedRoutes.count, 2)
        
        for route in namedRoutes {
            XCTAssertNotNil(route.name)
            XCTAssertEqual(route.name, routeName)
            XCTAssertEqual(route.type, RoutingType.Other)
        }
    }
    
    func test_routesByType_returnsRegisteredRoutesForBogusType() {
        let router = Router()
        router.register(Route("testRoutesByType", type: .Other))
        router.register(Route("testRoutesByType", type: .Other))
        
        let fakeRoutes = router.routesByType(.Static)
        XCTAssertTrue(fakeRoutes.isEmpty)
    }
}

// MARK: - register Tests

extension RouterTests {
    func test_register_namedRouteGetsAppendedToRoutes() {
        let router = Router()
        let route = Route("registerTest", type: .Other)
        
        router.register(route)
        XCTAssertEqual(router.routes.count, 1)
    }
    
    func test_register_unnamedRouteDoesNotGetAppendedToRoutes() {
        let router = Router()
        let route = Route("registerTest", type: .Other)
        let variableRoute = Route(type: .Variable, parentRoute: route)
        variableRoute.parentRoute = nil
        
        router.register(variableRoute)
        XCTAssertEqual(router.routes.count, 0)
    }
    
    func test_register_parentRouteIsAppendedWhenRegisteringItsSubRoute() {
        let router = Router()
        let route = Route("parentRoute", type: .Other)
        let subRoute = Route("subRoute", type: .Other, parentRoute: route)
        
        router.register(subRoute)
        XCTAssertEqual(router.routes[0], route)
        XCTAssertNotEqual(router.routes[0], subRoute)
    }
}

// MARK: - evaluate Tests

extension RouterTests {
    func test_evaluate_returnsTrueForHandledURL() {
        let router = Router()
        router.register(Route("walmart.com", type: .Other))
        
        let routeWasHandled = router.evaluate(["walmart.com"])
        XCTAssertTrue(routeWasHandled)
    }
    
    func test_evaluate_returnsFalseForUnhandledURL() {
        let router = Router()
        
        let routeWasHandled = router.evaluate(["walmart.com"])
        XCTAssertFalse(routeWasHandled)
    }
}

// MARK: - evaluateURL Tests

extension RouterTests {
    func test_evaluateURL_returnsTrueForHandledURL() {
        let router = Router()
        router.register(Route("walmart.com", type: .Other))
        let url = NSURL(string: "scheme://walmart.com")!
        let routeWasHandled = router.evaluateURL(url)
        
        XCTAssertTrue(routeWasHandled)
    }
    
    func test_evaluateURL_returnsFalseForUnhandledURL() {
        let router = Router()
        let url = NSURL(string: "scheme://walmart.com")!
        
        let routeWasHandled = router.evaluateURL(url)
        XCTAssertFalse(routeWasHandled)
    }
    
    func test_evaluateURL_returnsFalseForBadURL() {
        let router = Router()
        let url = NSURL(string: "::")!
        
        let routeWasHandled = router.evaluateURL(url)
        XCTAssertFalse(routeWasHandled)
    }
    
    func test_evaluateURL_executesActionWithMultipleURLComponents() {
        let router = Router()
        let handlerExpectation = expectationWithDescription("route handler should run")
        
        router.register(Route("walmart.com", type: .Other).route("item", type: .Other).variable().route("something", type: .Other) { variable in
            XCTAssertNotNil(variable)
            XCTAssertEqual(variable!, "12345")
            handlerExpectation.fulfill()
            return nil
            })
        
        router.evaluateURL(NSURL(string: "scheme://walmart.com/item/12345/something")!)
        
        waitForConditionsWithTimeout(2.0) { () -> Bool in
            return false
        }
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func test_evaluateURL_executesActionWithSingleVariableComponent() {
        let router = Router()
        let handlerExpectation = expectationWithDescription("route handler should run")
        
        router.register(Route("walmart.com", type: .Other).variable() { variable in
            XCTAssertNotNil(variable)
            XCTAssertEqual(variable!, "12345")
            
            handlerExpectation.fulfill()
            return nil
        })
        
        
        router.evaluateURL(NSURL(string: "scheme://walmart.com/12345")!)
        
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func test_evaluateURL_executesActionWithSingleRouteComponent() {
        let router = Router()
        let handlerExpectation = expectationWithDescription("route handler should run")
        
        router.register(Route("walmart.com", type: .Other) { variable in
            handlerExpectation.fulfill()
            return nil
            })
        
        router.navigator = UITabBarController(nibName: nil, bundle: nil)
        let executed = router.evaluateURL(NSURL(string: "scheme://walmart.com")!)
        
        XCTAssert(executed, "This should've failed")
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
    
    func test_evaulate_executesActionWithBasicOtherRoute() {
        let router = Router()
        let handlerRanExpectation = expectationWithDescription("route handler should run")
        
        let route = Route("foo", type: .Other) { (variable) in
            handlerRanExpectation.fulfill()
            return nil
        }
        
        router.register(route)
        router.navigator = UITabBarController(nibName: nil, bundle: nil)
        
        router.evaluate(["foo"])
        waitForExpectationsWithTimeout(2.0, handler: nil)
    }
}

// MARK: - evaluateURLString Tests

extension RouterTests {
    func test_evaluateURLString_returnsTrueForHandledURL() {
        let router = Router()
        router.register(Route("walmart.com", type: .Other))
        
        let routeWasHandled = router.evaluateURLString("scheme://walmart.com")
        XCTAssertTrue(routeWasHandled)
    }
    
    func test_evaluateURLString_returnsFalseForUnhandledURL() {
        let router = Router()
        
        let routeWasHandled = router.evaluateURLString("scheme://walmart.com")
        XCTAssertFalse(routeWasHandled)
    }
    
    func test_evaluateURLString_returnsFalseForBadURLL() {
        let router = Router()
        
        let routeWasHandled = router.evaluateURLString("      ")
        XCTAssertFalse(routeWasHandled)
    }
}

// MARK: - processing Tests

extension RouterTests {
    func test_processing_returnsFalseWhenNoRoutesAreInFlight() {
        let router = Router()
        let processing = router.processing
        
        XCTAssertFalse(processing)
    }
}

// MARK: - serializedRoute Tests

extension RouterTests {
    func test_serializedRoute_dismissesPresentedViewController() {
        // TODO: fix this test. failing because UIViewController is being presented in a view that is not
        // part of the view hiearchy
        let router = Router()
        let navigator = MockNavigator()
        router.navigator = navigator
        let viewController = UIViewController(nibName: nil, bundle: nil)
        navigator.testNavigationController?.topViewController?.presentViewController(viewController, animated: false, completion: nil)
        
        XCTAssertNotNil(navigator.testNavigationController?.topViewController?.presentedViewController)

        router.serializedRoute([], components: [], animated: false)
        
        XCTAssertNil(navigator.testNavigationController?.topViewController?.presentedViewController)
    }
}