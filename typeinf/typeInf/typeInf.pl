:- dynamic gvar/2.

/* match functions by unifying with arguments
   and infering the result
*/
typeExp(Expr, T) :-
    typeExp(Expr, [], T).

/* tuple expression */
typeExp(tuple(Exprs), Env, tuple(Types)) :-
    is_list(Exprs),
    typeExpList(Exprs, Env, Types),
    !.

/* sum constructors */
typeExp(inl(Expr, RightT), Env, sum(LeftT, RightT)) :-
    bType(RightT),
    typeExp(Expr, Env, LeftT),
    bType(LeftT),
    !.

typeExp(inr(LeftT, Expr), Env, sum(LeftT, RightT)) :-
    bType(LeftT),
    typeExp(Expr, Env, RightT),
    bType(RightT),
    !.

typeExp(Fct, Env, T) :-
    nonvar(Fct),
    compound(Fct),
    Fct =.. [Fname|Args],
    append(Args, [T], FType),
    functionType(Fname, Env, TArgs),
    typeExpList(FType, Env, TArgs),
    !.

typeExp(Name, Env, T) :-
    atom(Name),
    \+ bType(Name),
    lookupVar(Name, Env, T),
    !.

/* zero-parameter function call as atom expression
   Example: gfLet(c, [], int, [return(int)]) can be called using expr(c)
*/
typeExp(Name, Env, T) :-
    atom(Name),
    \+ bType(Name),
    functionType(Name, Env, [T]),
    !.

/* propagate type variables */
typeExp(X, _Env, T) :-
    var(X),
    !,
    X = T.

/* basic type literals */
typeExp(B, _Env, B) :-
    bType(B).

/* list version to allow function matching */
typeExpList([], _, []).
typeExpList([Hin|Tin], Env, [Hout|Tout]) :-
    typeExp(Hin, Env, Hout),
    typeExpList(Tin, Env, Tout).

/* variable lookup: local env first, then globals */
lookupVar(Name, Env, T) :-
    memberchk(Name-T, Env),
    !.
lookupVar(Name, _Env, T) :-
    gvar(Name, T),
    \+ is_list(T).

/* statement wrappers */
typeStatement(S, T) :-
    typeStatement(S, [], _EnvOut, T).

/* expression statement */
typeStatement(expr(E), Env, Env, T) :-
    typeExp(E, Env, T).

/* return statement */
typeStatement(return(E), Env, Env, T) :-
    typeExp(E, Env, T).

/* local variable definition */
typeStatement(lvLet(Name, T, Expr), Env, [Name-T|Env], unit) :-
    atom(Name),
    typeExp(Expr, Env, T),
    bType(T).

/* tuple templated assignment/unpacking
   Example:
       tplLet([x-int, y-float], tuple([int, float]))
*/
typeStatement(tplLet(Bindings, TupleExpr), Env, EnvOut, unit) :-
    is_list(Bindings),
    tupleBindingTypes(Bindings, Types),
    typeExp(TupleExpr, Env, tuple(Types)),
    append(Bindings, Env, EnvOut).

/* global variable definition
   Example:
       gvLet(v, T, int) ~ let v = 3;
*/
typeStatement(gvLet(Name, T, Expr), Env, Env, unit) :-
    atom(Name),
    typeExp(Expr, Env, T),
    bType(T),
    retractall(gvar(Name, _)),
    asserta(gvar(Name, T)).

/* global function definition
   Params is a list of Name-Type pairs, e.g.
   gfLet(add, [x-int, y-int], int, [return(iplus(x,y))])
*/
typeStatement(gfLet(Name, Params, RetT, Body), Env, Env, unit) :-
    atom(Name),
    paramsType(Params, ParamTypes),
    append(ParamTypes, [RetT], Sig),
    bType(Sig),
    retractall(gvar(Name, _)),
    setup_call_cleanup(
        asserta(gvar(Name, Sig), Ref),
        ( append(Params, Env, FunEnv),
          typeCodeOrStatement(Body, FunEnv, BodyT),
                    BodyT = RetT
        ),
        erase(Ref)
    ),
    asserta(gvar(Name, Sig)).

/* if statement */
typeStatement(if(Cond, ThenCode, ElseCode), Env, Env, T) :-
    typeExp(Cond, Env, bool),
    typeCodeOrStatement(ThenCode, Env, TThen),
    typeCodeOrStatement(ElseCode, Env, TElse),
    typeExp(TThen, Env, T),
    typeExp(TElse, Env, T).

