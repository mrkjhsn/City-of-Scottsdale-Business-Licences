-- orders business sequentially based on when they applied for Scottsdale Business License
select *
from [dbo].[BusinessLicenses]
order by [LicenseNumber]

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

-- look at over 4K businesses with no service street address in Scottsdale, what is the makeup?
-- lots of companys that look as if they do business in the area temporarily for conferences/sales events like Barret Jackson Auto show, or Art exhibitions
-- parent companies of local franchises, such as fast food restaurants

-- by a long shot CA has more businesses headquartered that do business in Scottsdale
select 
	[ServiceState]
	,count([ServiceState]) as _count_
from [dbo].[BusinessLicenses]
group by [ServiceState]
having [ServiceState] <> 'AZ'
order by count([ServiceState]) desc


-- For Arizona based businesses, which cities have the largest number of businesses that do business in Scottsdale?
-- vast majority of businesses are headquartered in Phoenix
select [ServiceCity]
	,count([ServiceCity]) as _count_
from [dbo].[BusinessLicenses]
group by [ServiceCity], [ServiceState] 
having [ServiceState] = 'AZ' 
	and [ServiceCity] <> 'Scottsdale'
order by count([ServiceCity]) desc



-- Denny's Inc parent company has a SC service address
-- while two restaurant locations have local addresses
select *
from [dbo].[BusinessLicenses]
where [BusinessName] like '%denny%'

-- 203 businesses have identical service street addresses and mailing street addresses
-- businesses like WalMart.Com USA LLC are included here
select *
from [dbo].[BusinessLicenses]
where [ServiceState] <> 'AZ' and
	[ServiceStreet] = [MailingStreet]


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

-- which addresses are associated with the highest number of business?
-- conversly, are some business types associated with my sub-businesses?
select count(concat([ServiceStreet]
			  ,[ServiceStreet2]
			  ,[ServiceUnitType]
			  ,[ServiceCity]
			  ,[ServiceCounty]
			  ,[ServiceState]
			  ,[ServiceZip]
			  ,[ServiceCountry])) as service_address
from [dbo].[BusinessLicenses]
group by concat([ServiceStreet]
			  ,[ServiceStreet2]
			  ,[ServiceUnitType]
			  ,[ServiceCity]
			  ,[ServiceCounty]
			  ,[ServiceState]
			  ,[ServiceZip]
			  ,[ServiceCountry])
--order by count(concat([ServiceStreet]
--			  ,[ServiceStreet2]
--			  ,[ServiceUnitType]
--			  ,[ServiceCity]
--			  ,[ServiceCounty]
--			  ,[ServiceState]
--			  ,[ServiceZip]
--			  ,[ServiceCountry])) desc



select A.[BusinessName]
	   ,B.service_address	

from [dbo].[BusinessLicenses] as A
	inner join (select
				concat(B.[ServiceStreet],B.[ServiceZip]) as _concat_
			    ,count(concat([ServiceStreet],[ServiceZip])) as service_address_count
			    from [dbo].[BusinessLicenses]
			    group by concat(B.[ServiceStreet]
			   ,B.[ServiceZip]) as B on concat(B.[ServiceStreet],B.[ServiceZip]) = concat(A.[ServiceStreet],A.[ServiceZip])
																	
order by B.service_address desc











-- WalMart has a separate license for it's website as well as it's 1 physical store in north Scottsdale
-- how many other businesses have multiple licenses like this?
select *
from [dbo].[BusinessLicenses]
where [BusinessName] like '%walmart%'

-- find all website businesses licenses
select *
from [dbo].[BusinessLicenses]
where [BusinessName] like '%.com%'
order by [LicenseNumber]

-- insert dates as best I can identify from company websites
UPDATE [dbo].[BusinessLicenses]
SET [Founding_Date] = '1963'
WHERE [BusinessName] = 'GREEN ACRES MORTUARY AND CEMET'

UPDATE [dbo].[BusinessLicenses]
SET [Founding_Date] = '1959'
WHERE [BusinessName] = 'THE COACH HOUSE'

UPDATE [dbo].[BusinessLicenses]
SET [Founding_Date] = '1958'
WHERE [BusinessName] = 'BARRY''S DANCE THEATRE SHOP'

UPDATE [dbo].[BusinessLicenses]
SET [Founding_Date] = '1965'
WHERE [BusinessName] = 'ASSOCIATED FINISHES INC'

UPDATE [dbo].[BusinessLicenses]
SET [Founding_Date] = '1947'
WHERE [BusinessName] = 'LOS OLIVOS MEXICAN PATIO INC'

UPDATE [dbo].[BusinessLicenses]
SET [Founding_Date] = '1971'
WHERE [BusinessName] = 'PAUL SCHOONOVER INC'

-- create column for business founding year
alter table [dbo].[BusinessLicenses]
add Founding_Date int


