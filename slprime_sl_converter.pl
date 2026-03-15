%% slprime_sl_converter.pl
%%
%% Two-way converter between Starlog prime form and Starlog form.
%%
%% Starlog prime form: predicates written as name'arity (e.g., append'2, member'1)
%% Starlog form:       predicates written as name_arity (e.g., append_2, member_1)
%%
%% Usage from SWI-Prolog:
%%   ?- slprime_to_sl("F8 is reverse(append'2(findall_until_fail(B,B is member'1(reverse(F4)),is_space(B),F5),F6)),!.", Output).
%%   Output = "F8 is reverse(append_2(findall_until_fail(B,B is member_1(reverse(F4)),is_space(B),F5),F6)),!."
%%
%%   ?- sl_to_slprime("F8 is reverse(append_2(findall_until_fail(B,B is member_1(reverse(F4)),is_space(B),F5),F6)),!.", Output).
%%   Output = "F8 is reverse(append'2(findall_until_fail(B,B is member'1(reverse(F4)),is_space(B),F5),F6)),!."
%%
%% File-based conversion:
%%   ?- slprime_to_sl_file("input.pl", "output.pl").
%%   ?- sl_to_slprime_file("input.pl", "output.pl").
%%
%% Tests:
%%   ?- run_tests.

%% slprime_to_sl(+Input, -Output)
%% Converts Starlog prime form to Starlog form.
%% Replaces each occurrence of name'N (apostrophe before digits) with name_N.

slprime_to_sl(Input, Output) :-
    string_codes(Input, Codes),
    slprime_to_sl_codes(Codes, OutCodes),
    string_codes(Output, OutCodes).

%% sl_to_slprime(+Input, -Output)
%% Converts Starlog form to Starlog prime form.
%% Replaces each occurrence of name_N (underscore before digits at end of identifier)
%% with name'N.

sl_to_slprime(Input, Output) :-
    string_codes(Input, Codes),
    sl_to_slprime_codes(Codes, OutCodes),
    string_codes(Output, OutCodes).

%% Character code constants:
%%   39 = ' (apostrophe/prime)
%%   95 = _ (underscore)

%% slprime_to_sl_codes(+Codes, -OutCodes)
%% Scans character codes and replaces apostrophe (39) immediately before a digit
%% with an underscore (95).

slprime_to_sl_codes([], []).
slprime_to_sl_codes([39|Rest], [95|OutRest]) :-
    Rest = [D|_],
    char_type(D, digit),
    !,
    slprime_to_sl_codes(Rest, OutRest).
slprime_to_sl_codes([C|Rest], [C|OutRest]) :-
    slprime_to_sl_codes(Rest, OutRest).

%% sl_to_slprime_codes(+Codes, -OutCodes)
%% Scans character codes and replaces underscore (95) before a digit sequence that
%% ends the identifier (i.e., is not followed by another identifier character)
%% with an apostrophe (39).

sl_to_slprime_codes([], []).
sl_to_slprime_codes([95|Rest], [39|OutRest]) :-
    Rest = [D|_],
    char_type(D, digit),
    digits_then_nonident(Rest),
    !,
    sl_to_slprime_codes(Rest, OutRest).
sl_to_slprime_codes([C|Rest], [C|OutRest]) :-
    sl_to_slprime_codes(Rest, OutRest).

%% digits_then_nonident(+Codes)
%% True if Codes begins with one or more digits followed by either end-of-string
%% or a non-identifier character (i.e., not alphanumeric and not underscore).
%% This ensures that only arity suffixes like _2 or _12 are converted, while
%% identifiers like findall_until_fail are left unchanged.

digits_then_nonident([D|Rest]) :-
    char_type(D, digit),
    !,
    digits_then_nonident_rest(Rest).

digits_then_nonident_rest([]).
digits_then_nonident_rest([D|Rest]) :-
    char_type(D, digit),
    !,
    digits_then_nonident_rest(Rest).
digits_then_nonident_rest([C|_]) :-
    \+ is_ident_char(C).

%% is_ident_char(+Code)
%% True if Code is an identifier character: alphanumeric or underscore.

is_ident_char(C) :- char_type(C, alnum).
is_ident_char(95).  %% underscore

%% ---- File-based conversion ----

%% slprime_to_sl_file(+InputFile, +OutputFile)
%% Reads InputFile, converts Starlog prime form to Starlog form, writes to OutputFile.

