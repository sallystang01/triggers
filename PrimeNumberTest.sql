create proc spPrimeNumberTest

AS

use PrimeNumberTest
SELECT TOP (10) Number
FROM Numbers N1
WHERE N1.Number > 1 
  AND NOT EXISTS (
    SELECT 1 FROM Numbers N2
    WHERE N2.Number > 1 
         AND N1.Number > N2.Number
         AND N1.Number % N2.Number = 0
    )

