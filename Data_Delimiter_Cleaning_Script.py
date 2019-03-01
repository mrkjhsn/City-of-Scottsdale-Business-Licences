import re

first_row = True #assign first_row as boolean

with open('ct_BusinessLicences.csv','r') as input_file: #read from this file
    with open('BusinessLicenses_cleaned.txt','w') as output_file: #write into this file
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
