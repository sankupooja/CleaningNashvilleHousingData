-- Cleaning Data in SQL queries 

Select * from PortfolioProject..NashvilleHousing

--Standardize Date format 

Select SaleDateConverted 
from PortfolioProject..NashvilleHousing

/*Update PortfolioProject..NashvilleHousing
SEt SaleDate=  CONVERT(Date, SaleDate)*/

Alter table PortfolioProject..NashvilleHousing
Add SaleDateConverted Date 

Update PortfolioProject..NashvilleHousing
SEt SaleDateConverted =  CONVERT(Date, SaleDate)

-- Populate Prperty address

Select * 
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null 
order by ParcelID

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
  on a.ParcelID=b.ParcelID 
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress= isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
Join PortfolioProject..NashvilleHousing b
  on a.ParcelID=b.ParcelID 
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into individual columns (Address, City, State)

Select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null 
--order by ParcelID

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Location
from PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitAddress Nvarchar(255)

Update PortfolioProject..NashvilleHousing
SEt PropertySplitAddress =  SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

Alter table PortfolioProject..NashvilleHousing
Add PropertySplitCity Nvarchar(255)

Update PortfolioProject..NashvilleHousing
SEt PropertySplitCity =  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


Select * 
from PortfolioProject..NashvilleHousing


Select OwnerAddress 
from PortfolioProject..NashvilleHousing

select 
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update PortfolioProject..NashvilleHousing
SEt OwnerSplitAddress =  PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Update PortfolioProject..NashvilleHousing
SEt OwnerSplitCity =  PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter table PortfolioProject..NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update PortfolioProject..NashvilleHousing
SEt OwnerSplitState =  PARSENAME(Replace(OwnerAddress,',','.'),1)

--Change Y and N to Yes and No in "Sold as Vacant" field 

select distinct SoldAsVacant, count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
       case 
	       when SoldAsVacant = 'N' then 'No'
		   when SoldAsVacant = 'Y' then 'Yes'
		   else SoldAsVacant
	   end
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set SoldAsVacant =
      case 
	       when SoldAsVacant = 'N' then 'No'
		   when SoldAsVacant = 'Y' then 'Yes'
		   else SoldAsVacant
	   end

--Remove duplicates 

with RowNumCTE as(
select *,
     row_number() over 
     (partition by ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   order by 
				         uniqueID) row_num
from PortfolioProject..NashvilleHousing)
--order by ParcelID
select *
from RowNumCTE
where row_num>1
order by PropertyAddress

-- delete unused columns 

select *
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column owneraddress, Taxdistrict, propertyAddress

alter table PortfolioProject..NashvilleHousing
drop column saledate

