# slprime-sl

Two-way conversion between Starlog prime form (with a primed or non-normally last argument last) and Starlog form, and back.

## Overview

- **Starlog prime form**: predicate names include an apostrophe before the arity number, e.g. `append'2`, `member'1`
- **Starlog form**: predicate names include an underscore before the arity number, e.g. `append_2`, `member_1`

### Example

Starlog prime form:
```
F8 is reverse(append'2(findall_until_fail(B,B is member'1(reverse(F4)),is_space(B),F5),F6)),!.
```

Starlog form:
```
F8 is reverse(append_2(findall_until_fail(B,B is member_1(reverse(F4)),is_space(B),F5),F6)),!.
```

## Requirements

- [SWI-Prolog](https://www.swi-prolog.org/) (version 7 or later)

## Usage

Load `slprime_sl_converter.pl` in SWI-Prolog:

```
swipl -l slprime_sl_converter.pl
```

### Convert Starlog prime form to Starlog form

```prolog
?- slprime_to_sl("F8 is reverse(append'2(findall_until_fail(B,B is member'1(reverse(F4)),is_space(B),F5),F6)),!.", Output).
Output = "F8 is reverse(append_2(findall_until_fail(B,B is member_1(reverse(F4)),is_space(B),F5),F6)),!."
```

### Convert Starlog form to Starlog prime form

```prolog
?- sl_to_slprime("F8 is reverse(append_2(findall_until_fail(B,B is member_1(reverse(F4)),is_space(B),F5),F6)),!.", Output).
Output = "F8 is reverse(append'2(findall_until_fail(B,B is member'1(reverse(F4)),is_space(B),F5),F6)),!."
```

### File-based conversion

```prolog
%% Convert a file from Starlog prime form to Starlog form:
?- slprime_to_sl_file("input.pl", "output.pl").

%% Convert a file from Starlog form to Starlog prime form:
?- sl_to_slprime_file("input.pl", "output.pl").
```

## Tests

```prolog
?- run_tests.
```

All 9 built-in tests cover:
- Starlog prime form to Starlog form (problem statement example)
- Starlog form to Starlog prime form (problem statement example)
- Roundtrip Starlog prime to Starlog to Starlog prime
- Roundtrip Starlog to Starlog prime to Starlog
- Names without arity suffix are unchanged (e.g. `is_space`, `findall_until_fail`)
- Multi-digit arity (e.g. `foo'12` and `foo_12`)
