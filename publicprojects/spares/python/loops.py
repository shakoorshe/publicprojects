import turtle
screen = turtle.Screen()
screen.bgcolor("black")

pen = turtle.Turtle()
pen.color("white")
pen.speed(0)


size = 4141
shape = 200

for i in range(size):
  pen.forward(i)
  pen.right(shape)