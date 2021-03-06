### City of Scottsdale Business Licences

The City of Scottsdale publishes a [dataset](http://data.scottsdaleaz.gov/dataset/business-licenses)* of all businesses(approximately 25K) who are currently licensed to operate in Scottsdale.  The data is provided as a csv file with the below attributes:

+ BusinessName,LicenseNumber,LicenseType,

+ ServiceStreet,ServiceStreet2,ServiceUnitType,ServiceUnit,ServiceCity,ServiceCounty,ServiceState,ServiceZip,ServiceCountry,

+ IssuedDate,

+ MailingStreet,MailingStreet2,MailingUnitType,MailingUnit,MailingCity,MailingCounty,MailingState,MailingZip,MailingCountry


 #### ~~Before I Can Analyze This Dataset:~~
~~The data was exported in CSV format.  This is problematic since many business names include a *comma* as part of the name.  For instance - ABCD, LLC.  As a result, when I import into SQL, a number of business names have been shifted into the LicenseNumber column.  And in some cases several columns to the right into the LicenseType and ServiceStreet columns.~~

 ~~As yet I don't know enough about regular expressions to parse the data into a format that will allow me to import it into SQL to perform analysis.  However I believe regular expressions could do that job.  A pattern exists.  LicenseNumber is an integer, the smallest of which is 27, the largest of which is over 1 million.  If a regular expression can find (,2x[0-9]) then work back from this to the beginning of the line this should be able to catch virtually all business names properly.~~

#### Results:

+ The dataset doesn't include the date the business first filed for a license.  ~~However the numbering appears to be chronological~~,(not true, a simple graph shows huge spikes. Although business licenses may have started by being sequential, this has not been consistent throughout the history of Scottsdale) with the smallest business number(27) belonging to *A-Accent Plumbing*, which claims to have been started in 1963 according to its [website](https://a-accentplumbing.com/contact-us/).  It would be interesting to analyze the makeup of the oldest businesses and compare/contrast those business names with more recent business names.
   + by binning the business license dataset, then tokenizing business names and performing a simple frequency analysis on the oldest and newest bins the biggest difference is in the usage of "LLC" vs. "Inc".  This makes sense since LLC's are a more recent business construct.  Also used more frequenly in the past are the tokens "Corporation" and "Co".

#### To Investigate Further:

+ 744 businesses have a service street addresses in one non-AZ state and mailing street addresses in another non-AZ state.  Are any patterns noticable here?  The higest combination was CA/OR.  33 Businesses have a 'Service Address' in California and a 'Mailing Address' in Oregon.  Many of these are tech companies with the words "solar" in the business name.  What sorts of advantages are companies availing themselves of by these sorts of arrangements?

+ Some addresses are associated with a number of businesses.  Are specific industries more likely to have many subsidiary businesses under the same roof?

+ What percent of businesses are headquartered in Arizona versus another state?  Both *service address* and *mailing address* are captured in the data.  My guess is that mailing addresses reflects the headquarters or parent company of a subsidiary or franchise that may be doing business in Scottsdale.

+ Businesses with addresses in commercial office/business areas versus private residences.  A number of businesses have *Apt* addresses that make me think someone is working out of their house.  There could be other cues in the data to identify these types of businesses.  Are these sorts of business distributed evenly throughout the full business license listing, or are they weighted towards more recent Scottsdale history(wich would fit with the gig economy and contract work becomming more prevelent)?

+ Has the structure of business names changed over time?  For instance, businesses that include the proprietor's name, business names that include acronmys, ect.  Use NLTK library to dig into the syntax of business names.

+ A number of businesses with a physical presence are associated with a similar *.com* namesake.  For instance Walmart.com and Target.com.  My guess is that these are businesses associated with the online sales associated with the parrent company.  Are the locations of these *.com* businesses within the Business License Dataset indicative of anything?




*Contains information from the City of Scottsdale Open Database Portal, which is made available here under the [Open Database License](http://www.scottsdaleaz.gov/AssetFactory.aspx?did=69351).
