/****** Data Cleaning  ******/


  -- Standardize Date Format

  Select SaleDate, Convert(Date,SaleDate)
  From [Portfolio_Project_1].[dbo].[NashvilleData];

  Update [Portfolio_Project_1].[dbo].[NashvilleData]
  SET SaleDate = Convert(Date,SaleDate);

  Alter Table [Portfolio_Project_1].[dbo].[NashvilleData]
  Add SaleDateConverted Date;

  Update [Portfolio_Project_1].[dbo].[NashvilleData]
  SET SaleDateConverted = Convert(Date,SaleDate);


  -- Populate Property Address data


  Select * from [Portfolio_Project_1].[dbo].[NashvilleData]
  where PropertyAddress is null
  order by ParcelID;

  Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  From [Portfolio_Project_1].[dbo].[NashvilleData] a
  Join [Portfolio_Project_1].[dbo].[NashvilleData] b
  on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null;


  Update a
  SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  From [Portfolio_Project_1].[dbo].[NashvilleData] a
  Join [Portfolio_Project_1].[dbo].[NashvilleData] b
  on a.ParcelID = b.ParcelID and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null;

  -- Breaking out Address into Individual Columns (Address, City, State)

  Select PropertyAddress
  From [Portfolio_Project_1].[dbo].[NashvilleData];

  Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address_1,
  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as Address_2
  From [Portfolio_Project_1].[dbo].[NashvilleData];

  --Select CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress) From [Portfolio_Project_1].[dbo].[NashvilleData];
   
   Alter Table [Portfolio_Project_1].[dbo].[NashvilleData]
   Add PropertySplitAddress Nvarchar(255);

   Update [Portfolio_Project_1].[dbo].[NashvilleData]
   SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1);

   Alter Table [Portfolio_Project_1].[dbo].[NashvilleData]
   Add PropertySplitCity Nvarchar(255);

   Update [Portfolio_Project_1].[dbo].[NashvilleData]
   SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress));


   Select OwnerAddress from [Portfolio_Project_1].[dbo].[NashvilleData];


   Select PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
  ,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
  From [Portfolio_Project_1].[dbo].[NashvilleData];



  ALTER TABLE [Portfolio_Project_1].[dbo].[NashvilleData]
  Add OwnerSplitAddress Nvarchar(255);



  Update [Portfolio_Project_1].[dbo].[NashvilleData]
  SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3);




  ALTER TABLE [Portfolio_Project_1].[dbo].[NashvilleData]
  Add OwnerSplitCity Nvarchar(255);



  Update [Portfolio_Project_1].[dbo].[NashvilleData]
  SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2);




  ALTER TABLE [Portfolio_Project_1].[dbo].[NashvilleData]
  Add OwnerSplitState Nvarchar(255);



  Update [Portfolio_Project_1].[dbo].[NashvilleData]
  SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1);




  Select *
  From [Portfolio_Project_1].[dbo].[NashvilleData];


  -- Change Y and N to Yes and No in "Sold as Vacant" field



  Select Distinct(SoldAsVacant), Count(SoldAsVacant) 
  From [Portfolio_Project_1].[dbo].[NashvilleData]
  Group by SoldAsVacant
  Order by 2;



  Select SoldAsVacant, 
  Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   END
   From [Portfolio_Project_1].[dbo].[NashvilleData];



   Update [Portfolio_Project_1].[dbo].[NashvilleData]
   SET SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   Else SoldAsVacant
	   END

  

  -- Remove Duplicates

  With T1 as (
  Select *, Row_number() Over(Partition by ParcelID, PropertyAddress, SalePrice, SaleDate,LegalReference
            Order by UniqueID) row_num
			From [Portfolio_Project_1].[dbo].[NashvilleData])

			Select * from T1
			where row_num >1


  With T1 as (
  Select *, Rank() Over(Partition by ParcelID, PropertyAddress, SalePrice, SaleDate,LegalReference
            Order by UniqueID) row_num
			From [Portfolio_Project_1].[dbo].[NashvilleData])

			Delete from T1
			where row_num >1




	--Delete unused columns

	Alter Table [Portfolio_Project_1].[dbo].[NashvilleData]
	Drop Column TaxDistrict, SaleDate