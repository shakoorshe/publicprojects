from kivyapp import App
from kivyapp import Builder

kv = """
Floatlayout:
    Button:
        text: 'Hello World!'
"""


class SuperApp(App):
    def build(self):
        return Builder.load_string(kv)


SuperApp().run()
