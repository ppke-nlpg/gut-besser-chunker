#!/usr/bin/perl

#Convert merged test file from IOE2 to IOE1
#Input: IOE2
#Output: IOE1

#use strict;

#open (inFP_ioe1, "<test.ioe1.wch100.merge");
my $line_ioe1;
#my @ref;

my $line;
my @ioe1;
my @ioe2;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_ioe1=<inFP_ioe1>;	
    #chomp($line_ioe1);
    #$ref[$i] = $line_ioe1;
     
    chomp($line);
    $ioe1[$i] = $line;
    $iob2[$i] = $line;
    #print $ioe1[$i],"\n";
    $i++; 
}


for (my $j=0;$j<=$#ioe1;$j++){
    # === split a line into words ===	
    my @ioe1_words = split(' ',$ioe1[$j]);
    
    # === skip blank line ===
    if ($#ioe1_words < 1){
    	#print "\n";
    	next;
    }        
    
    # === split a tagged chunk, eg.I-NP => "I" and "NP" ===
    my @cur = split ('-',$ioe1_words[3]);
    
    # === get previous ===
    my @prv_words = split(' ',$iob2[$j-1]);
    my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$iob2[$j+1]);
    my @flw = split('-',$flw_words[3]);
       
    
    
    
    # === Case "I" ===
    if ($cur[0] eq "I"){
       	$ioe1[$j] = $ioe1_words[0]." ".$ioe1_words[1]." ".$ioe1_words[2]." I-".$cur[1]; 
    }
    
    
    # === Case "E" ===
    if ($cur[0] eq "E"){
    
    	# "I" if follow(E) is "I" or "E" and follow != cur
    	if ($flw[0]=~/^I|E$/ and $flw[1] ne $cur[1]){
       		$ioe1[$j] = $ioe1_words[0]." ".$ioe1_words[1]." ".$ioe1_words[2]." I-".$cur[1];
    	
    	# "I" if follow(E) is "O"
    	}elsif ($flw[0] eq "O"){
    		$ioe1[$j] = $ioe1_words[0]." ".$ioe1_words[1]." ".$ioe1_words[2]." I-".$cur[1];
    	
    	# "E" if o.w.
    	}else{
    		$ioe1[$j] = $ioe1_words[0]." ".$ioe1_words[1]." ".$ioe1_words[2]." E-".$cur[1];
    	}
    	
    }
    
    
    
}

for(my $j=0;$j<=$#ioe1;$j++){
    my @words = split(' ',$ioe1[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
