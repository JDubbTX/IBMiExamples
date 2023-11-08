--Code in this example will help you prevent signature violation errors on IBM i
--When a Program is bound to a service program, the exported signature from the service program 
--must match the stored signature from when the calling program was built

-- For this set of queries, first set the current_shema special regiter. Set it to the program object library where
-- your programs and service programs are stored
set current_schema = 'JWEIRICH1';

-- Now lets query bound service program info in our program lib.
SELECT a.*
  FROM QSYS2.BOUND_SRVPGM_INFO a
  WHERE PROGRAM_LIBRARY = current_schema
  and bound_service_program_library != 'QSYS'
  ;

-- The signature is not readable as its blob character data.
-- To get it readable, first create an unhex user defined function (udf).
-- This only needs to be run one time.
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
  -- and program_name = 'BASE64TST' uncomment to target a specific program
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
 --  and PROGRAM_NAME = 'PRINTER' uncomment to target a specific sercie program
 ;

--We can combine the two queries as cte's, check if the signatures match.  If not, update the signature
With PROGRAMS as -- Programs CTE
(SELECT PROGRAM_NAME
, PROGRAM_LIBRARY
, OBJECT_TYPE
, BOUND_SERVICE_PROGRAM
, BOUND_SERVICE_PROGRAM_LIBRARY
, BOUND_SERVICE_PROGRAM_SIGNATURE
, UNHEX(CAST(a.BOUND_SERVICE_PROGRAM_SIGNATURE as VARCHAR(32000))) as BOUND_SERVICE_PROGRAM_SIGNATURE_UNHEXED
  FROM QSYS2.BOUND_SRVPGM_INFO a
  WHERE PROGRAM_LIBRARY = current_schema
    and bound_service_program_library != 'QSYS'
  ),
  SERVICE_PROGRAMS as --Servce Program CTE
  (SELECT PROGRAM_NAME
, PROGRAM_LIBRARY
, EXPORT_SIGNATURES
, UNHEX( CAST(EXPORT_SIGNATURES as VARCHAR(32000))) as EXPORT_SIGNATURES_UNHEXED
  FROM QSYS2.PROGRAM_INFO
  WHERE PROGRAM_LIBRARY = current_schema
  )
  SELECT PROGRAMS.PROGRAM_NAME -- final select that joins them together based on bound service program name
  , PROGRAMS.PROGRAM_LIBRARY
  , PROGRAMS.BOUND_SERVICE_PROGRAM
  , PROGRAMS.BOUND_SERVICE_PROGRAM_LIBRARY
  , BOUND_SERVICE_PROGRAM_SIGNATURE_UNHEXED
  , EXPORT_SIGNATURES_UNHEXED
  , CASE 
     when LOCATE_IN_STRING(BOUND_SERVICE_PROGRAM_SIGNATURE,EXPORT_SIGNATURES)>0 
     then 'NO'
     else CASE
          when QSYS2.QCMDEXC('UPDPGM PGM(' 
             CONCAT PROGRAMS.PROGRAM_LIBRARY 
             CONCAT '/' CONCAT PROGRAMS.PROGRAM_NAME 
             CONCAT ') MODULE(*NONE) BNDSRVPGM((*LIBL/' 
             CONCAT PROGRAMS.BOUND_SERVICE_PROGRAM 
             CONCAT' *IMMED))') = 1
             then 'YES, UPDATED'
          else 'YES, NOT UPDATED - Check Joblog'
          end  
    end as SIGNATURE_VIOLATION
  FROM PROGRAMS
  JOIN SERVICE_PROGRAMS ON PROGRAMS.BOUND_SERVICE_PROGRAM = SERVICE_PROGRAMS.PROGRAM_NAME
  where PROGRAMS.PROGRAM_LIBRARY = current_schema
;
