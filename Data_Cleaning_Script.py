#python script that cleans CSV data and organizes it with a separator that doesn't compromise the data on import
import re

inputfile = open('ct_BusinessLicences.csv','r') #pulls raw data
output_data = open("BusinessLicenses_cleaned.txt","w") #cleaned data saved in this file
index = 0

for row in inputfile:
    index += 1   #handle the first row differently since it only includes column labels
    if index == 1:
        headers = re.sub(r',','|',row)
        output_data.write(headers)
    else:   #all other rows need to be cleaned
        bus_name = row[0:(re.search(r'[,]\d{2,7}[,]', row).start())]  #pulls the business name off the front of the string, using the business number(between 2 and 7 digits) as the point of reference for the regex
        bus_info_raw = row[(re.search(r'[,]\d{2,7}[,]', row).start()):] #pulls everything after the business name into a string
        bus_info_clean = re.sub(r',','|',bus_info_raw) #does a find/replace to remove all commas from business info string and replace them with bar character
        output_data.write(bus_name+bus_info_clean) #write cleaned data to txt file
output_data.close()