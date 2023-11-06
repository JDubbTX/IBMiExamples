--Code in this example will help you prevent signature violation errors on IBM i
--When a Program is bound to a service program, the exported signature from the service program 
--must match the stored signature from when the calling program was built

set current_schema = 'JWEIRICH1';

-- Now lets query bound service program info in our program named 'BASE64TST'.
SELECT a.*
  FROM QSYS2.BOUND_SRVPGM_INFO a
  WHERE PROGRAM_LIBRARY = current_schema
  and program_name = 'BASE64TST'
  and bound_service_program_library != 'QSYS'
  ;

-- The signature is not readable as its blob character data.
-- To get it readable, first create an unhex user defined function (udf).
CREATE OR REPLACE FUNCTION unhex(in VARCHAR(32000))
RETURNS VARCHAR(32000)
RETURN in;

-- Now you can use the function to return a readable representation of the signature

SELECT PROGRAM_NAME
, PROGRAM_LIBRARY
, OBJECT_TYPE
, BOUND_SERVICE_PROGRAM
, BOUND_SERVICE_PROGRAM_LIBRARY
, BOUND_SERVICE_PROGRAM_SIGNATURE
, UNHEX(CAST(a.BOUND_SERVICE_PROGRAM_SIGNATURE as VARCHAR(32000))) as BOUND_SERVICE_PROGRAM_SIGNATURE_UNHEXED
  FROM QSYS2.BOUND_SRVPGM_INFO a
  WHERE PROGRAM_LIBRARY = current_schema
  and program_name = 'BASE64TST'
  and bound_service_program_library != 'QSYS'
  ;

-- The BOUND_SERVICE_PROGRAM_SIGNATURE field contains the signature.
-- Its a binary / hex representation of the signature.

SELECT PROGRAM_LIBRARY
, PROGRAM_NAME
, PROGRAM_LIBRARY
, OBJECT_TYPE
, TEXT_DESCRIPTION
, EXPORT_SIGNATURES
, UNHEX( CAST(EXPORT_SIGNATURES as VARCHAR(32000))) as EXPORT_SIGNATURES_UNHEXED
  FROM QSYS2.PROGRAM_INFO
 WHERE PROGRAM_LIBRARY = current_schema
 and PROGRAM_NAME = 'PRINTER';

--We can combine the two queries as cte's, check if the signatures match.  If not, we should update the signature
With PROGRAMS as 
(SELECT PROGRAM_NAME
, PROGRAM_LIBRARY
, OBJECT_TYPE
, BOUND_SERVICE_PROGRAM
, BOUND_SERVICE_PROGRAM_LIBRARY
, BOUND_SERVICE_PROGRAM_SIGNATURE
, UNHEX(CAST(a.BOUND_SERVICE_PROGRAM_SIGNATURE as VARCHAR(32000))) as BOUND_SERVICE_PROGRAM_SIGNATURE_UNHEXED
  FROM QSYS2.BOUND_SRVPGM_INFO a
  WHERE PROGRAM_LIBRARY = current_schema
    and program_name = 'BASE64TST'
    and bound_service_program_library != 'QSYS'
  ),
  SERVICE_PROGRAMS as 
  (SELECT PROGRAM_NAME
, PROGRAM_LIBRARY
, EXPORT_SIGNATURES
, UNHEX( CAST(EXPORT_SIGNATURES as VARCHAR(32000))) as EXPORT_SIGNATURES_UNHEXED
  FROM QSYS2.PROGRAM_INFO
  WHERE PROGRAM_LIBRARY = current_schema
    and PROGRAM_NAME = 'PRINTER'
  )
  SELECT PROGRAMS.PROGRAM_NAME
  , PROGRAMS.PROGRAM_LIBRARY
  , PROGRAMS.BOUND_SERVICE_PROGRAM
  , PROGRAMS.BOUND_SERVICE_PROGRAM_LIBRARY
  , BOUND_SERVICE_PROGRAM_SIGNATURE_UNHEXED
  , EXPORT_SIGNATURES_UNHEXED
  , CASE 
     when LOCATE_IN_STRING(BOUND_SERVICE_PROGRAM_SIGNATURE,EXPORT_SIGNATURES)>0 then 'NO'
     else 'YES' end as SIGNATURE_VIOLATION
  FROM PROGRAMS
  JOIN SERVICE_PROGRAMS ON PROGRAMS.BOUND_SERVICE_PROGRAM = SERVICE_PROGRAMS.PROGRAM_NAME
;