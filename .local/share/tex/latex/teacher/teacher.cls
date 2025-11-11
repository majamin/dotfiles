%% teacher.cls
%% A LaTeX class for creating professional secondary school teaching materials
%% Version 0.2 - Now with Beamer presentation support

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{teacher}[2024/11/07 v0.2 Teacher Materials Class]

% Class options
\newif\if@beamer
\@beamerfalse
\DeclareOption{beamer}{\@beamertrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

% ============================================================
% BEAMER MODE
% ============================================================
\if@beamer
  % Load Beamer with sensible defaults
  \LoadClass[aspectratio=169,11pt]{beamer}
  
  % Metropolis theme
  \usetheme{metropolis}
  
  % Font setup for Beamer
  \usepackage{fontspec}
  \setsansfont{Fira Sans}[Scale=MatchLowercase]
  
  % Essential packages
  \usepackage{amsmath}
  \usepackage{amssymb}
  \usepackage{bm}
  \usepackage{tikz}
  \usepackage{xcolor}
  \usepackage{booktabs}
  \usepackage{graphicx}
  
  % Color scheme (matching worksheet colors but adapted for slides)
  \definecolor{primarycolor}{RGB}{51,51,51}
  \definecolor{accentcolor}{RGB}{100,100,100}
  \definecolor{Good}{HTML}{2E7D32}
  \definecolor{Warn}{HTML}{EF6C00}
  \definecolor{Bad}{HTML}{C62828}
  \definecolor{Accent1}{HTML}{1976D2}
  \definecolor{Accent2}{HTML}{7B1FA2}
  \definecolor{Accent3}{HTML}{388E3C}
  
  % Colored block environments for visual variety
  \newenvironment{blueblock}[1]{%
    \setbeamercolor{block title}{fg=white,bg=Accent1}%
    \setbeamercolor{block body}{fg=black,bg=Accent1!10}%
    \begin{block}{#1}%
  }{%
    \end{block}%
  }
  
  \newenvironment{purpleblock}[1]{%
    \setbeamercolor{block title}{fg=white,bg=Accent2}%
    \setbeamercolor{block body}{fg=black,bg=Accent2!10}%
    \begin{block}{#1}%
  }{%
    \end{block}%
  }
  
  \newenvironment{greenblock}[1]{%
    \setbeamercolor{block title}{fg=white,bg=Accent3}%
    \setbeamercolor{block body}{fg=black,bg=Accent3!10}%
    \begin{block}{#1}%
  }{%
    \end{block}%
  }
  
  % Helper commands for Beamer
  \newcommand{\vocab}[2]{\textbf{#1:} #2}
  
  % Activity timing helpers
  \newcommand{\tps}[1][2 minutes]{Think–Pair–Share (#1)}
  
  % Quick practice environment
  \newenvironment{quickpractice}[1][2 minutes]{%
    \begin{frame}{Quick Practice (#1)}
  }{%
    \end{frame}
  }
  
  % Exit ticket environment
  \newenvironment{exitticket}[1][1 minute]{%
    \begin{frame}{Exit Ticket (#1)}
  }{%
    \end{frame}
  }
  
  % Coordinate grid for Beamer (simplified)
  \newcommand{\coordgrid}[5][0.6]{%
    \begin{tikzpicture}[scale=#1]
      % Grid
      \draw[step=1, gray!30, very thin] (#2,#4) grid (#3,#5);
      % Axes
      \draw[thick,->] (#2-0.2,0) -- (#3+0.2,0) node[right] {$x$};
      \draw[thick,->] (0,#4-0.2) -- (0,#5+0.2) node[above] {$y$};
      % Tick marks
      \foreach \x in {#2,...,#3} {
        \ifnum\x=0\else
          \draw (\x,0.1) -- (\x,-0.1) node[below] {\tiny $\x$};
        \fi
      }
      \foreach \y in {#4,...,#5} {
        \ifnum\y=0\else
          \draw (0.1,\y) -- (-0.1,\y) node[left] {\tiny $\y$};
        \fi
      }
      \node[below left] at (0,0) {\tiny $0$};
    \end{tikzpicture}
  }

% ============================================================
% ARTICLE MODE (Original worksheet functionality)
% ============================================================
\else
  % Base class - article with letter paper
  \LoadClass[11pt,letterpaper]{article}
  
  % Essential packages
  \RequirePackage[margin=0.75in]{geometry}
  \RequirePackage[T1]{fontenc}
  \RequirePackage{FiraSans}
  \renewcommand{\familydefault}{\sfdefault}
  \RequirePackage{amsmath}
  \RequirePackage{amssymb}
  \RequirePackage{bm}
  \RequirePackage{tikz}
  \RequirePackage{enumitem}
  \RequirePackage[table]{xcolor}
  \RequirePackage{tcolorbox}
  \RequirePackage{tabularx}
  \RequirePackage{multicol}
  \RequirePackage{graphicx}
  \RequirePackage[document]{ragged2e}
  \RequirePackage{booktabs}
  
  \newcounter{qn}
  \renewcommand{\theqn}{\arabic{qn}.}
  
  % Set up colors (neutral, professional)
  \definecolor{primarycolor}{RGB}{51,51,51}
  \definecolor{accentcolor}{RGB}{100,100,100}
  \definecolor{lightgray}{RGB}{240,240,240}
  
  % Remove default title formatting
  \renewcommand{\maketitle}{}
  
  % Custom header command for worksheets
  \newcommand{\worksheetheader}[3]{%
    \noindent
    \begin{minipage}[t]{0.6\textwidth}
      {\Large\bfseries #1}\\[2pt]
      {\large #2}
    \end{minipage}%
    \hfill
    \begin{minipage}[t]{0.35\textwidth}
      \raggedleft
      Name: \underline{\hspace{3cm}}\\[4pt]
      Date: \underline{\hspace{3cm}}
    \end{minipage}
    \par\vspace{12pt}
  }
  
  % Page layout tweaks
  \setlength{\parindent}{0pt}
  \setlength{\parskip}{6pt}
  \pagestyle{plain}
  
  % Reduce spacing in lists
  \setlist{nosep, leftmargin=*}
  
  % Question/Answer environment
  \tcbuselibrary{skins, breakable}
  
  \newtcolorbox{qanda}[2][]{
    colback=white,
    colframe=primarycolor,
    boxrule=1pt,
    arc=2pt,
    breakable,
    before skip=10pt,
    after skip=10pt,
    title={\stepcounter{qn}\theqn\ #2},
    fonttitle=\bfseries\boldmath,
    coltitle=white,
    colbacktitle=primarycolor,
    toptitle=3pt,
    bottomtitle=3pt,
    title filled,
    #1
  }
  
  % Two-column layout
  \newcommand{\qandapair}[4]{%
    \noindent
    \begin{tabular}{@{}p{0.48\textwidth}@{\hspace{0.04\textwidth}}p{0.48\textwidth}@{}}
      \begin{qanda}{#1}
        #2
      \end{qanda}
      &
      \begin{qanda}{#3}
        #4
      \end{qanda}
    \end{tabular}
    \par\vspace{10pt}
  }
  
  % Three-column layout
  \newcommand{\qandatriple}[6]{%
    \noindent
    \begin{tabular}{@{}p{0.31\textwidth}@{\hspace{0.035\textwidth}}p{0.31\textwidth}@{\hspace{0.035\textwidth}}p{0.31\textwidth}@{}}
      \begin{qanda}{#1}
        #2
      \end{qanda}
      &
      \begin{qanda}{#3}
        #4
      \end{qanda}
      &
      \begin{qanda}{#5}
        #6
      \end{qanda}
    \end{tabular}
    \par\vspace{10pt}
  }
  
  % Workspace helpers
  \newcommand{\workspace}[1]{%
    \par\noindent
    \begin{minipage}[t]{\linewidth}\vspace{#1}\end{minipage}%
  }
  
  \newcommand{\wsone}{\workspace{0.75cm}}
  \newcommand{\wstwo}{\workspace{1.5cm}}
  \newcommand{\wsthree}{\workspace{2.5cm}}
  \newcommand{\wsfour}{\workspace{3.5cm}}
  \newcommand{\wsfive}{\workspace{5cm}}
  \newcommand{\wssix}{\workspace{7cm}}
  
  % Graphing helpers
  \newcommand{\coordgrid}[5][0.8]{%
    \begin{tikzpicture}[scale=#1]
      % Grid
      \draw[step=1, gray!30, very thin] (#2,#4) grid (#3,#5);
      % Axes
      \draw[thick,->] (#2-0.2,0) -- (#3+0.2,0) node[right] {$x$};
      \draw[thick,->] (0,#4-0.2) -- (0,#5+0.2) node[above] {$y$};
      % Tick marks
      \foreach \x in {#2,...,#3} {
        \ifnum\x=0\else
          \draw (\x,0.1) -- (\x,-0.1) node[below] {\small $\x$};
        \fi
      }
      \foreach \y in {#4,...,#5} {
        \ifnum\y=0\else
          \draw (0.1,\y) -- (-0.1,\y) node[left] {\small $\y$};
        \fi
      }
      \node[below left] at (0,0) {\small $0$};
    \end{tikzpicture}
  }
  
  % Plot function
  \newcommand{\plotfunction}[7][0.8]{%
    \begin{tikzpicture}[scale=#1]
      % Grid
      \draw[step=1, gray!30, very thin] (#2,#4) grid (#3,#5);
      % Axes
      \draw[thick,->] (#2-0.2,0) -- (#3+0.2,0) node[right] {$x$};
      \draw[thick,->] (0,#4-0.2) -- (0,#5+0.2) node[above] {$y$};
      % Tick marks
      \foreach \x in {#2,...,#3} {
        \ifnum\x=0\else
          \draw (\x,0.1) -- (\x,-0.1) node[below] {\small $\x$};
        \fi
      }
      \foreach \y in {#4,...,#5} {
        \ifnum\y=0\else
          \draw (0.1,\y) -- (-0.1,\y) node[left] {\small $\y$};
        \fi
      }
      \node[below left] at (0,0) {\small $0$};
      % Function plot
      \draw[thick, #7, domain=#2:#3, samples=100, smooth] 
        plot (\x, {#6});
    \end{tikzpicture}
  }
  
  % BC Curriculum Proficiency Scale Rubric
  \newcommand{\hdr}[1]{\raisebox{0pt}[2.5ex][2.5ex]{\color{white}\bfseries #1}}
  
  \newenvironment{rubric}{%
    \begingroup
    \renewcommand{\arraystretch}{1.85}%
    \small\setlength{\tabcolsep}{5pt}%
    \tabularx{\textwidth}{@{}>{\raggedright\arraybackslash}p{0.18\textwidth}*{4}{>{\raggedright\arraybackslash}X}@{}}
      \rowcolor{primarycolor}
      \hdr{Criteria} & \hdr{Emerging} & \hdr{Developing} & \hdr{Proficient} & \hdr{Extending}\\
      \midrule
  }{%
      \bottomrule
    \endtabularx%
    \endgroup
  }
  
  \newcommand{\rubricrow}[5]{%
    #1 & #2 & #3 & #4 & #5 \\
  }
\fi

\endinput
