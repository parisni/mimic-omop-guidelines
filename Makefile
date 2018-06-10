pdf:
	cat 0*.rst > merged.rst
	perl -pe 's/==(.*?)==/\\action{\1}/g' merged.rst | pandoc -f markdown+footnotes+citations+latex_macros -t latex --variable urlcolor=blue --include-in-header=./pandoc/pandoc-include-in-header.txt -o merged.pdf --latex-engine=xelatex -N
	browse merged.pdf
merge:
	cat 01-introduction.rst 02-method.rst 03-result.rst 04-discussion.rst 05-limitation.rst 06-conclusion.rst > merged.rst
doc:
	pandoc merged.rst -o merged.doc
tex: 
	pandoc merged.rst -o merged.tex -N
clean:
	rm merged.*
