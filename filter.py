import csv
import datetime
from datetime import datetime
from datetime import date
from decimal import Decimal

sample = open('sample.csv')
csvreader = csv.reader(sample)

#Final results variables
FOR_SALE = 0
UNDER_CONTRACT = 0
HOMES_SOLD = 0
AVG_DAYS_ON_MARKET = 0
AVG_PRICE_SOLD = 0
AVG_PRICE_SQFT = 0
LOWEST_PRICE_SOLD = 5000000
HIGHEST_PRICE_SOLD = 0

#Helper variables
TOTAL_DAYS_ON_MARKET = 0

TOTAL_SOLD_DOLLARS = 0

TOTAL_SQFT = 0
TOTAL_SQFT_N = 0


#Indecies and their corresponding column headers:
#  [0]                          [1]                   [2]              [3]                 [4]              [5]
#"Status"     "Listing Office 1 - Office Code"     "Price"     "Days On Market"     "Approx Sq Ft"     "Status Date"
i = 0
csvreader.next()
for row in csvreader:
    # print(row[0])
    #Count how many homes are currently for sample
    #If the status of the home is "ACTIVE", it is for sale
    if (row[0] == "ACTIVE"):
        FOR_SALE += 1

    #Count how many homes are currently under under contract
    #If the status of the home is "Under contract", it is under contract
    if (row[0] == "Under Contract"):
        UNDER_CONTRACT += 1

    #Count how many home sold this month
    #Format the "Status date" field using datetime package to easily filter for this month
    date_object = datetime.strptime(row[5], "%m/%d/%Y")
    today = date.today()
    #Convert the $XXX,XXX format to an integer
    dollars = int(row[2].strip('$').replace(',', ''))
    #If status is "SOLD" and it happened this month, it is a sold home
    if (row[0] =="SOLD" and date_object.month == today.month):
        HOMES_SOLD += 1
        TOTAL_SOLD_DOLLARS += dollars
        TOTAL_DAYS_ON_MARKET += int(row[3])

    #Find the lowest priced sale from this month
    #If the price of this home is lower than the existing lowest, and it is this month, it is the lowest
    if (dollars < LOWEST_PRICE_SOLD and date_object.month == today.month):
        LOWEST_PRICE_SOLD = dollars

    #Find the highest prices sale from this month
    #If the price of this home is higher than the existing highest, and it is this month, it is the highest
    if (dollars > HIGHEST_PRICE_SOLD and date_object.month == today.month):
        HIGHEST_PRICE_SOLD = dollars

#Calculate average price sold
AVG_PRICE_SOLD = TOTAL_SOLD_DOLLARS / HOMES_SOLD
AVG_DAYS_ON_MARKET = TOTAL_DAYS_ON_MARKET / HOMES_SOLD
print("For Sale: " + str(FOR_SALE))
print("Under Contract: " + str(UNDER_CONTRACT))
print("Homes Sold: " + str(HOMES_SOLD))
print("Lowest Price Sold: " + str(LOWEST_PRICE_SOLD))
print("Highest Price Sold: " + str(HIGHEST_PRICE_SOLD))
print("Average Sold Price: " + str(AVG_PRICE_SOLD))
print("Average Days on Market: " + str(AVG_DAYS_ON_MARKET))


sample.close()
