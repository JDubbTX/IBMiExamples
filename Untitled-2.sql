SELECT * FROM JWEIRICH1.CUSTOMER_DDL_TABLE as a;
delete from jweirich1.customer_ddl_table;

select Systools.HTTPGETCLOB(
    URL => CAST('https://namey.muffinlabs.com/name.json?count=1&type=surname&frequency=ALL' AS VARCHAR(255)),
    HTTPHEADER => CAST(NULL AS CLOB(1K)))
from sysibm.sysdummy1;

SELECT SYSTOOLS.HTTPGETCLOB(                            
  URL => CAST('http://ws.geonames.org/countryInfo?lang=' CONCAT 
          SYSTOOLS.URLENCODE('en','') CONCAT                 
          '&country=' CONCAT
          SYSTOOLS.URLENCODE('us','') CONCAT
          '&type=XML' AS VARCHAR(255)),
  HTTPHEADER => CAST(NULL AS CLOB(1K)))
FROM SYSIBM.SYSDUMMY1; 

-- Random Name generator from US Census.  Change count to get more or less
insert into customer_ddl_table -- Final
     (CUSTOMER_NAME_FIRST, CUSTOMER_NAME_MI, CUSTOMER_NAME_LAST)
With names as(
Select  SUBSTR(FullName, 1,LOCATE(' ',FullName)-1) as FIRST_NAME
      , CHR(INT(RAND()*26)+65) as MIDDLE_INITIAL
      , SUBSTR(FullName, LOCATE(' ',FullName)+1) as LAST_NAME  
From JSON_TABLE(
    Systools.HTTPGETCLOB(
    URL => CAST('https://namey.muffinlabs.com/name.json?count=10&with_surname=true&frequency=common' AS VARCHAR(255) CCSID 37),
    HTTPHEADER => CAST(NULL AS CLOB(1K))
    ),'$'
    COLUMNS
    (FullName VARCHAR(255) path '$'
    ) error on error
    ) as x)
select FIRST_NAME, MIDDLE_INITIAL, LAST_NAME 
     From names;

select * from customer_ddl_table;

INSERT INTO CORPDATA.EMPTIME
     (EMPNUMBER, PROJNUMBER, STARTDATE, ENDDATE)
  SELECT EMPNO, PROJNO, EMSTDATE, EMENDATE
    FROM CORPDATA.EMPPROJACT;


SELECT *
    FROM JSON_TABLE(
SYSTOOLS.HTTPGETCLOB(
  'https://api.mapbox.com/geocoding/v5/mapbox.places/' CONCAT 
          SYSTOOLS.URLENCODE(TRIM(City), '') CONCAT 
          '.json?access_token=' CONCAT
          SYSTOOLS.URLENCODE(TRIM(APIKEY),'') CONCAT
          '&limit=' CONCAT
          SYSTOOLS.URLENCODE('1',''), NULL
  ),
  '$'
  COLUMNS
  (Lat    FLOAT     path '$.features[0].center[1]',
   Lon    FLOAT     path '$.features[0].center[0]',
   PName  CHAR(100) path '$.features[0].place_name'
  ) error on error
  ) as x;

  Values CHR(INT(RAND()*26)+65);