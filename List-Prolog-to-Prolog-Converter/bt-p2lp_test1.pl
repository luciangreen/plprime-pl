% back-translates Prolog to List Prolog then List Prolog to Prolog.

% bt-p2lp_test(A,B).
% A - output: total tests
% B - output: total correct results

% bt-p2lp_test1(N,B).
% N - input: number to test
% B - output: result

bt-p2lp_test(BL,RL) :-
findall(A,(p2lp_test(N,_I,O),((lp2p1(O,I1),p2lpconverter([string,I1],O2),O=O2)->(writeln([bt-p2lp_test,N,passed]),A=passed);(writeln([bt-p2lp_test,N,failed]),A=failed))),B),
length(B,BL),
findall(_,member(passed,B),R),length(R,RL),!.

bt-p2lp_test1(N,A) :-
p2lp_test(N,_I,O),((lp2p1(O,I1),p2lpconverter([string,I1],O2),O=O2)->(writeln([bt-p2lp_test,N,passed]),A=passed);(writeln([bt-p2lp_test,N,failed]),A=failed)),!.



bt-p2lp_pp_test(BL,RL) :-
findall(A,(p2lp_test(N,_I,O),((pp_lp2p0(O,I1),p2lpconverter([string,I1],O2),O=O2)->(writeln([bt-p2lp_test,N,passed]),A=passed);(writeln([bt-p2lp_test,N,failed]),A=failed))),B),
length(B,BL),
findall(_,member(passed,B),R),length(R,RL),!.

bt-p2lp_pp_test1(N,A) :-
p2lp_test(N,_I,O),((pp_lp2p0(O,I1),p2lpconverter([string,I1],O2),O=O2)->(writeln([bt-p2lp_test,N,passed]),A=passed);(writeln([bt-p2lp_test,N,failed]),A=failed)),!.

% to do
% back-translation, on I not O


bt1-p2lp_test(BL,RL) :-
findall(A,(p2lp_test(N,I,_O),(p2lpconverter([string,I],O1),(lp2p1(O1,I2),(string_concat(I1,"\n",I2)->true;I1=I2),I=I1)->(writeln([bt1-p2lp_test,N,passed]),A=passed);(writeln([bt1-p2lp_test,N,failed]),A=failed))),B),
length(B,BL),
findall(_,member(passed,B),R),length(R,RL),!.

bt1-p2lp_test1(N,A) :-
p2lp_test(N,I,_O),(p2lpconverter([string,I],O1),(lp2p1(O1,I2),(string_concat(I1,"\n",I2)->true;I1=I2),I=I1)->(writeln([bt1-p2lp_test,N,passed]),A=passed);(writeln([bt1-p2lp_test,N,failed]),A=failed)),!.
