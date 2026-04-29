:- begin_tests(typeInf).
:- include(typeInf). 
:- set_test_options([format(log), output(always)]).

/* Note: when writing tests keep in mind that 
    the use of of global variable and function definitions
    define facts for gvar() predicate. Either test
    directy infer() predicate or call
    delegeGVars() predicate to clean up gvar().
*/

/* ------------------------------------------------------------------ */
/* typeExp tests */
/* ------------------------------------------------------------------ */

test(typeExp_iplus) :-
    typeExp(iplus(int, int), int).

test(typeExp_iplus_F, [fail]) :-
    typeExp(iplus(int, int), float).

test(typeExp_iplus_T, [true(T == int)]) :-
    typeExp(iplus(int, int), T).

test(typeExp_builtin_string_concat) :-
    typeExp(concat(string, string), string).

test(typeExp_builtin_bool) :-
    typeExp(and(bool, bool), bool).

test(typeExp_tuple_basic, [true(T == tuple([int, float]))]) :-
    typeExp(tuple([int, float]), T).

test(typeExp_sum_left, [true(T == sum(int, float))]) :-
    typeExp(inl(int, float), T).

test(typeExp_sum_right, [true(T == sum(int, float))]) :-
    typeExp(inr(int, float), T).

/* ------------------------------------------------------------------ */
/* statement + environment tests */
/* ------------------------------------------------------------------ */

test(typeStatement_gvar, [nondet, true(T == int)]) :-
    deleteGVars(),
    typeStatement(gvLet(v, T, iplus(X, Y)), unit),
    assertion(X == int),
    assertion(Y == int),
    gvar(v, int).

test(typeStatement_local_let, [nondet, true(T == int)]) :-
    typeStatement(lvLet(x, T, int), unit).

test(typeStatement_tuple_unpack, [nondet, true(T == int)]) :-
    typeStatement(tplLet([x-int, y-int], tuple([int, int])), [], Env1, unit),
    typeStatement(expr(iplus(x, y)), Env1, _Env2, T).

test(mockedFct, [nondet]) :-
    deleteGVars(),
    asserta(gvar(my_fct, [int, float])),
    typeExp(my_fct(X), T),
    assertion(X == int),
    assertion(T == float).

/* ------------------------------------------------------------------ */
/* infer/2 tests (>=20 cases) */
/* ------------------------------------------------------------------ */

test(infer_01_gvar_basic, [nondet, true(T == unit)]) :-
    infer([gvLet(v, TV, iplus(X, Y))], T),
    assertion(TV == int),
    assertion(X == int),
    assertion(Y == int),
    gvar(v, int).

test(infer_02_expr_stmt, [true(T == int)]) :-
    once(infer([expr(iplus(int, int))], T)).

test(infer_03_block_last_type, [true(T == float)]) :-
    once(infer([block([expr(fplus(float, float))])], T)).

test(infer_04_two_statements, [true(T == int)]) :-
    once(infer([expr(print(string)), expr(iplus(int, int))], T)).

test(infer_05_if_int_branches, [true(T == int)]) :-
    once(infer([if(ilt(int, int), expr(iplus(int, int)), expr(iminus(int, int)))], T)).

test(infer_06_if_mismatch_fail, [fail]) :-
    infer([if(ilt(int, int), expr(iplus(int, int)), expr(fplus(float, float)))], _T).

test(infer_07_let_in_local, [true(T == int)]) :-
    once(infer([letIn(x, TX, int, expr(iplus(x, int)))], T)),
    assertion(TX == int).

test(infer_08_for_unit, [true(T == unit)]) :-
    once(infer([for(i, int, int, expr(print(i)))], T)).

test(infer_09_for_bounds_fail, [fail]) :-
    infer([for(i, float, int, expr(print(i)))], _T).

test(infer_10_function_definition, [true(T == unit)]) :-
    once(infer([
        gfLet(add, [x-int, y-int], int, [expr(iplus(x, y))])
    ], T)),
    gvar(add, [int, int, int]).

test(infer_11_function_call_after_def, [true(T == int)]) :-
    once(infer([
        gfLet(add, [x-int, y-int], int, [expr(iplus(x, y))]),
        expr(add(int, int))
    ], T)).

test(infer_12_function_return_stmt, [true(T == int)]) :-
    once(infer([
        gfLet(add, [x-int, y-int], int, [return(iplus(x, y))]),
        expr(add(int, int))
    ], T)).

test(infer_13_recursive_function, [true(T == int)]) :-
    once(infer([
        gfLet(id_like, [n-int], int,
            if(ilt(n, int), return(int), return(id_like(n)))
        ),
        expr(id_like(int))
    ], T)).

test(infer_14_global_var_use, [true(T == int)]) :-
    once(infer([
        gvLet(v, int, int),
        expr(iplus(v, int))
    ], T)).

test(infer_15_global_var_type_fail, [fail]) :-
    infer([
        gvLet(v, int, int),
        expr(fplus(v, float))
    ], _T).

