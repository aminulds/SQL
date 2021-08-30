

-- Cleaning data in SQL Query


select *
from Housing;

-- Date Formate
ALTER TABLE	Housing
Add SaleDateConvrt Date;

update Housing
set SaleDateConvrt = CONVERT(Date, SaleDate);


-- Property address data
select *
from Housing
order by ParcelID;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from Housing a
join Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from Housing a
join Housing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


-- Splite Address Column into indivusual column
select PropertyAddress
from Housing;

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address

from Housing;

alter table Housing
Add PropertySplitAddress Nvarchar(255);

Update Housing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

alter table Housing
Add PropertySplitCity Nvarchar(255);

Update Housing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select *
from Housing

select OwnerAddress
from Housing;

select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

from Housing;

alter table Housing
add OwnerSpltAddress Nvarchar(255)
alter table Housing
add OwnerSpltCity Nvarchar(255)
alter table Housing
add OwnerSpltState Nvarchar(255)

Update Housing
set OwnerSpltAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	OwnerSpltCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	OwnerSpltState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

select *
from Housing;


-- Change Y and N in Sold as Vacant 
select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from Housing
group by SoldAsVacant
order by 2;

select SoldAsVacant,
CASE When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		End
from Housing

Update Housing
set SoldAsVacant = CASE When SoldAsVacant = 'Y' then 'Yes'
		When SoldAsVacant = 'N' then 'No'
		End


-- Remove Duplicate
With RowNumCTE as(
select*,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
				UniqueID
	) row_num
from Housing
)
select *
from RowNumCTE
where row_num > 1
Order by PropertyAddress

select *
from Housing


-- Delete Unused Columns
alter table Housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate;

select *
from Housing;