create or replace procedure JWEIRICH1.GETTMPLIB (IN msgq char, OUT TEMPLIB char) 
LANGUAGE CL  
EXTERNAL NAME JWEIRICH1.MSGPROC GENERAL;

call jweirich1.gettmplib('JWEIRICH',?);
