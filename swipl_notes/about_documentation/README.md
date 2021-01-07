# SWI-Prolog Latex-based documentation

There are two documentation systems:

- `pldoc` to document code directly in the source, similar to Doxygen, Javadoc etc. This is the same system used for the SWI-Prolog manual website
   - [pldoc](https://eu.swi-prolog.org/pldoc/doc_for?object=section(%27packages/pldoc.html%27))
- The manual documentation itself is based on LaTeX. The .doc files in the distribution are LaTeX.   

There needs to be an example page in the manual.

## Random LaTeX links

- http://applied-r.com/latex-line-and-page-breaks/
- https://tex.stackexchange.com/questions/7453/what-is-the-use-of-percent-signs-at-the-end-of-lines-why-is-my-macro-creat
- https://en.wikibooks.org/wiki/LaTeX/Special_Characters

## Problems

- The quotes are crazy double backticks as intro generally works but double single quotes as outro behaves differently depending on
  context (within parentheses etc.)
- The processor doesn't understand dashes like `\textemdash.`: https://tex.stackexchange.com/questions/53413/what-is-the-latex-command-for-em-dash  

## How to modify the doc.

- Fork SWI-Prolog repository to your github account (Fork A)
- Clone that fork to your machine. Documentation is _edited_ there. (Clone A)
- Files of interest are:   
   - `$CLONE_A_DIR/man/builtin.doc` - LaTeX for builtin predicates
   - `$CLONE_A_DIR/man/extensions.doc` - LaTeX for SWI-Prolog extensions  
- Clone the SWI-Prolog repository to your machine, including git modules. Documentation is _built_ here. (Clone B)
- When done editing, copy the relevant files from Clone A to Clone B.
- Build Clone B, including PDF documentation.
- Check the results: HTML documentation and PDF
   - `$CLONE_B_DIR/build/man/SWI-Prolog-8.3.14.pdf`   
   - `$CLONE_B_DIR/build/man/Manual/extensions.html`
   - `$CLONE_B_DIR/build/man/Manual/builtin.html`
- Commit and push your well-manicured changes to Fork A.
- Create a pull request for Fork A.

The `swiprologpull.sh` installation script in [compiling](/compiling) helps doing the above.

Changing the bibliography, however, is hairy. Some [notes on this](bibliography)   

## LaTeX style elements

### Labeling

"4 Built-in Predicates"

```
\chapter{Built-in Predicates}
\label{sec:builtin}
```
 
"4.10 Exception handling"

```
\section{Exception handling}
\label{sec:exception}
```
 
"4.10.3 The exception term"

```
\subsection{The exception term}
\label{sec:exceptterm}
```

These are not in the TOC, they seem to be too deep:

```
\subsubsection{Throwing exceptions from applications and libraries}
\label{sec:throwsfromuserpreds}
```

Note that referencing drops the "sec":
 
``` 
\label{sec:argmode}
```

but to reference:
 
``` 
\secref{argmode}
```

### Referencing other sections by name

These are replaced by a link and a text like "section 8.1".

```
\chapref{modules}
\secref{attvar}
```

For example, `\secref{attvar}` generates a live link to `https://eu.swi-prolog.org/pldoc/man?section=attvar`
 
### Text style

Boldface:

```
\textbf{no}
```

Emphasis. Looks better than boldface and expresses what one wants to do:

```
\emph{no} 
```

### Quoting

Use _backtick_ twice at the start and _quote_ twice at the end.

Seems fussy. There should probably be a special construct for that like `\quoting{}`.

```
`something`             (this doesn't look right)  
``But these seem good'' (looks right but is ugly, the spacing is massacred)
```

### Terms

To write compound terms `x(y)`
 
```
\term{x}{y}
```

Note that `\term{x}` will not work. A character is forcefully grabbed from the subsequent text and put into parentheses.

A little test:

```
Try \term{a}{b}

Try \term{a}{b,c}

Try \term{a}

Hello world
```

yields:

![Result of typesetting term](pics/result_of_typesetting_term.png)


Note that the typesetting is a bit surprising:

```
\term{dotlists}{true}
```

![Result of term](pcis/result_of_term_dotlists_true.png)


### Line break or line fuse

- `%`   to break at the end of the line
- `\\`  to fuse two lines

### Align a list with a terminating line break

```
++& Argument must be ... \\ 
```

### Constants

```
\const{type_error}
\const{'[]'}
```

It is not 100% clear what to label as constant. For example, are these constants?

```
\const{'[]'}   - the atom '[]'
\const{[]}     - the empty list
```

Especially for the empty list, there should be a special construct like `\emptylist`

Use `\exam` for example code. Currently renders the same, but is semantically different.

A little test

```
Constant with quotes inside: \const{'[]'}

Constant with single quotes outside: `\const{[]}'

Constant with double quotes outside: ``\const{[]}''

Constant without quotes: \const{[]}

Using exam: \exam{[]}

Using verbatim: \verb$[]$
```

yields:

![Result of typesetting empty list](pics/result_of_testing_typesetting_empty_list.png)

### Character

```
\chr{+}
```

Different semantics than `\const{}` I would say.

### Verbatim quote 

For code etc. The documentation uses the `$` marker:

```
\verb$:=$
```

Stack Overflow says:

https://tex.stackexchange.com/questions/2790/when-should-one-use-verb-and-when-texttt

> ... you use \verb where you need to write a small piece of inline verbatim material that contains characters
> TeX treats (or rather, is currently treating) as special. `\texttt` is for when you just want typewriter font.

### Example code

```
\exam{findall(X, Goal, 1)}
```

### Footnote

```
\footnote{The ISO standard dictates that}
```

Stylistically, I feel the manual overdoes footnotes. A lot of footnotes belong right into the text.

### Predicate indicator, functor

```
\functor{.}{2}
```

### Predicate indicator with or without link

```
\predref{=..}{2}
\predref{.}{3}
```

The following suppresses predicate reference generation:

```
\nopredref{find_postal_code}{4}
```

Things like `write_term/2` are automatically linkified.

- what about `write_term//2`
- there is no notation for "dict functions". Should be fixed.

 If you use `\functor{}{}`, no links are created.
 
 However, just writing the predicate indicator directly, as in `member/2`, will create a link to the page of the predicate (if that page exists).

### Predicate argument

Italicized in the text

```
\arg{x}
```

### Predicate declarations

(does it work with arity 0?)

```
\predicate[ISO]{write_canonical}{1}{+Term}
\predicate[semidet]{write_length}{3}{+Term, -Length, +Options}
\predicate[ISO]{write_term}{3}{+Stream, +Term, +Options}
\predicate{setarg}{3}{+Arg, +Term, +Value}
```

These are linkified and a reference is inserted into the TOC.

### Jargon

```
\jargon{ground}
```

The text is italicized. No references to a glossary are inserted (that's ok, it would overload the text, 
but there should be a construct for that: `\glossaryjargon{}`)

### A not very beautiful list of "term items"

```
\begin{description} 
\termitem{x}{y} 
\end{description}
```

### A file

```
\file{SWI-Prolog.h}.
```

### Special symbols

```
\Scons{}   ---> rendered as [|]
\Snil{}    ---> rendered as []
```

### Tables

An example

```
\begin{table}
\begin{center}
\begin{tabular}{lcc}
\hline
\bf Mode & \prologflag{double_quotes} & \prologflag{back_quotes} \\
\hline
Version~7 default & string & codes \\
\cmdlineoption{--traditional} & codes & symbol_char \\
\hline
\end{tabular}
\end{center}
    \caption{Mapping of double and back quoted text in the two
             modes.}
    \label{tab:quote-mapping}
\end{table}
```

## A list of descriptions

The descriptions are written in bold

```
begin{description}
    \item [ A DCG literal ]  Although represented as ...
\end{description}
```

## Style notes

Jan says:

> Please do not build a story in code blocks using comments. Instead, use should code blocks and normal running text in 
> between. That looks a lot better, notably in the PDF version where long code blocks causes poor page layout.

## ASCII graphics

Yes, these are still a thing. At least they are stylistically uniform:

A `[fontsize=\small]` suffix after `\begin{code}` is not recognized and written verbatim.

```none
\begin{code}
   Traditional list               SWI-Prolog 7 list

       '.'                              '[|]'
      /   \                             /   \
     1    '.'                          1   '[|]'
         /   \                             /   \
        2    '.'                          2   '[|]'
            /   \                             /   \
           3   '[]'                          3     []

           terminated with                   terminated with
           the atom '[]',                    a special constant
           indistinguishable from text       which is printed as []
\end{code}
```

