import csv
import datetime
from datetime import datetime
from datetime import date

sample = open('sample.csv')
csvreader = csv.reader(sample)

FOR_SALE = 0
UNDER_CONTRACT = 0
HOMES_SOLD = 0
AVG_DAYS_ON_MARKET = 0
AVG_PRICE_SOLD = 0
AVG_PRICE_SQFT = 0
LOWEST_PRICE_SOLD = 0
HIGHEST_PRICE_SOLD = 0

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
    #If status is "SOLD" and it happened this month, it is a sold home
    date_object = datetime.strptime(row[5], "%m/%d/%Y")
    today = date.today()
    if (row[0] =="SOLD" and date_object.month == today.month):
        HOMES_SOLD += 1

print("For Sale: " + str(FOR_SALE))
print("Under Contract: " + str(UNDER_CONTRACT))
print("Homes Sold: " + str(HOMES_SOLD))

sample.close()
