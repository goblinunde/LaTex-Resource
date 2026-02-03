\def\fileversion{1.0}
\def\filedate{2024/8/30}

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{TransBook}[\filedate\space Version \fileversion\space by
 MA WEI JIAN]
 
 % 文档类支持以下宏包选项:
 
 % adobe 使用adobe字体
 % ubuntu 使用ubuntu字体
 % windows 使用windows字体
 % fandol 使用fandol字体，随texlive默认安装
 % mac 使用mac字体
 % list 以列表项目格式显示试题

\newcommand\@fontset{windows}
\DeclareOption{adobe}{\renewcommand\@fontset{adobe}}
\DeclareOption{ubuntu}{\renewcommand\@fontset{ubuntu}}
\DeclareOption{mac}{\renewcommand\@fontset{mac}}
\DeclareOption{windows}{\renewcommand\@fontset{windows}}
\DeclareOption{fandol}{\renewcommand\@fontset{fandol}}



\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass{article}

\RequirePackage[fontset = \@fontset, punct=kaiming]{ctex}
\RequirePackage{xcolor} % 彩色、图片、图释
\RequirePackage{geometry,fancyhdr} % 纸张、边距、页眉、页脚
\RequirePackage{lipsum}
\RequirePackage[fontsize=14pt]{fontsize}
\RequirePackage{calc} % 引入 calc 包
\RequirePackage{setspace} % 引入 setspace 包
\RequirePackage{tikz} % 引入 tikz 包
\RequirePackage{sidenotes}
\RequirePackage{tcolorbox}
\RequirePackage{titletoc} % 目录
\RequirePackage{titlesec} % 标题
\RequirePackage{pifont} % 标题
\RequirePackage{ifthen}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage} % 添加 lastpage 包
\RequirePackage{tcolorbox}
\RequirePackage{fontspec}
\RequirePackage{hyperref}

\hypersetup {colorlinks=true,linkcolor=black, urlcolor=themeColor, citecolor=red}


% \setmainfont{Times New Roman} % 设置全局英文字体为 Times New Roman
\geometry{a4paper, left=18mm, right=60mm, top=25mm, bottom=20mm, headsep=5mm}   

\setstretch{1.8} % 设置全局行间距为 1.5 倍
\setlength{\parindent}{0pt}

\newcounter{ParagraphCounter}
\newcounter{SentenceCounter}

\newif\if@resetcounter
\@resetcounterfalse

