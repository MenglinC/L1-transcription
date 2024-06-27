#!perl
#perl ./gRNA_screenTE_mismatch.pl -sgRNA ./gRNA30all.txt -length 30 -mismatch 0 -fastaindex hg38_bedtools_TE.chr1-Y.processed.final.50.fasta #修改mismatch和length
use Getopt::Long;
GetOptions(
            "sgRNA=s" =>\$sgRNA,
			"length=s" =>\$length,
			"mismatch=s" =>\$mismatch,
			"fastaindex=s" =>\$fastaindex,
            "h|help" =>\$help,
 
);
if($help)
{
print
"
usage:
-sgRNA     : A text file containing sgRNA sequences, with each line representing a candidate sequence; the default file name is gRNA.txt;
-length     : Length of the sgRNA,default:30;
-mismatch     : Mismatch number when searching,default:0;
-fastaindex      : Fasta file name used to build the BLAST index;default:hg38_bedtools_L1.chr1-Y.fasta;
-h         : usage of this scripts
"
}
open (MARK, "< ".$sgRNA) or die "can not open it!";
$searchLen = $length - $mismatch;
print $searchLen;
$Result = "Result_".$mismatch;
$Count = "Count_".$mismatch;
$outfile = "Output".$mismatch.".txt";
while ($line = <MARK>){
		print($line);
		chomp($line);
		print($line);
		$line = uc($line);
		system_call("mkdir -p ".$Result);
		system_call("mkdir -p ".$Count);
		system_call("mkdir -p tmp");
		system_call("echo '>".$line."\' > ".$line.".fa");
		system_call("echo ".$line." >>".$line.".fa");
		system_call("blastn -db ".$fastaindex." -query ".$line.".fa -word_size 4 -dust no -outfmt 6 -task blastn-short -max_target_seqs 100000 | awk '((\$3 == 100.000 && \$4 >= ".$searchLen.")||(\$4 == ".$length." && \$5 <= ".$mismatch."))' >\./".$Result."/".$line.".blast.result  ");#default:word_size 4
		system_call("cat \./".$Result."/".$line.".blast.result |awk '{print \$2}' |awk -v FS=\":\" -v OFS=\":\" '{print \$1,\$2,\$3}' |sort |uniq -c |awk -v OFS=\"\t\" '{print \$2,\$1,\"".$line."\"}' >\./".$Count."/".$line.".count".$mismatch.".result");
} 
system_call("cat \./".$Count."/* >".$outfile);
system_call("mv *.fa ./tmp/");
close(MARK);
sub system_call
{
  my $command=$_[0];
  print "\n\n".$command."\n\n";
  system($command);
}
