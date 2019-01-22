import re

first_row = True #assign first_row as boolean

<<<<<<< HEAD
with open('ct_BusinessLicences.csv','r') as input_file: #read from this file
    with open("BusinessLicenses_cleaned.txt","w") as output_file: #write into this file
        for row in input_file: #step through each row of csv file
            if first_row: #handle first row different since it doesn't have business numbers
                headers = re.sub(r',','|',row) 
                output_file.write(headers) #write headers to txt file
                first_row = False #prevent first row from being processed again
            else:
                n = re.search(r'[,]\d{2,7}[,]', row).start() #regex as variable
                bus_name = row[0:n]  #pulls the business name off the front of the string
                bus_info_raw = row[n:] #pulls everything after the business name
                bus_info_clean = re.sub(r',', '|', bus_info_raw) #replace commas with bar characters
                if bus_info_clean.count('|') == 21: #exclude handful of businesses with non-standard number of fields
                    output_file.write(bus_name+bus_info_clean) #write cleaned data to txt file
=======
for row in inputfile:
    index += 1   #handle the first row differently since it only includes column labels
    if index == 1:
        headers = re.sub(r',','|',row)
        output_data.write(headers)
    else:   #all other rows need to be cleaned
        bus_name = row[0:(re.search(r'[,]\d{2,7}[,]', row).start())]  #pulls the business name off the front of the string, using the business number(between 2 and 7 digits) with commas on either side as the point of reference for the regex
        bus_info_raw = row[(re.search(r'[,]\d{2,7}[,]', row).start()):] #pulls everything after the business name into a string
        bus_info_clean = re.sub(r',','|',bus_info_raw) #does a find/replace to remove all commas from business info string and replace them with bar character
        output_data.write(bus_name+bus_info_clean) #write cleaned data to txt file
>>>>>>> 64eca8dac7c33cb2b5a553dd361125a6ebcfb8c1
