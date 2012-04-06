#! /usr/bin/perl


###################################################################################
### This program is copyright (c) by                    						###
### Prashant Bhutani <prashantbhutani2008@gmail.com>            				###
### 2011-2020 or stated otherwise.                      						###
###						                                        				###
### This program is free software. You can redistribute it and/or modify it     ###
### under the terms of version 2 of the GNU General Public License, which you   ###
### should have received with it.                       						###
###								                                        		###
### This program is distributed in the hope that it will be useful, but 		###
### without any warranty, expressed or implied.             					###
###################################################################################



# usage is as or perl file_name  starting_directory_address  search_pattern
# or another way is to first make the perl file executable by switching on the executable bit
# chmod u+x file_name; ./file_name  starting_directory_address  search_pattern
die "usage <directory address> <search pattern>" unless @ARGV == 2;

# initialize root directory and the serach pattern from command line arguments
my ($root_dir,$search_pattern) = @ARGV;

# calling the sub-routine
&recursive_directory_search($root_dir);

# defining the sub-routine
sub recursive_directory_search
{
	
	my $dir = shift; 								# initializing the local variable $dir which keeps track of current directory the sub-routine is working on
	
	my $temp = $dir;								# making a copy of $dir variable as the directory is modified in the following program
	
	opendir(DIR,$dir) || warn "cannot open $dir\n"; # opens the directory pointed by $dir or warns if the directory is unable to be opened
		
	#my @files = readdir(DIR);
	#foreach $file(@files)
	foreach $file (readdir(DIR))					# running for loop over the elements present in the directory
	{
		chomp; 										# remove the trailing new line character, if any

		next if ($file eq "proc");				# skip the proc directory used for processes update

		if ($dir ne '/')							# checks if the directory is root or not?
		{
			$file = join("",$dir.'/',$file);		# if directory is not root, then make the path of file absolute by joing directory and file by adding "/"
		}
		else
		{
		    $file = join("",$dir,$file);			# if directory is root, just join file and directory
		}
		
		next if (-l $file);							# go to next file name if the current file is a symbolic link otherwise it will go into infinite loops for some folders

		if (-f $file and $file =~ /\b$search_pattern\b/)		# if the current element is a file and contains the search pattern
		{
		     print $file."\n" ;									# print out the path and newline character
		}                
		
		
		if(-d $file)											# if the element is a directory
        {
			if($temp eq '/')									# check if the current directory is root?
			{
				$temp = undef();								# if yes, then make the temp variable NULL
			}
			my $one = join("",$temp,"/.");
			my $two = join("",$temp,"/..");
			
			if(($file eq $one) or ($file eq $two))				# check if the current element is a parent directory ".." or current directory "."
			{
                next;											# if yes, then goto next element
            }
            else
            {
				&recursive_directory_search($file);				# otherwise call the same sub-routine recursively with the new directory
                next;
            }
	   }
     }
 }
