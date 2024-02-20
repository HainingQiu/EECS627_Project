#!/usr/bin/env perl

use strict;
use warnings;
use POSIX qw(ceil);

# Input and output file names
my $input_file = '../Iter3.txt';
my $output_file = 'Final_result_Nodes.txt';
my $Ground_Truth='output.txt';
my $diff_file = 'Diff_res.txt';

# Open input file for reading
open(my $input_fh, '<', $input_file) or die "Cannot open $input_file: $!";

# Open output file for writing
open(my $output_fh, '>', $output_file) or die "Cannot create $output_file: $!";

# Parameters
my $BW_FV_SRAM = 64;
my $FV_size = 16;
my $Num_FV_line = $BW_FV_SRAM / $FV_size;      # 64/16=4
my $Max_Num_FV = 128;
my $offset_FV_Node = $Max_Num_FV / $Num_FV_line;    # 128/4=32
my $line_cnt = 0;
my $num_nodes = 32;
my $Num_Replay_Iter = 4;
my $Num_Nodes_Bank = $num_nodes / $Num_Replay_Iter;    # 32/4=8 nodes per bank
my $Current_Bank = 0;
my $Num_line_bank = 1024;    # How many lines per bank
my $Num_Weight_Layer = 2;
my $Num_Output_line = ceil($Num_Weight_Layer / $Num_FV_line);    # 2/2=1
my $output_cnt = 0;
my $Current_Node = 1;
my $wait_bank_change_flag = 0;    # Need to wait until bank change
my $num_Bank=4;

# Process input file and generate output
while (my $line = <$input_fh>) {
    if($line_cnt<17)
    {
        print "Current Line:$line_cnt \n";
        print "line Value:$line";
        print "wait_bank_change_flag:$wait_bank_change_flag \n";
        print "Current_Node:$Current_Node \n";


    }
            
    if ($wait_bank_change_flag != 1) {
        if ($line_cnt % $offset_FV_Node == 0) {
            $Current_Node++;
        }
        if ($line_cnt % $offset_FV_Node == $output_cnt) {
            print "line_cnt:$line_cnt";
            print $output_fh $line;
            $output_cnt++;
        } 
        if ($output_cnt == $Num_Output_line) {
            $output_cnt = 0;
            if ($Current_Node >$Num_Nodes_Bank) {
                $wait_bank_change_flag = 1;
            }
        }
    }

    $line_cnt++;
    
    if ($line_cnt % $Num_line_bank == 0 && $line_cnt != 0) {
        $Current_Bank++;
        $Current_Node=1;
        $wait_bank_change_flag = 0;
    }

}
# seek($output_fh, -1, 1);  # Move the filehandle pointer one position back
# truncate($output_fh, tell($output_fh));  # Truncate the file to the current position

# Close input and output file handles
close($input_fh);
close($output_fh);
my $input_fh_true;
# # Open files for comparison
open($input_fh_true, '<', $Ground_Truth) or die "Cannot open $input_fh_true: $!";
open($output_fh, '<', $output_file) or die "Cannot open $output_file: $!";
open(my $diff_fh, '>', $diff_file) or die "Cannot create $diff_file: $!";

# Compare input and output files
my $uncorrect_lines = 1;
while (my $line1 = <$input_fh_true> and my $line2 = <$output_fh>) {
    # Check if the lines are equal
    unless (defined $line2 && $line1 eq $line2) {
        print $diff_fh "$line2:$uncorrect_lines\n";
    }
    $uncorrect_lines++;
}
# Close file handles for comparison
close($input_fh_true);
close($output_fh);
close($diff_fh);

print "Script executed successfully.\n";
