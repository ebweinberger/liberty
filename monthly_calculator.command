#!/usr/bin/env python
from Tkinter import *
from tkinter.filedialog import askopenfilename
import csv
import datetime
from datetime import datetime
from datetime import date
from decimal import Decimal

window = Tk()
window.title("Real Estate Stats")
window.geometry('350x475')

FILENAME = ""
filepath = ""

def choose_file_clicked():
    global FILENAME
    global filepath

    for_sale.configure(text = "")
    under_contract.configure(text = "")
    homes_sold.configure(text = "")
    lowest_price_sold.configure(text = "")
    highest_price_sold.configure(text = "")
    avg_price_sold.configure(text = "")
    avg_days_on_market.configure(text = "")

    filepath = askopenfilename()
    path = filepath.split('/')
    FILENAME = path[-1]
    chosen_file.configure(text=FILENAME)

def go_clicked():
    # print(filepath)
    result = getAll(filepath, month_entry, year_entry) # Excecutes calculator functions below
    for_sale.configure(text = "For Sale: " + str(result[0]))
    under_contract.configure(text = "Under Contract: " + str(result[1]))
    homes_sold.configure(text = "Homes Sold: " + str(result[2]))
    lowest_price_sold.configure(text = "Lowest Price Sold: $" + str(result[3]))
    highest_price_sold.configure(text = "Highest Price Sold: $" + str(result[4]))
    avg_price_sold.configure(text = "Average Price Sold: $" + str(result[5]))
    median_price_sold.configure(text = "Median Price Sold: $" + str(result[9]))
    avg_days_on_market.configure(text = "Average Days on Market: " + str(result[6]))
    avg_price_sqft.configure(text = "Average Price per SqFt: " + str(result[7]))
    avg_sqft.configure(text = "Average SqFt: " + str(result[8]))



choose_file_button = Button(window, text="Choose a file", command=choose_file_clicked)
choose_file_button.grid(column=0, row=0)

description_label = Label(window, text='MM/YY')
description_label.grid(column=0, row=2)
month_entry = Entry(window, width=2)
month_entry.grid(column=1, row=2)
slash_label = Label(window, text='/')
slash_label.grid(column=2, row=2)
year_entry = Entry(window, width=2)
year_entry.grid(column=3, row=2)

go_button = Button(window, text="Go", command=go_clicked)
go_button.grid(column=0, row=3)
chosen_file = Label(window, text="", bg = "white")
chosen_file.grid(column=1, row=0)

# TODO: Convert labels into text boxes so that copying works
for_sale = Label(window, text="")
for_sale.grid(column=0, row=4)
under_contract = Label(window, text="")
under_contract.grid(column=0, row=5)
homes_sold = Label(window, text="")
homes_sold.grid(column=0, row=6)
lowest_price_sold = Label(window, text="")
lowest_price_sold.grid(column=0, row=7)
highest_price_sold = Label(window, text="")
highest_price_sold.grid(column=0, row=8)
avg_price_sold = Label(window, text="")
avg_price_sold.grid(column=0, row=9)
median_price_sold = Label(window, text="")
median_price_sold.grid(column=0, row=10)
avg_days_on_market = Label(window, text="")
avg_days_on_market.grid(column=0, row=11)
avg_price_sqft = Label(window, text="")
avg_price_sqft.grid(column=0, row=12)
avg_sqft = Label(window, text="")
avg_sqft.grid(column=0, row=13)



# --- Calculation Functions ---

