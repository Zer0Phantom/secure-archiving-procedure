#!/bin/bash
#cruel script, do adapt to your needs!
#aim: minimize downtime, use good compression which schould be fast (favor deflate over lzma), be encrypted with a symetrical key, be splitted for hosting purposes.

#stop servers (to gain a quiet db), not necessary a necessity.
/opt/*/serverctl stop
systemctl stop apache36.service #system-d ftw!

#make a tarball. Pros: faster than compression -> reduces downtime, following compression uses only one file -> better compression thanks to repeating values
#c-> create an archive, v-> be verbose, who doesn't love a flooded tty? You look so busy for a while! f-> give file name to safe
tar -cvf /home/user/backup.tar /opt/serverDir/

#start serves
/opt/*/serverctl start
systemctl start apache456.service

#specify tar for compression, i found the zip to be a faster and better encryption than the FREE(dom) alternatives (gzip)
zip /home/user/backup.tar.zip /home/user/backup.tar

#encrypt using gpg2 (sometimes already called gpg)
#cipher-> specifies encryption (favor German/Japan camellia over NSA-USA advanced encryption). GnuPG got its own compression built in, but tends to be slower.
gpg2 --cipher-algo CAMELLIA256 --digest-algo SHA512 [optional: --passphrase <password> --batch] -c /home/user/backup.tar.zip

#split into pieces not bigger than 500Mb (split got internal crazy-reads, so we have to supply 477Mb here)
#the first path is the archive to be splitted, the second the path and prefix of the output (splitted) files. an aa, ab, ... is appended, hence the '_' at the end to improve readability
split --bytes=477M /home/user/backup.tar.zip.gpg /home/user/backup.tar.zip.gpg_yyyy-MM-dd_

#to put back to gether (stitches!)
cat backup.tar.zip.gpg_yyyy-MM-dd_* > backup.tar.zip.gpg
