**FREE
Ctl-Opt option(*srcstmt:*nodebugio);

Dcl-Pi RPGPGM1;
  RangeStart char(2);
  RangeEnd   char(2);
End-Pi;

dcl-ds Customer_t extname('CUSTOMER') qualified alias template end-ds;
dcl-s Cust_ID like(Customer_t.CUSTOMER_ID);

// Declare cursor
exec sql 
  declare c1 cursor for 
  select CUSTOMER_ID
  from CUSTOMER_DDL_TABLE
  where substr(CUSTOMER_ID , 7 , 2) >= :RangeStart
    and substr(CUSTOMER_ID , 7 , 2) <= :RangeEnd;
exec sql open c1;
exec sql fetch c1 into :Cust_ID;

dow sqlcode = 0;
  // Insert some logic to build a name
  // More logic to be added here
  // update forde ;
  exec sql fetch c1 into :Cust_ID;
ENDDO;
// new comment
*inlr = *on;
