import turtle
screen = turtle.Screen()
screen.bgcolor("black")

pen = turtle.Turtle()
pen.speed(0)
pen.color("white")

size = 9412
shape = 1651

for i in range(size):
  pen.forward(i)
  pen.right(shape)