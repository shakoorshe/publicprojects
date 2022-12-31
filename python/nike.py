import turtle

turtleDrawer = turtle.Turtle()
turtleDrawer.getscreen().bgcolor("deep sky blue")
turtleDrawer.color("black")
turtleDrawer.shape("turtle")

#logo
turtleDrawer.speed(0)
turtleDrawer.begin_fill()
turtleDrawer.penup()
turtleDrawer.right(180)
turtleDrawer.forward(40)
turtleDrawer.pendown()

for i in range(200):
  turtleDrawer.forward(0.5)
  turtleDrawer.right(0.6)
turtleDrawer.left(160)

for i in range(275):
  turtleDrawer.forward(0.6)
  turtleDrawer.left(0.5)
  
for i in range(75):
  turtleDrawer.forward(0.425)
  turtleDrawer.left(0.325)
  
turtleDrawer.left(9)
turtleDrawer.forward(200)
turtleDrawer.left(170)
turtleDrawer.forward(160)

for i in range(120):
  turtleDrawer.forward(0.4)
  turtleDrawer.right(0.3)
turtleDrawer.end_fill()
turtleDrawer.hideturtle()