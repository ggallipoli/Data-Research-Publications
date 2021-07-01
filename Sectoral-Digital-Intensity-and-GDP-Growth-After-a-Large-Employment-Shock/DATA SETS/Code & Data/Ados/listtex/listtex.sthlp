{smcl}
{.-}
help for {cmd:listtex} {right:(Roger Newson)}
{.-}
 
{title:List a variable list to a file or to the log for inclusion in a TeX, HTML or word processor table}

{p 8 21 2}
{cmd:listtex} [ {varlist} ] [ {helpb using} {it:filename} ] {ifin} [ ,
  {break}
  {cmdab:b:egin}{cmd:(}{it:string}{cmd:)} {cmdab:d:elimiter}{cmd:(}{it:string}{cmd:)}
  {cmdab:e:nd}{cmd:(}{it:string}{cmd:)} {cmdab:m:issnum}{cmd:(}{it:string}{cmd:)}
  {cmdab:rs:tyle}{cmd:(}{it:rowstyle}{cmd:)}
  {break}
  {cmdab:he:adlines}{cmd:(}{it:string_list}{cmd:)} {cmdab:fo:otlines}{cmd:(}{it:string_list}{cmd:)}
  {cmdab:nol:abel} {cmdab:t:ype} {cmdab:replace:}
  {cmdab:ap:pendto}{cmd:(}{it:filename}{cmd:)} {cmdab:ha:ndle}{cmd:(}{it:handle_name}{cmd:)}
  ]

{p 8 21 2}
{cmd:listtex_vars} [ {varlist} ] [ ,
  {break}
  {cmdab:b:egin}{cmd:(}{it:string}{cmd:)} {cmdab:d:elimiter}{cmd:(}{it:string}{cmd:)}
  {cmdab:e:nd}{cmd:(}{it:string}{cmd:)} {cmdab:m:issnum}{cmd:(}{it:string}{cmd:)}
  {cmdab:rs:tyle}{cmd:(}{it:rowstyle}{cmd:)}
  {break}
  {cmdab:su:bstitute}{cmd:(}{it:variable_attribute}{cmd:)} {cmdab:lo:cal}{cmd:(}{help macro:{it:local_macro_name}}{cmd:)}
  ]

{p 8 21 2}
{cmd:listtex_rstyle} [ ,
  {cmdab:b:egin}{cmd:(}{it:string}{cmd:)} {cmdab:d:elimiter}{cmd:(}{it:string}{cmd:)}
  {cmdab:e:nd}{cmd:(}{it:string}{cmd:)} {cmdab:m:issnum}{cmd:(}{it:string}{cmd:)}
  {cmdab:rs:tyle}{cmd:(}{it:rowstyle}{cmd:)}
  ]  