test(infer_16_nested_let_in, [true(T == int)]) :-
    once(infer([
        letIn(x, int, int,
            letIn(y, int, int,
                expr(iplus(x, y))
            )
        )
    ], T)).

test(infer_17_bool_pipeline, [true(T == bool)]) :-
    once(infer([
        expr(and(ilt(int, int), or(bool, not(bool))))
    ], T)).

test(infer_18_string_pipeline, [true(T == string)]) :-
    once(infer([
        expr(concat(string, string))
    ], T)).

test(infer_19_conversion_pipeline, [true(T == float)]) :-
    once(infer([
        expr(iToFloat(iplus(int, int)))
    ], T)).

test(infer_20_conversion_pipeline_2, [true(T == int)]) :-
    once(infer([
        expr(fToInt(fplus(float, float)))
    ], T)).

test(infer_21_block_with_local_chain, [true(T == int)]) :-
    once(infer([
        block([
            lvLet(x, int, int),
            lvLet(y, int, int),
            expr(iplus(x, y))
        ])
    ], T)).

test(infer_22_if_inside_block, [true(T == int)]) :-
    once(infer([
        block([
            if(ieq(int, int), expr(iplus(int, int)), expr(iplus(int, int)))
        ])
    ], T)).

test(infer_23_function_wrong_return_fail, [fail]) :-
    infer([
        gfLet(bad, [x-int], float, [expr(iplus(x, int))])
    ], _T).

test(infer_24_for_then_expr, [true(T == int)]) :-
    once(infer([
        for(i, int, int, expr(print(i))),
        expr(iplus(int, int))
    ], T)).

test(infer_25_global_reset_between_calls, [nondet]) :-
    once(infer([gvLet(v, int, int), expr(iplus(v, int))], int)),
    gvar(v, int),
    infer([expr(int)], int),
    \+ gvar(v, _).

test(infer_26_imult, [true(T == int)]) :-
    once(infer([expr(imult(int, int))], T)).

test(infer_27_idiv, [true(T == int)]) :-
    once(infer([expr(idiv(int, int))], T)).

test(infer_28_fmult, [true(T == float)]) :-
    once(infer([expr(fmult(float, float))], T)).

test(infer_29_fdiv, [true(T == float)]) :-
    once(infer([expr(fdiv(float, float))], T)).

test(infer_30_if_nonbool_cond_fail, [fail]) :-
    infer([if(int, expr(iplus(int, int)), expr(iplus(int, int)))], _T).

/* ------------------------------------------------------------------ */
/* bonus tests */
/* ------------------------------------------------------------------ */

test(infer_31_tuple_value, [true(T == tuple([int, float, string]))]) :-
    once(infer([expr(tuple([int, float, string]))], T)).

test(infer_32_tuple_unpack_and_use, [true(T == int)]) :-
    once(infer([
        tplLet([a-int, b-int], tuple([int, int])),
        expr(iplus(a, b))
    ], T)).

test(infer_33_tuple_unpack_shape_fail, [fail]) :-
    infer([
        tplLet([a-int, b-int], tuple([int, int, int]))
    ], _T).

test(infer_34_sum_match_left, [true(T == int)]) :-
    once(infer([
        gvLet(s, sum(int, int), inl(int, int)),
        match(s, [
            case(inl(x), expr(iplus(x, int))),
            case(inr(y), expr(iplus(y, int)))
        ])
    ], T)).

test(infer_35_sum_match_right, [true(T == int)]) :-
    once(infer([
        gvLet(s, sum(int, int), inr(int, int)),
        match(s, [
            case(inl(x), expr(iplus(x, int))),
            case(inr(y), expr(iplus(y, int)))
        ])
    ], T)).

test(infer_36_sum_match_branch_type_fail, [fail]) :-
    infer([
        gvLet(s, sum(int, int), inl(int, int)),
        match(s, [
            case(inl(x), expr(iplus(x, int))),
            case(inr(y), expr(fplus(float, float)))
        ])
    ], _T).

test(infer_37_match_non_sum_fail, [fail]) :-
    infer([
        match(int, [
            case(inl(x), expr(x)),
            case(inr(y), expr(y))
        ])
    ], _T).

test(infer_38_zero_param_function_call, [true(T == int)]) :-
    once(infer([
        gfLet(c, [], int, [return(int)]),
        expr(c)
    ], T)).

test(infer_39_match_single_case_fail, [fail]) :-
    infer([
        gvLet(s, sum(int, int), inl(int, int)),
        match(s, [
            case(inl(x), expr(iplus(x, int)))
        ])
    ], _T).

test(infer_40_tplLet_inside_for_body, [true(T == unit)]) :-
    once(infer([
        for(i, int, int,
            block([
                tplLet([a-int, b-int], tuple([i, int])),
                expr(print(iplus(a, b)))
            ])
        )
    ], T)).

test(infer_41_gfLet_tuple_return, [true(T == tuple([int, float]))]) :-
    once(infer([
        gfLet(mkpair, [x-int, y-float], tuple([int, float]),
              [return(tuple([x, y]))]),
        expr(mkpair(int, float))
    ], T)).

:-end_tests(typeInf).
