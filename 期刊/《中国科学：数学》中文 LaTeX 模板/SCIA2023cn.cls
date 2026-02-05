\def\sci@fileversion{2.05}
\def\sci@filedate{2018/5/16}
\def\@journal{中国科学: 数学}
\def\@issn{1674-7216}
\def\@copyright{$\copyright$~2023~《中国科学》杂志社}
\def\@website{\url{www.scichina.com}~~~~\url{mathcn.scichina.com}}

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{SCIA2023cn}[\sci@filedate, \sci@fileversion]

% \let\CCTCJKfonts=1
\LoadClass[twoside,fontset=windows]{ctexart}%cctart}
%% math packages
\RequirePackage{amsmath,amsthm,amsfonts,amssymb,bm,cite,upgreek,multicol,mathrsfs,pifont,amscd,latexsym,geometry,color,fancyhdr}
%% graphics packages
\RequirePackage{graphicx,xcolor}
%% other packages
\RequirePackage{algorithm,algorithmic,tabularx,url,float,booktabs}
%% check pdfTeX mode
\RequirePackage{ifpdf}
\RequirePackage{fancyhdr,lastpage}
\RequirePackage{supertabular}
%\RequirePackage{breakurl}
\urlstyle{same}%定义url字体和正文相同
\RequirePackage[hyperindex=true,colorlinks=true,linkcolor=blue,breaklinks=true,urlcolor=blue,citecolor=blue,CJKbookmarks]{hyperref}
%\RequirePackage[pdfstartview=FitH,hyperindex=true,CJKbookmarks=false,colorlinks=true,linkcolor=blue,breaklinks,urlcolor=blue,citecolor=blue]{hyperref}
%dvipdfm

%-------------------------- Page layout ------------------------------
\paperwidth 21 true cm                  % 纸张宽
\paperheight 28 true cm                 % 纸张高

\textwidth=160truemm
\textheight=208truemm
\topmargin=-10pt
\headsep=7truemm
\oddsidemargin=2pt
\evensidemargin=2pt
\parindent=22pt
\footskip=10mm
\renewcommand{\baselinestretch}{1.31}
\renewcommand{\arraystretch}{1.21}
\newcommand{\sanhao}{\fontsize{18pt}{\baselineskip}\selectfont}
\newcommand{\xiaosanhao}{\fontsize{15pt}{2\baselineskip}\selectfont}
\newcommand{\xiaosihao}{\fontsize{12pt}{\baselineskip}\selectfont}
\newcommand{\wuhao}{\fontsize{10pt}{\baselineskip}\selectfont}
\newcommand{\xiaowuhao}{\fontsize{9pt}{0.76\baselineskip}\selectfont}
\newcommand{\bahao}{\fontsize{9pt}{\baselineskip}\selectfont}
\newcommand{\qihao}{\fontsize{7pt}{\baselineskip}\selectfont}
\newcommand{\jiuhao}{\fontsize{9pt}{0.8\baselineskip}\selectfont}
\newcommand{\shihao}{\fontsize{6pt}{0.8\baselineskip}\selectfont}

