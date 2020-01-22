#!/usr/bin/env python
from Tkinter import *
from tkinter.filedialog import askopenfilename
import filter
from filter import FILENAME
window = Tk()
window.title("Real Estate Stats")
window.geometry('400x300')


def choose_file_clicked():
    filename = askopenfilename()
    path = filename.split('/')
    filename = path[-1]
    chosen_file.configure(text=filename)
    FILENAME = filename

def go_clicked():
    result = filter.getAll()
    for_sale.configure(text = "For Sale: " + str(result[0]))
    under_contract.configure(text = "Under Contract: " + str(result[1]))
    homes_sold.configure(text = "Homes Sold" + str(result[2]))
    lowest_price_sold.configure(text = "Lowest Price Sold: $" + str(result[3]))
    highest_price_sold.configure(text = "Highest Price Sold: $" + str(result[4]))
    avg_price_sold.configure(text = "Avergae Price Sold: $" + str(result[5]))
    avg_days_on_market.configure(text = "Average Days on Market: " + str(result[6]))




choose_file_button = Button(window, text="Choose a file", command=choose_file_clicked)
choose_file_button.grid(column=0, row=0)
go_button = Button(window, text="Go", command=go_clicked)
go_button.grid(column=0, row=2)
chosen_file = Label(window, text="", bg = "white")
chosen_file.grid(column=1, row=0)

for_sale = Label(window, text="")
for_sale.grid(column=0, row=3)
under_contract = Label(window, text="")
under_contract.grid(column=0, row=4)
homes_sold = Label(window, text="")
homes_sold.grid(column=0, row=5)
lowest_price_sold = Label(window, text="")
lowest_price_sold.grid(column=0, row=6)
highest_price_sold = Label(window, text="")
highest_price_sold.grid(column=0, row=7)
avg_price_sold = Label(window, text="")
avg_price_sold.grid(column=0, row=8)
avg_days_on_market = Label(window, text="")
avg_days_on_market.grid(column=0, row=9)



window.mainloop()
