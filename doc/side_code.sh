new_file="out.md"
cp $1 $new_file

sed -i -e 's/\\side/\\begin{table}[!h]\
\\begin{minipage}{0.45\\linewidth}\
\\begin{lstlisting}/g' $new_file

sed -i -e 's/\\middle_side/\\end{lstlisting}\
\\end{minipage}\
\\hfill\\vrule\\hfill\
\\begin{minipage}{0.45\\linewidth}\
\\begin{lstlisting}/g' $new_file

sed -i -e 's/\\end_side/\\end{lstlisting}\
\\end{minipage}\
\\end{table}/g' $new_file

sed -i -e 's/\\code/\\lstset{basicstyle=\\ttfamily\\normalsize}\
\\begin{lstlisting}/g' $new_file

sed -i -e 's/\\end_code/\\end{lstlisting}\
\\lstset{basicstyle=\\ttfamily\\footnotesize}/g' $new_file

sed -i -e 's/\\md_code/\\color{cyan!50!black}/g' $new_file

sed -i -e 's/\\end_md_code/\\color{black}/g' $new_file