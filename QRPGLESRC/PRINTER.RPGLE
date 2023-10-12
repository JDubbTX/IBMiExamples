**free
ctl-opt NoMain;
/copy ./qptypesrc/printer.rpgleinc
// Procedure for Printing to a spool file
dcl-proc print_this export;
  dcl-pi *n;
    inLabel char(21) const;
    inValue varchar(100) const;
  end-pi;

  Dcl-f QPRINT printer(132) static;
  dcl-ds line len(132) inz qualified;
    Label    char(21);
    *n       char(1);
    Val      char(100);
  end-ds;

  line.Label = inLabel;
  line.Val = inValue;
  write QPRINT line;

  return;
  
end-proc;
