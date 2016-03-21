#!/usr/bin/perl

#Convert merged test file from IOB1 to IOB2
#Input: IOB1
#Output: IOB2

use strict;

#open (inFP_iob2, "<test.iob2.wch100.merge");
my $line_iob2;
#my @ref;

my $line;
my @iob2;
my @iob1;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_iob2=<inFP_iob2>;	
    #chomp($line_iob2);
    #$ref[$i] = $line_iob2;
     
    chomp($line);
    $iob2[$i] = $line;
    $iob1[$i] = $line;
    #print $iob2[$i],"\n";
    $i++; 
}


for (my $j=0;$j<=$#iob2;$j++){
    # === split a line into words ===	
    my @iob2_words = split(' ',$iob2[$j]);
    
    # === skip blank line ===
    if ($#iob2_words < 1){
    	#print "\n";
    	next;
    }        
    
    # === split a tagged chunk, eg.I-NP => "I" and "NP" ===
    my @cur = split ('-',$iob2_words[3]);
    
    # === previous ===
    my @iob1_words = split(' ',$iob1[$j-1]);
    my @prv = split('-',$iob1_words[3]);
        
        
    # === Case "I" ===    
    if ($cur[0] eq "I"){
        # === "B" if previous(I)="O" or empty ===
        if ($prv[0] eq "O" or $prv[0] =~ /^$/){
        	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." B-".$cur[1]; 
        	
        # === "B" if previous(I)="I" and previous !=cur
        }elsif ($prv[0] eq "I" and $prv[1] ne $cur[1]){
        	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." B-".$cur[1];
        }
    }	 
}

for(my $j=0;$j<=$#iob2;$j++){
    my @words = split(' ',$iob2[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
