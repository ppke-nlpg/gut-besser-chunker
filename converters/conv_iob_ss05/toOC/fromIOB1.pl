#!/usr/bin/perl

#Convert merged test file from IOB1 to O+C
#Input: IOB1
#Output: O+C

#use strict;

#open (inFP_oc, "<test.o+c.wch100.merge");
my $line_oc;
#my @ref;

my $line;
my @oc;
my @iob1;
my $i=0;

# === read a line from file ===
while($line=<>){

    #$line_oc=<inFP_oc>;	
    #chomp($line_oc);
    #$ref[$i] = $line_oc;
     
    chomp($line);
    $oc[$i] = $line;
    $iob1[$i] = $line;
    #print $oc[$i],"\n";
    $i++; 
}


for (my $j=0;$j<=$#oc;$j++){
    # === split a line into words ===	
    my @oc_words = split(' ',$oc[$j]);
    
    # === skip blank line ===
    if ($#oc_words < 1){
    	#print "\n";
    	next;
    }        
    
    # === split a tagged chunk, eg.I-NP => "I" and "NP" ===
    my @cur = split ('-',$oc_words[3]);
    
    # === get previous ===
    my @prv_words = split(' ',$iob1[$j-1]);
    my @prv = split('-',$prv_words[3]);
    
    # === get follow ===
    my @flw_words = split(' ',$iob1[$j+1]);
    my @flw = split('-',$flw_words[3]);
       
    
    
    
    # === Case "I" ===
    if ($cur[0] eq "I"){
    
    	# "O" if previous(I) is "I" or "B" and previous = cur and follow(I) is "I" and follow = cur
	if ($prv[0]=~/^I|B$/ and $prv[1] eq $cur[1] and $flw[I] eq "I" and $flw[1] eq $cur[1]){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." O-".$cur[1];  
    
    	# "[" if previous(I) is "O" or empty and follow(I) is "I" and follow = cur
    	}elsif ($prv[0]=~/^O|$/ and $flw[0] eq "I" and $flw[1] eq $cur[1]){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." [-".$cur[1]; 
    	
    	# "[" if previous(I) is "I" and previous != cur and follow(I) is "I" and follow = cur
    	}elsif ($prv[0] eq "I" and $prv[1] ne $cur[1] and $flw[0] eq "I" and $flw[1] eq $cur[1]){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." [-".$cur[1]; 
    	
    	# "]" if previous(I) is "I" or "B" and follow(I) is "O" or "B" or empty
    	}elsif (($prv[0] eq "I" or $prv[0] eq "B") and $prv[1] eq $cur[1] and ($flw[0] eq "O" or $flw[0] eq "B" or $flw[0]=~/^$/)){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." ]-".$cur[1];    
    	
    	# "]" if previous(I) is "I" or "B" and follow(I) is "I" and follow != cur
    	}elsif (($prv[0] eq "I" or $prv[0] eq "B") and $prv[1] eq $cur[1] and $flw[0] eq "I" and $flw[1] ne $cur[1]){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." ]-".$cur[1];  	
    	
    	# "[]" if previous(I) is "O" or empty and follow(I) is "O" or "B" or empty
    	}elsif ($prv[0]=~/^O|$/ and $flw[0]=~/^O|B|$/){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	
    	# "[]" if previous(I) is "I" and previous != cur and follow(I) is "I" and follow != cur
    	}elsif ($prv[0] eq "I" and $prv[1] ne $cur[1] and $flw[0] eq "I" and $flw[1] ne $cur[1]){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	
    	# "[]" if previous(I) is "I" and previous != cur and follow(I) is "O" or "B" or follow is empty
    	}elsif ($prv[0] eq "I" and $prv[1] ne $cur[1] and ($flw[0] eq "O" or $flw[0] eq "B")){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	
    	# "[]" if previous(I) is "O" or empty and follow(I) is "I" and follow != cur
    	}elsif (($prv[0] eq "O" or $prv[0]=~/^$/) and $flw[0] eq "I" and $flw[1] ne $cur[1]){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	}
    
    }
    
    
    # === Case "B" ===
    if ($cur[0] eq "B"){
    
    	# "[" if follow(B) is "I" and follow = cur
    	if ($flw[0] eq "I" and $flw[1] eq $cur[1]){
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." [-".$cur[1];
    
    	# "[]" if o.w.  follow(B) is "B" or "O" or empty
    	}else{
    		$oc[$j] = $oc_words[0]." ".$oc_words[1]." ".$oc_words[2]." []-".$cur[1];
    	}
    }
    
    
    
}

for(my $j=0;$j<=$#oc;$j++){
    my @words = split(' ',$oc[$j]);
    #my @words_ref = split(' ',$ref[$j]);
    #print $words[0]," ";
    #print $words[1]," ";
    #print $words_ref[2]," ";
    print $words[1]," ",$words[2]," ",$words[3],"\n";	
}
