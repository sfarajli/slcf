#!/bin/sh

sed '/\[--.*--\]/d' |
	sed '/\[\(--[^]]*--\|cid:[^]]*\)\]/d' |
	sed '/\[\(twitter\|instagram\|linkedin\|facebook\)\]/d' |
	sed '/[^[:space:]]/,$!d' |
	awk 'BEGIN{blank=0} /^[[:space:]]*$/{blank++; if(blank<=2) print; next} {blank=0; print}'