%-------------------- Article Information ----------------------------
\let\@Luntan\@empty \def\Luntan#1{\def\@Luntan{#1}}
\let\@ArticleType\@empty \def\ArticleType#1{\def\@ArticleType{#1}}
\let\@SpecialTopic\@empty \def\SpecialTopic#1{\def\@SpecialTopic{#1}}
\let\@Year\@empty \def\Year#1{\def\@Year{#1}}
\let\@Vol\@empty \def\Vol#1{\def\@Vol{#1}}
\let\@No\@empty \def\No#1{\def\@No{#1}}
\let\@AuthorMark\@empty \def\AuthorMark#1{\def\@AuthorMark{#1}}
\let\@AuthorCitation\@empty \def\AuthorCitation#1{\def\@AuthorCitation{#1}}
\let\@BeginPage\@empty \def\BeginPage#1{\def\@BeginPage{#1}}
\let\@DOI\@empty \def\DOI#1{\def\@DOI{#1}}
\let\@ReceiveDate\@empty \def\ReceiveDate#1{\def\@ReceiveDate{#1}}
\let\@AcceptDate\@empty \def\AcceptDate#1{\def\@AcceptDate{#1}}
\let\@OnlineDate\@empty \def\OnlineDate#1{\def\@OnlineDate{#1}}
\let\@Foundation\@empty \def\Foundation#1{\def\@Foundation{#1}}
\let\@comment\@empty \def\comment#1{\def\@comment{#1}}
\let\@abstract\@empty \renewcommand\abstract[1]{\def\@abstract{#1}}
\let\@keywords\@empty \def\keywords#1{\def\@keywords{#1}}
\let\@enAuthorCitation\@empty \def\enAuthorCitation#1{\def\@enAuthorCitation{#1}}
\let\@enabstract\@empty \def\enabstract#1{\def\@enabstract{#1}}
\let\@enkeywords\@empty \def\enkeywords#1{\def\@enkeywords{#1}}
\let\@encomment\@empty \def\encomment#1{\def\@encomment{#1}}
\def\lastpage{\pageref{LastPage}}
\let\@SubTitle\@empty \def\SubTitle#1{\def\@SubTitle{#1}}
\let\@MSC\@empty \def\MSC#1{\def\@MSC{#1}}
\let\@enMSC\@empty \def\enMSC#1{\def\@enMSC{#1}}
\def\dl{\displaystyle}
\let\@Emails\@empty \def\Emails#1{\def\@Emails{#1}}



%-------------------------- Title ------------------------------------
\let\@title\@empty
\renewcommand\title[2]{
    \def\@title{\bfseries\huge\zihao{2}#1}
    \def\@titlehead{#2}
    \ifx\@titlehead\@empty\def\@titlehead{#1}\fi
    \def\@titlecitation{#2}
    \ifx\@titlecitation\@empty\def\@titlecitation{#1}\fi
}

\let\@entitle\@empty
\newcommand\entitle[2]{
    \def\@entitle{#1}
    \def\@entitlecitation{#2}
    \ifx\@entitlecitation\@empty\def\@entitlecitation{#1}\fi
}

\let\@author\@empty
\let\@authoremaillist\@empty
\let\@onlyoneauthor\@empty
\renewcommand*{\author}[4][]{%
  \ifx \@author\@empty
    \def\@author{#2\@authornote{#1}{#3}{#4}}
  \else
    \def\@onlyoneauthor{No}
    \expandafter\def\expandafter\@author\expandafter
      {\@author,\,\, #2\@authornote{#1}{#3}{#4}}
  \fi
  \ifx#3\@empty\else
      \ifx\@authoremaillist\@empty \def\@authoremaillist{#3}
      \else \expandafter\def\expandafter\@authoremaillist\expandafter{\@authoremaillist,~#3}
      \fi
  \fi
}

\let\@enauthor\@empty
\newcommand*{\enauthor}[3][]{%
  \ifx \@enauthor\@empty
    \def\@enauthor{#2\@enauthornote{#1}{#3}}
    \let\@enauthortemp\@enauthor
  \else
    \let\@enauthor\@enauthortemp
    \expandafter\def\expandafter\@enauthor\expandafter
      {\@enauthor~{\&}~#2\@enauthornote{#1}{#3}}
    \expandafter\def\expandafter\@enauthortemp\expandafter
      {\@enauthortemp,~#2\@enauthornote{#1}{#3}}
  \fi
}

\def\@authornote#1#2{%
  \ifx#1\@empty
  \else \textsuperscript{\footnotesize #1}%
  \fi

  \ifx#2\@empty
  \else
    \ifx\@onlyoneauthor\@empty
    \else \textsuperscript{\raisebox{-2pt}[0mm][0mm]{}}%作者加*
    \fi
  \fi
}

\def\@enauthornote#1#2{%
  \ifx#1\@empty
  \else \textsuperscript{#1}%
  \fi

  \ifx#2\@empty
  \else
    \ifx\@onlyoneauthor\@empty
    \else \textsuperscript{\raisebox{-2pt}[0mm][0mm]{}}%作者加*
    \fi
  \fi
}

\def\@address{}
\newcommand*{\address}[2][]{
    \def\@addressnote{#1}
  \ifx\@address\@empty
    \ifx\@addressnote\@empty
        \def\@address{#2}
    \else
        \def\@address{#1~#2}
    \fi
  \else
    \ifx\@addressnote\@empty
        \expandafter\def\expandafter\@address\expandafter
        {\@address\\{#2}}
    \else
        \expandafter\def\expandafter\@address\expandafter
        {\@address\\{#1~#2}}
    \fi
  \fi}


\def\@enaddress{}
\newcommand*{\enaddress}[2][]{
    \def\@enaddressnote{#1}
  \ifx \@enaddress\@empty
    \ifx\@enaddressnote\@empty
        \def\@enaddress{{\it #2}}
    \else
        \def\@enaddress{#1~{\it #2}}
    \fi
  \else
    \ifx\@enaddressnote\@empty
        \expandafter\def\expandafter\@enaddress\expandafter
        {\@enaddress;\\{\it #2}}
    \else
        \expandafter\def\expandafter\@enaddress\expandafter
        {\@enaddress;\\{#1~{\it #2}}}
    \fi
  \fi}



\renewcommand\maketitle{
    %首页页眉页脚
   \begin{picture}(0,0)
    \ifx\@Luntan\@empty\else
        \put(-21,17){\makebox[118truemm][r]{\heiti\zihao{-5}\@Luntan}}
        \put(-21,-140){\makebox[160truemm][r]{\vbox{\hbox{\includegraphics{kxjslt.eps}}}}}
    \fi
        \put(-21,35){\parbox[c]{120mm}{\jiuhao 中国科学: 数学~~评审中稿件\hspace{5mm}\@Year\,\hspace{3mm}\,\@Vol\,\hspace{3mm}\,\@No\,\,\;}}
        \put(-21,29){\thicklines\line(1,0){335}}
        \put(-21,17){\parbox[c]{120mm}{\zihao{-5} SCIENTIA SINICA~\,\,Mathematica}}
        \put(-21,17){\makebox[160truemm][r]{\includegraphics{SB-F.eps}}}
        \put(-21,-9){\makebox[160truemm][r]{\href{http://crossmark.crossref.org/dialog/?doi=\@DOI}{\includegraphics{Print-CrossMark.eps}}}}

        \ifx\@SpecialTopic\@empty
        \ifx\@ArticleType\@empty\else
            \put(-21,-2){\colorbox[cmyk]{0,0,0,.3}{\heiti\zihao{-4}~~~\@ArticleType~~~}}
        \fi
        \else
        \ifx\@ArticleType\@empty
            \put(-21,-2){\colorbox[cmyk]{0,0,0,.3}{\heiti\zihao{-4}~~~\@SpecialTopic~~~}}
        \else
            %\put(-21,-2){\colorbox[cmyk]{0,0,0,.3}{\heiti\zihao{-4}~~~\@SpecialTopic~{\bf\sanhao\raisebox{2pt}{.}}~\@ArticleType~~~}}
            \put(-21,-2){{\colorbox[cmyk]{0,0,0,.3}{\heiti\zihao{-4}~~~\@SpecialTopic~~~}}\quad{\colorbox[cmyk]{0,0,0,.3}{\heiti\zihao{-4}~~~\@ArticleType~~~}}}
        \fi
        \fi
        \put(-21,-610){\fcolorbox[rgb]{0,0,0}{0.8,0.8,0.8}{\parbox[t]{141.5truemm{\bf\scriptsize 英文引用格式:\ }}%141.5truemm调英文引用格式灰色条的长度
        {\scriptsize %\@AuthorCitation. \@titlecitation. 中国科学: 数学, \@Year, \@Vol: \@BeginPage--\lastpage, doi: \href{http://doi.org/\@DOI}{\@DOI}\\
        \@enAuthorCitation. \@entitlecitation~(in Chinese). Sci Sin Math, \@Year, \@Vol: \@BeginPage--\lastpage, doi: \href{http://doi.org/\@DOI}{\@DOI}}}}
        \put(-21,-641.3){\makebox[160truemm][l]{\scriptsize\bf$\copyright$~2023~《中国科学》杂志社}}
        \put(-21,-641.3){\makebox[160truemm][r]{\scriptsize\bf\@website}}%
    \end{picture}

    \renewcommand\thefootnote{\@fnsymbol\c@footnote}
    \def\@makefnmark{\hbox{\@textsuperscript{\normalfont\@thefnmark}}}
    \long\def\@makefntext##1{\noindent\@textsuperscript{\normalfont\@thefnmark}##1}
    \@maketitle
    \thispagestyle{empty}
    \long\def\@makefntext##1{\indent\hbox{\hss{\@thefnmark)\ }}\baselineskip 10pt ##1}
    \def\@makefnmark{\hbox\textsuperscript{\@thefnmark)}}

    \renewcommand\thefootnote{\arabic{footnote}}
    \setcounter{footnote}{0}
    \setcounter{page}{\@BeginPage}
    \textwidth=160truemm\textheight=219truemm

\numberwithin{equation}{section}



}



\def\@maketitle{
  \noindent
    \vspace{6truemm}
    \begin{flushleft}
        %标题
        \renewcommand{\baselinestretch}{1.06}
        \@title\\
        {\normalfont\wuhao\kaishu \@SubTitle}
    \end{flushleft}
    %\vspace{-3mm}
    \vskip 4 true mm
    \begin{flushleft}
        %作者
        \renewcommand{\baselinestretch}{1.21}
        {\rmfamily\Large\kaishu\zihao{4}\begin{tabular}[t]{@{}l@{}}\@author\end{tabular}}
    \end{flushleft}
    \vspace{-5mm}
    \begin{flushleft}
        \renewcommand{\baselinestretch}{1.35}
        \rmfamily\footnotesize\songti\zihao{6}
        %单位
        \@address\\
        %email

            \ifx\@onlyoneauthor\@empty
            E-mail: \href{mailto:\@authoremaillist}{\@authoremaillist}
        \else
            E-mail: \href{mailto:\@authoremaillist}{\@authoremaillist}
        \fi
        %其他信息
        \ifx\@comment\@empty
        \else\\\@comment
        \fi
    \end{flushleft}
    \vspace{-2mm}
    \begin{flushleft}
        \renewcommand{\baselinestretch}{1.2}
        \rmfamily\footnotesize\songti\zihao{6}
        %日期
        收稿日期: \@ReceiveDate;\ \ 接受日期: \@AcceptDate
        %%\ifx\@OnlineDate\@empty
%%        \else;\ \ 网络出版日期: \@OnlineDate;\ \   *~通信作者
%%        \fi
        \ifx\@onlyoneauthor\@empty
        ;\ \ 网络出版日期: \@OnlineDate
        \else;\ \ 网络出版日期: \@OnlineDate;\ \   *~通信作者
        \fi
        %资助
        \ifx\@Foundation\@empty
        \else\\\@Foundation
        \fi
    \end{flushleft}
    \vspace{-3mm}


  %摘要和关键词
  \ifx\@abstract\@empty
  \else
  \begin{picture}(0,0){\put(-22,0){\color[rgb]{0.4,0.4,0.4}\line(1,0){456}}}\end{picture}
  \vskip2.3mm\noindent\hspace*{-2.8mm}
  \noindent
  \begin{tabular}{p{1.0\textwidth}!{\color[gray]{0.4}}}
    {\heiti 摘要\quad}\ignorespaces\fangsong\@abstract\vspace{1.5mm}\\
    \xiaowuhao{\heiti 关键词\quad} \ignorespaces\fangsong\@keywords\\
    \xiaowuhao{\heiti\bf MSC (2020) 主题分类\quad} \ignorespaces\fangsong\@MSC
  \end{tabular}
  \begin{picture}(0,0){\put(0,-5){\color[rgb]{0.4,0.4,0.4}\line(1,0){456}}}\end{picture}
  \fi
}

\def\makeentitle{
    \begin{flushleft}
        %英文标题
        \vspace{12mm}
        \renewcommand{\baselinestretch}{0.85}
        \bfseries\xiaosanhao\@entitle
    \end{flushleft}
    \begin{flushleft}
        %英文作者
        \renewcommand{\baselinestretch}{0.9}
        \normalsize\sf
        \begin{tabular}[t]{@{}l@{}}\@enauthor\end{tabular}
    \end{flushleft}
    %%\begin{flushleft}
%%        \renewcommand{\baselinestretch}{0.7}
%%        \bahao
%%        %英文单位
%%        %\@enaddress
%%        %email
%%       %% \ifx\@onlyoneauthor\@empty
%%%%            \\E-mail: \@authoremaillist
%%%%        \else
%%%%            \\*E-mail: \@authoremaillist
%%%%        \fi
%%        %其他信息
%%        \ifx\@encomment\@empty
%%        \else
%%            \\\@encomment
%%        \fi
%%    \end{flushleft}
    %英文摘要关键词
    \vspace{-5mm}
    \ifx\@enabstract\@empty
    \else
    \noindent\hspace*{-2.9mm}
    \begin{tabular}{p{\textwidth}}
    \renewcommand{\baselinestretch}{0.7}
    \bahao
    \textbf{Abstract}\quad\@enabstract\\
    \footnotesize\textbf{Keywords\hspace{2mm} \@enkeywords}

   \vspace{1mm} \footnotesize\textbf{MSC(2020)\hspace{2mm} \@enMSC}

    \vspace{1mm}\footnotesize\textbf{doi:\ \@DOI}
    \end{tabular}
    \fi
}




\let\@authorcount\@empty
\newcommand*{\authorcv}[3][]{
    \def\@authorphoto{#1}
    \ifx\@authorcount\@empty
        \noindent
        \begin{tabular*}{\textwidth}{l}
            \hspace*{-1em}
            \begin{minipage}[t]{0.48\textwidth}
                \renewcommand{\baselinestretch}{1}
                \baselineskip 9pt
                \parindent=9pt
                \ifx\@authorphoto\@empty
                \else \parpic{\includegraphics[width=25mm]{#1}}
                \fi
                {\noindent\qihao{\bf #2}~#3\par}
            \end{minipage}
        \def\@authorcount{1}
    \else
            \begin{minipage}[t]{0.48\textwidth}
                \renewcommand{\baselinestretch}{1}
                \baselineskip 9pt
                \parindent=9pt
                \ifx\@authorphoto\@empty
                \else \parpic{\includegraphics[width=25mm]{#1}}
                \fi
                {\noindent\qihao{\bf #2}~#3\par}
            \end{minipage}
        \end{tabular*}
        \let\@authorcount\@empty
    \fi
}

%----------------------- Running heads ---------------------------------
\def\ps@myheadings{

    \def\@evenhead{\hspace{-1mm}
        \vbox{\hbox to \textwidth{\rmfamily\small\songti\zihao{-5}
        \@AuthorMark: \@titlehead \hfill}\vspace{1.5truemm}
        \hrule depth 0pt height 0.25truemm width\textwidth}}
    \def\@evenfoot{
        \vbox{\hbox to\textwidth{\footnotesize\rm\hbox to 1cm {\songti\rm\zihao{-5}\small
        \thepage
        \hfill} \hfill \hfill}}}

    \def\@oddhead{\hspace{-2mm}
        \vbox{\hbox to\textwidth{\rmfamily\small\songti\zihao{-5} \hfill
        中国科学: 数学~~评审中稿件\hspace{3mm}~\@Vol~\hspace{3mm}~\@No~}\vspace{1.5truemm}
        \hrule depth 0pt height 0.25truemm width\textwidth}}
    \def\@oddfoot{\vbox{\hbox to \textwidth{\hfill\hbox to 1cm{\hfill\songti\rm\zihao{-5}\small\hspace{2mm}
        \thepage
        }}}}
    \thispagestyle{fancy}\fancyfoot{}
}
\pagestyle{myheadings}



%-------------------------- Sections ----------------------------------
\newcommand*\Acknowledgements[1]{
    \vskip 3mm
    \baselineskip 12pt \renewcommand{\baselinestretch}{1.18}
    {\xiaowuhao\noindent\textbf{致谢}{\kaishu\quad#1}}\par
}

\newcommand*\Supplements[1]{
    \vskip 5mm
    \baselineskip 16pt
    {\textbf{补充材料}\quad{\fangsong#1~本文的补充材料见网络版infocn.scichina.com.
    补充材料为作者提供的原始数据, 作者对其学术质量和内容负责.}}\par
}

\ctexset{section={format={\raggedright\normalfont\large\bfseries\zihao{-4}}}}
\ctexset{subsection={format={\raggedright\normalfont\normalsize\bfseries}}}
\ctexset{subsubsection={format={\raggedright\normalfont\normalsize\bfseries}}}

% \renewcommand\sectionname{\thesection}
% \renewcommand\sectionformat{}
% \renewcommand\section{
%     \@startsection{section}{1}{\z@}%
%     {-4.5ex \@plus -1ex \@minus -.2ex}%
%     {2.5ex \@plus.1ex}%
%     {\normalfont\large\bfseries\zihao{-4}}
% }

% \renewcommand\subsection{
%     \@startsection{subsection}{2}{\z@}%
%     {-2ex\@plus -2ex \@minus -.1ex}%
%     {2ex \@plus .2ex}%
%     {\normalfont\normalsize\bfseries}
% }

% \renewcommand\subsubsection{
%     \@startsection{subsubsection}{3}{\z@}%
%     {-3ex\@plus -1ex \@minus -.1ex}%
%     {1ex \@plus .1ex}%
%     {\normalfont\normalsize\bfseries}
% }

%%\renewenvironment{proof}[1][\proofname]{\par
%%  \pushQED{\qed}%
%%  \normalfont \topsep3\p@\@plus3\p@\relax
%%  \trivlist
%%  \item[\hskip\labelsep
%%        \itshape
%%    #1\@addpunct{.}]\ignorespaces
%%}{%
%%  \popQED\endtrivlist\@endpefalse
%%}


\let\oldappendix\appendix
\renewenvironment{appendix}{
     \hspace{10mm}\oldappendix
    \setcounter{section}{0}
    \def\thesection{\Alph{section}}
    \renewcommand{\theequation}{\Alph{section}\arabic{equation}}
    \renewcommand{\thefigure}{\Alph{section}\arabic{figure}}
    \renewcommand{\thetable}{\Alph{section}\arabic{table}}
    \renewcommand{\thealgorithm}{\Alph{section}\arabic{algorithm}}
    \renewcommand{\section}{
        \setcounter{equation}{0}
        \setcounter{table}{0}
        \setcounter{figure}{0}
        \setcounter{algorithm}{0}
        \@startsection{section}{1}{\z@}%
        {-2ex\@plus -2ex \@minus -.1ex}%
        {2ex \@plus .2ex}%
        {\normalfont\large\bfseries\heiti\zihao{-4}}%\normalfont\normalsize\bfseries}
    }
\renewcommand{\baselinestretch}{0.98}
%\renewcommand{\arraystretch}{0.5}
   \wuhao% \footnotesize


}

\newenvironment{supplement}{
    \newpage
    \oldappendix
    \setcounter{page}{1}
    \setcounter{section}{0}
    \setcounter{equation}{0}
    \setcounter{table}{0}
    \setcounter{figure}{0}
    \setcounter{algorithm}{0}
    \def\sectionname{补充材料(\thesection)}
    \def\thesection{\Roman{section}}
    \renewcommand{\theequation}{S\arabic{equation}}
    \renewcommand{\thefigure}{S\arabic{figure}}
    \renewcommand{\thetable}{S\arabic{table}}
    \renewcommand{\thealgorithm}{S\arabic{algorithm}}
    \renewcommand{\section}{
        \@startsection{section}{1}{\z@}%
        {-2ex\@plus -2ex \@minus -.1ex}%
        {2ex \@plus .2ex}%
        {\normalfont\normalsize\bfseries}
    }
    \footnotesize
}

%-------------------------- Bibliography ------------------------------
\def\@biblabel#1{#1~}

\renewenvironment{thebibliography}[1]{
    \vspace{6mm}\noindent
    \parbox[c]{20mm}{\heiti\zihao{5}参考文献}
    \hspace{-6mm}
    \rule[0.01\baselineskip]{0.9\textwidth}{0.5pt}
    \vskip0.1in \baselineskip 11.5pt \vspace{-4mm}
    \list{\@biblabel{\@arabic\c@enumiv}}{
        \settowidth\labelwidth{\@biblabel{#1}}%
        \leftmargin\labelwidth
        \advance\leftmargin\labelsep
        \@openbib@code
        \usecounter{enumiv}%
        \let\p@enumiv\@empty
        \renewcommand\theenumiv{\@arabic\c@enumiv}
    }
    \itemsep 0ex \parskip 0ex
    \footnotesize\sloppy
}

%\newcommand{\upcite}[1]{$^{\mbox{\scriptsize \cite{#1}}}$}
\usepackage{cite}
\newcommand{\upcite}[1]{\!\textsuperscript{\cite{#1}}}
%\def\@citess#1{\textsuperscript{\color{blue}[#1]}}%

\let\citedash\relax
\providecommand{\citedash}{\color{blue}--\penalty\@m}
\makeatletter

%%%%参考文献引用括号颜色\color{black}
\def\@cite#1#2{{\color{blue}[{#1\if@tempswa , #2\fi}]}}
%\def\@cite#1#2{\textsuperscript{\color{blue}[{#1\if@tempswa , #2\fi}]}}

%%%%公式序号颜色\color{black}

\let\reftagform@=\tagform@
\def\tagform@#1{\maketag@@@{\textcolor{blue}{(\ignorespaces{#1}\unskip\@@italiccorr)}}}





\makeatother

\renewcommand{\UrlFont}{\selectfont} %使用\url{}使参文中的url自动断行



\RequirePackage{cleveref}%图表序号多个1－3

  %\PackageInfo{cleveref}{loaded `english' language definitions}
  \AtBeginDocument{
\renewcommand{\crefrangeconjunction}{--}%连续数字1－3
%\renewcommand{\crefpairconjunction}{-}%数字1和2


\renewcommand{\crefpairconjunction}{ {\color{black}and}~}
      \renewcommand{\creflastconjunction}{ {\color{black}and}~}%
      \renewcommand{\crefpairgroupconjunction}{ {\color{black}and}~}%
      \renewcommand{\creflastgroupconjunction}{{\color{black}, and}~}%



%\renewcommand{\crefpairconjunction}{{\color{black},} }
 %\renewcommand{\crefpairgroupconjunction}{ \color{black}and~}


\crefname{table}{\color{blue}表}{\color{blue}表}%%%表格序号颜色black
\crefname{figure}{\color{blue}图}{\color{blue}图}%%%图题字颜色black
\crefname{equation}{\color{blue}eq.}{\color{blue}eqs.}%公式序号题字颜色black
\Crefname{equation}{\color{blue}Eq.}{\color{blue}Eqs.}
\crefname{section}{\color{blue}第}{\color{blue}第}%小标题字颜色black
\Crefname{section}{\color{blue}第}{\color{blue}第}%小标题字颜色black
 }


%------------------ Figures, tables, algorithms -----------------------

\setlength{\floatsep}{16pt plus 1pt minus 1pt}%页面顶部/底部的浮动对象间的垂直距离, 缺省为12pt plus 2pt minus 2pt
\setlength{\textfloatsep}{16pt plus 1pt minus 1pt}%页顶部/底部的浮动对象与文本间垂直距离, 缺省20pt plus 2pt minus 4pt
\setlength{\intextsep}{12pt plus 3pt minus 2pt}%页中浮动对象与上下方文本间垂直距离, 缺省12pt plus 2pt minus 2pt
\setlength{\belowrulesep}{0pt}%横线和其下文字的间距
\setlength{\aboverulesep}{0pt}%横线和其上文字的间距
\setlength{\doublerulesep}{0.4pt}
\newcommand\Times{\fontfamily{ptm}\selectfont}
\newcommand{\picsize}{\fontsize{8pt}{0.4\baselineskip}\selectfont}
\usepackage[bf,footnotesize,labelsep=quad]{caption}
\captionsetup[subfloat]{labelformat=simple,skip=0pt}
\captionsetup[table]{aboveskip=1mm}
\captionsetup[figure]{aboveskip=3mm}
\captionsetup[algorithm]{font=footnotesize}
\floatname{algorithm}{算法}

\renewcommand{\captionlabelfont}{\footnotesize \bfseries\color{blue}}%%(11月注释：小号黑体标题编号)
\newcommand*{\cnfigurename}{图}
\newcommand*{\enfigurename}{Figure}
\newcommand*{\cnenfigcaption}[2]{%
    \def\figurename{\cnfigurename}
    \caption{\baselineskip 10pt\bahao\bf #1}
 %   \addtocounter{figure}{-1}
    \vspace*{-3mm}
 %   \def\figurename{\enfigurename}
%    \caption{\baselineskip 10pt #2}
}

\newcommand*{\cntablename}{表}
\newcommand*{\entablename}{Table}
\newcommand*{\cnentablecaption}[2]{%
    \def\tablename{\cntablename}
    \caption{\baselineskip 10pt\bahao\bf #1}
    %\addtocounter{table}{-1}
    \vspace*{-1mm}
  %  \def\tablename{\entablename}
 %   \caption{\baselineskip 10pt #2}
}


%------------------------------ Math ----------------------------------
\def\leq{\leqslant}
\def\geq{\geqslant}
\def\le{\leqslant}
\def\ge{\geqslant}
\abovedisplayskip=11pt plus 0pt minus 6pt
\belowdisplayskip=11pt plus 0pt minus 6pt
\newcommand{\set}[1]{\ensuremath{\left\{ #1 \right\}}}%
\newcommand{\Set}[2]{\ensuremath{\left\{ #1 \left| \right. #2 \right\}}}%
\newcommand{\abs}[1]{\ensuremath{\left| #1 \right|}}%
\newcommand{\map}[3]{\ensuremath{#1 : #2 \rightarrow #3}}%
\newcommand{\C}[1]{\ensuremath{\mathcal{#1}}}%
\newcommand{\restrict}[2]{\ensuremath{#1 \left|_{#2}\right.}}%
\newcommand{\NN}{\mathbb{N}^0}
\newcommand{\PN}{\mathbb{N}}
\newcommand{\syn}{\mathbf{S}}
\newcommand{\Syn}{\mathbf{M}}
\allowdisplaybreaks
\setlength{\arraycolsep}{2.0pt}

%----------------------------- Theorems -------------------------------
%\def\proof{{\heiti 证明}\quad}
%\def\th#1{{\bf\heiti\zihao{5} #1}\quad} %通用形式
%\usepackage[amsmath,thref,thmmarks]{ntheorem}
%\renewcommand{\qedsymbol}{} %去掉小方框
%\renewcommand*{\qedsymbol}{[证毕]}
%\usepackage[thmmarks]{ntheorem}
%\newtheoremstyle{mythm}
\newtheoremstyle{newdefinition}%
    {0pt}% Space above
    {0pt}% Space below%0.2em
    {\normalfont}% Body font
    {2em}% Indent amount
    {\bfseries}% Theorem head font
    {}% Punctuation after theorem head
    {1.5em}% Space after theorem head%10pt plus 1pt minus 1pt
    {}% Theorem head spec (can be left empty, meaning `normal')





\makeatletter% amsthm: get rid of \itshape and \@addpunct{.}
\renewenvironment{proof}[1][\proofname]{\par%
\pushQED{\qed}%
\normalfont \topsep0\p@\@plus0\p@\relax%
\trivlist%
\item[\hskip\labelsep%
#1]\ignorespaces%
}{%
\popQED\endtrivlist\@endpefalse%
}
\renewcommand{\proofname}{\hspace{0.3mm}\qquad{\heiti{证明}}\hspace{0.7em}}
\makeatother



%\def\endproof{\hspace*{\fill}~\QED\par\endtrivlist\unskip}


\iffalse
\makeatletter
\renewcommand\normalsize{%
   \@setfontsize\normalsize\@xpt\@xiipt
   \abovedisplayskip 9\p@ \@plus4\p@ \@minus5\p@
   \abovedisplayshortskip \z@ \@plus3\p@
   \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
   \belowdisplayskip  \abovedisplayskip
   \let\@listi\@listI}
\makeatother
\fi

%--------------------------------- list ---------------------------------
\renewenvironment{itemize}{
\begin{list}{$\bullet$}{
\labelwidth=4em
\labelsep=0.5em
\leftmargin=0em
\rightmargin=0em
\parsep=\parskip
\itemsep=0em
\topsep=0em
\itemindent=2.1em
}
}{\end{list}}

\endinput
