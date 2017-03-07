echo "Problem Set 2"

echo "Q1: Use BEDtools intersect to identify the size of the largest overlap between CTCF and H3K4me3 locations."
echo "answer_1=bedtools intersect -a encode.tfbs.chr22.bed -b encode.h3k4me3.hela.chr22.bed -wo | awk 'BEGIN {FS="\t"; OFS="\t"} ($4=="CTCF"){print $0}' | sort -k15nr | head -1 | cut -f 15"
echo "answer-1: $answer_1"
echo "The size of the largest overlap between CTCF and H3K4me3 locations is 1079."

"Q2: Use BEDtools to calculate the GC content of nucleotides 19,000,000 to 19,000,500 on chr22 of hg19 genome build. Report the GC content as a fraction (e.g., 0.50)."
# Create a BED file from scratch to define the interval of interest. The string "chr22\t19000000\19000500" creates three columns.
# Now you can use bedtools nuc (or nucBed) to calculate the GC content.
# nuc -> "Profile the nucleotide content of intervals in a FASTA file."
# https://media.readthedocs.org/pdf/bedtools/latest/bedtools.pdf
answer_2= echo -e "chr22\t19000000\t19000500" | bedtools nuc -fi hg19.chr22.fa -bed - | cut -f 5 | tail
echo "answer-2: $answer_2"

echo "Q3: Use BEDtools to identify the length of the CTCF ChIP-seq peak (i.e., interval) that has the largest mean signal in ctcf.hela.chr22.bg.gz."
# NOTE: We're looking for the CTCF peaks, i.e., the peaks of a particular gene called CTCF. Therefore, we need to filter the encode.tfbs.chr22.bed file to retain only the CTCF records.
answer_3=bedtools map -a encode.tfbs.chr22.bed -b ctcf.hela.chr22.bg -c 4 -o mean | awk 'BEGIN {OFS="\t"}($4=="CTCF")' |  awk 'BEGIN {OFS= "\t"} {print $0, $3-$2}' | sort -k5nr | head -1 | cut -f 6
echo "answer-3: $answer_3"

echo "Q4: Use BEDtools to identify the gene promoter (defined as 1000 bp upstream of a TSS) with the highest median signal in ctcf.hela.chr22.bg.gz. Report the gene name (e.g., 'ABC123')"
answer_4=bedtools map -a flank.pos.bed -b ctcf.hela.chr22.bg -c 4 -o median | sort -k7nr | head -1 | cut -f 4
echo "answer-4: $answer_4"
        
echo "Q5: Use BEDtools to identify the longest interval on chr22 that is not covered by genes.hg19.bed.gz. Report the interval like chr1:100-500."
answer_5=awk 'BEGIN {OFS="\t"}{$1="chr22"}{$3-$2>0}{print $0, $3-$2}' genes.hg19.bed | sort -k7nr | head -1 | cut -f1-3
# chr22   144146810       146467744
echo "answer-5: $answer_5"
# "Exeperienced a persistent error seemingly due to zero-length interval- error only appeared upon trying to run from vim... see https://github.com/arq5x/bedtools2/issues/121"
# Note: awk didn't want to play along when I tried to create a variable named length, most likely because the data we're using to start does not have column headers.

echo "Q6: Use one or more BEDtools that we haven't covered in class. Be creative."

