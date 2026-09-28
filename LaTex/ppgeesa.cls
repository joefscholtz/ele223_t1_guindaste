%==============================================================================
% ppgeesa - Seminario de Andamento do PPGEE
% Copyright (C) 2004..2016 Walter Fetter Lages <fetter@ece.ufrgs.br>
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
%==============================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ppgeesa}[2016/03/16 v2.0.0 Pacote DeLaeTeX - ppgeesa.cls - Seminario de Andamento do PPGEE]

\DeclareOption{english}{\@englishtrue\OptionNotUsed}\newif\if@english
\DeclareOption{twoside}{\PassOptionsToClass{twoside}{IEEETran}}
%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{IEEETran}}
\ProcessOptions\relax

\LoadClass[10pt,final,journal,a4paper]{IEEEtran}
\RequirePackage[english,brazilian]{babel}
\RequirePackage{cite}
\input{delae_pt_BR.ldf}
\input{delae_en.ldf}
\if@english
        \selectlanguage{english}
        \AtBeginDocument{\selectlanguage{english}}
\fi
\RequirePackage{delaedefs}

