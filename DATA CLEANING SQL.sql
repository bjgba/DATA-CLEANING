--cleaning data in sql
SELECT *
FROM nashvillehousing

-----standardize date format
select saledate
from nashvillehousing

alter table nashvillehousing
alter column saledate date

------populate property address date

SELECT *
FROM nashvillehousing
--where propertyaddress is null
order by parcelid

select a.parcelid,a.propertyaddress,a.parcelid,b.propertyaddress,isnull(a.propertyaddress,b.PropertyAddress)
from nashvillehousing as a
join nashvillehousing as b
on a.parcelid=b.parcelid
and a.uniqueid<>b.uniqueid
where a.PropertyAddress is null


update a
set propertyaddress=isnull(a.propertyaddress,b.PropertyAddress)
from nashvillehousing as a
join nashvillehousing as b
on a.parcelid=b.parcelid
and a.uniqueid<>b.uniqueid
where a.PropertyAddress is null


----brEAking down address int individual columns(address,city,state)


SELECT PROPERTYADDRESS
FROM nashvillehousing
--WHERE PROPERTYADDRESS IS NULL
--ORDER BY PARCELID

SELECT  
SUBSTRING(PROPERTYADDRESS,1, charindex(',',propertyaddress)-1) as ADDRESS,
SUBSTRING(PROPERTYADDRESS,charindex(',',propertyaddress)+1,LEN(PROPERTYADDRESS)) 
FROM nashvillehousing

ALTER TABLE nashvillehousing
ADD PROPERYTYSPILTADDRESS NVARCHAR(255)

UPDATE nashvillehousing
SET PROPERYTYSPILTADDRESS=SUBSTRING(PROPERTYADDRESS,1, charindex(',',propertyaddress)-1) 
 

ALTER TABLE NASHVILLEHOUSING
ADD PROPERTYSPILTCITY NVARCHAR(255)

UPDATE nashvillehousing
SET PROPERTYSPILTCITY= SUBSTRING(PROPERTYADDRESS,charindex(',',propertyaddress)+1,LEN(PROPERTYADDRESS))



SELECT *
FROM nashvillehousing


SELECT OwnerAddress
FROM nashvillehousing



--EASY ALTERNATIVE FOR SUBSTRING

SELECT 
PARSENAME (REPLACE(Owneraddress,',','.'),3),
PARSENAME (REPLACE(Owneraddress,',','.'),2),
PARSENAME (REPLACE(Owneraddress,',','.'),1)
from nashvillehousing
order by OwnerAddress

alter table nashvillehousing 
add ownersplitaddress nvarchar(255)

update nashvillehousing
set ownersplitaddress=PARSENAME (REPLACE(Owneraddress,',','.'),3)


ALTER table nashvillehousing 
add ownersplitcity nvarchar(255)

update nashvillehousing
set ownersplitcity=PARSENAME (REPLACE(Owneraddress,',','.'),2)


alter table nashvillehousing
add ownersplitstate nvarchar(255)

update nashvillehousing
set ownersplitstate =PARSENAME (REPLACE(Owneraddress,',','.'),1)


select *
from nashvillehousing


---change Y AND N TO YES AND NO IN  SOLD AS VACANT

SELECT DISTINCT(SOLDASVACANT),COUNT(SOLDASVACANT)
FROM nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant,
CASE
WHEN SoldAsVacant='Y' THEN 'YES'
WHEN SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant 
END 
FROM nashvillehousing


UPDATE nashvillehousing
SET SOLDASVACANT=CASE
WHEN SoldAsVacant='Y' THEN 'YES'
WHEN SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant 
END 





-------REMOVE DUPLICATES

WITH ROWNUMCTE AS (
select *,
ROW_NUMBER() over (partition by
PARCELID,
PROPERTYADDRESS,
SALEPRICE,
SALEDATE,
LEGALREFERENCE
ORDER BY UNIQUEID
) ROW_NUM
FROM nashvillehousing	
--ORDER BY PARCELID			
)
SELECT *
 FROM ROWNUMCTE
 WHERE ROW_NUM >1
 --ORDER BY PropertyAddress



select *
from nashvillehousing 

--- DELETE UNUSED COLUMN

ALTER TABLE NASHVILLEHOUSING
DROP COLUMN PROPERTYADDRESS,OWNERADDRESS,TAXDISTRICT

------DATA CLEANING

SELECT *
FROM NASH1


select saledate
from nash1

alter table nash1
alter column saledate date


select *
from nash1
where PropertyAddress is null

---popularize the propertyaddress

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress)
from nash1 as a
join NASH1 as b
on a.[UniqueID ]<>b.[UniqueID ]
and a.ParcelID=b.ParcelID
where b.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.propertyaddress,b.PropertyAddress)
from nash1 as a
join NASH1 as b
on a.[UniqueID ]<>b.[UniqueID ]
and a.ParcelID=b.ParcelID
where b.PropertyAddress is null

select propertyaddress
from nash1
where PropertyAddress is null

-=-----splitpropertyaddress

select propertyaddress
from NASH1

select SUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1),
		substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))
from NASH1


alter table nash1
add propertyspiltaddress nvarchar(255)


update nash1
set propertyspiltaddress=sUBSTRING(propertyaddress,1,charindex(',',propertyaddress)-1)


alter table nash1
add propertyspiltcity nvarchar(255)


update nash1
set propertyspiltcity=substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))

--spilt owneraddress

select owneraddress
from nash1

select *
from nash1

select PARSENAME(REPLACE(OWNERADDRESS,',','.'),3),
		PARSENAME(REPLACE(OWNERADDRESS,',','.'),2),
		PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)
FROM NASH1


ALTER TABLE NASH1
ADD OWNERSPILTADDRESS NVARCHAR(255)

UPDATE NASH1
SET OWNERSPILTADDRESS=PARSENAME(REPLACE(OWNERADDRESS,',','.'),3)


ALTER TABLE NASH1
ADD OWNERSPILTCITY NVARCHAR(255)

UPDATE NASH1
SET OWNERSPILTCITY=PARSENAME(REPLACE(OWNERADDRESS,',','.'),2)


ALTER TABLE NASH1
ADD OWNERSPILTSTATE NVARCHAR(255)

UPDATE NASH1
SET OWNERSPILTSTATE=PARSENAME(REPLACE(OWNERADDRESS,',','.'),1)



--CHANGE N AND Y TO NO AND YES IN SOLDASVACANT

SELECT SoldAsVacant,
CASE
WHEN SoldAsVacant='Y' THEN 'YES'
WHEN SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant
END
FROM NASH1 


UPDATE NASH1
SET SoldAsVacant=CASE
WHEN SoldAsVacant='Y' THEN 'YES'
WHEN SoldAsVacant='N' THEN 'NO'
ELSE SoldAsVacant
END


SELECT *
FROM NASH1

---REMOVE DUPLICATE ROW


WITH CTE AS
(
SELECT*, ROW_NUMBER() OVER (PARTITION
					BY
					PARCELID,
					SALEDATE,
					SALEPRICE,
					PROPERTYADDRESS,
					LEGALREFERENCE ORDER BY UNIQUEID)
					ROW_NUM
					--ORDER BY PARCELID
	FROM NASH1
	)


SELECT *
FROM CTE
WHERE ROW_NUM>1
--ORDER BY PROPERTYADDRESS




