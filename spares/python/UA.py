import turtle
td = turtle.Turtle()
td2 = turtle.Turtle()
td.shape("turtle")
td.shape("turtle")
td.speed(0)
td2.speed(0)
td2.penup()
td2.goto(-90,-90)
#first U shape
td.begin_fill()
td.left(155)
for i in range(100):
  td.forward(1)
  td.right(0.5)
td.right(90)
for i in range(350):
  td.forward(0.2)
td.right(120)
td.forward(20)
for i in range(550):
  td.forward(0.3)
  td.left(0.3)
td.left(30)
td.forward(60)
td.right(103)
td.forward(70)
td.right(110)
td.forward(60)
for i in range(450):
  td.forward(0.3)
  td.right(0.185)
td.forward(14)
td.end_fill()