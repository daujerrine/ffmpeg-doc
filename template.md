$if(title)$
# $title$
$endif$
$if(subtitle)$
# $subtitle$
$endif$
$for(author)$
## $author$
$endfor$
$if(date)$
## *Last updated $date$*
$endif$

--------------------------------------------------------------------------------

$for(header-includes)$
$header-includes$

$endfor$
$for(include-before)$
$include-before$

$endfor$
$if(toc)$
$toc$

$endif$
$body$
$for(include-after)$

$include-after$
$endfor$
