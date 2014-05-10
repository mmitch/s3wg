#!/usr/bin/perl -w
#
# s3wg - simple static streaming website generator
# Copyright (C) 2014  Christian Garbs <mitch@cgarbs.de>
# Licensed under GNU GPL v3 (or later)
#
# Scans a directory for .mp4 video files and generates a
# static index.html file that allows playback of all
# files via the HTML5 <video> tag.
#
use strict;

open HTML, '>', 'index.html' or die "can't open `index.html': $!";

print HTML <<EOF;
<html>
    <body>
    <div>
      <video id="player" width="320" height="240" controls>
	<source type="video/mp4" />
	Your browser does not support the video tag.
      </video>
    </div>
    <div id="filelist" style="overflow:auto;">
      <ul>
EOF
    ;

for my $file (glob '*.mp4')
{
    if (-f $file)
    {
	my $quoted = $file;
	$quoted =~ s/([^^A-Za-z0-9\-_.!~*'()])/ sprintf "%%%0x", ord $1 /eg;
	print HTML <<"EOF";
	<li><a href="#" onclick="a('$quoted')">$quoted</a></li>
EOF
    ;
    }
}

print HTML <<EOF;
      </ul>
    </div>
    <script>
      function a(url) { document.getElementById("player").src=url; }
      function resize() { document.getElementById("filelist").style.height = (window.innerHeight - 260) + 'px'; }
      window.addEventListener('resize', resize, false);
      window.addEventListener('orientationChanged', resize, false);
      resize();
    </script>
  </body>
</html>
EOF

close HTML or die "can't close `index.html': $!";