slprime_to_sl_file(InputFile, OutputFile) :-
    atom_string(InputFile1, InputFile),
    read_file_to_string(InputFile1, Input, []),
    slprime_to_sl(Input, Output),
    atom_string(OutputFile1, OutputFile),
    open(OutputFile1, write, Stream),
    write(Stream, Output),
    close(Stream).

%% sl_to_slprime_file(+InputFile, +OutputFile)
%% Reads InputFile, converts Starlog form to Starlog prime form, writes to OutputFile.

sl_to_slprime_file(InputFile, OutputFile) :-
    atom_string(InputFile1, InputFile),
    read_file_to_string(InputFile1, Input, []),
    sl_to_slprime(Input, Output),
    atom_string(OutputFile1, OutputFile),
    open(OutputFile1, write, Stream),
    write(Stream, Output),
    close(Stream).

%% ---- Tests ----

%% slprime_sl_test(+N, +Input, +Expected, +Label)
%% Runs a single named test: applies the conversion and checks the result.

slprime_sl_test(slprime_to_sl, Input, Expected, Label) :-
    slprime_to_sl(Input, Output),
    (Output = Expected ->
        format("~w: passed~n", [Label])
    ;
        format("~w: FAILED~n", [Label]),
        format("  Input:    ~w~n", [Input]),
        format("  Output:   ~w~n", [Output]),
        format("  Expected: ~w~n", [Expected])
    ).
slprime_sl_test(sl_to_slprime, Input, Expected, Label) :-
    sl_to_slprime(Input, Output),
    (Output = Expected ->
        format("~w: passed~n", [Label])
    ;
        format("~w: FAILED~n", [Label]),
        format("  Input:    ~w~n", [Input]),
        format("  Output:   ~w~n", [Output]),
        format("  Expected: ~w~n", [Expected])
    ).

%% run_tests/0
%% Runs all tests for the converter.

run_tests :-
    SLPrimeExample = "F8 is reverse(append'2(findall_until_fail(B,B is member'1(reverse(F4)),is_space(B),F5),F6)),!.",
    SLExample      = "F8 is reverse(append_2(findall_until_fail(B,B is member_1(reverse(F4)),is_space(B),F5),F6)),!.",

    %% Test 1: Starlog prime form -> Starlog form
    slprime_sl_test(slprime_to_sl,
        SLPrimeExample,
        SLExample,
        test1_slprime_to_sl),

    %% Test 2: Starlog form -> Starlog prime form
    slprime_sl_test(sl_to_slprime,
        SLExample,
        SLPrimeExample,
        test2_sl_to_slprime),

    %% Test 3: Roundtrip Starlog prime -> Starlog -> Starlog prime
    slprime_to_sl(SLPrimeExample, Mid3),
    sl_to_slprime(Mid3, Out3),
    (Out3 = SLPrimeExample ->
        writeln('test3_roundtrip_slprime_sl_slprime: passed')
    ;
        writeln('test3_roundtrip_slprime_sl_slprime: FAILED'),
        format("  Output: ~w~n", [Out3])
    ),

    %% Test 4: Roundtrip Starlog -> Starlog prime -> Starlog
    sl_to_slprime(SLExample, Mid4),
    slprime_to_sl(Mid4, Out4),
    (Out4 = SLExample ->
        writeln('test4_roundtrip_sl_slprime_sl: passed')
    ;
        writeln('test4_roundtrip_sl_slprime_sl: FAILED'),
        format("  Output: ~w~n", [Out4])
    ),

    %% Test 5: Names without arity suffix are unchanged
    slprime_sl_test(slprime_to_sl,
        "is_space(B)",
        "is_space(B)",
        test5_no_arity_slprime_to_sl),

    slprime_sl_test(sl_to_slprime,
        "is_space(B)",
        "is_space(B)",
        test6_no_arity_sl_to_slprime),

    %% Test 7: Compound identifier with _ not followed by digits is unchanged
    slprime_sl_test(sl_to_slprime,
        "findall_until_fail(B)",
        "findall_until_fail(B)",
        test7_compound_no_arity),

    %% Test 8: Multi-digit arity
    slprime_sl_test(slprime_to_sl,
        "foo'12(X)",
        "foo_12(X)",
        test8_multi_digit_arity_slprime_to_sl),

    slprime_sl_test(sl_to_slprime,
        "foo_12(X)",
        "foo'12(X)",
        test9_multi_digit_arity_sl_to_slprime).
