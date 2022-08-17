import turtle
screen = turtle.Screen()
screen.bgcolor("black")

pen = turtle.Turtle()
pen.speed(0)
pen.color("white")

size=1414
shape=4141

for i in range(size):
  pen.forward(i)
  pen.right(shape)