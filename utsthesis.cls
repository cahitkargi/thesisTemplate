%
% 
 
\ProvidesClass{utsthesis}
\NeedsTeXFormat{LaTeX2e}

% ----- For Including Graphics -----
\RequirePackage{graphicx}

% ----- Useful AMS packages -----
\RequirePackage[fleqn]{amsmath}
\RequirePackage{amssymb}

% footnote stuff for option processing
%
\usepackage{fancyhdr}
\newwrite\tf@not

\newif\ifendnotes      % true if doing endnotes
  \endnotesfalse
\newif\ifchapternotes  % true if doing chapternotes
  \chapternotesfalse
\let\printchapternotes\relax
\let\printendnotes\relax
 
\DeclareOption{footnotes}% selects bottom-of-page notes (default)
  {}
\DeclareOption{chapternotes}% selects end-of-chapter notes
  {\chapternotestrue}
\DeclareOption{endnotes}% selects end-of-thesis notes
  {\endnotestrue}

%
% ----  Thesis is a modified (default 12pt) book style  -----------------
%

%\def\set@sides{\@twosidefalse}
%\def\ds@twoside{\def\set@sides{\@twosidetrue}}
\def\logo{\begin{figure}[h]
 \centering
 \includegraphics[clip=true, totalheight=0.095\textheight, angle=0]{UTS_logo.png}
\end{figure}}
\def\@f@ntsize{12pt}
\DeclareOption{10pt}{\def\@f@ntsize{10pt}}
\DeclareOption{11pt}{\def\@f@ntsize{11pt}}
\DeclareOption{12pt}{\def\@f@ntsize{12pt}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions
\PassOptionsToClass{\@f@ntsize}{book}
\PassOptionsToClass{openany}{book}
\ProcessOptions
\LoadClass{book}

%\set@sides
%\if@twoside \message{[twosides]}\else\message{[oneside]}\fi

%
% ---- page sizes ----------------------------------------------
%
% text size computed from paper size
%

\voffset -0.9in  
\hoffset -1in

\topmargin 50\p@  
\headheight 15\p@
\headsep 36\p@
\oddsidemargin 90\p@ 
\evensidemargin 90\p@
\newdimen\botmargin
\botmargin 50\p@
\marginparwidth 72\p@
\marginparsep 7\p@
\footskip 45\p@ % set later
\footnotesep 14\p@
\parindent 1.5em

\textheight\paperheight
  \advance\textheight by-\topmargin
  \advance\textheight by-\headheight
  \advance\textheight by-\headsep
  \advance\textheight by-\footskip
  \advance\textheight by-\botmargin
\textwidth\paperwidth
  \advance\textwidth by-\oddsidemargin
  \advance\textwidth by-\evensidemargin

% ---------------

\def\baselinestretch{1.5}    % not quite doublespaced

\setcounter{totalnumber}{5}
\setcounter{topnumber}{5}
\renewcommand\topfraction{.7}
\renewcommand\textfraction{.2}
\setlength\floatsep    {18\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\textfloatsep{30\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\intextsep   {20\p@ \@plus 4\p@ \@minus 4\p@}
\let\@normalsize\normalsize  % retain old definition
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{10\p@}

 
%
%  ----  Footnotes  ------------------------------------------
%
% Footnote placement option
%
%   [endnotes] put the references at the thesis end
%   [chapternotes] put the references at the chapter end
%   [footnotes] put the references at the page bottom
%
%   When text is written to file (.not) the source linebreaks
%   are maintained.  This keeps the individual lines in the file short.
%   Control sequences in the note text are not expanded.
%

\let\n@teitem\relax

\def\@chapternotetext{\begingroup
  \catcode`\^^M=12\newlinechar=`\^^M
  \catcode`\\=12
  \d@chapternote}

\long\def\d@chapternote#1{%
  \immediate \write\tf@not
      {\n@teitem[\note@label] #1\relax}%
  \endgroup}

%
\def\@startnotes{%  opens the .not file
  \immediate \openout\tf@not\jobname.not\relax
  \immediate \write\tf@not{\relax}
  \setcounter{footnote}{0}}

%
% chapternotes
%

\ifchapternotes
  % \typeout{Doing chapternotes}
  \let\@footnotetext\@chapternotetext
  \@startnotes
  \def\note@label{\arabic{footnote}}
  \def\printchapternotes{% Prints the accumulated notes
    \ifnum\c@footnote>1
      \clearpage
      \begin{center} Notes to Chapter \arabic{chapter} \end{center}\par
      \addcontentsline{toc}{section}{\protect
          \numberline{}{Notes to Chapter \arabic{chapter}}}
      \begin{description}
      \immediate\closeout\tf@not
      \catcode`@=11
      \let\n@teitem\item
      \@input{\jobname.not}
      \end{description}
      \clearpage
      \@startnotes
    \fi
  }
  \let\old@enddocument\enddocument
  \def\enddocument{\printchapternotes\old@enddocument}
\fi

%
% endnotes
%

\ifendnotes
  % \typeout{Doing endnotes}
  \let\@footnotetext\@chapternotetext
  \@startnotes
  \def\note@label{\arabic{chapter}.\arabic{footnote}}
  \def\printendnotes{% Prints the accumulated notes
    \chapter*{Notes}
    \addcontentsline{toc}{chapter}{Notes}
    \pagestyle{plain}
    \begin{description}
    \immediate\closeout\tf@not
    \catcode`@=11
    \let\n@teitem\item
    \@input{\jobname.not}
    \end{description}
    \@startnotes  % allows multiple endnotes
   }
\fi

%
%  bottom-of-page footnotes format
%  full width line and hanging indent
%
\def\footnoterule{\kern-3\p@
 \hrule width \columnwidth \kern 2.6\p@}
\long\def\@makefntext#1{\parindent 1em\noindent \hangindent\parindent
 \def\baselinestretch{1.0}\normalfont
 \hb@xt@1.8em{\hss\@makefnmark}#1}
 
%
%  ----  Text pages  ----------------------------------
%
%  In two-sided style Chapter 1 is right handed
%
\def\textofChapter#1{\gdef\@textofChapter{#1}}  \textofChapter{Chapter}
\def\textofAppendix#1{\gdef\@textofAppendix{#1}}  \textofAppendix{Appendix}

\def\textpages{% Start of text pages
   \clearpage\pagestyle{empty}
   \cleardoublepage\pagestyle{fancy}\markboth{}{}
   \pagestyle{fancy}
   \def\@chapapp{\protect\@textofChapter}
   \def\Thechapter{\arabic{chapter}}
   %\pagenumbering{arabic}
   \advance\textheight by 0\p@ % no bottom-of-page numbers now
     %\footskip 60\p@
   % \ifarchitect \textwidth 614\p@ \oddsidemargin 36\p@ \twocolumn\fi
   }
 
\def\appendix{\par
 \setcounter{chapter}{0}
 \setcounter{section}{0}
 \def\@chapapp{\protect\@textofAppendix}
 \def\Thechapter{\Alph{chapter}}
 \def\thechapter{\Alph{chapter}}}
 
 
%
%  Chapter headings
%
\def\@makechapterhead#1{ \vspace*{2pc} {\centering
 \ifnum \c@secnumdepth >\m@ne \large \@chapapp{} \Thechapter \par
 \vspace{10\p@} \fi \large\bf \uppercase\expandafter{#1}\par
 \nobreak \vspace{20\p@}} }
%
\def\@makeschapterhead#1{ \vspace*{2pc} {\centering
 \large\bf \uppercase\expandafter{#1}\par
 \nobreak \vspace{20\p@}} }
%
\def\chapter{
   \printchapternotes
   \if@openright\cleardoublepage\else\clearpage\fi
   \thispagestyle{fancy}
   \global\@topnum\z@
   \@afterindenttrue
   % \let\\\relax
   \secdef\@chapter\@schapter}
%
%  Complication is added here to allow line breaks
%  in the chapter titles (via \\).
%
\def\@chapter[#1]#2{
  \ifnum \c@secnumdepth >\m@ne
  \refstepcounter{chapter}
\lhead[\thepage]{\small\it\@chapapp\ \thechapter: #1}
\chead{}
\rhead[\small\it\@chapapp\ \thechapter: #1]{\thepage}
\lfoot{}\cfoot{}\rfoot{}
\typeout{\@chapapp\space\thechapter.}  
%\typeout{<<\thechapter>>}
  {\def\\{ }  % allow \\ in title
   \addcontentsline{toc}{chapter}{\protect
     \numberline{\@chapapp\ \thechapter:}#1}}\else
  {\def\\{ }  % allow \\ in title
   \addcontentsline{toc}{chapter}{#1}}\fi
 \addtocontents{lof}{\protect\addvspace{10\p@}}
 \addtocontents{lot}{\protect\addvspace{10\p@}}
 \if@twocolumn
  \@topnewpage[\@makechapterhead{#2}]
  \else \@makechapterhead{#2}
  \@afterheading \fi}
\def\@schapter#1{\if@twocolumn \@topnewpage[\@makeschapterhead{#1}]
  \else \@makeschapterhead{#1}
  \@afterheading\fi}
%
%  Section headings
%
\renewcommand\section{%
  \@startsection {section}{1}{\z@}%
       {-3.5ex \@plus -1ex \@minus -.2ex}%
       {2.3ex \@plus.2ex}%
       {\reset@font\normalsize\bfseries\slshape}}
\renewcommand\subsection{%
  \@startsection{subsection}{2}{\z@}%
       {-3.25ex\@plus -1ex \@minus -.2ex}%
       {1.5ex \@plus .2ex}%
       {\reset@font\normalsize\mdseries\itshape}}
\renewcommand\subsubsection{%
  \@startsection{subsubsection}{3}{\z@}%
       {-3.25ex\@plus -1ex \@minus -.2ex}%
       {1.5ex \@plus .2ex}%
       {\reset@font\normalsize\mdseries\itshape}}

%
%  Provide for `Chapter ' in the toc
%  (increase \@tempdima)
%
\renewcommand\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \vskip 1.0em \@plus\p@
    \setlength\@tempdima{85\p@}%
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \leavevmode \bfseries
      \advance\leftskip\@tempdima
      \hskip -\leftskip
      #1\nobreak\hfil \nobreak\hbox to\@pnumwidth{\hss #2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}

%
% ------ Special captions ---------------------
%
% \caption[]{text} produces normal caption and numbering
% \caption(-){(continued)} produces `(continued)' caption and 
%        same-as-last caption number
% \caption(x)[]{text} produces lettered caption.  1.1a, 1.1b, ...
%        If (x) is (a) or (A) then caption number is incremented,
%        else it is same numbered.

\def\thecaptionletter{}
\newif\ifcaptiontotoc\captiontotoctrue

\def\caption{\@ifnextchar({\@specialcaption}{\@normalcaption}}

\def\@normalcaption{\refstepcounter\@captype \@dblarg{\@caption\@captype}}
\def\@specialcaption(#1){%
  \def\thecaptionletter{#1}%
  \captiontotocfalse
  \if#1-\def\thecaptionletter{}\fi
  \if#1a\refstepcounter\@captype\captiontotoctrue\fi
  \if#1A\refstepcounter\@captype\captiontotoctrue\fi
  \@dblarg{\@caption\@captype}}

\long\def\@caption#1[#2]#3{\par
  \ifcaptiontotoc
    \addcontentsline{\csname
    ext@#1\endcsname}{#1}{\protect\numberline{\csname
    the#1\endcsname}{\ignorespaces #2}}%
  \fi
  \begingroup
    \@parboxrestore
    \def\baselinestretch{1.0}
    \normalsize
    \@makecaption{\csname fnum@#1\endcsname
        \thecaptionletter}{\ignorespaces #3}\par
  \endgroup}

\def\@listI{\leftmargin\leftmargini \parsep 7\p@ plus 3\p@ minus 1\p@\topsep
 12\p@ plus 5\p@ minus 6\p@\itemsep 7\p@ plus 3\p@ minus 1\p@}
 
 
%
%  ----  Facing pages and double-page figures and tables
%
%  \begin{fullpage} ... \end{fullpage}
%  \begin{leftfullpage} ... \end{leftfullpage}
%  \begin{xtrafullpage} ... \end{xtrafullpage}

\newif\if@LP \@LPfalse
\newif\if@XP \@XPfalse

\newbox\@@wholepage
\def\fullpage{\setbox\@@wholepage=\vbox\bgroup}
\def\endfullpage{\egroup\dp\@@wholepage\z@
   \vbox to\textheight{\vss\unvbox\@@wholepage\vss}}
\def\leftfullpage{\setbox\@@wholepage=\vbox\bgroup}
\def\endleftfullpage{\egroup\dp\@@wholepage\z@
   \vbox to\textheight{\vss\unvbox\@@wholepage\vss}\global\@LPtrue}

\if@twoside
   \typeout{Formatting for twoside printing.}
   \let\xtrafullpage\fullpage
   \let\endxtrafullpage\endfullpage
\else
   \typeout{Formatting for oneside printing.}
   \def\xtrafullpage{\setbox\@@wholepage=\vbox\bgroup}
   \def\endxtrafullpage{\egroup\dp\@@wholepage\z@
      \vbox to\textheight{\vss\unvbox\@@wholepage\vss}\global\@XPtrue}
\fi

\let\oldend@float\end@float
\def\end@float{%
  \if@LP\global\@namedef{LP:\expandafter\string\@currbox}{L}%
  \else \global\@namedef{LP:\expandafter\string\@currbox}{z}%
  \fi
  \if@XP\global\@namedef{XP:\expandafter\string\@currbox}{X}%
  \else \global\@namedef{XP:\expandafter\string\@currbox}{z}%
  \fi
  \global\@LPfalse
  \global\@XPfalse
  \oldend@float
}


\if@twoside

% reject a left-side float that appears on an odd page
 \let\old@xtryfc\@xtryfc
 \def\@xtryfc #1{%
   \expandafter\if\csname LP:\string#1\endcsname L%
      % \typeout{facing page in xtryfc}%
      \ifodd\count0\global\@colht\z@
          \typeout{I moved a leftpage float from page \the\count0.}%
      \fi\fi
    \old@xtryfc #1}

\else

\def\unstep@page{\addtocounter{page}{-1}}

% flip a facing page caption
 \let\@oldwtryfc\@wtryfc
 \def\@wtryfc #1{%
  \expandafter\if\csname LP:\string#1\endcsname L\gdef\LP@page{}%
      \typeout{Encountered a facing page.}%
   \fi
  \expandafter\if\csname XP:\string#1\endcsname X\gdef\XP@page{}%
      \typeout{Encountered an extra page.}%
   \fi
   \@oldwtryfc #1}

 \let\old@outputpage\@outputpage
 \def\@outputpage{%
   \begingroup
   \@ifundefined{LP@page}
     {\let\@themargin\oddsidemargin \let\@thehead\@oddhead}
     {\let\@themargin\evensidemargin \let\@thehead\@evenhead
       \typeout{Printing a left-hand one-side page.}%
       \global\let\LP@page\relax
      }
   \@ifundefined{XP@page}
     {}
     {\let\@thehead\@empty \let\@thefoot\@empty
       \typeout{Printing an extra page.}%
       \global\let\XP@page\relax
       \aftergroup\unstep@page
      }
   \old@outputpage\endgroup
 }
\fi

%
%  ----  Preliminary pages  ---------------------------
%
\def\prelimpages{ % sets page numbering for the preliminary pages
   \pagestyle{empty} % will be {plain} at start of toc
   \pagenumbering{roman}
   \setcounter{page}{1}
   %\footskip 60\p@ % allowance for the roman page numbers
    \advance\textheight by -10\p@
   % \ifarchitect \textwidth 450\p@ \oddsidemargin 118\p@\fi
   }
%
%      (The following macros are used once and discarded)
%
%  Title page

\def\Title#1{\gdef\@Title{#1}}
\def\Program#1{\gdef\@Title{#1}}
\def\By#1{\gdef\@By{#1}} \By{by}
\def\Author#1{\gdef\@Author{#1}}
\def\Year#1{\gdef\@Year{#1}}  \Year{\year}
\def\Degree#1{\gdef\@Degree{#1}}
\def\In#1{\gdef\@In{#1}} \In{in}
\def\InThe#1{\gdef\@InThe{#1}} \InThe{in the}
\def\AtThe#1{\gdef\@AtThe{#1}} \AtThe{at the}
\def\Program#1{\gdef\@Program{#1}}
\def\School#1{\gdef\@School{#1}} \School{University of Technology Sydney}
\def\GSchool#1{\gdef\@GSchool{#1}} \GSchool{School of Mathematical and Physical Sciences}
\def\Degreetext#1{\gdef\@Degreetext{#1}} 
  \Degreetext{A thesis submitted in satisfaction of the \\
    requirements for the degree of}
\def\Programtext#1{\gdef\@Programtext{#1}}  
       \Programtext{}

\def\titlepage{                   % Prints the title page
    \vspace{7pc}
    \begin{center}
      {\Large
      \lineskip 3ex
      \textbf{\@Title}\par}
      \par\vskip\z@ plus1fill\relax
      \@By
      \par\vskip\z@ plus1fill\relax
      \textbf{\@Author}
      \par\vskip\z@ plus1fill\relax
      \@Degreetext
      \par\vskip\z@ plus1fill\relax
      \@Degree~\@In~\@Program
      \par\vskip\z@ plus1fill\relax
      \@InThe
      \par\vskip\z@ plus1fill\relax
      \@GSchool
      \par\vskip\z@ plus1fill\relax
      \@AtThe
      \par\vskip\z@ plus1fill\relax
      \@School
      \par\vskip\z@ plus10fill\relax
      \logo
      \par\vskip\z@ plus0.5fill\relax
      \@Year
      \par\vskip\z@ plus1fill\relax
      
    \end{center}
     \vspace{2pc}\relax
  \let\titlepage\relax}
 
%
%  Signature page
%

\def\thesissignaturepage{  % Prints the thesis signature page
   \clearpage
    \begin{center}
      \begin{large}\textbf{Certificate of Original Authorship}\end{large}
    \end{center}
    \vskip\p@ plus0.1fill\relax
    I, \@Author~declare that this thesis, is submitted in fulfilment of the requirements for the award of \@Degree, in the \@GSchool~at the \@School.

    Except where acknowledged in the customary manner, the material presented in this thesis is, to the best of my knowledge, original and has not been submitted in whole or part for a degree in any university.
    
    This thesis is wholly my own work unless otherwise referenced or acknowledged. In addition, I certify that all information sources and literature used are indicated in the thesis. 

    This research is supported by the Australian Government Research Training Program.
    \begin{center}
      \par\vskip\p@ plus0.1fill\relax
      \makebox[\textwidth]{\hspace{10pc}\hrulefill\hspace{10pc}}
      \textbf{\@Author}
    \end{center}
    \par\vskip\z@ plus2fill\relax
   \par

  \let\signaturepage\relax\let\thesissignaturepage\relax}
 
%
%   Abstract
%
%  normal parameters
\def\textofAbstract#1{\gdef\@textofAbstract{#1}}  \textofAbstract{Abstract}
%--------------

\long\def\abstract#1{\chapter*{\@textofAbstract\@mkboth{}{}}
   \thispagestyle{plain}
   #1\par
   \vfill
   \let\abstract\relax}

%
%   Table of contents (right side page) (always page `i')
%
%
\def\textofToC#1{\gdef\@textofToC{#1}}  \textofToC{Table of Contents}
\def\tableofcontents{\pagestyle{plain}\cleardoublepage
   \chapter*{\@textofToC\@mkboth{}{}}
   \thispagestyle{plain}
   %\setcounter{page}{1}
   {\let\footnotemark\relax  % in case one is in the title
   \@starttoc{toc}
    }
   }
%
%   List of figures
%
\def\textofLoF#1{\gdef\@textofLoF{#1}}  \textofLoF{List of Figures}
\def\listoffigures{\chapter*{\@textofLoF\@mkboth{}{}}
   \thispagestyle{plain}
   \addcontentsline{toc}{chapter}{\protect\@textofLoF}
   {\let\footnotemark\relax  % in case one is in the title
   \@starttoc{lof}
    }
   }
%
%   List of tables
%
\def\textofLoT#1{\gdef\@textofLoT{#1}}  \textofLoT{List of Tables}
\def\listoftables{\chapter*{\@textofLoT\@mkboth{}{}}
   \thispagestyle{plain}
   \addcontentsline{toc}{chapter}{\protect\@textofLoT}
   {\let\footnotemark\relax  % in case one is in the title
   \@starttoc{lot}
    }
   }
%
%  Abbreviations (Nomenclature)
%
\def\textofAbbreviations#1{\gdef\@textofAbbreviations{#1}}  
\textofAbbreviations{Nomenclature}
\long\def\abbreviations#1{\chapter*{\@textofAbbreviations\@mkboth{}{}}
   \thispagestyle{plain}
   \addcontentsline{toc}{chapter}{\protect\@textofAbbreviations}
   #1\par
   \vfill
   \let\abbreviations\relax}




%  Bibliography
%
\def\textofBIB#1{\gdef\@textofBIB{#1}}  \textofBIB{References}
\def\thebibliography#1{\chapter*{\@textofBIB\@mkboth{REFERENCES}{REFERENCES}}
\lhead{\small\it References}\chead{}\rhead{\thepage}
\lfoot{}\cfoot{}\rfoot{}
 \addcontentsline{toc}{chapter}{\protect\@textofBIB}
 \list
 {[\arabic{enumi}]}{\settowidth\labelwidth{[#1]}\leftmargin\labelwidth
 \advance\leftmargin\labelsep
 \usecounter{enumi}} 	
 \def\newblock{\hskip .11em plus .33em minus .07em}
 \sloppy\clubpenalty4000\widowpenalty4000
 \sfcode`\.=1000\relax}
 
%
%   Acknowledgments
%
\def\textofAck#1{\gdef\@textofAck{#1}}  \textofAck{Acknowledgments}
\long\def\acknowledgments#1{\chapter*{\@textofAck\@mkboth{}{}}
   \thispagestyle{plain}
   #1\par
   \vfill
   \let\acknowledgments\relax}
 
%
%   Dedication
%
\def\textofDed#1{\gdef\@textofDed{#1}}  \textofDed{}
%\textofDed{Dedication}
\long\def\dedication#1{\chapter*{\@textofDed\@mkboth{}{}}
   \thispagestyle{plain}
   \vspace{\fill}
   \begin{center}
	\emph{#1}\par
   \end{center}
   \vfill
   \let\dedication\relax}
 
%
%   Vita
%
\def\textofVita#1{\gdef\@textofVita{#1}}  \textofVita{Vita}
\long\def\vita#1{\chapter*{\@textofVita\@mkboth{VITA}{VITA}}
\lhead{\small\it Vita}\chead{}\rhead{\thepage}
\addcontentsline{toc}{chapter}{\protect\@textofVita}
\lfoot{}\cfoot{}\rfoot{}
   #1\par
   \vfill
   \let\vita\relax}
 
%
%   Gratis definition of a glossary environment
%
\renewenvironment{glossary}
  {\begin{list}{}{\setlength\itemindent{\parindent}
   \def\makelabel##1{\footnotesize\uppercase{##1:}\hfill}}}
  {\end{list}}

  % End of the thesis style