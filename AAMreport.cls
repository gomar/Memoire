%% This is file `AAMreport.cls'
%%
%% Welcome to the CERFACS / AAM LaTeX package.
%%
%% For further details and support, read the Users Manual AAMreport.pdf.
%%
%% Description: LaTeX package for CERFACS / AAM reports 
%%
%%  `AAMreport.cls' - A LaTeX class to create CERFACS / AAM report
%%
%%  The basic approach is to load the LaTeX article class and various
%%  standard LaTeX packages.
%%
%%  To use, simply select this class file in your LaTeX document.  For example,
%%
%%    \documentclass{AAMreport}
%%
\NeedsTeXFormat{LaTeX2e}
\def\AAMversion{0.2}
\ProvidesClass{AAMreport}[2008/04/10 v0.2 CERFACS / AAM report]
\newif\if@aam@longreport
\newif\if@aam@hyperlink
\newif\if@aam@draft
\newif\if@aam@correction
\newif\if@aam@french
\newif\if@aam@confidential
\@aam@hyperlinkfalse
\@aam@draftfalse
\@aam@correctionfalse
\@aam@frenchtrue
\@aam@confidentialtrue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{long}%
 {\@aam@longreporttrue}
\DeclareOption{short}%
 {\@aam@longreportfalse}
\DeclareOption{notconfidential}%
 {\@aam@confidentialfalse}
\DeclareOption{draft}%
 {\@aam@drafttrue
   \ExecuteOptions{correction}
   \PassOptionsToPackage{draft}{graphicx}}
\DeclareOption{correction}%
 {\@aam@correctiontrue}
\DeclareOption{english}{%
  \@aam@frenchfalse}
\DeclareOption{hyperlink}{%
  \@aam@hyperlinktrue}
\ExecuteOptions{long}
\ProcessOptions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% classe de bases et packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% longreport
\if@aam@longreport
  \if@aam@draft
    \LoadClass[a4paper,twoside,11pt,draft,openright]{report}
  \else
    \LoadClass[a4paper,twoside,11pt,openright]{report}
  \fi
  \RequirePackage{titlesec}
%% short report
\else
  \if@aam@draft
    \LoadClass[a4paper,twoside,11pt,draft]{article}
  \else
    \LoadClass[a4paper,twoside,11pt]{article}
  \fi
\fi
% hyperlink
\if@aam@hyperlink
  \if@aam@draft
    \RequirePackage[draft]{hyperref} % hyperlinks
  \else
    \RequirePackage{hyperref} % hyperlinks
  \fi
  \hypersetup{colorlinks=true,bookmarksopen=true,%
    bookmarksnumbered=true,bookmarksopenlevel=1,pdfstartview=FitH}
\fi
%% draft
\if@aam@correction
  \RequirePackage{setspace}
  \if@aam@longreport
    \RequirePackage[reset,a4paper,twoside,vscale=0.75,hscale=0.65,hmarginratio=3:2,vmarginratio=1:1,headheight=18pt]{geometry}
  \else
    \RequirePackage[reset,a4paper,twoside,vscale=0.75,hscale=0.65,hmarginratio=1:1,vmarginratio=1:1,headheight=18pt]{geometry}
  \fi
\else
  \if@aam@longreport
    \RequirePackage[reset,a4paper,twoside,vscale=0.8,hscale=0.8,hmarginratio=3:2,vmarginratio=1:1,headheight=18pt]{geometry}
  \else
    \RequirePackage[reset,a4paper,twoside,vscale=0.8,hscale=0.8,hmarginratio=1:1,vmarginratio=1:1,headheight=18pt]{geometry}
  \fi
\fi
%% languages
\if@aam@french
  \RequirePackage[frenchb]{babel}
\else
  \RequirePackage{babel}
