#!/bin/sh
echo "||'''Port'''||'''Category'''||'''Repository'''||'''Tickets'''||"; \
for name in $(port echo "category:(\W|^)kde4(\W|$)"); do \
	if ( echo $name | grep -qv 'kde-l10n-' ); then
		port file $name 2>&1 \
		| grep 'tarballs' \
		| sed -E \
			-e 's|/opt/local/var/macports/sources/rsync.macports.org/release/tarballs/ports/||' \
			-e 's|^(.*)/Portfile$|trunk/dports/\1|' \
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
	fi
done
