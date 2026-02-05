%%
%% This is file `amsc.cls',
%% generated with the docstrip utility.
%%
%% The original source files were:
%%
%% ams-c.dtx  (with options: `cls,art')
%% 
%% This is a generated file.
%% 
%% Copyright 2011-2015
%% The Editorial Office of Acta Mathematica Sinica
%% 
%% This file was generated from file(s) of the ams-c package project.
%% ----------------------------------------------------------------------
%% 
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.2
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.2 or later is part of all distributions of LaTeX
%% version 1999/12/01 or later.
%% 
%% To produce the documentation run the original source files ending
%% with `.dtx' through LaTeX.
%% 
%% \CharacterTable
%%  {Upper-case    \A\B\C\D\E\F\G\H\I\J\K\L\M\N\O\P\Q\R\S\T\U\V\W\X\Y\Z
%%   Lower-case    \a\b\c\d\e\f\g\h\i\j\k\l\m\n\o\p\q\r\s\t\u\v\w\x\y\z
%%   Digits        \0\1\2\3\4\5\6\7\8\9
%%   Exclamation   \!     Double quote  \"     Hash (number) \#
%%   Dollar        \$     Percent       \%     Ampersand     \&
%%   Acute accent  \'     Left paren    \(     Right paren   \)
%%   Asterisk      \*     Plus          \+     Comma         \,
%%   Minus         \-     Point         \.     Solidus       \/
%%   Colon         \:     Semicolon     \;     Less than     \<
%%   Equals        \=     Greater than  \>     Question mark \?
%%   Commercial at \@     Left bracket  \[     Backslash     \\
%%   Right bracket \]     Circumflex    \^     Underscore    \_
%%   Grave accent  \`     Left brace    \{     Vertical bar  \|
%%   Right brace   \}     Tilde         \~}
%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{amsc}
  [2011/06/30 v0.1b Acta Mathematica Sinica Chinese
   article document class]
\newif\ifams@evenend \ams@evenendfalse
\DeclareOption{evenend}{\ams@evenendtrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexart}}
\PassOptionsToClass{twoside}{ctexart}
\ProcessOptions
\LoadClass{ctexart}
\RequirePackage{ifpdf}
\RequirePackage{graphicx,subfigure}
\RequirePackage{amsmath,amsthm,amssymb,amsfonts,amscd,mathrsfs,bm}
\RequirePackage[numbers,sort&compress]{natbib}
\input scrload.tex
\textheight 20.7 true cm
\textwidth 14.7 true cm
\topmargin 0pt
\oddsidemargin 0pt
\evensidemargin 0pt
\headsep 0.4 true cm
\headheight 8 true mm
\footskip 2mm
\parindent 2\ccwd
\renewcommand\baselinestretch{1.1}
\allowdisplaybreaks[4]
\newfam\cryfam
\newfam\smbfam
\newfont{\htxt}{eufm10 scaled \magstep0}
\font\tenthxt=eufm10 scaled \magstep0 \font\tenBbb=msbm10 scaled
\magstep0 \font\tencyr=wncyr10 scaled \magstep0 \font\tenrm=cmr10
scaled \magstep0 \font\tenbf=cmb10 scaled \magstep0
\font\tenBb=msbm7 \font\tenB=msbm10 scaled \magstep3

%\def\cyr{\tencyr} %long 2012-11-22
%\def\Bbb{\tenBbb} %long 2012-11-22
%\def\Bb{\tenBb} %long 2012-11-22
%\def\B{\tenB} %long 2012-11-22
%\def\txt{\tenthxt} %long 2012-11-22

%\def\ST{\songti\rm\relax} %long 2012-11-22
\def\HT{\heiti\bf\relax} 
%\def\FS{\fangsong\relax} %long 2012-11-22
%\def\KS{\kaishu\relax} %long 2012-11-22



\newcommand*\EditorNote[1]{%
  \begingroup
    \long\def\@makefntext##1{\parindent 1em\noindent\hbox to 0pt{\hss$^{}$}##1}%
    \footnotetext{#1}%
  \endgroup}
\newcommand\PageNum[1]{\setcounter{page}{#1}}
\def\ps@headings{%
  \let\@oddfoot\@empty\let\@evenfoot\@empty
  \def\@evenhead{%
    \vbox{\hbox to\textwidth{\rlap{\small\thepage}
    \hfill {\zihao{-5}\songti 数\quad 学\quad 学\quad 报\quad\kaishu 中\ 文\ 版}
    \hfill {\small\ams@volume}{\zihao{-5}\songti 卷}
    \llap{}}\protect\vspace{2truemm}\relax
    \hrule depth0pt height0.15truemm width\textwidth}}
  \def\@oddhead{%
    \vbox{\hbox to\textwidth{\rlap{}
    {\small\ams@number}{\zihao{-5}\songti 期}\hfill
    {\small\zihao{-5}\songti \ams@titlemark}\hfill
    \llap{\small\thepage}}
    \protect\vspace{2truemm}\relax
    \hrule depth0pt height0.15truemm width\textwidth}}
  \let\@mkboth\@gobbletwo
  \let\sectionmark\@gobble
  \let\subsectionmark\@gobble
}
\ps@headings
\newcommand*\TitleMark[1]{\def\ams@titlemark{#1}}
\def\ams@year{2011}
\def\ams@month{1}
\def\ams@volume{54}
\def\ams@number{1}
\newcommand*\Volume[4]{%
  \def\ams@year{#1}%
  \def\ams@month{#2}%
  \def\ams@volume{#3}%
  \def\ams@number{#4}}
\def\ams@paperid{}
\newcommand*\PaperID[1]{%
  \def\ams@paperid{#1}}
\def\ams@documentcode{}
\newcommand*\DocumentCode[1]{%
  \def\ams@documentcode{#1}}
\newcommand*\ams@shortmonthname[1]{%
\ifcase#1\or Jan.\or Feb.\or Mar.\or Apr.\or May\or Jun.%
\or Jul.\or Aug.\or Sep.\or Oct.\or Nov.\or Dec.\fi}
\newcommand*\Title[1]{%
  \vspace*{.2in}
  \begin{center}
    {\huge\bf\zihao{2}\heiti #1}\\[.2in]
  \end{center}
}
\newcommand*\ETitle[1]{%
  \vskip.2in
  \begin{center}
    {\tenbf #1}\\[.2in]
  \end{center}
}
\newcommand*\Author[2]{%
  \begin{center}
    \zihao{4}\fangsong#1\\[.1in]
    \small\zihao{-5}#2\\[.1in]
  \end{center}
}
\newcommand*\EAuthor[2]{%
  \begin{center}
    \footnotesize #1\\[.1in]
    {\footnotesize\it #2}\\[.1in]
  \end{center}
}
\newcommand*\BeginTitle{%
  \vspace*{-13mm}%
  \thispagestyle{empty}%
  \noindent \hbox to \textwidth{\small{\zihao{-5}\songti 第}%
  \,\ams@volume{\zihao{-5}\songti 卷 第}%
  \,\ams@number{\zihao{-5}\songti 期}%
  \hfill{\zihao{-4} 数 \quad 学 \quad 学 \quad 报 \quad {\kaishu 中\ 文\ 版}}%
  \hfill Vol.\ams@volume, No.\ams@number} \vskip -0.3mm % \vskip -0.2mm long 20110705
  \par\noindent%
  \hbox to \textwidth{\small\ams@year{\zihao{-5}\songti 年}%
  \,\ams@month{\zihao{-5}\songti 月}%
  \hfill ACTA MATHEMATICA SINICA, CHINESE SERIES % Chinese Series %long20131128
  \hfill \ams@shortmonthname{\ams@month}, \ams@year} \vskip -0.3mm %
  \par\noindent %
  \rule[2mm]{\textwidth}{0.5pt}\hspace*{-\textwidth}\rule[1.5mm]{\textwidth}{0.5pt}%
  \ziju{0.025} \par\noindent {\small\heiti\bf\relax 文章编号:}\ \ams@paperid%
  \qquad\qquad{\small\HT 文献标识码:\ \ams@documentcode}%
}
\newcommand*\EndTitle{\vskip .1in}
\newcommand*\Abstract[1]{%
  \begingroup\vskip.1in\narrower\noindent
    {\heiti\bf 摘\quad 要}\fangsong\quad #1%
  \par\vskip.1in\endgroup}
\newcommand*\EAbstract[1]{%
  \begingroup\vskip.1in\narrower\noindent
    {\heiti\bf Abstract}\rm\quad #1%
  \par\vskip.1in\endgroup}
\newcommand*\Keywords[2][关键词]{%
  \begingroup\narrower\noindent
    {\heiti\bf #1}\fangsong\quad #2%
  \par\endgroup}
\newcommand*\EKeywords[2][Keywords]{%
  \begingroup\narrower\noindent
    {\heiti\bf #1}\rm\quad #2%
  \par\endgroup}
\newcommand*\MRClass[2][MR(2010)主题分类]{%
  \begingroup\narrower\noindent
    {\heiti\bf #1}\fangsong\quad #2%
  \par\endgroup}
\newcommand*\EMRClass[2][MR(2010) Subject Classification]{%
  \begingroup\narrower\noindent
    {\heiti\bf #1}\rm\quad #2%
  \par\endgroup}
\newcommand*\CLClass[2][中图分类]{%
  \begingroup\narrower\noindent
    {\heiti\bf #1}\fangsong\quad #2%
  \par\endgroup}
\newcommand*\ECLClass[2][Chinese Library Classification]{%
  \begingroup\narrower\noindent
    {\heiti\bf #1}\rm\quad #2%
  \par\endgroup}
\newcommand*\Section[2][]{%
  \edef\ams@temp{#1}
  \ifx\ams@temp\@empty\addtocounter{section}{1}
  \else\setcounter{section}{#1}\fi
 \setcounter{equation}{0} \setcounter{theorem}{0} %long2012-10-30 添加
  \vspace{.2in}
  \leftline{\large\bf\heiti\zihao{-4}\thesection\ \ #2}
  \vspace{.1in}
  \normalsize
  \abovedisplayskip=4.0pt plus 2.0pt minus 2.0pt
  \belowdisplayskip=4.0pt plus 2.0pt minus 2.0pt
  \baselineskip 15.3pt
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%设置定理环境 long2012-10-30
\theoremstyle{definition}
\newtheoremstyle{mythm}{0ex}{0ex}
   {\songti}{\parindent}{\songti\bf }{}{1em}{}
%\newtheoremstyle{mythm}{1ex}{1ex}%定理环境的上下间距.
%{\CJKfamily{song}}{\parindent}{\CJKfamily{hei} \bf}{}{1em}{}%定理内容为宋体, 缩进, 定理名称为黑粗体
\theoremstyle{mythm}%设置定理环境
\newtheorem{theorem}{定理\relax}[section]
\newtheorem{lemma}[theorem]{引理\relax}
\newtheorem{property}[theorem]{性质\relax}
\newtheorem{proposition}[theorem]{命题\relax}
\newtheorem{question}[theorem]{问题\relax}
\newtheorem{corollary}[theorem]{推论\relax}
\newtheorem{definition}[theorem]{定义\relax}
\newtheorem{remark}[theorem]{注\relax}
\newtheorem{example}[theorem]{例\relax}

\newenvironment{prof}[1][Proof]{\heiti\bf 证明\!\quad\rm}
{\hfill $\Box$}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% long2012-10-30

\newcommand*\Thanks[1]{%
  \vskip8pt{\heiti\bf\relax 致谢}\hspace{0.25cm} #1\par}
\renewcommand\refname{\bf\heiti\zihao{-4}参\hspace{8mm}考\hspace{8mm}文\hspace{8mm}献\vspace*{2mm}} % by long 20110704
\newcommand\BeginRef{\vspace*{2mm}\baselineskip 11pt \footnotesize \parindent=4.75mm % by long 20110704
\begin{thebibliography}{99}}
\newcommand\EndRef{\end{thebibliography}}
\newcommand*\REF[1]{\bibitem{#1}}
\newcommand*\supercite[1]{\textsuperscript{\cite{#1}}}
\endinput
%%
%% End of file `amsc.cls'.