\fi
%% load packages
\RequirePackage[fleqn]{amsmath}
\RequirePackage{xspace}
\RequirePackage{graphicx}
\RequirePackage{url}
\RequirePackage{array}
\RequirePackage{fancyhdr}
\RequirePackage{textcomp}
\RequirePackage{lastpage}
\RequirePackage{tabularx}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Some language settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\if@aam@french
  \newcommand{\draftString}{BROUILLON}
  \newcommand{\confidentialString}{CONFIDENTIEL}
  \newcommand{\history}{Historique}
  \newcommand{\cause}{\bf Cause et/ou nature de l'\'evolution}
  \newcommand{\quality}{\bf Qualit\'e}
  \newcommand{\function}{\bf Fonction}
  \newcommand{\name}{\bf Nom}
  \newcommand{\merci}{Remerciements}
\else
  \newcommand{\confidentialString}{CONFIDENTIAL}
  \newcommand{\draftString}{DRAFT}
  \newcommand{\history}{\bf History}
  \newcommand{\cause}{\bf Cause and/or nature of evolution}
  \newcommand{\quality}{\bf Quality}
  \newcommand{\function}{\bf Function}
  \newcommand{\name}{\bf Name}
  \newcommand{\merci}{Acknowledgments}
\fi
\newcommand{\visa}{visa}
\newcommand{\diffusion}{Diffusion}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% New column type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcolumntype{C}{>{\centering\arraybackslash}X}
\newcolumntype{R}{>{\raggedleft\arraybackslash}X}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% titlepage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\global\newsavebox{\@aamType}\savebox{\@aamType}{\mbox{}}
\global\newsavebox{\@aamRef}\savebox{\@aamRef}{\mbox{}}
\newcommand{\AAMtype}[1]{\savebox{\@aamType}{\setlength{\tabcolsep}{0pt}\Large
    \begin{tabular}{r}
      #1
    \end{tabular}}}
\newcommand{\AAMreference}[1]{\savebox{\@aamRef}{#1}}

\renewcommand\maketitle{%
\newlength{\rightmarg}\setlength{\rightmarg}{.5cm}
\vspace*{-25mm}\par
\noindent\begin{tabularx}{\textwidth}{XCR}
\includegraphics[width=.2\textwidth]{logo_aam_color_petit} &
\if@aam@confidential
  \hfill {\Large\bf\confidentialString}
\fi
& \usebox{\@aamRef}
\end{tabularx}
\hrule
\thispagestyle{empty}
\enlargethispage{5\baselineskip}
\renewcommand{\and}{\\}  % {\vskip 4pt}
\vspace{6cm}\par
\noindent\rule{\textwidth}{1.5pt}
\begin{flushright}
  {\Huge\begin{tabular}{p{.8\textwidth}p{\rightmarg}}
   \raggedleft\bf \@title  &
  \end{tabular}}\par
  \noindent\rule{\textwidth}{1.5pt}\vspace{.5\baselineskip}\par
  {\Large\begin{tabular}{rp{\rightmarg}}
      \@author & \\
      \\
      \\
      \usebox{\@aamType}\\
      \@date
    \end{tabular}}
\end{flushright}
\vfill
\if@aam@correction
  {\centering\Large\draftString\par}
  \vfill
\fi
\hrule
\vspace{1mm}\par
\noindent\begin{minipage}[b]{.85\textwidth}
\if@aam@french
  \copyright\ Tous droits r\'eserv\'es\par
\else
  \copyright\ Copyrighted by the author(s)\par
\fi
\vspace{2ex}\par
\footnotesize
Centre Europ\'een de Recherche et de Formation Avanc\'ee en Calcul
Scientifique\par
42 avenue Coriolis -- 31057 \textsc{Toulouse} \textsc{Cedex} 1 -- \textsc{France}\par
T\'el~: +33 5 61 19 31 31 -- Fax~: +33 5 61 19 30 00\par
\url{http://www.cerfacs.fr} -- e-mail: \url{secretar@cerfacs.fr}\par\vskip0pt
\end{minipage}\hfill
\begin{minipage}[b]{.12\linewidth}
%  \includegraphics[width=\textwidth]{cerfacst.eps}\par\vskip0pt
  \includegraphics[width=\textwidth]{cerfacs_aam_color.jpg}\par\vskip0pt

\end{minipage}\newpage
\if@aam@correction
  \doublespacing
\fi  
\global\let\thanks\relax
\global\let\maketitle\relax
\global\let\@thanks\@empty
\global\let\@author\@empty
\global\let\@date\@empty
\global\let\@title\@empty
\global\let\title\relax
\global\let\author\relax
\global\let\date\relax
\global\let\and\relax}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% make default figure placement to be [htbp]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\fps@figure{htbp}
\def\fps@table{htbp}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% headers and footers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\fancyhf{} %reset
\renewcommand{\headrulewidth}{0pt}
% header
\if@aam@confidential
  \fancyhead[C]{\Large\bf\confidentialString}
  \renewcommand{\headrulewidth}{0.4pt}
\fi
\if@aam@correction
  \fancyhead[LE,RO]{\draftString}
  \renewcommand{\headrulewidth}{0.4pt}
\fi
% footer
\if@aam@french
  \fancyfoot[C]{Page \thepage\ / \pageref{LastPage}}
\else
  \fancyfoot[C]{Page \thepage\ of \pageref{LastPage}}
\fi
\renewcommand{\footrule}{\hfill\hrulefill\hspace*{\fill}\vss}
\renewcommand{\footrulewidth}{0.4pt}
% no footers and headers on empty pages
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
  \hbox{}
  \vspace*{\fill}
  \thispagestyle{empty}
  \newpage
  \if@twocolumn\hbox{}\newpage\fi\fi\fi}
% redefine plain style for chapter page
\fancypagestyle{plain}{%
\fancyhf{}
\if@aam@french
  \fancyfoot[C]{Page \thepage\ / \pageref{LastPage}}
\else
  \fancyfoot[C]{Page \thepage\ of \pageref{LastPage}}
\fi
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0.4pt}} 
\pagestyle{fancy}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% some useful commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\elsa}{\emph{elsA}\xspace}
\newcommand{\qref}[1]{Eq.~\eqref{#1}\xspace}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% new environments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{acknowledgment}{\section*{\merci}}{}
\newenvironment{AAMdiffusion}{\begin{center}{\Large\bf\centering\diffusion\par\vspace*{2mm}}\begin{tabular}{|p{.2\textwidth}|p{.2\textwidth}|p{.2\textwidth}|p{.2\textwidth}|}
    \hline
    \quality & \function & \name & \bf Visa\\
    \hline\hline}{\\\hline\end{tabular}\end{center}\par}
\newenvironment{AAMhistory}{\begin{center}{\Large\bf\centering\history\par\vspace*{2mm}}\begin{tabular}{|c|c|m{8cm}|}
    \hline
    \bf Version & \bf Date & \cause\\
    \hline\hline}{\\\hline\end{tabular}\end{center}\par}
\newcommand{\AAMdiffusionhistory}[2]{\mbox{}\vfill\thispagestyle{empty}%
\begin{AAMhistory}
#1
\end{AAMhistory}\vfill\begin{AAMdiffusion}
#2\end{AAMdiffusion}\vspace*{\fill}\newpage}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Chapter headers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\if@aam@longreport
  \titleformat{\chapter}[display]{\normalfont}{\hrulefill\ \chaptername\
  \thechapter\ \hrulefill\mbox{}}{.3em}{\bf\centering\Large}[\rule{\textwidth}{2pt}]
\fi
