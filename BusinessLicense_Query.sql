-- orders business sequentially based on when they applied for Scottsdale Business License
select *
from [dbo].[BusinessLicenses]
order by [LicenseNumber]

-- build a histogram to see distribution of business license numbers
select
	floor([LicenseNumber]/50000)*50000 as bucket_floor
	,count(*) as count_
from [dbo].[BusinessLicenses]
group by floor([LicenseNumber]/50000)*50000
order by floor([LicenseNumber]/50000)*50000

-- multiple business names associated with different service/mailing addresses
-- the highest number of same name businesses are appartment complexes in Scottsdale with each appartment registered under a separate business number
-- for instance Sunscape Villas has 27 apartment units along Hayden Rd.
-- Edward Jones has each of its locations listed under a separate business license number
select A.*
	   ,B._count_
from [dbo].[BusinessLicenses] as A
	inner join (select [BusinessName]
				,count([BusinessName]) as _count_
				from [dbo].[BusinessLicenses]
				group by [BusinessName]
				) as B on B.BusinessName = A.BusinessName
order by B._count_ desc, A.BusinessName

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