{pstd}
where {it:rowstyle} is a {help listtex##listtex_row_styles:row style} as defined below under {helpb listtex##listtex_row_styles:Row Styles},
{break}
{it:variable_attribute} is

{pstd}
{cmd:name} | {cmd:type} | {cmd:format} | {cmd:vallab} | {cmd:varlab} | {cmd:char} {help char:{it:charname}}

{pstd}
and {help char:{it:charname}} is a {help char:characteristic name}.


{title:Description}

{pstd}
{cmd:listtex} lists the variables in the {varlist} (or all variables, if the {varlist}
is absent) to the Stata log, or to a file (or files) specified by {helpb using}, {cmd:appendto()} or {cmd:handle()},
in a table format, with one table row per observation and the values of different variables separated by a delimiter string.
Optionally, the user may specify a list of header lines before the data rows
and/or a list of footer lines after the data rows.
The log or output file can then
be cut and pasted, or linked or embedded (eg with the TeX  {cmd:\input} command),
into a TeX, HTML or word processor table.
Values of numeric variables are output according to their display formats or value labels (if non-missing),
or as the missing value string specified by {cmd:missnum()} (if missing).

{pstd}
The commands {cmd:listtex_vars} and {cmd:listtex_rstyle} are tools for programmers to use with {cmd:listtex}.
{cmd:listtex_vars} generates a table row, containing, in each column,
an attribute (such as the name) of the variable corresponding to the column.
This generated table row is saved in {cmd:r(vars)} and (optionally) in a local macro,
and is then typically used to specify a {cmd:headlines()} option for {cmd:listtex}.
{cmd:listtex_rstyle} inputs a {cmd:listtex} {help listtex##listtex_row_styles:row style},
and saves in {cmd:r()} the components of the {help listtex##listtex_row_styles:row style}.

{pstd}
Users of {help version:Stata Versions 11 or higher} should probably not use {cmd:listtex}.
Instead, they should probably use the {helpb listtab} package, which can be downloaded from {help ssc:SSC},
and was introduced as the {help version:Stata Version 11} replacement for {cmd:listtex}.


{title:Options for {cmd:listtex}, {cmd:listtex_vars}, and {cmd:listtex_rstyle}}

{p 4 8 2}{cmd:begin(}{it:string}{cmd:)} specifies a string to be output at the beginning of every
output line corresponding to an observation. If absent, it is set to an empty string.

{p 4 8 2}{cmd:delimiter(}{it:string}{cmd:)} specifies the delimiter between values in an observation.
If absent, it is set to "&".

{p 4 8 2}{cmd:end(}{it:string}{cmd:)} specifies a string to be output at the end of every
output line corresponding to an observation. If absent, it is set to an empty string.

{p 4 8 2}{cmd:missnum(}{it:string}{cmd:)} specifies a string to be output for numeric missing values.
If absent, it is set to an empty string.

{p 4 8 2}{cmd:rstyle(}{it:rowstyle}{cmd:)} specifies a {help listtex##listtex_row_styles:row style} for the table rows.
A {help listtex##listtex_row_styles:row style} is a named combination of values
for the {cmd:begin()}, {cmd:end()}, {cmd:delimiter()} and {cmd:missnum()} options.
It may be {cmd:html}, {cmd:htmlhead}, {cmd:tabular}, {cmd:halign},
{cmd:settabs} or {cmd:tabdelim}.
Row styles are specified under {helpb listtex##listtex_row_styles:Row styles} below.
The options set by a {help listtex##listtex_row_styles:row style}
may be overridden by the {cmd:begin()}, {cmd:end()}, {cmd:delimiter()} and {cmd:missnum()} options.


{title:Options for {cmd:listtex} only}

{p 4 8 2}{cmd:headlines(}{it:string_list}{cmd:)} specifies a list of lines of text to appear before the first
of the table rows in the output.
This option enables the user to add table preludes and/or headers.

{p 4 8 2}{cmd:footlines(}{it:string_list}{cmd:)} specifies a list of lines of text to appear after the last
of the table rows in the output.
This option enables the user to add table postludes and/or footnotes.

{p 4 8 2}{cmd:nolabel} specifies that numeric variables with variable labels are to be output as
numbers and not as labels.

{p 4 8 2}{cmd:type} specifies that the output from {cmd:listtex} must be typed to the Stata log
(or to the Results window).
The data can then be cut and pasted from the Stata log (or from the Results window)
to a TeX, HTML or word processor file.

{p 4 8 2}{cmd:replace} specifies that any existing file with the same name as the {helpb using}
file must be overwritten.

{p 4 8 2}{cmd:appendto(}{it:filename}{cmd:)} specifies the name of a file,
to which the output from {cmd:listtex} will be appended.

{p 4 8 2}{cmd:handle(}{it:handle_name}{cmd:)} specifies the name of a file handle,
specifying a file that is already open for output as a text file,
to which the output from {cmd:listtex} will be added, without closing the file.
See help for {helpb file} for details about file handles.
This option allows the user to use {cmd:listtex}
together with {helpb file} as a low-level output utility, possibly combining {cmd:listtex} output with
other output.

{p 4 8 2}Note that the user must specify the {helpb using} qualifier and/or the {cmd:type} option
and/or the {cmd:appendto()} option and/or the {cmd:handle()} option.


{title:Options for {cmd:listtex_vars} only}

{p 4 8 2}{cmd:substitute(}{it:variable_attribute}{cmd:)} specifies a variable attribute
to be entered into the columns of the generated table row.
This attribute may be
{cmd:name}, {cmd:type}, {cmd:format}, {cmd:vallab}, {cmd:varlab}, or {cmd:char} {help char:{it:charname}},
specifying the {help varname:variable name}, {help data types:storage type}, {help format:display format},
{help label:value label}, {help label:variable label},
or a named {help char:variable characteristic}, respectively.
If {cmd:substitute()} is not specified, then {cmd:substitute(name)} is assumed,
and variable names are entered in the columns of the generated table row.
In the table row generated by {cmd:listtex_vars},
the attributes of the variables in the {varlist} (or of all the variables, if the {varlist} is absent)
appear in the columns,
and are separated by the {cmd:delimiter()} string, and prefixed by the {cmd:begin()} and {cmd:end()} strings,
specified by the {help listtex##listtex_row_styles:row style}.

{p 4 8 2}{cmd:local(}{help macro:{it:local_macro_name}}{cmd:)} specifies the name of a {help macro:local macro}
in the program that calls {cmd:listtex_vars}.
This macro will be assigned the value of the row of variable attributes generated by {cmd:listtex_vars}.
Whether or not {cmd:local()} is specified,
{cmd:listtex_vars} saves the generated table row in {cmd:r(vars)}.
The {cmd:local()} option has the advantage that the user can save multiple header rows in multiple local macros.
For instance, the user might want two header rows, one containing variable names, and the other containing variable labels.


{marker listtex_row_styles}{...}
{title:Row styles}

{pstd}
A row style is a combination of the {cmd:begin()}, {cmd:end()},
{cmd:delimiter()} and {cmd:missnum()} options. Each row style produces rows for a particular
type of table (HTML, TeX or word processor). The row styles available are as follows:

{hline}
{cmd:Row style}   {cmd:begin}       {cmd:delimiter}       {cmd:end}             {cmd:missnum}     {cmd:Description}
{cmd:html}        "<tr><td>"  "</td><td>"     "</td></tr>"    ""          HTML table rows
{cmd:htmlhead}    "<tr><th>"  "</th><th>"     "</th></tr>"    ""          HTML table header rows
{cmd:tabular}     ""          "&"             `"\\"'          ""          LaTeX {cmd:\tabular} environment table rows
{cmd:halign}      ""          "&"             "\cr"           ""          Plain TeX {cmd:\halign} table rows
{cmd:settabs}     "\+"        "&"             "\cr"           ""          Plain TeX {cmd:\settabs} table rows
{cmd:tabdelim}    ""          {cmd:char(9)}         ""              ""          Tab-delimited text file rows
{hline}

{pstd}
The {cmd:tabdelim} row style produces text rows delimited by the tab character,
returned by the {help strfun:char() function} as {cmd:char(9)}.
It should be used with {helpb using}, or with the {cmd:appendto()} or {cmd:handle()} options,
to output the table rows to a file. It should not be used with the {cmd:type} option, because the tab character
is not preserved in the Stata log or Results window.
Any of these row styles may be specified together with {cmd:begin()} and/or {cmd:delimiter()}
and/or {cmd:end()} and/or {cmd:missnum()} options, and the default options for the row style
will then be overridden. For instance, the user may specify any of the above options with {cmd:missnum(-)}, and
then missing numeric values will be given as minus signs.


{title:Remarks}

{pstd}
{cmd:listtex} creates (either on disk or in the Stata log and/or Results window) a text table with up to 3
kinds of rows. These are headline rows, data rows and footline rows.
Any of these categories of rows may be empty.
The headline and footline rows can be anything the user specifies in the {cmd:headline()} and
{cmd:footline()} options, respectively. This allows the user to specify TeX preambles, LaTeX
environment delimiters, HTML table delimiters and header rows, or other headlines and/or footlines
for table formats not yet invented. The data rows must contain variable values, separated by the
{cmd:delimiter()} string, with the optional {cmd:begin()} string on the left and the optional
{cmd:end()} string on the right. This general plan allows the option of using the same package
to generate TeX, LaTeX, HTML, Microsoft Word, and possibly other tables. The {cmd:rstyle()}
option saves the user from having to remember other options. The text table generated can then
be cut and pasted, embedded, or linked (eg with the TeX {hi:\input} command) into a document.
The {helpb inccat} command, available on {help ssc:SSC}, can be used to embed a {helpb using}
file produced by {cmd:listtex} into a document. If all the variables are string, then title rows
may sometimes be created using the {helpb ingap} package, also on {help ssc:SSC}, instead
of using the {cmd:headlines()} option of {cmd:listtex}.
For more about the use of {cmd:listtex} with other packages,
see Newson (2006), Newson (2004), and Newson (2003).

{pstd}
The {helpb ssc}, {helpb findit} or {helpb net} commands can also be used to find the various
alternatives to {cmd:listtex}, such as {helpb textab}, {helpb outtex}, {helpb sutex}, {helpb outtable}
and {helpb estout},
which also produce tables from Stata.


{title:Examples}

{pstd} To type text table lines separated by {hi:&} characters for cutting and pasting into a
Microsoft Word table using the menu sequence {hi:Table->Convert->Text to Table}:

{p 16 20}{inp:. listtex make foreign weight mpg, type}{p_end}

{pstd}
To output text table lines separated by tab characters to a text file
for cutting and pasting into a
Microsoft Word table using {hi:Table->Convert->Text to Table}:

{p 8 12 2}{inp:. listtex make foreign weight mpg using trash1.txt, rstyle(tabdelim)}{p_end}

{pstd}
To produce TeX table lines for a plain TeX {cmd:\halign} table:

{p 8 12 2}{inp:. listtex make foreign weight mpg using trash1.tex, rs(halign) replace}{p_end}

{pstd}
To produce TeX table lines for a plain TeX {cmd:\halign} table with
horizontal and vertical rules:

{p 8 12 2}{inp:. listtex make foreign weight mpg using trash1.tex, b(&&) d(&&) e(&\cr{\noalign{\hrule}}) replace}{p_end}

{pstd}
To produce TeX table lines for a plain TeX {cmd:\settabs} table:

{p 8 12 2}{inp:. listtex make foreign weight mpg using trash1.tex, rstyle(settabs) replace}{p_end}

{pstd}
To produce LaTeX table lines for the LaTeX {cmd:tabular} environment:

{p 8 12 2}{inp:. listtex make foreign weight mpg using trash1.tex, rstyle(tabular) replace}{p_end}

{pstd}
To produce a LaTeX {hi:tabular} environment with a title line, for cutting and pasting into a document:

{p 8 12 2}{inp:. listtex make weight mpg if foreign, type rstyle(tabular) head("\begin{tabular}{rrr}" `"\textit{Make}&\textit{Weight (lbs)}&\textit{Mileage (mpg)}\\"') foot("\end{tabular}")}{p_end}

{pstd}
Note that the user must specify compound quotes {hi:`""'}
around strings in the {cmd:head()} option containing the double backslash {hi:\\} at the end of a LaTeX line.
This is because, inside Stata strings delimited by simple quotes {hi:""},
a double backslash is interpreted as a single backslash.

{pstd}
To produce HTML table rows for insertion into a HTML table:

{p 8 12 2}{inp:. listtex make foreign weight mpg using trash1.htm, rstyle(html) replace}{p_end}

{pstd}
To produce a HTML table for cutting and pasting into a HTML document:

{p 8 12 2}{inp:. listtex make weight mpg if foreign, type rstyle(html) head(`"<table border="1">"' "<tr><th>Make and Model</th><th>Weight (lbs)</th><th>Mileage (mpg)</th></tr>") foot("</table>")}{p_end}

{pstd}
To produce the same HTML table, using {cmd:listtex_vars}:

{p 8 12 2}{inp:. listtex_vars make weight mpg, substitute(varlab) rstyle(htmlhead) local(headrow)}{p_end}
{p 8 12 2}{inp:. listtex make weight mpg if foreign, type rstyle(html) head(`"<table border="1">"' `"`headrow'"') foot("</table>")}{p_end}

{pstd}
To produce a HTML table of variable attributes using {cmd:listtex_vars} with the {helpb descsave} package
(an extended version of {helpb describe} downloadable from {help ssc:SSC}):

{p 8 12 2}{inp:. preserve}{p_end}
{p 8 12 2}{inp:. descsave, norestore}{p_end}
{p 8 12 2}{inp:. list, noobs abbr(32) subvarname}{p_end}
{p 8 12 2}{inp:. listtex_vars, rstyle(htmlhead) substitute(char varname)}{p_end}
{p 8 12 2}{inp:. listtex, type rstyle(html) head("<table frame=box>" "`r(vars)'") foot("</table>")}{p_end}
{p 8 12 2}{inp:. restore}{p_end}


{title:Saved results}

{pstd}
{cmd:listtex_rstyle} saves the following in {cmd:r()}:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(begin)}}{cmd:begin()} string{p_end}
{synopt:{cmd:r(delimiter)}}{cmd:delimiter()} string{p_end}
{synopt:{cmd:r(end)}}{cmd:end()} string{p_end}
{synopt:{cmd:r(missnum)}}{cmd:missnum()} string{p_end}
{p2colreset}{...}

{pstd}
{cmd:listtex_vars} saves the above items in {cmd:r()},
and also the following:

{synoptset 15 tabbed}{...}
{p2col 5 15 19 2: Macros}{p_end}
{synopt:{cmd:r(vars)}}generated table row{p_end}
{p2colreset}{...}


{title:Author}

{pstd}
Roger Newson, Imperial College London, UK.
Email: {browse "mailto:r.newson@imperial.ac.uk":r.newson@imperial.ac.uk}


{title:References}

{phang}
Newson, R.  2006. 
Resultssets, resultsspreadsheets and resultsplots in Stata.
Presented at {browse "http://ideas.repec.org/s/boc/dsug06.html" :the 4th German Stata User Meeting, Mannheim, 31 March, 2006}.
Also downloadable from
{net "from http://www.imperial.ac.uk/nhli/r.newson":Roger Newson's website at http://www.imperial.ac.uk/nhli/r.newson}.

{phang}
Newson, R.  2004.
From datasets to resultssets in Stata.
Presented at {browse "http://ideas.repec.org/s/boc/usug04.html" :the 10th United Kingdom Stata Users' Group Meeting, London, 29 June, 2004}.
Also downloadable from
{net "from http://www.imperial.ac.uk/nhli/r.newson":Roger Newson's website at http://www.imperial.ac.uk/nhli/r.newson}.

{phang}
Newson, R.  2003.
Confidence intervals and {it:p}-values for delivery to the end user.
{it:The Stata Journal} 3(3): 245-269.
Pre-publication draft downloadable from
{net "from http://www.imperial.ac.uk/nhli/r.newson":Roger Newson's website at http://www.imperial.ac.uk/nhli/r.newson}.


{title:Also see}

{p 4 13 2}
{bind: }Manual: {hi:[D] describe}, {hi:[P] file}, {hi:[D] insheet}, {hi:[D] list}, {hi:[D] outsheet}, {hi:[D] type}
{p_end}
{p 4 13 2}
On-line: help for {helpb describe}, {helpb file}, {helpb insheet}, {helpb list}, {helpb ssc}, {helpb outsheet}, {helpb type}{break}
help for {helpb descsave}, {helpb estout}, {helpb inccat}, {helpb ingap}, {helpb outtable}, {helpb outtex}, {helpb textab}, {helpb sutex},
{helpb listtab} if installed
{p_end}
{p 4 13 2}
{bind:  }Other: {hi:Knuth D. E. 1992. The TeXbook. Reading, Mass: Addison-Wesley.}{break}
{hi:Lamport L. 1994. LaTeX: a document preparation system. 2nd edition. Boston, Mass: Addison-Wesley.}{break}
{browse "http://www.w3.org/MarkUp/":The W3C HyperText Markup Language (HTML) Home Page at http://www.w3.org/MarkUp/}
{p_end}
