### City of Scottsdale Business Licences

The City of Scottsdale publishes a [dataset](http://data.scottsdaleaz.gov/dataset/business-licenses) of all businesses(approximately 25K) who are currently licensed to operate in Scottsdale.  The data is provided in the below format:

BusinessName,LicenseNumber,LicenseType,ServiceStreet,ServiceStreet2,ServiceUnitType,ServiceUnit,ServiceCity,ServiceCounty,ServiceState,ServiceZip,ServiceCountry,IssuedDate,MailingStreet,MailingStreet2,MailingUnitType,MailingUnit,MailingCity,MailingCounty,MailingState,MailingZip,MailingCountry


#### Before I Can Analyze This Dataset:
The data was exported in CSV format.  This is problematic since many business names include a *comma* as part of the name.  For instance - ABCD, LLC.  As a result, when I import into SQL, a number of business names have been shifted into the LicenseNumber column.  And in some cases several columns to the right into the LicenseType and ServiceStreet columns.

As yet I don't know enough about regular expressions to parse the data into a format that will allow me to import it into SQL to perform analysis.  However I believe regular expressions could do that job.  A pattern exists.  LicenseNumber is an integer, the smallest of which is 27, the largest of which is over 1 million.  If a regular expression can find (,2x[0-9]) then work back from this to the beginning of the line this should be able to catch virtually all business names properly. 

#### To Investigate:

+ The dataset doesn't include the date the business first filed for a license.  However the numbering appears to be chronological, with the smallest business number(27) belonging to *A-Accent Plumbing*, which claims to have been started in 1963 according to its [website](https://a-accentplumbing.com/contact-us/).  It would be interesting to analyze the makeup of the oldest one thousand businesses to get a sense for what types of businesses they are.  Are there any particular reasons for their longevity?

+ What percent of businesses are headquartered in Arizona versus another state?  Both *service address* and *mailing address* are captured in the data.  My guess is that mailing address reflects the headquarters or parent company or a subsidiary or franchise that may be doing business in Scottsdale.

+ Businesses with addresses in commercial office/business areas versus private residences.  A number of businesses have *Apt* addresses that make me think someone has a business and is working out of their house.  There could be other cues in the data to identify these types of businesses.  Are these sorts of business distributed evenly throughout the full business license listing, or are they weighted towards more recent Scottsdale history(wich would fit with the gig economy becomming more prevelent)?

+ Has the structure of business names changed over time?  For instance, businesses that include the proprietor's name, business names that include acronmys, ect.
