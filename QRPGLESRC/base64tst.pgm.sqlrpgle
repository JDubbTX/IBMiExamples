**free
ctl-opt actgrp(*new) bnddir('BNDUTIL');

// Start of Main Procedure
// Declare some stand-alone fields
Dcl-S PlainText   VARCHAR(100) INZ('MyText') CCSID(1208);
Dcl-S EncodedText VARCHAR(100);
Dcl-S DecodedTextVarBinary  sqltype(VARBINARY:100);
Dcl-S TranslatedTextVarChar VARCHAR(100) CCSID(1208);

/copy ./qptypesrc/printer.rpgleinc

// Print headings
print_this('Field Name' : 'Value');
print_this('---------------------' : '-----------------------------------------------------------');

print_this('PlainText' : %Trim(PlainText));

Exec SQL Values QSYS2.BASE64_ENCODE(:PlainText) Into :EncodedText;
print_this('EncodedText' : %trim(EncodedText));

Exec SQL Values QSYS2.BASE64_DECODE(:EncodedText) Into :DecodedTextVarBinary;
print_this('DecodedTextVarBinary' : %trim(DecodedTextVarBinary));

TranslatedTextVarChar = DecodedTextVarBinary;
print_this('TranslatedTextVarChar' : %trim(TranslatedTextVarChar));

return;
