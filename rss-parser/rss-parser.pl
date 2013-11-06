#!/usr/bin/perl -w
use strict;
use DBI; 
use XML::RSS;
use LWP::Simple;

# Variables
my $username = 'username'; # set your MySQL username 
my $password = 'password'; # set your MySQL password 
my $database = 'database'; # set your MySQL database name
my $server = 'mysqlservername'; # set your server hostname (probably localhost)

# Get the rows from database
my $dbh = DBI->connect("DBI:mysql:$database;host=$server", $username, $password)
 || die "Could not connect to database: $DBI::errstr";
my $sth = $dbh->prepare('select id, nama, url from xml')
 || die "$DBI::errstr";
#$sth->bind_param(1, "");
$sth->execute();

# Print number of rows found
if ($sth->rows < 0) {
    print "Sorry, no domains found.\n";
} else {
    printf ">> Found %d domains\n", $sth->rows;
    # Loop if results found
    while (my $results = $sth->fetchrow_hashref) {
        my $domainname = $results->{nama}; 
        my $url = $results->{url}; 
	my $id = $results->{id};
        printf " +--- %s \e[1;42m %s (%s)\e[0m\n", $id, $domainname, $url;

	# initialize object
	my $raw = get($url);
	my $rss = new XML::RSS->parse($raw);

	foreach my $item (@{$rss->{'items'}}) { 
		my $title = $item->{'title'};
		my $link = $item->{'link'};
		my $isi = $item->{'description'};
		
		my $dth = $dbh->prepare('INSERT INTO link (id_sindikasi, judul, link, ringkasan) VALUES (?, ?, ?, ?);')
		 || die "$DBI::errstr";
		#$dth->prepare($query);
		
		$title =~ s/^\s+|\s+$//g;
		$isi =~ s/^\s+|\s+$//g;
		$dth->execute($id, $title, $link, $isi);
		print "    +--- $title \n";
		$dth->finish;
	}

    }
}
# Disconnect 
$sth->finish; 
$dbh->disconnect;
        