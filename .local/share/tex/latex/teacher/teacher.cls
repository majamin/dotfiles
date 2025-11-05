%% teacher.cls
%% A LaTeX class for creating professional secondary school teaching materials
%% Version 0.1

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{teacher}[2024/11/03 v0.1 Teacher Materials Class]

% Base class - article with letter paper
\LoadClass[11pt,letterpaper]{article}

% Essential packages
\RequirePackage[margin=0.75in]{geometry}  % Maximize content space
\RequirePackage[T1]{fontenc}
\RequirePackage{FiraSans}                  % Load Fira Sans package
\renewcommand{\familydefault}{\sfdefault}  % Set sans-serif as default
\RequirePackage{amsmath}                   % Math environments and symbols
\RequirePackage{amssymb}
\RequirePackage{bm}                        % Bold math symbols
\RequirePackage{tikz}                      % For graphics and organizers
\RequirePackage{enumitem}                  % Better list control
\RequirePackage[table]{xcolor}                    % Color support
\RequirePackage{tcolorbox}                 % Boxes for organizers
\RequirePackage{tabularx}                  % Better tables
\RequirePackage{multicol}                  % Multiple columns
\RequirePackage{graphicx}                  % For including images
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

% Page layout tweaks for maximum content
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt}
\pagestyle{plain}

% Reduce spacing in lists
\setlist{nosep, leftmargin=*}

% Question/Answer environment using tcolorbox
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

% Two-column equal height layout
% Usage: \qandapair{question1}{content1}{question2}{content2}
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

% Three-column equal height layout
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
% Basic coordinate grid
% Usage: \coordgrid[scale]{xmin}{xmax}{ymin}{ymax}
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

% Plot a function on a coordinate grid
% Usage: \plotfunction[scale]{xmin}{xmax}{ymin}{ymax}{function expression}{color}
% Example: \plotfunction{-3}{3}{-1}{10}{\x*\x}{blue}
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
% \newcolumntype{M}[1]{>{\RaggedRight\arraybackslash}m{#1}} % vertically centered paragraph

% header cell macro adds a symmetric strut
\newcommand{\hdr}[1]{\raisebox{0pt}[2.5ex][2.5ex]{\color{white}\bfseries #1}}

% Usage: \rubricrow{Criteria}{Emerging}{Developing}{Proficient}{Extending}
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

\endinput
