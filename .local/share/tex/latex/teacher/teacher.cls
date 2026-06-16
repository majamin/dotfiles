%% teacher.cls
%% A LaTeX class for creating professional secondary school teaching materials
%% v0.5 (2025-11-23): Added \titleslidewithbackground command for Beamer title slides with images
%% v0.4 (2025-11-16): Added svg to Article mode, consolidated coordgrid, moved vocab to shared
%% v0.3 (2025-11-11): Added course.sty support and Beamer presentation support

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{teacher}[2025/11/23 v0.5 Teacher Materials Class]

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
  \usepackage{pgfplots}
  \pgfplotsset{compat=1.18}
  \usepackage{xcolor}
  \usepackage{booktabs}
  \usepackage{graphicx}
  \usepackage{adjustbox}

  % Default color scheme (can be overridden by course.sty)
  \providecolor{primarycolor}{RGB}{51,51,51}
  \providecolor{accentcolor}{RGB}{100,100,100}
  \providecolor{Good}{HTML}{2E7D32}
  \providecolor{Warn}{HTML}{EF6C00}
  \providecolor{Bad}{HTML}{C62828}
  \providecolor{Accent1}{HTML}{1976D2}
  \providecolor{Accent2}{HTML}{7B1FA2}
  \providecolor{Accent3}{HTML}{388E3C}

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

  % Title slide with background image
  % Usage: \titleslidewithbackground[opacity]{textcolor}{background-path}
  % Example: \titleslidewithbackground[0.5]{white}{images/backgrounds/cloudscape.jpg}
  % Images fill the width of the slide while maintaining aspect ratio
  \NewDocumentCommand{\titleslidewithbackground}{O{0.5} m m}{%
    {%
      \usebackgroundtemplate{%
        \begin{tikzpicture}[remember picture,overlay]
          % Place image centered, filling the width
          \node[inner sep=0pt,outer sep=0pt] at (current page.center) {
            \includegraphics[width=\paperwidth,keepaspectratio]{#3}
          };
          % Dark overlay for text readability
          \fill[black,opacity=#1] (current page.south west) rectangle (current page.north east);
        \end{tikzpicture}
      }%
      % Set title colors for dark background
      \setbeamercolor{title}{fg=#2}%
      \setbeamercolor{subtitle}{fg=#2!90!black}%
      \setbeamercolor{author}{fg=#2!80!black}%
      \setbeamercolor{date}{fg=#2!70!black}%
      \begin{frame}
        \titlepage
      \end{frame}
    }%
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
  \RequirePackage{svg}
  \RequirePackage[document]{ragged2e}
  \RequirePackage{booktabs}
  
  \newcounter{qn}
  \renewcommand{\theqn}{\arabic{qn}.}

  % Default colors (neutral, professional) - can be overridden by course.sty
  \providecolor{primarycolor}{RGB}{51,51,51}
  \providecolor{accentcolor}{RGB}{100,100,100}
  \providecolor{lightgray}{RGB}{240,240,240}
  
  % Remove default title formatting
  \renewcommand{\maketitle}{}
  
  % Custom header command for worksheets
  % Usage: \worksheetheader[DOCTYPE]{Title}{Course}{Concept}
  % DOCTYPE is optional: NOTES, PRACTICE, REVIEW, ASSESSMENT, etc.
  % If omitted, defaults to NOTES
  \RequirePackage{xparse}
  \NewDocumentCommand{\worksheetheader}{O{NOTES} m m m}{%
    % Thick colored bar at absolute top of page
    \begin{tikzpicture}[remember picture, overlay]
      \fill[primarycolor] (current page.north west) rectangle +(\paperwidth,-0.5cm);
      % Logo positioned below the bar, on the left
      \node[anchor=north west] at ([xshift=0.75in, yshift=-0.8cm]current page.north west) {%
        \IfFileExists{./images/logo.svg}{%
          \includesvg[height=0.55in]{./images/logo}%
        }{%
          \IfFileExists{logo.pdf}{%
            \includegraphics[height=0.55in]{logo.pdf}%
          }{%
            \IfFileExists{logo.png}{%
              \includegraphics[height=0.55in]{logo.png}%
            }{}%
          }%
        }%
      };
      % Student info positioned below the bar, on the right
      \node[anchor=north east] at ([xshift=-0.75in, yshift=-0.85cm]current page.north east) {%
        \begin{tabular}{@{}r@{~}l@{}}
          \textsc{Student Name:} & \underline{\hspace{2.5in}} \\[4pt]
          \textsc{Date:} & \underline{\hspace{2.5in}}
        \end{tabular}%
      };
    \end{tikzpicture}

    \vspace{1.35cm}

    % Main header layout with proper alignment
    \noindent
    \begin{minipage}[t]{0.25\textwidth}
      \vspace{0pt}% Force top alignment
      % Document type - prominent display
      \begin{tcolorbox}[
        enhanced,
        colback=primarycolor,
        colframe=primarycolor,
        boxrule=0pt,
        arc=2mm,
        left=8pt,
        right=8pt,
        top=10pt,
        bottom=10pt,
        before skip=0pt,
        after skip=0pt
      ]
        \centering
        {\LARGE\bfseries\color{white}#1 #4}
      \end{tcolorbox}
    \end{minipage}%
    \hfill
    \begin{minipage}[t]{0.72\textwidth}
      \vspace{0pt}% Force top alignment
      % Course and concept information
      \raggedright
      {\small\textsc{\textcolor{primarycolor}{#3} \textbullet\ Concept #4}}

      \vspace{3pt}

      {\Large\bfseries #2}
    \end{minipage}

    \vspace{16pt}
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
    enhanced,
    colback=white,
    colframe=primarycolor,
    boxrule=1pt,
    arc=0.1mm,
    breakable,
    before skip=10pt,
    after skip=10pt,
    top=5mm,
    bottom=5mm,
    title={#2},
    fonttitle=\bfseries\boldmath,
    coltitle=black,
    colbacktitle=white,
    boxed title style={boxrule=0pt,colframe=white},
    attach boxed title to top left={
      yshift=-\tcboxedtitleheight/2,
      xshift=4mm
    },
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

  % Example/You Try counter and environments
  \newcounter{exnum}
  \renewcommand{\theexnum}{\arabic{exnum}}

  \newcommand{\exampletitle}[1]{%
    \stepcounter{exnum}%
    Example \theexnum: #1%
  }

  \newcommand{\youtrytitle}[1]{%
    \stepcounter{exnum}%
    You Try \theexnum: #1%
  }

  \newenvironment{example}[1]{%
    \begin{qanda}{\exampletitle{#1}}%
  }{%
    \end{qanda}%
  }

  \newenvironment{youtry}[1]{%
    \begin{qanda}{\youtrytitle{#1}}%
  }{%
    \end{qanda}%
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

% ============================================================
% SHARED COMMANDS (Available in both modes)
% ============================================================
% Vocabulary formatting helper
\newcommand{\vocab}[2]{\textbf{#1:} #2}

% Coordinate grid helper
% Usage: \coordgrid[scale]{xmin}{xmax}{ymin}{ymax}
% Optional scale parameter (default 0.8 for article, adjustable for beamer)
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

% ============================================================
% LOAD COURSE-SPECIFIC STYLING (if it exists)
% ============================================================
% This must come AFTER all class setup so that course.sty can
% override colors, commands, etc.
\IfFileExists{course.sty}{%
  \RequirePackage{course}
}{%
  % course.sty not found, using default styling
}

\endinput
