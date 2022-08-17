cash=0
num_items=input("How many items are you purchasing today?")
shoppingList=[]
priceList=[]
countList=[]
for i in range(int(num_items)):
  item= input("Enter item")
  shoppingList.append(item)
  c= input("How many of this item will you be buying?")
  countList.append(int(c))
  price=input("Enter price for {}".format(item))
  priceList.append(int(price))
  print(shoppingList)
  total=0
for i in range(int(num_items)):
    total+= priceList[i]*countList[i]
print(total)
input("Cash or card?")
cash = int(input("Here's your total."))
if cash>total:
  print("Here is your change! Have a nice day.")
elif cash<total:
    print("I'm afraid you'll have to remove an item.")
elif cash==total:
  print("Here are your items. Have a nice day!")