\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\RequirePackage{expl3}
\ProvidesExplClass {J_Jmath} {2024-03-29} {v0.0.1} {LaTeX template for Journal of Mathematics}

% 检查 LaTeX2e kernel 版本
\msg_new:nnn { J_Jmath } { latex-too-old }
  { TeX~ Live~ 2020~ or~ later~ version~ is~ required~ to~ compile~ this~ document. }
\@ifl@t@r \fmtversion { 2020/02/02 }
  { }
  { \msg_fatal:nn { J_Jmath } { latex-too-old } }

% 检查编译引擎，要求使用 XeLaTeX。
\msg_new:nnn { J_Jmath } { incompatible-engine }
  { XeLaTeX~ is~ required~ to~ compile~ this~ document. }

\sys_if_engine_xetex:F
  { \msg_fatal:nn { J_Jmath } { incompatible-engine } }


% 使用 l3keys 定义 \jmathsetup 配置命令
\NewDocumentCommand \jmathsetup { m }
  { \keys_set:nn { J_Jmath } {#1} }



% 加载文档类和宏包

% 处理文档类选项
\PassOptionsToClass 
  {
    UTF8 , 
    scheme = chinese,
    a4paper,
    11pt,
    % twoside
  } 
  { ctexart }
\DeclareOption* { \PassOptionsToClass { \CurrentOption } { ctexart } }
\ProcessOptions*

\RequirePackage { filehook }
\AtEndOfPackageFile* { fontspec }
  { \msg_redirect_name:nnn { fontspec } { no-script } { none } }
\AtEndOfPackageFile* { xeCJK }
  {
    \msg_redirect_name:nnn { xeCJK } { CJKfamily-redef } { none }
    \defaultCJKfontfeatures
      {
        Script  = CJK,
      }
  }

% 载入 \cls{ctexart} 文档类。
\LoadClass { ctexart }

% 要求 ctex v2.4.9 2017-04-01 或更高的版本。
\msg_new:nnn { J_Jmath } { require-package-version }
  { The~ package~ "#1"~ is~ required. }

\@ifclasslater { ctexart } { 2017/04/01 }
  { }
  {
    \msg_fatal:nnn { J_Jmath } { require-package-version }
      { ctex~ v2.4.9~ 2017-04-01 }
  }

% 建议在模板开始处载入全部宏包，不要轻易改变加载顺序。
\RequirePackage { etoolbox }
\RequirePackage { geometry }
\RequirePackage { fontspec }
\RequirePackage { xeCJK }
\RequirePackage { xeCJKfntef }
\RequirePackage { fancyhdr }
\RequirePackage { lastpage }
\RequirePackage { amsmath }
\RequirePackage { amsthm }
\RequirePackage { thmtools }
\RequirePackage { enumitem }
\RequirePackage { graphicx }


%%%%
% \headsep=0.5truecm \footskip 0pt \topmargin 0pt \oddsidemargin 0pt
% \evensidemargin 0pt \setlength{\textwidth}{14.8truecm}
% \setlength{\textheight}{21.5truecm}
%%%%
\geometry
  {
    verbose,
    headsep = 0.5truecm,
    footskip = 0pt,
    % topmargin = 0pt
    headheight = 0pt,
    % oddsidemarin = 0pt, evensidemargin = 0pt
    % lmargin = 0pt,
    % rmargin = 0pt,
    marginparwidth = 0pt,
    marginparsep = 0pt,
    textwidth = 14.8truecm,
    textheight = 21.5truecm,
  }


\pagestyle{fancy}
\fancyhf{}
\fancyfoot[c]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}


\renewcommand{\theequation}{\arabic{section}.\arabic{equation}}



\RequirePackage
  [
    % backref      = true,
    backend      = biber,
    bibstyle     = gb7714-2015,
    sorting      = nty,
    gbalign      = right,
    citestyle    = gb7714-CCNU,
    gbnamefmt    = givenahead,
    gbpunctin    = false
  ]{biblatex}



\ctexset
  {
    section = 
      {
        format+= \raggedright\large,
        aftername = {\space\space}
      }
  }

% 去掉.号，但只能通过新定义 style 的方式进行
\declaretheoremstyle
  [
    headpunct     = {},
    postheadspace = { 0.5em },
    headindent    = 2\ccwd
  ]
  { ccnustyle }
\cs_new:Npn \__ccnu_declare_theorem_with_counter_within:n #1
  {
    \declaretheorem
      [
        style = ccnustyle,
        name =  \clist_item:nn {#1} {1} ,
        refname = \clist_item:nn {#1} {2} ,
        within = \clist_item:nn {#1} {3} ,
      ]
      { \clist_item:nn {#1} {4} }
  }
\cs_new:Npn \__ccnu_declare_theorem_with_counter_sibling:n #1
  {
    \declaretheorem
      [
        style   = ccnustyle ,
        name    = \clist_item:nn {#1} {1} ,
        refname = \clist_item:nn {#1} {2} ,
        sibling = \clist_item:nn {#1} {3} ,
      ]
      { \clist_item:nn {#1} {4} }
  }


\declaretheorem
  [
    style = ccnustyle,
    name =  例,
    refname = 例 ,
  ]
  { example }
\declaretheorem
  [
    style = ccnustyle,
    name =  注,
    refname = 注 ,
    numbered = no
  ]
  { remark }

\clist_map_function:nN
  {
    { 定理, 定理, section, theorem },
    { 问题, 问题, section, question },
  }
  \__ccnu_declare_theorem_with_counter_within:n

\clist_map_function:nN
  {
    { 定义, 定义, theorem, definition },
    { 性质, 性质, theorem, property },
    { 命题, 命题, theorem, proposition },
    { 推论, 推论, theorem, corollary },
    { 引理, 引理, theorem, lemma },
    { 公理, 公理, theorem, axiom },
    { 反例, 反例, theorem, counterexample },
    { 猜想, 猜想, theorem, conjecture },
    { 断言, 断言, theorem, claim }
  }\__ccnu_declare_theorem_with_counter_sibling:n

\NewDocumentCommand { \ccnunewtheorem } { s O{} m m }
  {
    \IfBooleanTF {#1}
      {
        % 有*
        \declaretheorem
          [
            style = ccnustyle,
            name =  #3 ,
            refname = #3 ,
            numbered = no,
            #2
          ]
          { #4 }
      }
      {
        % 无*
        \declaretheorem
          [
            style = ccnustyle,
            name =  #3 ,
            refname = #3 ,
            #2
          ]
          { #4 }
      }
  }

% 重定义 proof 环境的样式
\RenewDocumentEnvironment { proof } { O{证} +b }
  {
    \par
    \pushQED { \qed }
    \normalfont \topsep6 \p@ \@plus6 \p@ \relax
    \trivlist
    \item \relax
    \group_begin:
      \hspace*{2\ccwd}
      \bfseries #1
    \group_end:
    \hspace \labelsep \ignorespaces
    #2
  }
  {
    \popQED \endtrivlist \@endpefalse
  }