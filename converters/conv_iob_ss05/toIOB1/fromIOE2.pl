#!/usr/bin/perl

#Convert merged test file from IOE2 to IOB1
#Input: IOE2
#Output: IOB1

#use strict;

#open (inFP_iob1, "<test.iob1.wch100.merge");
my $line_iob1;
#my @ref;

my $line;
my @iob1;
my @ioe2;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_iob1=<inFP_iob1>;	
    #chomp($line_iob1);
    #$ref[$i] = $line_iob1;
     
    chomp($line);
    $iob1[$i] = $line;
    $ioe2[$i] = $line;
    #print $iob1[$i],"\n";
    $i++; 
}


for (my $j=0;$j<=$#iob1;$j++){
    # === split a line into words ===	
    my @iob1_words = split(' ',$iob1[$j]);
    
    # === skip blank line ===
    if ($#iob1_words < 1){
    	#print "\n";
    	next;
    }        
    
    # === split a tagged chunk, eg.I-NP => "I" and "NP" ===
    my @cur = split ('-',$iob1_words[3]);
    
    # === get previous ===
    my @prv_words = split(' ',$ioe2[$j-1]);
    my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$ioe2[$j+1]);
    my @flw = split('-',$flw_words[3]);
      
    
    # === Case "I" ===
    if ($cur[0] eq "I"){
    	
    	# "B" if follow(I) is "E" and previous = cur
    	if ($prv[0] eq "E" and $prv[1] eq $cur[1]){
    		$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." B-".$cur[1];
    	
    	# "I" if o.w.
    	}else{
    		$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." I-".$cur[1];
    	}
    }  
    
    # === Case "E" ===
    if ($cur[0] eq "E"){
    
    	# "B" if previous(E) is "E" and previous = cur
    	if ($prv[0] eq "E" and $prv[1] eq $cur[1]){
    		$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." B-".$cur[1];
    
    	# "I" if o.w.
    	}else{
    		$iob1[$j] = $iob1_words[0]." ".$iob1_words[1]." ".$iob1_words[2]." I-".$cur[1];
    	}
    }
}


for(my $j=0;$j<=$#iob1;$j++){
    my @words = split(' ',$iob1[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
