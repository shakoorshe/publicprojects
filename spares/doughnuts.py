import turtle
turtleDrawer = turtle.Turtle()
turtleDrawer.speed(0)
turtleDrawer.shape("turtle")
turtleDrawer.getscreen().bgcolor("deep sky blue")

for i in range(85):
  turtleDrawer.color("blue")
  turtleDrawer.right(5)
  turtleDrawer.bk(60)
  turtleDrawer.right(60)
  turtleDrawer.forward(10)
  turtleDrawer.circle(50)
  
turtleDrawer.penup()
turtleDrawer.left(45)
turtleDrawer.forward(150)
turtleDrawer.pendown()

for i in range(85):
  turtleDrawer.color("yellow")
  turtleDrawer.right(5)
  turtleDrawer.bk(60)
  turtleDrawer.right(60)
  turtleDrawer.forward(10)
  turtleDrawer.circle(50)
  
turtleDrawer.penup()
turtleDrawer.left(-45)
turtleDrawer.forward(150)
turtleDrawer.pendown()


for i in range(85):
  turtleDrawer.color("black")
  turtleDrawer.right(5)
  turtleDrawer.bk(60)
  turtleDrawer.right(60)
  turtleDrawer.forward(10)
  turtleDrawer.circle(50)
  
turtleDrawer.penup()
turtleDrawer.left(45)
turtleDrawer.forward(150)
turtleDrawer.pendown()

for i in range(85):
  turtleDrawer.color("green")
  turtleDrawer.right(5)
  turtleDrawer.bk(60)
  turtleDrawer.right(60)
  turtleDrawer.forward(10)
  turtleDrawer.circle(50)
  
turtleDrawer.penup()
turtleDrawer.left(45)
turtleDrawer.forward(150)
turtleDrawer.pendown()

for i in range(85):
  turtleDrawer.color("red")
  turtleDrawer.right(5)
  turtleDrawer.bk(60)
  turtleDrawer.right(60)
  turtleDrawer.forward(10)
  turtleDrawer.circle(50)
  
turtleDrawer.penup()
turtleDrawer.left(90)
turtleDrawer.forward(150)
turtleDrawer.pendown()

for i in range(85):
  turtleDrawer.color("orange")
  turtleDrawer.right(5)
  turtleDrawer.bk(60)
  turtleDrawer.right(60)
  turtleDrawer.forward(10)
  turtleDrawer.circle(50)
  
turtleDrawer.penup()
turtleDrawer.left(45)
turtleDrawer.forward(150)
turtleDrawer.pendown()
print("GOODBYE(WOULD YOU LIKE A DOUGHNUT?)")
turtle.exitonclick()