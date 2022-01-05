SELECT * FROM fame.`nashville housing data for data cleaning (1)`;
select saledate from fame.`nashville housing data for data cleaning (1)`;
-- populate property address
select * from fame.`nashville housing data for data cleaning (1)`
-- where PropertyAddress = ''
order by ParcelID;

select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(b.propertyaddress, a.propertyaddress)
from fame.`nashville housing data for data cleaning (1)` a
join fame.`nashville housing data for data cleaning (1)` b
	on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
where a.PropertyAddress= '';

update a
inner join fame.`nashville housing data for data cleaning (1)` a
	on a.ParcelID = b.ParcelID
    and a.UniqueID <> b.UniqueID
set PropertyAddress = ifnull(b.propertyaddress, a.propertyaddress)
where a.propertyaddress = '';

select propertyaddress 
from fame.`nashville housing data for data cleaning (1)`
where PropertyAddress = '';

-- breaking out address into individual columns (address,city,state)
select PropertyAddress
from fame.`nashville housing data for data cleaning (1)`;
-- where PropertyAddress = ''
-- order by ParcelID;

select substring_index(PropertyAddress, ',', 1) as Address,
	substring_index(PropertyAddress, ',', -1) as City
from fame.`nashville housing data for data cleaning (1)`;

alter table fame.`nashville housing data for data cleaning (1)`
add PropertySplitAddress varchar(255);

update fame.`nashville housing data for data cleaning (1)`
 set PropertySplitAddress = substring_index(PropertyAddress, ',', 1);
 
alter table fame.`nashville housing data for data cleaning (1)`
add PropertySplitCity varchar(255);

update fame.`nashville housing data for data cleaning (1)`
 set PropertySplitCity = substring_index(PropertyAddress, ',', -1);
 
 select substring_index(OwnerAddress, ',', 1),
		substring_index(substring_index(OwnerAddress, ',', 2),',',-1),
		substring_index(OwnerAddress, ',', -1)
 from fame.`nashville housing data for data cleaning (1)`;
 
 alter table fame.`nashville housing data for data cleaning (1)`
add OwnerSplitAddress varchar(255);

update fame.`nashville housing data for data cleaning (1)`
 set OwnerSplitAddress = substring_index(OwnerAddress, ',', 1);
 
 alter table fame.`nashville housing data for data cleaning (1)`
add OwnerSplitCity varchar(255);

update fame.`nashville housing data for data cleaning (1)`
 set OwnerSplitCity = substring_index(substring_index(OwnerAddress,',', 2),',',-1);
 
 alter table fame.`nashville housing data for data cleaning (1)`
add OwnerSplitState varchar(255);

update fame.`nashville housing data for data cleaning (1)`
 set OwnerSplitState = substring_index(OwnerAddress, ',', -1);
 
 -- change Y and N to Yes and No In soldAsVacant field
 
 select distinct(SoldAsVacant), count(SoldAsVacant)
 from fame.`nashville housing data for data cleaning (1)`
 group by SoldAsVacant
 order by 2;
 
 select SoldAsVacant,
 CASE 
	    WHEN SoldAsVacant='Y' THEN 'YES'
		WHEN SoldAsVacant='N' THEN 'NO'
        ELSE SoldAsVacant
        END
 from fame.`nashville housing data for data cleaning (1)`;
 
 update fame.`nashville housing data for data cleaning (1)`
 set SoldAsVacant = CASE 
	    WHEN SoldAsVacant='Y' THEN 'YES'
		WHEN SoldAsVacant='N' THEN 'NO'
        ELSE SoldAsVacant
        END;
        
        -- remove duplicates
        
with RowNumCTE as (       
	 select * 
		from row_number() over(
		partition by ParcelID,
					 PropertyAddress,
                     SalePrice,
                     SaleDate,
                     LegalReference
                     order by
						UniqueID
                        ) row_num
from fame.`nashville housing data for data cleaning (1)`
 )
  SELECT * FROM RowNumCTE
  WHERE row_num > 1
  order by PropertyAddress;
 
 -- delete unused columns

  alter table fame.`nashville housing data for data cleaning (1)`
  drop column OwnerAddress,
  drop column PropertyAddress;
  
  select * from fame.`nashville housing data for data cleaning (1)`
 
 






