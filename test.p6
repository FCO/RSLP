use RSLP;
my RSLP $rslp .= new;
say do for lines.map: |*.lc.comb(/\w+/) -> $word {
    $rslp($word)
}.Bag
