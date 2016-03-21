#!/usr/bin/perl

#Convert merged test file from O+C to IOB2
#Input: O+C
#Output: IOB2

use strict;

#open (inFP_iob2, "<test.iob2.wch100.merge");
my $line_iob2;
#my @ref;

my $line;
my @iob2;
my @oc;
my $i=0;

# === read a line from file ===
while($line=<>){
    
    #$line_iob2=<inFP_iob2>;	
    #chomp($line_iob2);
    #$ref[$i] = $line_iob2;
    
    chomp($line);
    $iob2[$i] = $line;
    $oc[$i] = $line;
    
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
    
    # === "[" => "B" ===
    if ($cur[0] eq "["){
    	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." B-".$cur[1]; 
    }
    
    # === "]" => "I" ===
    if ($cur[0] eq "]"){
    	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." I-".$cur[1]; 
    }
    
    # === "[]" => "B" ===
        if ($cur[0] eq "[]"){
        	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." B-".$cur[1]; 
    }
    
    # === "O-NP" => "I-NP" ===
    if ($cur[0] eq "O" and $cur[1] !~ /^$/){
    	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." I-".$cur[1]; 
    }
    
    # === "O-xx" do not care ===
    #if ($cur[0] eq "O" and $cur[1] !~ /^$/){
    #	$iob2[$j] = $iob2_words[0]." ".$iob2_words[1]." ".$iob2_words[2]." O-".$cur[1]; 
    #}
    
    
    
}

for(my $j=0;$j<=$#iob2;$j++){
    my @words = split(' ',$iob2[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
