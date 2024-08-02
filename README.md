I have taken the Housing data which contained the housing sale information along with owner information. 

In SSMS, I have used queries to do some data cleaning like mentioned below :
   1. Changing the Sale date into a proper date format .
   2. Populating the property address i.e there are some rows where the parcel Id is same but unique ID is not same , in that case I have populated that null value to same address with same parcel ID.
   3. Breaking out the address into Address, city and State for better data analysis.
   4. Standardizing data in SoldAsVacant column so that the values do not differ by 'Y' or 'N'.
   5. Removing the duplicates
   6. removing the unused columns. 