\newcommand{\trinum}[2][pcolor]{% 定义命令，#1 是底色，#2 是数字
    \tikz[baseline]{\node[fill=#1, text=white, rounded corners=1mm, inner sep=2pt, yshift=1.5mm](n) {#2};}
}

% 定义段落环境
\newenvironment{Paragraph}[1][]
{%
    \@tfor \@opt :=#1\do
        {\if\@opt r \global\@resetcountertrue\fi}
    \if@resetcounter 
        \setcounter{SentenceCounter}{0}
    \fi
    \stepcounter{ParagraphCounter}
    
    \trinum{\fontsize{10pt}{0}{\heiti{第\chinese{ParagraphCounter}段}}}
    
% \setmainfont{Times New Roman} % 设置全局英文字体为 Times New Roman

}{%

}

\newcommand{\circlednum}[2][scolor]{% 定义命令，#1 是底色，#2 是数字
  \tikz[baseline]{
    \node[shape=circle,font=\fontsize{10pt}{12pt}\selectfont, fill=#1, draw=white, inner sep=2pt, yshift=1.8mm] (char) {\color{white}{#2}};
  }%
}

\newlength{\sentenceLength}

\newfontface\myfont{Times New Roman}

% 定义句子命令
\newcommand\Sentence[1]{%
    \stepcounter{SentenceCounter}
    \begin{spacing}{1.3} % 设置行间距为 1.5 倍
    \noindent % 取消段落缩进
    \circlednum[scolor]{\arabic{SentenceCounter}} \begingroup \myfont #1  \endgroup
    \end{spacing}
    \par
    \vspace*{0.5cm}
    \settowidth{\sentenceLength}{\arabic{SentenceCounter}.\quad #1} % 计算句子的长度
    \noindent\textcolor{black}{\rule[0.5ex]{\linewidth}{0.8pt}} % 添加可调节粗细的空白下划线
    \par
    \@tempdimb=\dimexpr\sentenceLength\relax 
    \@tempcnta=\numexpr\@tempdimb/\linewidth\relax
    \advance\@tempcnta by 1 
    \loop
        \noindent\textcolor{black}{\rule[0.5ex]{\linewidth}{0.8pt}} % 添加整行的可调节粗细的空白下划线
        \par
        \advance\@tempcnta by -1
    \ifnum\@tempcnta>1
    \repeat

    \@tempdimb=\dimexpr\sentenceLength\relax 
    \@tempcnta=\numexpr\@tempdimb/\linewidth\relax
    \advance\@tempcnta by 1 
}

% 定义绘制竖直虚线的命令
% \newcommand{\drawRightMarginLine}{
%     \begin{tikzpicture}[remember picture, overlay]
%         \draw[dashed] (current page.north east) ++(-55mm,\topmargin) -- ++(0,-\textheight);
%     \end{tikzpicture}
% }

\definecolor{themeColor}{HTML}{E15715} % 自定义颜色 蓝色
\definecolor{scolor}{HTML}{61589B} % 自定义颜色 蓝色
\definecolor{pcolor}{HTML}{38558F} % 自定义颜色 蓝色

% 定义绘制矩形的命令
\newcommand{\drawSidebarRectangle}{
\ifthenelse{\equal{\thepage}{\pageref{TOC}}}{}{
        
    \begin{tikzpicture}[remember picture, overlay]
        % % 在页面右侧绘制一个矩形
        % \draw[fill=themeColor!7, draw=themeColor, rounded corners=6pt, dashed] 
        %     (current page.north east) ++(-5.4cm,\topmargin) rectangle ++(\textwidth/3.6,-\textheight);
        \draw[fill=themeColor!6.2, 
              top color=themeColor!7, % 顶部颜色
              bottom color=themeColor!7, % 底部颜色
              right color=themeColor!7, % 右侧颜色
              left color=themeColor!7, % 左侧颜色
              draw=none, % 不绘制默认边框
              ]  
            (current page.north east) ++(-5.4cm,-2.5cm) rectangle ++(\textwidth/2.4,-\textheight);
        % 仅绘制左侧边
        \draw[themeColor, line width=1.5pt] (current page.north east) ++(-5.4cm, -2.5cm) -- ++(0,-\textheight);
        % 在矩形上方添加文字
        \node[anchor=north east, xshift=-3.0cm, yshift=-2.7cm,align=center] at (current page.north east) {\heiti \color{themeColor}\fontsize{10pt}{0}{\ding{45} 词汇手记}};
        \node[anchor=south west, xshift=-5.6cm, yshift=0.9cm,align=center] at (current page.south east) {\trinum[themeColor]{\heiti \leftmark}};
        \node[anchor=south west, xshift=-5.6cm, yshift=0.4cm,align=center] at (current page.south east) {\trinum[themeColor]{\heiti \rightmark}};
    \end{tikzpicture}

    \begin{tikzpicture}[remember picture, overlay]
        % % 在页面右侧绘制一个矩形
        % \draw[fill=themeColor!7, draw=themeColor, rounded corners=6pt, dashed] 
        %     (current page.north east) ++(-5.4cm,\topmargin) rectangle ++(\textwidth/3.6,-\textheight);
        \draw[fill=themeColor!6.2, 
              draw=none, % 不绘制默认边框
              ]  
            (current page.south west) ++(0cm,2cm) rectangle ++(0.8cm,2.4cm);
        \node[anchor=south west, xshift=0.8cm, yshift=2.25cm,align=center, rotate=90] at (current page.south west) {\heiti \color{white}研小布};
    \end{tikzpicture}
    }
}


% 配置 fancyhdr
\pagestyle{fancy}
\fancyhf{}  % 清除所有页眉页脚内容
% 自定义 \section 标题在目录中的样式

\titlecontents{section}[0em]
{\setcounter{ParagraphCounter}{0}\heiti\myfont}
{}
{}
{\titlerule*[0.4pc]{.}\contentspage}

\titlecontents{subsection}[2em]
{\bfseries\myfont}
{}
{}
{\titlerule*[0.4pc]{.}\contentspage}

\titlecontents{subsubsection}[4em]
{}
{}
{}
{\titlerule*[0.4pc]{.}\contentspage}

\titlespacing{\section}
{0pt} % 左边距
{2pt plus 2pt minus 2pt} % 上边距
{4pt plus 2pt minus 2pt} % 下边距

\titlespacing{\subsection}
{0pt} % 左边距
{2pt plus 2pt minus 2pt} % 上边距
{2pt plus 2pt minus 2pt} % 下边距

% 定制 \section 和 \subsection 格式，不显示编号
% \titleformat{\section}[block]{\normalfont\bfseries}{\thesection}{1em}{}
% \titleformat{\subsection}[block]{\normalfont\bfseries}{\thesubsection}{1em}{}


% 自定义 \section 标题样式
\titleformat{\section}[block]
{\newpage \centering\heiti\normalsize\myfont}
{}
{0em}
{} % 居中、字体和大小，每一个section都重启一页

% 自定义 \subsection 标题样式
\titleformat{\subsection}
{\myfont\normalsize\bfseries\centering} % 字体和大小
{} % 标题编号
{0em} % 与标题编号的间距
{} % 标题之后的间距
\renewcommand{\sectionmark}[1]{\markboth{\heiti \fontsize{10}{0}{\textbf{#1}}}{}}
\renewcommand{\subsectionmark}[1]{\markright{\fontsize{10}{0}{\textbf{#1}}}{}}
% 清除原有页码
\pagenumbering{gobble}  % 禁用默认页码

% 启用页码显示（如果需要）
\pagenumbering{arabic}


\fancyfoot[L]{\myfont\thepage/\pageref{LastPage}}  % 将页码放置在页面底部居中
\fancyfoot[C]{\fontsize{10pt}{4pt}{\kaishu 此手译本由公众号【研小布】排版制作}}  % 将页码放置在页面底部居中
% 去除页眉横线
\renewcommand{\headrulewidth}{0pt} 
% 去除页脚横线
\renewcommand{\footrulewidth}{0pt} 
 
% 在页面布局中调用绘制竖直虚线的命令
% \AddToHook{shipout/background}{\drawRightMarginLine}
% 在页面布局中调用绘制矩形的命令
\AddToHook{shipout/background}{\drawSidebarRectangle}