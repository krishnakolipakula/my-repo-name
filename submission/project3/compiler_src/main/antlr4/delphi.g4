grammar delphi;

program: topLevelDecl* stmt* mainBlock? EOF ;

topLevelDecl: interfaceDecl | classDecl | procedureDecl | functionDecl ;

mainBlock: 'begin' stmt* 'end' '.'? ;

classDecl
    : ID '=' 'class' ('(' ID (',' ID)* ')')? 'begin' classMember* 'end' ';'?
    ;
interfaceDecl
    : ID '=' 'interface' 'begin' methodSignature* 'end' ';'?
    ;
classMember: fieldDecl | methodDecl | constructorDecl | destructorDecl ;
methodSignature: 'procedure' ID '(' paramList? ')' ';' ;

fieldDecl: ('private' | 'public')? 'var' ID ':' type ';' ;
methodDecl: 'procedure' ID '(' paramList? ')' block ;
constructorDecl: 'constructor' '(' paramList? ')' block ;
destructorDecl: 'destructor' '(' ')' block ;

procedureDecl: 'procedure' ID '(' paramList? ')' block ';'? ;
functionDecl: 'function' ID '(' paramList? ')' ':' type block ';'? ;

paramList: param (';' param)* ;
param: ID ':' type ;

type: 'integer' | ID ;

stmt
    : varDeclStmt
    | assignStmt
    | objStmt
    | procCallStmt
    | ioStmt
    | exprStmt
    | whileStmt
    | forStmt
    | breakStmt
    | continueStmt
    | ';'
    ;

varDeclStmt: 'var' ID ':' type ';' ;
assignStmt: (ID | ID '.' ID) ':=' expr ';' ;
exprStmt: expr ';' ;
objStmt
    : ID ':=' ID '.' 'Create' '(' argList? ')' ';'
    | ID ':=' ID '.' 'create' '(' argList? ')' ';'
    | ID '.' ID '(' argList? ')' ';'
    ;
procCallStmt: ID '(' argList? ')' ';' ;
whileStmt: 'while' expr 'do' (block | stmt) ;
forStmt: 'for' ID ':=' expr ('to'|'downto') expr 'do' (block | stmt) ;
breakStmt: 'break' ';' ;
continueStmt: 'continue' ';' ;
ioStmt: 'readln' '(' ID ')' ';' | 'writeln' '(' expr ')' ';' ;

block: 'begin' stmt* 'end' ;

argList: expr (',' expr)* ;

expr: expr op=('*'|'/') expr               # MulDiv
    | expr op=('+'|'-') expr               # AddSub
    | expr op=('='|'<'|'>'|'<='|'>='|'<>') expr  # Comparison
    | atom                                 # AtomExpr
    ;

atom: INT
    | STRING
    | ID ('.' ID)?
    | ID '(' argList? ')'
    | '(' expr ')'
    ;

ID: [a-zA-Z_][a-zA-Z0-9_]* ;
INT: [0-9]+ ;
STRING: '"' (~["\\] | '\\' .)* '"' ;
WS: [ \t\r\n]+ -> skip ;
LINE_COMMENT: '//' ~[\r\n]* -> skip ;
BRACE_COMMENT: '{' ~[}]* '}' -> skip ;
