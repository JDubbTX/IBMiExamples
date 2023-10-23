**Free
// -------------------------------------------------------------------------------------
// Printer module - Procedures for printing to a spool file
// More info at https://jdubbtx.github.io/2023/10/16/How-to-Build-a-Service-Program.html
// -------------------------------------------------------------------------------------
Ctl-Opt NoMain Option(*SrcStmt) ReqPrExp(*Require);
/Copy ./qptypesrc/printer.rpgleinc

// Procedure for Printing to a spool file
Dcl-Proc printThis Export;
  Dcl-Pi *N; 
    inLabel Char(21) Const;
    inValue VarChar(100) Const;
  End-Pi;

  Dcl-F QPRINT Printer(132) Static;
  Dcl-Ds line Len(132) Inz Qualified;
    label    Char(21);
    *N       Char(1);
    val      Char(100);
  End-Ds;

  line.label = inLabel;
  line.val = inValue;
  Write QPRINT line;

  Return;
  
End-Proc;
