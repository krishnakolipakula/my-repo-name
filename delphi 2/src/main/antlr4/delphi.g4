grammar delphi;

program: (classDecl | interfaceDecl | stmt)* EOF ;

classDecl: 'class' ID (':' ID)? '{' classMember* '}' ';'? ;
interfaceDecl: 'interface' ID '{' interfaceMember* '}' ';'? ;
classMember: fieldDecl | methodDecl | constructorDecl | destructorDecl ;
interfaceMember: methodSignature ;

fieldDecl: 'var' ID ':' type ';' ;
methodDecl: 'procedure' ID '(' paramList? ')' block ;
constructorDecl: 'constructor' '(' paramList? ')' block ;
destructorDecl: 'destructor' '(' ')' block ;
methodSignature: 'procedure' ID '(' paramList? ')' ';' ;

paramList: param (',' param)* ;
param: ID ':' type ;

type: 'integer' | ID ;

stmt: varDeclStmt | assignStmt | exprStmt | ioStmt | objStmt | ';' ;
varDeclStmt: 'var' ID ':' type ';' ;
assignStmt: ID '=' expr ';' ;
exprStmt: expr ';' ;
objStmt: ID '=' 'new' ID '(' argList? ')' ';' | ID '.' ID '(' argList? ')' ';' ;
ioStmt: 'readln' '(' ID ')' ';' | 'writeln' '(' expr ')' ';' ;

block: '{' stmt* '}' ;

argList: expr (',' expr)* ;

expr: expr op=('*'|'/') expr   # MulDiv
    | expr op=('+'|'-') expr   # AddSub
    | atom                     # AtomExpr
    ;

atom: INT
    | STRING
    | ID ('.' ID)?
    | '(' expr ')'
    ;

ID: [a-zA-Z_][a-zA-Z0-9_]* ;
INT: [0-9]+ ;
STRING: '"' (~["\\] | '\\' .)* '"' ;
WS: [ \t\r\n]+ -> skip ;
LINE_COMMENT: '//' ~[\r\n]* -> skip ;
