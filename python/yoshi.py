# import the turtle modules
import turtle

# Forming the window screen
tut = turtle.Screen()
pen = turtle.Turtle()
m = turtle.Turtle()
grass = turtle.Turtle()
window = turtle.Turtle()
sun = turtle.Turtle()
pen.penup()
pen.speed(0)
grass.speed(0)
window.speed(0)
m.speed(0)
sun.speed(0)
pen.goto(-50, -50)
pen.pendown()
tut.bgcolor("light blue")
pen.color("light yellow")
pen.begin_fill()
for i in range(4):
    pen.forward(100)
    pen.right(90)
pen.end_fill()
pen.hideturtle()
m.color("yellow")
m.penup()
m.goto(-50, -50)
m.left(60)
m.pendown()
m.begin_fill()
m.forward(100)
m.right(120)
m.forward(100)
m.right(120)
m.forward(100)
m.end_fill()
m.hideturtle()
grass.penup()
grass.goto(0, -150)
grass.color("light green")

# grass code
grass.backward(200)
grass.pendown()
grass.begin_fill()
for i in range(4):
    grass.forward(400)
    grass.right(90)
grass.end_fill()
grass.hideturtle()

# window code
window.color("light blue")
window.penup()
window.goto(-40, -60)
window.pendown()
window.begin_fill()
for i in range(4):
    window.forward(20)
    window.right(90)
window.end_fill()
window.penup()
window.goto(10, -60)
window.pendown()
window.begin_fill()
for i in range(4):
    window.forward(20)
    window.right(90)
window.end_fill()
window.penup()
window.goto(-40, -100)
window.pendown()
window.begin_fill()
for i in range(4):
    window.forward(20)
    window.right(90)
window.end_fill()
window.penup()
window.goto(10, -100)
window.pendown()
window.begin_fill()
for i in range(4):
    window.forward(20)
    window.right(90)
window.end_fill()
window.color("white")
window.forward(10)
window.right(90)
window.forward(20)
window.backward(10)
window.right(90)
window.forward(10)
window.backward(20)
window.penup()
window.goto(-40, -60)
window.right(180)
window.forward(10)
window.pendown()
window.right(90)
window.forward(20)
window.backward(10)
window.right(90)
window.forward(10)
window.backward(20)
window.penup()
window.goto(10, -60)
window.right(180)
window.forward(10)
window.right(90)
window.pendown()
window.forward(20)
window.backward(10)
window.right(90)
window.forward(10)
window.backward(20)
window.penup()
window.goto(-40, -100)
window.right(180)
window.forward(10)
window.right(90)
window.pendown()
window.forward(20)
window.backward(10)
window.right(90)
window.forward(10)
window.backward(20)
window.hideturtle()
sun.color("Yellow")
sun.penup()
sun.goto(-120, 120)
sun.pendown()
sun.begin_fill()
sun.circle(25)
sun.end_fill()
sun.right(90)
sun.forward(25)
sun.goto(-120, 145)
sun.left(90)
sun.forward(50)
sun.backward(100)
sun.penup()
sun.goto(-120, 170)
sun.left(90)
sun.pendown()
sun.forward(25)
turtle.exitonclick()
