#!/usr/bin/perl

#Binary Grading System Database v0.01

#     __                     _____
#    /  \          /        /
#   /    \        /        /
#  /      \      /  ----  /
# /        \    /        /
#/          \__/        /_____

use strict;
use warnings;

#TODO: start working on teacher-side bulk stuff :) (maybe)

our $version = "v0.01";
our $user;

frontend1();

#Note to self: prototyping functions is just with the sigils
#Second note to self: "==" for number stuff, "eq" for word stuff

#Open studentfile and add a new assignment
#TODO: change this to a hard-linked directory delete in the C:\ drive
sub fileupdate{
		my $filename = $_[0];
		open(my $stufile, "<", "C:\NCBGSD\Students\$filename.csv") or die "Can't open student file\n";
		open(my $stufile_edit, ">", "C:\NCBGSD\Students\$filename~") or die "Can't open filebuffer\n";
		#insert new assigment into the file
		update($stufile_edit);
		#have to close files to reset what mode they're opened in
		close $stufile;
		close $stufile_edit;
		#this is very inefficient, but I'm on my first runthrough
		open($stufile, ">", "C:\NCBGSD\Students\$filename.csv") or die "Can't open student file\n";
		open($stufile_edit, "<", "C:\NCBGSD\Students\$filename~") or die "Can't open filebuffer\n";
		while (<$stufile_edit>){
				chomp;
				print $stufile $_;
		}
		close $stufile;
		close $stufile_edit;
		#delete the ~ file
		unlink("$filename~") or die "Could not delete tempfile\n";
		print "Student file successfully updated\n";
		logger("fileupdate", $user);
	  frontend3();
}

#inserting new assignment into file
#TODO: check if class is matched with a class the student has
sub update{
		my $file = $_[0];
		print "Assignment Name:\n";
		frontend3();
		my $assign_name = <STDIN>;
		print "Class Name:\n";
		frontend3();
		my $class_name = <STDIN>;
		print "Date:\n";
		frontend3();
		my $date = <STDIN>;
		print "Grade:\n";
		frontend3();
		my $grade = <STDIN>;
		if ($grade == 0){
				quickupdate($file);
		}
		my $writein = "$assign_name,$class_name,$date,$grade";
		print $file $writein;
}

#for use in the update function, requires file to be preopened
#autoupdates avg
sub quickupdate{
		my $filename = $_[0];
		while (<$filename>){
				chomp;
				if ($. == 1){
						$_ =~ s/\,[01]/0/;
				}
		}
}

sub logger{
		my $opname = $_[0];
		my $date = localtime();
		my $logmsg = "$user executed $opname on $date";
		open(my $logfile, ">>", "C:\NCBGSD\log.txt") or die "Couldn't open logfile\n";
		print $logfile $logmsg;
		close $logfile;
}

sub filecheck{
		my $filename = $_[0];
		open(my $stufile, "<", "C:\NCBGSD\Students\$filename.csv") or die "Could not open student file\n";
		while (<$stufile>){
				chomp;
				#prints the first and second lines 
				if ($. < 3){
						print "$_\n";
				} else {
						#break the chomp loop
						last;
				}
		}
		logger("filecheck", $user);
		frontend3();
}
		

#Console frontend (3-parter)
sub frontend1{
		open(my $splash, "<", "splashpage.txt");
		while (<$splash>){
				chomp;
				print "$_\n";
		}
		print "Welcome to the NCBGSD $version\n";
		print "Enter your username:\n";
	  print ">> ";
		$user = <STDIN>;
		$user =~ s/\n//;
		frontend2();
}

#gotta make it look cool on the console
sub frontend2{
		print ">> ";
		my $in = <STDIN>;
		#it always passes the return as part of the arg, so this is the hack
		$in =~ s/\n//;
		#switch statement keeps failing, so if-else it is
	  if ($in eq "help"){
				help();
		} elsif ($in eq "update"){
				print "Enter student namecode:\n";
				print ">> ";
				my $student = <STDIN>;
				$student =~ s/\n//;
				fileupdate("$student");
		} elsif ($in eq "check"){
				print "Enter student namecode:\n";
				print ">> ";
				my $student = <STDIN>;
				$student =~ s/\n//;
				filecheck("$student");
		} else {
				help();
		}
}

sub frontend3{
		print ">> ";
}

sub help{
		print "Type 'help' for this message\n";
		print "Type 'update' to update a student's grades\n";
		print "Type 'check' to check a student's profile\n";
		frontend2();
		}


