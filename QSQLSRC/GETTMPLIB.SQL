create or replace procedure JWEIRICH1.GETTMPLIB (IN msgq char(30), OUT TEMPLIB char(8)) 
LANGUAGE CL  
EXTERNAL NAME JWEIRICH1.MSGPROC GENERAL;

call jweirich1.gettmplib ('JWEIRICH1                              ');
