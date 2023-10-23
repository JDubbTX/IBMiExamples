**FREE
ctl-opt actgrp(*new) bnddir('BNDUTIL');

// Start of Main Procedure
// Declare some stand-alone fields
Dcl-S PlainText   VARCHAR(100) INZ('MyText') CCSID(1208);
Dcl-S EncodedText VARCHAR(100);
Dcl-S DecodedTextVarBinary  sqltype(VARBINARY:100);
Dcl-S TranslatedTextVarChar VARCHAR(100) CCSID(1208);

/copy ./qptypesrc/printer.rpgleinc

// Print headings
printThis('Field Name' : 'Value');
printThis('---------------------' : '-----------------------------------------------------------');

printThis('PlainText' : %Trim(PlainText));

// Encode the text into a VARCHAR field
Exec SQL Values QSYS2.BASE64_ENCODE(:PlainText) Into :EncodedText;
printThis('EncodedText' : %trim(EncodedText));

// Decode the encoded text into an EBCDIC VarBinary field
Exec SQL Values QSYS2.BASE64_DECODE(:EncodedText) Into :DecodedTextVarBinary;
printThis('DecodedTextVarBinary' : %trim(DecodedTextVarBinary));

// Translate binary data in EBCDIC to UTF-8
TranslatedTextVarChar = DecodedTextVarBinary;
printThis('TranslatedTextVarChar' : %trim(TranslatedTextVarChar));

return;
