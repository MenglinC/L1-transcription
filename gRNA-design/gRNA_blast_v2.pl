#!perl
use Getopt::Long;
GetOptions(
            "m=s" =>\$motif,
			"l=s" =>\$length,
			"p=s" =>\$outfile,
#			"i=s" =>\$index,
            "h|help" =>\$help,
 
);
if($help)
{
print
"
usage:
-m         : gRNA.txt
-l         : 23
-p         : all.gRNA.blast.result
-h         : usage of this scripts
"
}
open (MARK, "< ".$motif) or die "can not open it!";
while ($line = <MARK>){
		print($line);
		chomp($line);
		print($line);
		$line = uc($line);
		system_call("mkdir -p Result");
		system_call("mkdir -p Count");
		#system_call("mkdir -p homerinput");
		system_call("echo '>".$line."\' > ".$line.".fa");
		system_call("echo ".$line." >>".$line.".fa");
		system_call("blastn -db hg38_bedtools_L1.chr1-Y.fasta -query ".$line.".fa -word_size ".$length." -dust no -outfmt 6 -task blastn-short -evalue 1000 >\./Result/".$line.".blast.result");
		system_call("cat \./Result/".$line.".blast.result |awk '{print \$2}' |awk -v FS=\":\" '{print \$1}' |sort |uniq -c |awk -v OFS=\"\t\" '{print \$2,\$1,\"".$line."\"}' >\./Count/".$line.".count.result");
		#system_call("awk -v OFS=\"\t\" '{print \"peak\"NR,\$1,\$2,\$3,\$6,\$4}' ".$peakfile." >./homerinput/Homer_".$peakfile);
		#system_call("seq2profile.pl  ".$line." 0 ".$line."  >./motif/".$line.".motif");
		#system_call("annotatePeaks.pl ./homerinput/Homer_".$peakfile." hg38 -m \./motif/".$line.".motif -mbed ./mbed/".$line.".".$index.".bed >./mbed/".$index.".6kp_5UTR.600b.1000a.".$line.".bed");
		#system_call("mkdir -p ./mbed/noHeader");
		#system_call("sed '1d' ./mbed/".$line.".".$index.".bed >./mbed/noHeader/".$line.".".$index.".noHeader.bed");
		#system_call("bedtools intersect -wa -wb -a ./mbed/noHeader/".$line.".".$index.".noHeader.bed -b ".$peakfile." >./mbed/intersect.".$line.".".$index.".600b.1000a.bed");
		#system_call("mkdir -p distribution");
		#system_call("awk -v OFS=\"\t\" '{if(\$12==\"+\"){print \$1,\$2,\$3,\$4,\$5,\$6,\$7,\$8,\$9,\$10,\$11,\$12,(\$2-\$8)/(\$9-\$8-".$length."),\"".$line."\"}else{print \$1,\$2,\$3,\$4,\$5,\$6,\$7,\$8,\$9,\$10,\$11,\$12,\$13,(\$9-\$3)/(\$9-\$8-".$length."),\"".$line."\"}}' ./mbed/intersect.".$line.".".$index.".600b.1000a.bed\ >./distribution/".$line.".".$index.".600b.1000a.distribution.bed");
} 
system_call("cat \./Count/* >".$outfile);
close(MARK);
sub system_call
{
  my $command=$_[0];
  print "\n\n".$command."\n\n";
  system($command);
}
