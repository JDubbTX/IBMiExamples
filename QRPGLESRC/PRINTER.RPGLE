**Free
// -------------------------------------------------------------------------------------
// Printer module - Procedures for printing to a spool file
// More info at https://jdubbtx.github.io/2023/10/16/How-to-Build-a-Service-Program.html
// -------------------------------------------------------------------------------------
Ctl-Opt NoMain Option(*SrcStmt) ReqPrExp(*Require);
/COPY ./QPTYPESRC/PRINTER.RPGLEINC

///
// Title: printThis
// Description: Print stuff in 2 columns
///
Dcl-Proc printThis Export;
  Dcl-Pi *N; 
    inLabel Char(21) Const;
    inValue VarChar(100) Const;
  End-Pi;

  Dcl-F QPRINT Printer(132) Static;
  Dcl-Ds line Len(132) Inz Qualified;
    label    Char(21);
    *N       Char(1);
    val      char(100);
  End-Ds;

  line.label = inLabel;
  line.val = inValue;
  write QPRINT line;

  Return;
  
End-Proc;
