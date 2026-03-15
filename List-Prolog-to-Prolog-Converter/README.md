# List-Prolog-to-Prolog-Converter

Converts List Prolog code to Prolog code.

List Prolog (LP) Interpreter (available <a href="https://github.com/luciangreen/listprologinterpreter">here</a>) is an interpreter for a different version of Prolog that is in list format, making it easier to generate List Prolog programs. The LP interpreter is an algorithm that parses and runs List Prolog code. The converter helps convert List Prolog programs to Prolog programs.  The interpreter and converter are written in SWI-Prolog.


# Prerequisites

* Use a search engine to find the Homebrew (or other) Terminal install command for your platform and install it, and search for the Terminal command to install swipl using Homebrew and install it or download and install SWI-Prolog for your machine at <a href="https://www.swi-prolog.org/build/">SWI-Prolog</a>.

# Mac, Linux and Windows (with Linux commands installed): Prepare to run swipl

* In Terminal settings (Mac), make Bash the default shell:

```
/bin/bash
```

* In Terminal, edit the text file `~/.bashrc` using the text editor Nano:

```
nano ~/.bashrc
```

* Add the following to the file `~/.bashrc`:

```
export PATH="$PATH:/opt/homebrew/bin/"
```

* Check if `usr/local/bin` exists

```
ls -ld /usr/local/bin
```

* Create the directory if missing

```
sudo mkdir -p /usr/local/bin
```

* Link to swipl in Terminal

```
sudo ln -s /opt/homebrew/bin/swipl /usr/local/bin/swipl
```

# 1. Install manually

Download <a href="http://github.com/luciangreen/List-Prolog-to-Prolog-Converter/">this repository</a>, the <a href="https://github.com/luciangreen/listprologinterpreter">List Prolog Interpreter Repository</a> and the <a href="https://github.com/luciangreen/Text-to-Breasonings">Text to Breasonings Repository</a>.

# 2. Or Install from List Prolog Package Manager (LPPM)

* Download the <a href="https://github.com/luciangreen/List-Prolog-Package-Manager">LPPM Repository</a>:

```
mkdir GitHub
cd GitHub/
git clone https://github.com/luciangreen/List-Prolog-Package-Manager.git
cd List-Prolog-Package-Manager
swipl
['lppm'].
lppm_install("luciangreen","List-Prolog-to-Prolog-Converter").
../
halt.
```

# Running

* In Shell:
`cd List-Prolog-to-Prolog-Converter`
`swipl`
`['../listprologinterpreter/listprolog'].`    

* Load the List Prolog to Prolog Converter by typing:
`['lp2pconverter'].`

* The converter is called in the form:
`test(Number,_,Algorithm1,_),lp2p1(Algorithm1,Algorithm2),write(Algorithm2).`

Where:
Number - Test number of algorithm to convert (taken from <a href="https://github.com/luciangreen/listprologinterpreter/blob/master/lpiverify4.pl">"lpiverify4.pl"</a>).
Algorithm1 - is the List Prolog algorithm to convert.
Algorithm2 - is the Prolog algorithm produced.

* For example:
```
test(1,_,A,_),lp2p1(A,B),write(B).
function(A,B,C):-+(A,B,C).
```

```
test(2,_,A,_),lp2p1(A,B),write(B).
function(A,B,C):-+(A,B,D),+(D,1,C).
```

```
test(3,_,A,_),lp2p1(A,B),write(B).
function(A,B,C):-function2(D,F),+(A,B,E),+(E,F,G),+(G,D,C).
function2(A,F):-is(A,2),is(F,1).
```

```
test(4,_,A,_),lp2p1(A,B),write(B).
append1(A):-b(B),c(C),append(B,C,A).
b(["b"]).
c(["c"]).
```

```
test(15,_,A,_),lp2p1(A,B),write(B).
grammar1(U,T):-compound(U,"",[],T).
compound213(U,U,T,T).
compound(T,U)->"[","]",compound213(T,U).
compound(T,U)->"[",compound21(T,V),"]",compound213(V,U).
compound212(U,U,T,T).
compound21(T,U)->item(I),lookahead("]"),{wrap(I,Itemname1),append(T,Itemname1,V)},compound212(V,U).
compound21(T,U)->item(I),",",compound21([],Compound1name),{wrap(I,Itemname1),append(T,Itemname1,V),append(V,Compound1name,U)}.
item(T)->"\"",word21("",T),"\"".
item(T)->number21("",U),{stringtonumber(U,T)}.
item(T)->word21_atom("",T1),{atom_string(T,T1)}.
item(T)->compound([],T).
number212(U,U,T,T).
number21(T,U)->A,commaorrightbracketnext,{((stringtonumber(A,A1),number(A1))->(true);((equals4(A,".")->(true);(equals4(A,"-"))))),stringconcat(T,A,V)},number212(V,U).
number21(T,U)->A,{((stringtonumber(A,A1),number(A1))->(true);((equals4(A,".")->(true);(equals4(A,"-"))))),stringconcat(T,A,V)},number21("",Numberstring),{stringconcat(V,Numberstring,U)}.
word212(U,U,T,T).
word21(T,U)->A,quote_next,{not((=(A,"\""))),stringconcat(T,A,V)},word212(V,U).
word21(T,U)->A,{not((=(A,"\""))),stringconcat(T,A,V)},word21("",Wordstring),{stringconcat(V,Wordstring,U)}.
word212_atom(U,U,T,T).
word21_atom(T,U)->A,commaorrightbracketnext,{not((=(A,"\""))),not((=(A,"["))),not((=(A,"]"))),stringconcat(T,A,V)},word212_atom(V,U).
word21_atom(T,U)->A,{not((=(A,"\""))),not((=(A,"["))),not((=(A,"]"))),stringconcat(T,A,V)},word21_atom("",Wordstring),{stringconcat(V,Wordstring,U)}.
commaorrightbracketnext->lookahead(",").
commaorrightbracketnext->lookahead("]").
quote_next->lookahead("\"").
lookahead(A,A,B):-stringconcat(B,D,A).
```

# Tests

* Run `bt-p2lp_test(A,B)` or `bt-p2lp_test1(N,B)` where N is the test number from <a href="https://github.com/luciangreen/Prolog-to-List-Prolog/blob/master/p2lpverify.pl">Prolog to List Prolog/p2lpverify.pl</a>.
* Similarly, `bt1-p2lp_test(A,B)` and `bt1-p2lp_test1(N,B)` work.
  
# Authors

Lucian Green - Initial programmer - <a href="https://www.lucianacademy.com/">Lucian Academy</a>

# License

I licensed this project under the BSD3 License - see the LICENSE.md file for details