def parse_file(filename, month_entry, year_entry):
    #Final results variables
    FOR_SALE = 0
    UNDER_CONTRACT = 0
    HOMES_SOLD = 0
    AVG_DAYS_ON_MARKET = 0
    AVG_PRICE_SOLD = 0
    AVG_PRICE_SQFT = 0
    AVG_SQFT = 0
    LOWEST_PRICE_SOLD = 5000000
    HIGHEST_PRICE_SOLD = 0

    #Helper variables
    TOTAL_DAYS_ON_MARKET = 0

    TOTAL_SOLD_DOLLARS = 0
    AVG_PRICE = 0

    #SQFT calculation numbers
    TOTAL_SQFT_DOLLARS = 0
    TOTAL_SQFT = 0
    TOTAL_SQFT_N = 0

    TOTAL_LISTINGS = 0

    MEDIAN = []

    month_str = str(month_entry.get())
    if(len(month_str) == 1):
        month_str = "0"+month_str

    year_str = str(year_entry.get())

    user_date = datetime.strptime(month_str+"01"+year_str, "%m%d%y")

    file = open(filename)
    csvreader = csv.reader(file)
    #Indecies and their corresponding column headers:
    #  [0]                          [1]                   [2]              [3]                 [4]              [5]
    #"Status"     "Listing Office 1 - Office Code"     "Price"     "Days On Market"     "Approx Sq Ft"     "Status Date"
    csvreader.next()
    for row in csvreader:
        #Count how many homes are currently for sale regardless of date
        #If the status of the home is "ACTIVE", it is for sale
        if (row[0] == "ACTIVE"):
            FOR_SALE += 1


        #Count how many homes sold this month
        #Format the "Status date" field using datetime package to easily filter for this month
        try:
            date_object = datetime.strptime(row[5], "%m/%d/%Y")
        except:
            date_object = datetime.strptime(row[5], "%m/%d/%y")


        #Convert the $XXX,XXX format to an integer
        dollars = int(row[2].strip('$').replace(',', ''))


        #If status is "SOLD" and it happened this month, it is a sold home
        if ((row[0] =="SOLD") and date_object.month == user_date.month and date_object.year == user_date.year):

            HOMES_SOLD += 1
            TOTAL_SOLD_DOLLARS += dollars
            TOTAL_DAYS_ON_MARKET += int(row[3])
            MEDIAN.append(dollars)
            #If the house sold this month, add sqft to total sqft
            if (row[4] != ""):
                TOTAL_SQFT_DOLLARS += dollars
                TOTAL_SQFT += int(row[4])
                TOTAL_SQFT_N += 1

        #Count how many homes are currently under under contract regarding
        #If the status of the home is "Under Contract", it is under contract
        if (row[0] == "Under Contract"and date_object.month == user_date.month and date_object.year == user_date.year):
            UNDER_CONTRACT += 1


        #Find the lowest priced sale from this month
        #If the price of this home is lower than the existing lowest, and it is this month in this year, it is the lowest
        if (dollars < LOWEST_PRICE_SOLD and date_object.month == user_date.month and date_object.year == user_date.year):
            LOWEST_PRICE_SOLD = dollars

        #Find the highest prices sale from this month
        #If the price of this home is higher than the existing highest, and it is this month in this year, it is the highest
        if (dollars > HIGHEST_PRICE_SOLD and date_object.month == user_date.month and date_object.year == user_date.year):
            HIGHEST_PRICE_SOLD = dollars

    #Calculate average price sold
    AVG_PRICE_SOLD = TOTAL_SOLD_DOLLARS / HOMES_SOLD
    #Calculate average days on market
    AVG_DAYS_ON_MARKET = TOTAL_DAYS_ON_MARKET / HOMES_SOLD

    AVG_SQFT = TOTAL_SQFT/TOTAL_SQFT_N
    AVG_PRICE_SQFT = (TOTAL_SQFT_DOLLARS/TOTAL_SQFT)

    MEDIAN.sort()
    MEDIAN_PRICE = MEDIAN[int(len(MEDIAN)/2)]

    result = [FOR_SALE, UNDER_CONTRACT, HOMES_SOLD, LOWEST_PRICE_SOLD, HIGHEST_PRICE_SOLD, AVG_PRICE_SOLD, AVG_DAYS_ON_MARKET, AVG_PRICE_SQFT, AVG_SQFT, MEDIAN_PRICE]
    return result

#Print it all out
# print("For Sale: " + str(FOR_SALE))
# print("Under Contract: " + str(UNDER_CONTRACT))
# print("Homes Sold: " + str(HOMES_SOLD))
# print("Lowest Price Sold: " + str(LOWEST_PRICE_SOLD))
# print("Highest Price Sold: " + str(HIGHEST_PRICE_SOLD))
# print("Average Sold Price: " + str(AVG_PRICE_SOLD))
# print("Average Days on Market: " + str(AVG_DAYS_ON_MARKET))

def getAll(filename, month_entry, year_entry):
    result = parse_file(filename, month_entry, year_entry)
    return result

#Close the csv file
# file.close()







window.mainloop()