/* let-in local scope */
typeStatement(letIn(Name, T, Expr, InCode), Env, Env, TOut) :-
    atom(Name),
    typeExp(Expr, Env, T),
    bType(T),
    typeCodeOrStatement(InCode, [Name-T|Env], TOut).

/* for loop: for(i, Start, End, Body) */
typeStatement(for(Var, Start, End, Body), Env, Env, unit) :-
    atom(Var),
    typeExp(Start, Env, int),
    typeExp(End, Env, int),
    typeCodeOrStatement(Body, [Var-int|Env], _TBody).

/* match statement for sum types
   Example:
       match(E, [
           case(inl(x), expr(iplus(x, int))),
           case(inr(y), expr(iplus(y, int)))
       ])
*/
typeStatement(match(Expr, Cases), Env, Env, T) :-
    typeExp(Expr, Env, sum(LeftT, RightT)),
    select(case(inl(LeftPat), LeftBody), Cases, RestCases),
    select(case(inr(RightPat), RightBody), RestCases, []),
    bindCasePattern(LeftPat, LeftT, Env, LeftEnv),
    bindCasePattern(RightPat, RightT, Env, RightEnv),
    typeCodeOrStatement(LeftBody, LeftEnv, LeftOutT),
    typeCodeOrStatement(RightBody, RightEnv, RightOutT),
    LeftOutT = T,
    RightOutT = T.

/* block statement */
typeStatement(block(Code), Env, Env, T) :-
    typeCode(Code, Env, T).

/* Code is a list of statements. Type is the type of the last statement */
typeCode([S], Env, T) :-
    typeStatement(S, Env, _EnvOut, T).
typeCode([S|Code], Env, T) :-
    Code = [_|_],
    typeStatement(S, Env, EnvNext, _TS),
    typeCode(Code, EnvNext, T).

typeCodeOrStatement(Code, Env, T) :-
    is_list(Code),
    !,
    typeCode(Code, Env, T).
typeCodeOrStatement(Stmt, Env, T) :-
    typeStatement(Stmt, Env, _EnvOut, T).

paramsType([], []).
paramsType([_Name-T|Tail], [T|Ts]) :-
    bType(T),
    paramsType(Tail, Ts).

tupleBindingTypes([], []).
tupleBindingTypes([Name-T|Tail], [T|Ts]) :-
    atom(Name),
    bType(T),
    tupleBindingTypes(Tail, Ts).

bindCasePattern('_', _T, Env, Env) :- !.
bindCasePattern(Name-TAnn, T, Env, EnvOut) :-
    !,
    TAnn = T,
    bindCasePattern(Name, T, Env, EnvOut).
bindCasePattern(Name, T, Env, [Name-T|Env]) :-
    atom(Name),
    Name \= '_'.

/* top level function */
infer(Code, T) :-
    is_list(Code),
    deleteGVars(),
    typeCode(Code, [], T).

/* Basic types */
bType(int).
bType(float).
bType(string).
bType(bool).
bType(unit).
bType(tuple(Types)) :-
    is_list(Types),
    bTypeList(Types).
bType(sum(Left, Right)) :-
    bType(Left),
    bType(Right).

/* function type */
bType([H]) :- bType(H).
bType([H|T]) :- bType(H), bType(T).

bTypeList([]).
bTypeList([H|T]) :-
    bType(H),
    bTypeList(T).

/* delete all global definitions */
deleteGVars() :-
    retractall(gvar(_, _)).

/* builtin functions */
fType(iplus, [int, int, int]).
fType(iminus, [int, int, int]).
fType(imult, [int, int, int]).
fType(idiv, [int, int, int]).

fType(fplus, [float, float, float]).
fType(fminus, [float, float, float]).
fType(fmult, [float, float, float]).
fType(fdiv, [float, float, float]).

fType(fToInt, [float, int]).
fType(iToFloat, [int, float]).

fType(concat, [string, string, string]).

fType(ilt, [int, int, bool]).
fType(ieq, [int, int, bool]).
fType(flt, [float, float, bool]).
fType(feq, [float, float, bool]).
fType(and, [bool, bool, bool]).
fType(or, [bool, bool, bool]).
fType(not, [bool, bool]).

fType(print, [_X, unit]).

/* Find function signature
   A function is either local, user defined global, or built in
*/
functionType(Name, Env, Args) :-
    memberchk(Name-Args, Env),
    is_list(Args),
    !.
functionType(Name, _Env, Args) :-
    gvar(Name, Args),
    is_list(Args),
    !.
functionType(Name, _Env, Args) :-
    fType(Name, Args).
