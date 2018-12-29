-- orders business sequentially based on when they applied for Scottsdale Business License
select *
from [dbo].[BusinessLicenses]
order by [LicenseNumber]

-- group and count by city of mailing address
select [MailingCity]
	,count([MailingCity]) as _count_
from [dbo].[BusinessLicenses]
group by [MailingCity]
order by _count_ desc

-- group and count by state of mailing address
-- over 12K blanks, it seems these are business which have the same mailing and service address
select [MailingState]
	,count([MailingState]) as _count_
from [dbo].[BusinessLicenses]
group by [MailingState]
order by _count_ desc

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

-- many businesses have service street addresses in one non-AZ state and mailing street addresses in another non-AZ state, what's up with this?
select *
from [dbo].[BusinessLicenses]
where [ServiceState] <> 'AZ'

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
