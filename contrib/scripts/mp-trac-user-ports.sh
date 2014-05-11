#!/bin/sh
echo "||'''Port'''||'''Category'''||'''Repository'''||'''Tickets'''||"; \
for name in $(port echo "maintainer:(\W|^)$1(\W|$)"); do \
svn info $(port file $name) 2>&1 \
| grep -B 20 -E "^Revision" \
| grep -E '^URL: https?://svn.macports.org/repository/macports/' \
| sed -E \
-e 's|^URL: https?://svn.macports.org/repository/macports/||' \
-e 's|/Portfile$||' \
| awk -v NAME=$name 'BEGIN \
{ FS = "/" } ; \
{ printf "||[source:"$0" "NAME"]||[source:" } ; \
{ \
for (x=1; x<NF; x++) { \
printf "%s", $x ; \
if (x != NF-1) printf "/" \
} \
} ; \
{ printf " "$(NF-1)"]||[source:" } ; \
{ \
for (x=1; x<NF-1; x++) { \
printf "%s", $x ; \
if (x != NF-2) printf "/" \
} \
} ; \
{ printf " "$(NF-3)"]||||[[TicketQuery(port="NAME"&status=new|assigned|reopened)]]||\n" } ; \
' ;
done