pdf:
	cat 0*.md > merged.md
	perl -pe 's/==(.*?)==/\\action{\1}/g' merged.md | pandoc -f markdown+footnotes+citations+latex_macros -t latex --variable urlcolor=blue --include-in-header=./pandoc/pandoc-include-in-header.txt -o merged.pdf --latex-engine=xelatex -N
	browse merged.pdf
merge:
	cat 01-introduction.md 02-method.md 03-result.md 04-discussion.md 05-conclusion.md > merged.md
doc:
	pandoc merged.md -o merged.doc
tex: 
	pandoc merged.md -o merged.tex -N
clean:
	rm merged.*
