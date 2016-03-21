#!/usr/bin/perl

#Convert merged test file from IOE2 to IOB2
#Input: IOE2
#Output: IOB2

use strict;

#open (inFP_iob2, "<test.iob2.wch100.merge");
my $line_iob2;
#my @ref;

my $line;
my @iob2;
my @ioe2;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_iob2=<inFP_iob2>;	
    #chomp($line_iob2);
    #$ref[$i] = $line_iob2;	

    chomp($line);
    $iob2[$i] = $line;
    $ioe2[$i] = $line;
    #print $iob2[$i],"\n";
    $i++; 
}

# 
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
    
    # === split a a tagged chunk in previous array ===
    my @ioe2_words = split(' ',$ioe2[$j-1]);
    my @prv = split('-',$ioe2_words[3]);
    
    # === "I" => "B" if cur(I)="I" and prv(I)="O","E" or first word is empty ===
    if ($cur[0] eq "I"){
    	if ($prv[0] eq "O" or $prv[0] eq "E" or $prv[0] =~ /^$/){
    		$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." B-".$cur[1]; 
    	}
    }
    
    # === "E" => "I" ===
    if ($cur[0] eq "E"){
    	if ($prv[0] eq "I"){
    	   	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." I-".$cur[1]; 
    	}else{
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
