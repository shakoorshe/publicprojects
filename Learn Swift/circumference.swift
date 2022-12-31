class Circle {
  var radius: Double
/*
In Swift, the init function is a special type of function that is used to create an instance of a class, structure, or enumeration. It is called the initializer for the type.
*/
  init(radius: Double) {
    self.radius = radius
  }
  
  func circumference() -> Double {
    return 2 * .pi * radius
  }
  
  func area() -> Double {
    return .pi * radius * radius
  }
}

let circle = Circle(radius: 10.0)
print("The circumference of the circle is \(circle.circumference())")
print("The area of the circle is \(circle.area())")
