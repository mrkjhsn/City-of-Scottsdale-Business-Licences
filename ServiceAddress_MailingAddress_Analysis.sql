-- how many service addresses are found in AZ and outside of AZ?
-- less than a quarter of total service street addresses are located outside of AZ
-- does a business with no service street address in Scottsdale mean they have no physical presence in Scottsdale?

select sum(A.AZ_count) as AZ
	,sum(A.non_AZ_count) Non_AZ
from	(select [ServiceState]
			,case when [ServiceState]  = 'AZ' 
				then count([ServiceState]) 
				end as AZ_count
			,case when [ServiceState]  <> 'AZ' 
				then count([ServiceState]) 
				end as non_AZ_count
		from [dbo].[BusinessLicenses]
		group by [ServiceState]
		) as A

--  how many mailing addresses are found in AZ and outside of AZ?
-- twice as many mailing addresses are located outside of AZ as inside AZ
select sum(A.AZ_count) as AZ
	,sum(A.non_AZ_count) Non_AZ
from	(select [MailingState]
			,case when [MailingState]  = 'AZ' 
				then count([MailingState]) 
				end as AZ_count
			,case when [MailingState]  <> 'AZ' 
				then count([MailingState]) 
				end as non_AZ_count
		from [dbo].[BusinessLicenses]
		group by [MailingState]
		) as A


-- look at over 4K businesses with no service street address in Scottsdale, what is the makeup?
-- lots of companys that look as if they do business in the area temporarily for conferences/sales events like Barret Jackson Auto show, or Art exhibitions
-- parent companies of local franchises, such as fast food restaurants

-- which service addresses are associated with the highest number of business?

-- create temp table with count of all service addresses
select 		concat([ServiceStreet]
			  ,[ServiceStreet2]
			  ,[ServiceUnitType]
			  ,[ServiceCity]
			  ,[ServiceCounty]
			  ,[ServiceState]
			  ,[ServiceZip]
			  ,[ServiceCountry]) as service_address
			  ,count(concat([ServiceStreet]
			  ,[ServiceStreet2]
			  ,[ServiceUnitType]
			  ,[ServiceCity]
			  ,[ServiceCounty]
			  ,[ServiceState]
			  ,[ServiceZip]
			  ,[ServiceCountry])) as service_address_count
into #service_address_count
from [dbo].[BusinessLicenses]
group by concat([ServiceStreet]
			  ,[ServiceStreet2]
			  ,[ServiceUnitType]
			  ,[ServiceCity]
			  ,[ServiceCounty]
			  ,[ServiceState]
			  ,[ServiceZip]
			  ,[ServiceCountry])
order by count(concat([ServiceStreet]
			  ,[ServiceStreet2]
			  ,[ServiceUnitType]
			  ,[ServiceCity]
			  ,[ServiceCounty]
			  ,[ServiceState]
			  ,[ServiceZip]
			  ,[ServiceCountry])) desc


-- use the above temp table to list all addresses in descending order of businesses registered with the address
select A.*
	   ,concat(A.[ServiceStreet]
			  ,A.[ServiceStreet2]
			  ,A.[ServiceUnitType]
			  ,A.[ServiceCity]
			  ,A.[ServiceCounty]
			  ,A.[ServiceState]
			  ,A.[ServiceZip]
			  ,A.[ServiceCountry]) as service_address
	   ,B.service_address_count	

from [dbo].[BusinessLicenses] as A
	inner join #service_address_count as B on B.service_address = 
				  concat(A.[ServiceStreet]
						,A.[ServiceStreet2]
						,A.[ServiceUnitType]
						,A.[ServiceCity]
						,A.[ServiceCounty]
						,A.[ServiceState]
						,A.[ServiceZip]
						,A.[ServiceCountry])
--where A.ServiceState <> 'AZ'																	
order by B.service_address_count desc, A.ServiceStreet


-------------------------------------------------------------
-- which mailing addresses are associated with the highest number of business?

-- create temp table with count of all service addresses
select 		concat([MailingStreet]
			  ,[MailingStreet2]
			  ,[MailingUnitType]
			  ,[MailingUnit]
			  ,[MailingCity]
			  ,[MailingCounty]
			  ,[MailingState]
			  ,[MailingZip]
			  ,[MailingCountry]) as mailing_address
			  ,count(concat([MailingStreet]
			  ,[MailingStreet2]
			  ,[MailingUnitType]
			  ,[MailingUnit]
			  ,[MailingCity]
			  ,[MailingCounty]
			  ,[MailingState]
			  ,[MailingZip]
			  ,[MailingCountry])) as mailing_address_count
into #mailing_address_count
from [dbo].[BusinessLicenses]
group by concat([MailingStreet]
			  ,[MailingStreet2]
			  ,[MailingUnitType]
			  ,[MailingUnit]
			  ,[MailingCity]
			  ,[MailingCounty]
			  ,[MailingState]
			  ,[MailingZip]
			  ,[MailingCountry])
order by count(concat([MailingStreet]
			  ,[MailingStreet2]
			  ,[MailingUnitType]
			  ,[MailingUnit]
			  ,[MailingCity]
			  ,[MailingCounty]
			  ,[MailingState]
			  ,[MailingZip]
			  ,[MailingCountry])) desc


-- use the above temp table to list all addresses in descending order of businesses registered with the address
select A.*
	   ,concat(A.[MailingStreet]
			  ,A.[MailingStreet2]
			  ,A.[MailingUnitType]
			  ,A.[MailingUnit]
			  ,A.[MailingCity]
			  ,A.[MailingCounty]
			  ,A.[MailingState]
			  ,A.[MailingZip]
			  ,A.[MailingCountry]) as mailing_address
	   ,B.mailing_address_count	

from [dbo].[BusinessLicenses] as A
	inner join #mailing_address_count as B on B.mailing_address = 
				  concat(A.[MailingStreet]
						,A.[MailingStreet2]
						,A.[MailingUnitType]
						,A.[MailingUnit]
						,A.[MailingCity]
						,A.[MailingCounty]
						,A.[MailingState]
						,A.[MailingZip]
						,A.[MailingCountry])
where A.[MailingStreet] <> ''																	
order by B.mailing_address_count desc, A.[MailingStreet]

----------------------------
-- 744 businesses have a service street addresses in one non-AZ state and mailing street addresses in another non-AZ state, what's up with this?
-- 363 combinations of service address in one state and mailing address in another
-- CA/OR is the highest combination with 33 businesses

select [ServiceState]
	,[MailingState]
	,count([ServiceState]) as _count_
from [dbo].[BusinessLicenses]
where [ServiceState] <> 'AZ' and  -- exclude AZ businesses
	[MailingStreet] not like '' and  -- exclude businesses with no mailing addresses
	[ServiceState] <> [MailingState]  -- exclude businesses with idential service and mailing addresses
group by [ServiceState],[MailingState]
order by count([ServiceState]) desc

-- examine businesses that make up CA/OR combination
-- lots of tech/solar related businesses, many of the exact same addresses
select *
from [dbo].[BusinessLicenses]
where [ServiceState] = 'CA' and 
	  [MailingState] = 'OR'

-- examine businesses that make up CA/TX combination
-- no clear pattern of industries here
select *
from [dbo].[BusinessLicenses]
where [ServiceState] = 'CA' and 
	  [MailingState] = 'TX'