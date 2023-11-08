**FREE
Ctl-Opt option(*srcstmt:*nodebugio);

Dcl-Pi RPGPGM2;
  RangeStart char(2);
  RangeEnd   char(2);
End-Pi;

dcl-s KEY_FIELD zoned(9);

Dcl-F CUSTOMER KEYED ALIAS;

// read the customer ddl table
read(e) FCSREAA;

KEY_FIELD = CUSTOMER_ID;

// Declare cursor
// exec sql 
//   declare c1 cursor for 
//   select CUSTOMER_ID // final select
//   from CUSTOMER_DDL_TABLE
//   where substr(CUSTOMER_ID , 7 , 2) >= :RangeStart
//     and substr(CUSTOMER_ID , 7 , 2) <= :RangeEnd;
// exec sql open c1;
// exec sql fetch c1 into :Cust_ID;

// CHAIN Customer table


// dow sqlcode = 0;
// Insert some logic to build a name
// More logic to be added later
// update forde ;
//   exec sql fetch c1 into :Cust_ID;
// ENDDO;
// new comment
*inlr = *on;
